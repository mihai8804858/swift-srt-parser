@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class ItalicTextComponentParserTests: XCTestCase {
    func test_parse_tag_success() throws {
        var content = "<i>text</i>"[...]
        let expected = SRT.Text.Component.italic(text: "text")
        let parser = Parse(input: Substring.self) { ItalicTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_bracket_success() throws {
        var content = "{i}text{/i}"[...]
        let expected = SRT.Text.Component.italic(text: "text")
        let parser = Parse(input: Substring.self) { ItalicTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<i>text<i>"[...]
        let parser = Parse(input: Substring.self) { ItalicTextComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<i>text<i>")
    }

    func test_print() throws {
        var content = ""[...]
        let component = SRT.Text.Component.italic(text: "text")
        let parser = Parse(input: Substring.self) { ItalicTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "{i}text{/i}")
    }
}
