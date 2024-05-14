@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class CueMetadataParserTests: XCTestCase {
    func test_parse_full_success() throws {
        var content = "12:34:56,789 --> 23:45:67,890 X1:12 X2:34 Y1:56 Y2:78"[...]
        let expected = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            position: SRT.Position(x1: 12, x2: 34, y1: 56, y2: 78)
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        let time = try parser.parse(&content)
        XCTAssertNoDifference(time, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_partial_success() throws {
        var content = "12:34:56,789 --> 23:45:67,890"[...]
        let expected = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            position: nil
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        let time = try parser.parse(&content)
        XCTAssertNoDifference(time, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = "12:34:56,789 --> X1:12 X2:ab"[...]
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "12:34:56,789 --> X1:12 X2:ab")
    }

    func test_print_full() throws {
        var content = ""[...]
        let metadata = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            position: SRT.Position(x1: 12, x2: 34, y1: 56, y2: 78)
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        try parser.print(metadata, into: &content)
        XCTAssertNoDifference(content, "12:34:56,789 --> 23:45:67,890 X1:12 X2:34 Y1:56 Y2:78")
    }

    func test_print_partial() throws {
        var content = ""[...]
        let metadata = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            position: nil
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        try parser.print(metadata, into: &content)
        XCTAssertNoDifference(content, "12:34:56,789 --> 23:45:67,890")
    }
}
