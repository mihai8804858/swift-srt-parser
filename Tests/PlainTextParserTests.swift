@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class PlainTextParserTests: XCTestCase {
    func test_parse_up_to_cue_separator_success() throws {
        var content = "hello\n\n"[...]
        let expected = "hello"
        let parser = Parse(input: Substring.self) { PlainTextParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "\n\n")
    }

    func test_parse_up_to_end_success() throws {
        var content = "hello"[...]
        let expected = "hello"
        let parser = Parse(input: Substring.self) { PlainTextParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { PlainTextParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "")
    }

    func test_print() throws {
        var content = ""[...]
        let text = "hello"
        let parser = Parse(input: Substring.self) { PlainTextParser() }
        try parser.print(text, into: &content)
        XCTAssertNoDifference(content, "hello")
    }
}
