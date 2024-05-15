@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class TimeParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "12:34:56,789"[...]
        let expected = SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789)
        let parser = Parse(input: Substring.self) { TimeParser() }
        let time = try parser.parse(&content)
        XCTAssertNoDifference(time, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "12:34;56.789"[...]
        let parser = Parse(input: Substring.self) { TimeParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, ";56.789")
    }

    func test_print() throws {
        var content = ""[...]
        let time = SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789)
        let parser = Parse(input: Substring.self) { TimeParser() }
        try parser.print(time, into: &content)
        XCTAssertNoDifference(content, "12:34:56,789")
    }
}
