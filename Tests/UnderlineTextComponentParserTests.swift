@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class UnderlineTextComponentParserTests: XCTestCase {
    func test_parse_tag_success() throws {
        var content = "<u>text</u>"[...]
        let expected = SRT.Text.Component.underline(text: "text")
        let parser = Parse(input: Substring.self) { UnderlineTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_bracket_success() throws {
        var content = "{u}text{/u}"[...]
        let expected = SRT.Text.Component.underline(text: "text")
        let parser = Parse(input: Substring.self) { UnderlineTextComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<u>text<u>"[...]
        let parser = Parse(input: Substring.self) { UnderlineTextComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<u>text<u>")
    }

    func test_print() throws {
        var content = ""[...]
        let component = SRT.Text.Component.underline(text: "text")
        let parser = Parse(input: Substring.self) { UnderlineTextComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "{u}text{/u}")
    }
}
