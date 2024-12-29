@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class RGBParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "#FBFF1C"[...]
        let expected = SRT.Color.RGB(red: 0xFB, green: 0xFF, blue: 0x1C)
        let parser = Parse(input: Substring.self) { RGBParser() }
        let color = try parser.parse(&content)
        expectNoDifference(color, expected)
        expectNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "#FB1C"[...]
        let parser = Parse(input: Substring.self) { RGBParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        expectNoDifference(content, "")
    }

    func test_print() throws {
        var content = ""[...]
        let color = SRT.Color.RGB(red: 0xFB, green: 0xFF, blue: 0x1C)
        let parser = Parse(input: Substring.self) { RGBParser() }
        try parser.print(color, into: &content)
        expectNoDifference(content, "#FBFF1C")
    }
}
