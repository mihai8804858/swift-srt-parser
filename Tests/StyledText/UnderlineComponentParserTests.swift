@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class UnderlineComponentParserTests: XCTestCase {
    func test_parse_tag_success() throws {
        var content = "<u>text</u>"[...]
        let expected = StyledText.Component.underline(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { UnderlineComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_bracket_success() throws {
        var content = "{u}text{/u}"[...]
        let expected = StyledText.Component.underline(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { UnderlineComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<u>text<u>"[...]
        let parser = Parse(input: Substring.self) { UnderlineComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<u>text<u>")
    }

    func test_print() throws {
        var content = ""[...]
        let component = StyledText.Component.underline(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { UnderlineComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<u>text</u>")
    }
}
