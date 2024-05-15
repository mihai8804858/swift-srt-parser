@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class ItalicComponentParserTests: XCTestCase {
    func test_parse_tag_success() throws {
        var content = "<i>text</i>"[...]
        let expected = StyledText.Component.italic(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { ItalicComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_bracket_success() throws {
        var content = "{i}text{/i}"[...]
        let expected = StyledText.Component.italic(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { ItalicComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<i>text<i>"[...]
        let parser = Parse(input: Substring.self) { ItalicComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<i>text<i>")
    }

    func test_print() throws {
        var content = ""[...]
        let component = StyledText.Component.italic(children: [.plain(text: "text")])
        let parser = Parse(input: Substring.self) { ItalicComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<i>text</i>")
    }
}
