@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class PlainTextComponentParserTests: XCTestCase {
    func test_parse_up_to_tag_success() throws {
        var content = "hello<"[...]
        let expected = SRT.Text.Component.plain(text: "hello")
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "<")
    }

    func test_parse_up_to_bracket_success() throws {
        var content = "hello{"[...]
        let expected = SRT.Text.Component.plain(text: "hello")
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "{")
    }

    func test_parse_up_to_cue_separator_success() throws {
        var content = "hello\n\n"[...]
        let expected = SRT.Text.Component.plain(text: "hello")
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "\n\n")
    }

    func test_parse_up_to_end_success() throws {
        var content = "hello"[...]
        let expected = SRT.Text.Component.plain(text: "hello")
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "")
    }

    func test_print() throws {
        var content = ""[...]
        let component = SRT.Text.Component.plain(text: "hello")
        let parser = Parse(input: Substring.self) { PlainTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "hello")
    }
}
