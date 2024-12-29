@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class TimingParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "12:34:56,789 --> 23:45:67,890"[...]
        let expected = SRT.Timing(
            start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
            end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
        )
        let parser = Parse(input: Substring.self) { TimingParser() }
        let time = try parser.parse(&content)
        expectNoDifference(time, expected)
        expectNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "12:34:56,789 --> "[...]
        let parser = Parse(input: Substring.self) { TimingParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        expectNoDifference(content, "")
    }

    func test_print() throws {
        var content = ""[...]
        let timing = SRT.Timing(
            start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
            end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
        )
        let parser = Parse(input: Substring.self) { TimingParser() }
        try parser.print(timing, into: &content)
        expectNoDifference(content, "12:34:56,789 --> 23:45:67,890")
    }
}
