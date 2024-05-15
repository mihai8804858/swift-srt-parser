@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class ColouredComponentParserTests: XCTestCase {
    func test_parse_named_success() throws {
        var content = "<font color=\"green\">text</font>"[...]
        let expected = StyledText.Component.color(
            color: .named("green"),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { ColouredComponentParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_hex_success() throws {
        var content = "<font color=\"#FBFF1C\">text</font>"[...]
        let expected = StyledText.Component.color(
            color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { ColouredComponentParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "<font>text<font>"[...]
        let parser = Parse(input: Substring.self) { ColouredComponentParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "<font>text<font>")
    }

    func test_print_named() throws {
        var content = ""[...]
        let component = StyledText.Component.color(
            color: .named("green"),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { ColouredComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<font color=\"green\">text</font>")
    }

    func test_print_hex() throws {
        var content = ""[...]
        let component = StyledText.Component.color(
            color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)),
            children: [.plain(text: "text")]
        )
        let parser = Parse(input: Substring.self) { ColouredComponentParser() }
        try parser.print(component, into: &content)
        XCTAssertNoDifference(content, "<font color=\"#FBFF1C\">text</font>")
    }
}
