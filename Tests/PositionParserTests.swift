@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class PositionParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "X1:12 X2:34 Y1:56 Y2:78"[...]
        let expected = SRT.Position(x1: 12, x2: 34, y1: 56, y2: 78)
        let parser = Parse(input: Substring.self) { PositionParser() }
        let position = try parser.parse(&content)
        XCTAssertNoDifference(position, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "X1:12 X2:34 Y1:ab"[...]
        let parser = Parse(input: Substring.self) { PositionParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "X1:12 X2:34 Y1:ab")
    }

    func test_print() throws {
        var content = ""[...]
        let position = SRT.Position(x1: 12, x2: 34, y1: 56, y2: 78)
        let parser = Parse(input: Substring.self) { PositionParser() }
        try parser.print(position, into: &content)
        XCTAssertNoDifference(content, "X1:12 X2:34 Y1:56 Y2:78")
    }
}
