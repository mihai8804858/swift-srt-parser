@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class TextComponentParserTests: XCTestCase {
    func test_parse_bold_success() throws {
        var content = "<b>text</b>"[...]
        let expected = SRT.Text.Component.bold(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_italic_success() throws {
        var content = "<i>text</i>"[...]
        let expected = SRT.Text.Component.italic(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_underline_success() throws {
        var content = "<u>text</u>"[...]
        let expected = SRT.Text.Component.underline(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_coloured_success() throws {
        var content = "<font color=\"green\">text</font>"[...]
        let expected = SRT.Text.Component.color(
            color: .named("green"),
            text: "text"
        )
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_plain_success() throws {
        var content = "text"[...]
        let expected = SRT.Text.Component.plain(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "")
    }

    func test_print_bold() throws {
        var content = ""[...]
        let component = SRT.Text.Component.bold(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "{b}text{/b}")
    }

    func test_print_italic() throws {
        var content = ""[...]
        let component = SRT.Text.Component.italic(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "{i}text{/i}")
    }

    func test_print_underline() throws {
        var content = ""[...]
        let component = SRT.Text.Component.underline(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "{u}text{/u}")
    }

    func test_print_coloured() throws {
        var content = ""[...]
        let component = SRT.Text.Component.color(
            color: .named("green"),
            text: "text"
        )
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<font color=\"green\">text</font>")
    }

    func test_print_plain() throws {
        var content = ""[...]
        let component = SRT.Text.Component.plain(text: "text")
        let parser = Parse(input: Substring.self) { TextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "text")
    }
}
