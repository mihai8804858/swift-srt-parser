import Foundation
import Parsing

public struct SRTParser {
    private let parser = CuesParser()

    public init() {}

    public func parse(content: String) throws -> SRT {
        let sanitizedContent = content
            .trimmingPrefix(while: \.isNewline)
            .trimmingSuffix(while: \.isNewline)

        return try parser.parse(sanitizedContent)
    }

    public func print(srt: SRT) throws -> String {
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
        ParsePrint(.memberwise(SRT.CueMetadata.init(timing:position:))) {
            TimingParser()
            Optionally {
                Whitespace(1..., .horizontal)
                PositionParser()
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

struct PositionParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Position> {
        ParsePrint(.memberwise(SRT.Position.init(x1:x2:y1:y2:))) {
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
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text> {
        ParsePrint(.memberwise(SRT.Text.init(components:))) {
            Many(1...) {
                TextComponentParser()
            }
        }
    }
}

struct TextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        OneOf {
            BoldTextComponentParser()
            ItalicTextComponentParser()
            UnderlineTextComponentParser()
            ColouredTextComponentParser()
            PlainTextComponentParser()
        }
    }
}

struct BoldTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        Parse {
            OneOf {
                "<b>".utf8
                "{b}".utf8
            }
            PlainTextParser()
            OneOf {
                "</b>".utf8
                "{/b}".utf8
            }
        }
        .map(.case(SRT.Text.Component.bold))
    }
}

struct ItalicTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        ParsePrint {
            OneOf {
                "<i>".utf8
                "{i}".utf8
            }
            PlainTextParser()
            OneOf {
                "</i>".utf8
                "{/i}".utf8
            }
        }
        .map(.case(SRT.Text.Component.italic))
    }
}

struct UnderlineTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        ParsePrint {
            OneOf {
                "<u>".utf8
                "{u}".utf8
            }
            PlainTextParser()
            OneOf {
                "</u>".utf8
                "{/u}".utf8
            }
        }
        .map(.case(SRT.Text.Component.underline))
    }
}

struct ColouredTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        ParsePrint {
            "<font color=".utf8
            ColorParser()
            ">".utf8
            PlainTextParser()
            "</font>".utf8
        }
        .map(.case(SRT.Text.Component.color))
    }
}

struct PlainTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Text.Component> {
        PlainTextParser()
            .map(.case(SRT.Text.Component.plain))
    }
}

struct PlainTextParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, String> {
        OneOf {
            PrefixUpTo("<".utf8)
            PrefixUpTo("{".utf8)
            PrefixUpTo("\n\n".utf8)
            Prefix(1...)
        }
        .map(.string)
    }

    func print(_ output: String, into input: inout Substring.UTF8View) throws {
        input.prepend(contentsOf: output.utf8)
    }
}

struct ColorParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, SRT.Color> {
        OneOf {
            Parse {
                "\"".utf8
                RGBParser()
                "\"".utf8
            }
            .map(.case(SRT.Color.rgb))
            Parse {
                "\"".utf8
                Prefix(1...) { $0 != UInt8(ascii: "\"") }
                "\"".utf8
            }
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

private extension Substring.UTF8View {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }

    func isPlainTextTermination(at index: Int) -> Bool {
        let currentIndex = self.index(startIndex, offsetBy: index)
        let nextIndex = self.index(startIndex, offsetBy: index + 1)
        if self[safe: currentIndex] == .init(ascii: "<") { return true }
        if self[safe: currentIndex] == .init(ascii: "{") { return true }
        if self[safe: currentIndex] == .init(ascii: "\n") && self[safe: nextIndex] == .init(ascii: "\n") { return true }

        return false
    }
}
