@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class TextParserTests: XCTestCase {
    func test_parse_single_success() throws {
        var content = "<b>text</b>"[...]
        let expected = SRT.Text(components: [
            .bold(text: "text")
        ])
        let parser = Parse(input: Substring.self) { TextParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_multiple_success() throws {
        var content = "prefix<b>bold</b>middle 1<i>italic</i>middle 2<u>underline</u>middle 3<font color=\"green\">coloured text</font>suffix"[...]
        let expected = SRT.Text(components: [
            .plain(text: "prefix"),
            .bold(text: "bold"),
            .plain(text: "middle 1"),
            .italic(text: "italic"),
            .plain(text: "middle 2"),
            .underline(text: "underline"),
            .plain(text: "middle 3"),
            .color(color: .named("green"), text: "coloured text"),
            .plain(text: "suffix")
        ])
        let parser = Parse(input: Substring.self) { TextParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { TextParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "")
    }

    func test_print_single() throws {
        var content = ""[...]
        let text = SRT.Text(components: [
            .bold(text: "text")
        ])
        let parser = Parse(input: Substring.self) { TextParser() }
        try parser.print(text, into: &content)
        XCTAssertNoDifference(content, "{b}text{/b}")
    }

    func test_print_multiple() throws {
        var content = ""[...]
        let text = SRT.Text(components: [
            .plain(text: "prefix"),
            .bold(text: "bold"),
            .plain(text: "middle 1"),
            .italic(text: "italic"),
            .plain(text: "middle 2"),
            .underline(text: "underline"),
            .plain(text: "middle 3"),
            .color(color: .named("green"), text: "coloured text"),
            .plain(text: "suffix")
        ])
        let parser = Parse(input: Substring.self) { TextParser() }
        try parser.print(text, into: &content)
        XCTAssertNoDifference(content, "prefix{b}bold{/b}middle 1{i}italic{/i}middle 2{u}underline{/u}middle 3<font color=\"green\">coloured text</font>suffix")
    }
}
