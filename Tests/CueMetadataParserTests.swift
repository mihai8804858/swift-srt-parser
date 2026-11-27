@testable import SRTParser
import Parsing
import CustomDump
import Testing

struct CueMetadataParserTests {
    @Test func parse_full_success() throws {
        var content = "12:34:56,789 --> 23:45:67,890 X1:12 X2:34 Y1:56 Y2:78\n{\\an8}"[...]
        let expected = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            coordinates: SRT.Coordinates(x1: 12, x2: 34, y1: 56, y2: 78),
            position: SRT.Position.topCenter
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        let time = try parser.parse(&content)
        expectNoDifference(time, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_partial_success() throws {
        var content = "12:34:56,789 --> 23:45:67,890\n"[...]
        let expected = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            coordinates: nil,
            position: nil
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        let time = try parser.parse(&content)
        expectNoDifference(time, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_failure() throws {
        var content = "12:34:56,789 --> X1:12 X2:ab"[...]
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        #expect(throws: (any Error).self) { try parser.parse(&content) }
        expectNoDifference(content, "X1:12 X2:ab")
    }

    @Test func print_full() throws {
        var content = ""[...]
        let metadata = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            coordinates: SRT.Coordinates(x1: 12, x2: 34, y1: 56, y2: 78),
            position: SRT.Position.middleCenter
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        try parser.print(metadata, into: &content)
        expectNoDifference(content, "12:34:56,789 --> 23:45:67,890 X1:12 X2:34 Y1:56 Y2:78\n{\\an5}")
    }

    @Test func print_partial() throws {
        var content = ""[...]
        let metadata = SRT.CueMetadata(
            timing: SRT.Timing(
                start: SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789),
                end: SRT.Time(hours: 23, minutes: 45, seconds: 67, milliseconds: 890)
            ),
            coordinates: nil,
            position: nil
        )
        let parser = Parse(input: Substring.self) { CueMetadataParser() }
        try parser.print(metadata, into: &content)
        expectNoDifference(content, "12:34:56,789 --> 23:45:67,890\n")
    }
}
