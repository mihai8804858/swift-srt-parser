import Foundation
import Parsing

public struct SRTParser {
    private let parser = CuesParser()

    public init() {}

    public func parse(_ content: String) throws -> SRT {
        try parser.parse(content.trimmingEdges(while: \.isNewline))
    }

    public func print(_ srt: SRT) throws -> String {
        String(decoding: try parser.print(srt), as: UTF8.self)
    }
}

struct CuesParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT> {
        ParsePrint(.memberwise(SRT.init(cues:))) {
            Many {
                CueParser()
            } separator: {
                Whitespace(2..., .vertical)
            } terminator: {
                End()
            }
        }
    }
}

struct CueParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Cue> {
        ParsePrint(.memberwise(SRT.Cue.init(counter:metadata:text:))) {
            Int.parser()
            Whitespace(.horizontal)
            Whitespace(1, .vertical)
            CueMetadataParser()
            Whitespace(.horizontal)
            Whitespace(1, .vertical)
            TextParser()
        }
    }
}

struct CueMetadataParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.CueMetadata> {
        ParsePrint(.memberwise(SRT.CueMetadata.init(timing:coordinates:))) {
            TimingParser()
            Optionally {
                Whitespace(1..., .horizontal)
                CoordinatesParser()
            }
        }
    }
}

struct TimingParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Timing> {
        ParsePrint(.memberwise(SRT.Timing.init(start:end:))) {
            TimeParser()
            Whitespace(1..., .horizontal)
            "-->".utf8
            Whitespace(1..., .horizontal)
            TimeParser()
        }
    }
}

struct TimeParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Time> {
        ParsePrint(.memberwise(SRT.Time.init(hours:minutes:seconds:milliseconds:))) {
            Int.parser()
            ":".utf8
            Int.parser()
            ":".utf8
            Int.parser()
            ",".utf8
            Int.parser()
        }
    }

    func print(_ output: SRT.Time, into input: inout Substring.UTF8View) throws {
        let hours = String(format: "%02d", output.hours)
        let minutes = String(format: "%02d", output.minutes)
        let seconds = String(format: "%02d", output.seconds)
        let milliseconds = String(format: "%03d", output.milliseconds)
        let text = "\(hours):\(minutes):\(seconds),\(milliseconds)"
        input.prepend(contentsOf: text.utf8)
    }
}

struct CoordinatesParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Coordinates> {
        ParsePrint(.memberwise(SRT.Coordinates.init(x1:x2:y1:y2:))) {
            "X1:".utf8
            Int.parser()
            Whitespace(1..., .horizontal)
            "X2:".utf8
            Int.parser()
            Whitespace(1..., .horizontal)
            "Y1:".utf8
            Int.parser()
            Whitespace(1..., .horizontal)
            "Y2:".utf8
            Int.parser()
        }
    }
}

struct TextParser: ParserPrinter {
    func parse(_ input: inout Substring.UTF8View) throws -> SRT.StyledText {
        let utf8Input = String(decoding: input, as: UTF8.self)
        let prefix = String(utf8Input.prefix(upTo: "\n\n"))
        let text = try StyledTextParser().parse(prefix)
        input.removeFirst(prefix.utf8.count)

        return text
    }

    func print(_ output: SRT.StyledText, into input: inout Substring.UTF8View) throws {
        input.prepend(contentsOf: try StyledTextParser().print(output).utf8)
    }
}

struct ColorParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Color> {
        OneOf {
            RGBParser()
                .map(.case(SRT.Color.rgb))
            Prefix(1...) { $0 != UInt8(ascii: "\"") }
                .map(.string)
                .map(.case(SRT.Color.named))
        }
    }
}

struct RGBParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Color.RGB> {
        ParsePrint(.memberwise(SRT.Color.RGB.init(red:green:blue:))) {
            "#".utf8
            HexByteParser()
            HexByteParser()
            HexByteParser()
        }
    }
}

struct HexByteParser: ParserPrinter {
    func parse(_ input: inout Substring.UTF8View) throws -> UInt8 {
        let prefix = input.prefix(2)
        guard prefix.count == 2, let byte = UInt8(String(decoding: prefix, as: UTF8.self), radix: 16) else {
            throw SRTParsingError(message: "Failure parsing hex byte")
        }
        input.removeFirst(2)

        return byte
    }

    func print(_ output: UInt8, into input: inout Substring.UTF8View) {
        let byte = String(output, radix: 16, uppercase: true)
        input.prepend(contentsOf: byte.count == 1 ? "0\(byte)".utf8 : "\(byte)".utf8)
    }
}
