@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class CoordinatesParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "X1:12 X2:34 Y1:56 Y2:78"[...]
        let expected = SRT.Coordinates(x1: 12, x2: 34, y1: 56, y2: 78)
        let parser = Parse(input: Substring.self) { CoordinatesParser() }
        let coordinates = try parser.parse(&content)
        expectNoDifference(coordinates, expected)
        expectNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "X1:12 X2:34 Y1:ab"[...]
        let parser = Parse(input: Substring.self) { CoordinatesParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        expectNoDifference(content, "ab")
    }

    func test_print() throws {
        var content = ""[...]
        let coordinates = SRT.Coordinates(x1: 12, x2: 34, y1: 56, y2: 78)
        let parser = Parse(input: Substring.self) { CoordinatesParser() }
        try parser.print(coordinates, into: &content)
        expectNoDifference(content, "X1:12 X2:34 Y1:56 Y2:78")
    }
}
