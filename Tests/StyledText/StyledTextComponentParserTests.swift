@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class StyledTextComponentParserTests: XCTestCase {
    func test_parse_bold_success() throws {
        var content = "<b>text</b>"[...]
        let expected = StyledText.Component.bold(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_italic_success() throws {
        var content = "<i>text</i>"[...]
        let expected = StyledText.Component.italic(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_underline_success() throws {
        var content = "<u>text</u>"[...]
        let expected = StyledText.Component.underline(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_coloured_success() throws {
        var content = "<font color=\"green\">text</font>"[...]
        let expected = StyledText.Component.color(
            color: .named("green"),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_plain_success() throws {
        var content = "text"[...]
        let expected = StyledText.Component.plain(text: "text")
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "")
    }

    func test_print_bold() throws {
        var content = ""[...]
        let component = StyledText.Component.bold(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<b>text</b>")
    }

    func test_print_italic() throws {
        var content = ""[...]
        let component = StyledText.Component.italic(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<i>text</i>")
    }

    func test_print_underline() throws {
        var content = ""[...]
        let component = StyledText.Component.underline(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<u>text</u>")
    }

    func test_print_coloured() throws {
        var content = ""[...]
        let component = StyledText.Component.color(
            color: .named("green"),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<font color=\"green\">text</font>")
    }

    func test_print_plain() throws {
        var content = ""[...]
        let component = StyledText.Component.plain(text: "text")
        let parser = Parse(input: Substring.self) { StyledTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "text")
    }
}
