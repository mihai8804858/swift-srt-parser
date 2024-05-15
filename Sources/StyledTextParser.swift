import RegexBuilder

struct StyledTextParser {
    private let parsers: [StyledTextComponentParser] = [
        BoldComponentParser(),
        ItalicComponentParser(),
        UnderlineComponentParser(),
        ColorComponentParser()
    ]

    func parse(_ text: String) throws -> SRT.StyledText {
        SRT.StyledText(components: try parse(text))
    }

    func print(_ text: SRT.StyledText) throws -> String {
        try print(text.components)
    }

    private func parse(_ text: String) throws -> [SRT.StyledText.Component] {
        let components = try parsers.map { try $0.parse(text) }.sorted { lhs, rhs in
            guard let rhs else { return true }
            guard let lhs else { return false }
            return lhs.0.lowerBound < rhs.0.lowerBound
        }
        guard let component = components.first, let component else { return [.plain(text: text)] }
        let (leading, trailing) = try parseEdges(from: text, relativeTo: component)

        return leading + [component.1] + trailing
    }

    private func print(_ component: SRT.StyledText.Component) throws -> String {
        switch component {
        case .plain(let text):
            return text
        case .bold(let components):
            let children = try components.map(print).joined()
            return "<b>\(children)</b>"
        case .italic(let components):
            let children = try components.map(print).joined()
            return "<i>\(children)</i>"
        case .underline(let components):
            let children = try components.map(print).joined()
            return "<u>\(children)</u>"
        case .color(let color, let components):
            let color = try ColorParser().print(color)
            let children = try components.map(print).joined()
            return "<font color=\"\(color)\">\(children)</font>"
        }
    }

    private func parseEdges(
        from text: String,
        relativeTo component: (Range<String.Index>, SRT.StyledText.Component)
    ) throws -> (leading: [SRT.StyledText.Component], trailing: [SRT.StyledText.Component]) {
        let leadingText: String? = if component.0.lowerBound > text.startIndex {
            String(text[..<component.0.lowerBound])
        } else {
            nil
        }
        let trailingText: String? = if component.0.upperBound < text.endIndex {
            String(text[component.0.upperBound...])
        } else {
            nil
        }
        let leading = try leadingText.map { try parse($0) } ?? []
        let trailing = try trailingText.map { try parse($0) } ?? []

        return (leading, trailing)
    }

    private func print(_ components: [SRT.StyledText.Component]) throws -> String {
        try components.map(print).joined()
    }
}

private protocol StyledTextComponentParser {
    func parse(_ text: String) throws -> (range: Range<String.Index>, component: SRT.StyledText.Component)?
}

private struct BoldComponentParser: StyledTextComponentParser {
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring)> {
        Regex {
            ChoiceOf {
                "<b>"
                "{b}"
            }
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            ChoiceOf {
                "</b>"
                "{/b}"
            }
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func parse(_ text: String) throws -> (range: Range<String.Index>, component: SRT.StyledText.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let children = try StyledTextParser().parse(String(match[textReference]))
        let component = SRT.StyledText.Component.bold(children: children.components)

        return (match.range, component)
    }
}

private struct ItalicComponentParser: StyledTextComponentParser {
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring)> {
        Regex {
            ChoiceOf {
                "<i>"
                "{i}"
            }
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            ChoiceOf {
                "</i>"
                "{/i}"
            }
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func parse(_ text: String) throws -> (range: Range<String.Index>, component: SRT.StyledText.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let children = try StyledTextParser().parse(String(match[textReference]))
        let component = SRT.StyledText.Component.italic(children: children.components)

        return (match.range, component)
    }
}

private struct UnderlineComponentParser: StyledTextComponentParser {
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring)> {
        Regex {
            ChoiceOf {
                "<u>"
                "{u}"
            }
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            ChoiceOf {
                "</u>"
                "{/u}"
            }
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func parse(_ text: String) throws -> (range: Range<String.Index>, component: SRT.StyledText.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let children = try StyledTextParser().parse(String(match[textReference]))
        let component = SRT.StyledText.Component.underline(children: children.components)

        return (match.range, component)
    }
}

private struct ColorComponentParser: StyledTextComponentParser {
    private let colorReference = Reference(Substring.self)
    private let textReference = Reference(Substring.self)

    private var regex: Regex<(Substring, Substring, Substring)> {
        Regex {
            "<font color=\""
            Capture(as: colorReference) {
                ZeroOrMore(.any)
            }
            "\">"
            Capture(as: textReference) {
                ZeroOrMore(.any)
            }
            "</font>"
        }
        .repetitionBehavior(.reluctant)
        .ignoresCase()
    }

    func parse(_ text: String) throws -> (range: Range<String.Index>, component: SRT.StyledText.Component)? {
        guard let match = try regex.firstMatch(in: text) else { return nil }
        let color = try ColorParser().parse(String(match[colorReference]))
        let children = try StyledTextParser().parse(String(match[textReference]))
        let component = SRT.StyledText.Component.color(color: color, children: children.components)

        return (match.range, component)
    }
}
