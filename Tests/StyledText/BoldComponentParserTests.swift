@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class BoldComponentParserTests: XCTestCase {
    func test_parse_tag_success() throws {
        var content = "<b>text</b>"[...]
        let expected = StyledText.Component.bold(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { BoldComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_bracket_success() throws {
        var content = "{b}text{/b}"[...]
        let expected = StyledText.Component.bold(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { BoldComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<b>text<b>"[...]
        let parser = Parse(input: Substring.self) { BoldComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<b>text<b>")
    }

    func test_print() throws {
        var content = ""[...]
        let component = StyledText.Component.bold(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { BoldComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<b>text</b>")
    }
}
