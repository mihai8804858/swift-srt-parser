@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class ColorParserTests: XCTestCase {
    func test_parse_named_success() throws {
        var content = "\"red\""[...]
        let expected = SRT.Color.named("red")
        let parser = Parse(input: Substring.self) { ColorParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_hex_success() throws {
        var content = "\"#FBFF1C\""[...]
        let expected = SRT.Color.rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C))
        let parser = Parse(input: Substring.self) { ColorParser() }
        let color = try parser.parse(&content)
        XCTAssertNoDifference(color, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "\"\""[...]
        let parser = Parse(input: Substring.self) { ColorParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "\"\"")
    }

    func test_named_print() throws {
        var content = ""[...]
        let color = SRT.Color.named("blue")
        let parser = Parse(input: Substring.self) { ColorParser() }
        try parser.print(color, into: &content)
        XCTAssertNoDifference(content, "\"blue\"")
    }

    func test_hex_print() throws {
        var content = ""[...]
        let color = SRT.Color.rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C))
        let parser = Parse(input: Substring.self) { ColorParser() }
        try parser.print(color, into: &content)
        XCTAssertNoDifference(content, "\"#FBFF1C\"")
    }
}
