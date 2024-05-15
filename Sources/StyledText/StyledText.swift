import Parsing

public struct StyledText: Hashable {
    public enum Component: Hashable {
        case plain(text: String)
        case bold(children: [Component])
        case italic(children: [Component])
        case underline(children: [Component])
        case color(color: SRT.Color, children: [Component])
    }

    public let components: [Component]

    public init(components: [Component]) {
        self.components = components
    }
}

struct StyledTextComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        OneOf {
            BoldComponentParser()
            ItalicComponentParser()
            UnderlineComponentParser()
            ColouredComponentParser()
            PlainComponentParser()
        }
    }
}

struct BoldComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        Parse {
            OneOf {
                "{b}".utf8
                "<b>".utf8
            }
            Many {
                StyledTextComponentParser()
            }
            OneOf {
                "{/b}".utf8
                "</b>".utf8
            }
        }
        .map(.case(StyledText.Component.bold))
    }
}

struct ItalicComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        ParsePrint {
            OneOf {
                "{i}".utf8
                "<i>".utf8
            }
            Many {
                StyledTextComponentParser()
            }
            OneOf {
                "{/i}".utf8
                "</i>".utf8
            }
        }
        .map(.case(StyledText.Component.italic))
    }
}

struct UnderlineComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        ParsePrint {
            OneOf {
                "{u}".utf8
                "<u>".utf8
            }
            Many {
                StyledTextComponentParser()
            }
            OneOf {
                "{/u}".utf8
                "</u>".utf8
            }
        }
        .map(.case(StyledText.Component.underline))
    }
}

struct ColouredComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        ParsePrint {
            "<font color=".utf8
            ColorParser()
            ">".utf8
            Many {
                StyledTextComponentParser()
            }
            "</font>".utf8
        }
        .map(.case(StyledText.Component.color))
    }
}

struct PlainComponentParser: ParserPrinter {
    var body: some ParserPrinter<Substring.UTF8View, StyledText.Component> {
        OneOf {
            PrefixUpTo("{".utf8)
            PrefixUpTo("<".utf8)
            PrefixUpTo("\n\n".utf8)
            Prefix(1...)
        }
        .map(.string)
        .map(.case(StyledText.Component.plain))
    }
}
