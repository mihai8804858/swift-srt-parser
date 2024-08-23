import Foundation
import Parsing

public struct SRTParser {
    private let parser = CuesParser()

    public init() {}

    public func parse(_ content: String) throws -> SRT {
        try parser.parse(content.trimmingEdges(while: \.isNewline).trimmingBOM())
    }

    public func print(_ srt: SRT) throws -> String {
        String(try parser.print(srt))
    }
}

struct CuesParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT> {
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
    var body: some ParserPrinter<Substring, SRT.Cue> {
        ParsePrint(.memberwise(SRT.Cue.init(counter:metadata:text:))) {
            Int.parser()
            Whitespace(.horizontal)
            Whitespace(1..., .vertical)
            CueMetadataParser()
            TextParser(upTo: .newlines, count: 2)
        }
    }
}

struct CueMetadataParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.CueMetadata> {
        ParsePrint(.memberwise(SRT.CueMetadata.init(timing:coordinates:position:))) {
            TimingParser()
            Optionally {
                Whitespace(1..., .horizontal)
                CoordinatesParser()
            }
            Whitespace(.horizontal)
            Whitespace(1..., .vertical)
            Optionally {
                PositionParser()
            }
        }
    }
}

struct TimingParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Timing> {
        ParsePrint(.memberwise(SRT.Timing.init(start:end:))) {
            TimeParser()
            Whitespace(1..., .horizontal)
            "-->"
            Whitespace(1..., .horizontal)
            TimeParser()
        }
    }
}

struct TimeParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Time> {
        ParsePrint(.memberwise(SRT.Time.init(hours:minutes:seconds:milliseconds:))) {
            Int.parser()
            ":"
            Int.parser()
            ":"
            Int.parser()
            ","
            Int.parser()
        }
    }

    func print(_ output: SRT.Time, into input: inout Substring) throws {
        let hours = String(format: "%02d", output.hours)
        let minutes = String(format: "%02d", output.minutes)
        let seconds = String(format: "%02d", output.seconds)
        let milliseconds = String(format: "%03d", output.milliseconds)
        let text = "\(hours):\(minutes):\(seconds),\(milliseconds)"
        input.prepend(contentsOf: text)
    }
}

struct CoordinatesParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Coordinates> {
        ParsePrint(.memberwise(SRT.Coordinates.init(x1:x2:y1:y2:))) {
            "X1:"
            Int.parser()
            Whitespace(1..., .horizontal)
            "X2:"
            Int.parser()
            Whitespace(1..., .horizontal)
            "Y1:"
            Int.parser()
            Whitespace(1..., .horizontal)
            "Y2:"
            Int.parser()
        }
    }
}

struct PositionParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Position> {
        ParsePrint(.memberwise(SRT.Position.init(padNumber:))) {
            "{\\an"
            Int.parser()
            "}"
        }
    }

    func print(_ output: SRT.Position, into input: inout Substring) throws {
        input.prepend(contentsOf: "{\\an\(output.padNumber)}")
    }
}

struct TextParser: ParserPrinter {
    let terminator: CharacterSet
    let count: Int
    let includeTerminator: Bool

    init(upTo terminator: String, count: Int = 1, includeTerminator: Bool = false) {
        self.terminator = CharacterSet(charactersIn: terminator)
        self.count = count
        self.includeTerminator = includeTerminator
    }

    init(upTo terminator: CharacterSet, count: Int = 1, includeTerminator: Bool = false) {
        self.terminator = terminator
        self.count = count
        self.includeTerminator = includeTerminator
    }

    func parse(_ input: inout Substring) throws -> SRT.StyledText {
        let prefix = input.prefix(
            upTo: terminator,
            count: count,
            includeTerminator: includeTerminator
        )
        let text = try StyledTextParser().parse(String(prefix))
        input.removeFirst(prefix.count)

        return text
    }

    func print(_ output: SRT.StyledText, into input: inout Substring) throws {
        input.prepend(contentsOf: try StyledTextParser().print(output))
    }
}

struct ColorParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Color> {
        OneOf {
            RGBParser()
                .map(.case(SRT.Color.rgb))
            Prefix(1...) { $0 != "\"" }
                .map(.string)
                .map(.case(SRT.Color.named))
        }
    }
}

struct RGBParser: ParserPrinter {
    var body: some ParserPrinter<Substring, SRT.Color.RGB> {
        ParsePrint(.memberwise(SRT.Color.RGB.init(red:green:blue:))) {
            "#"
            HexByteParser()
            HexByteParser()
            HexByteParser()
        }
    }
}

struct HexByteParser: ParserPrinter {
    func parse(_ input: inout Substring) throws -> UInt8 {
        let prefix = input.prefix(2)
        guard prefix.count == 2, let byte = UInt8(prefix, radix: 16) else {
            throw SRTParsingError(message: "Failure parsing hex byte")
        }
        input.removeFirst(2)

        return byte
    }

    func print(_ output: UInt8, into input: inout Substring) {
        let byte = String(output, radix: 16, uppercase: true)
        input.prepend(contentsOf: byte.count == 1 ? "0\(byte)" : "\(byte)")
    }
}
