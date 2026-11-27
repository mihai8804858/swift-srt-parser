@testable import SRTParser
import Parsing
import CustomDump
import Testing

struct TimeParserTests {
    @Test func parse_success() throws {
        var content = "12:34:56,789"[...]
        let expected = SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789)
        let parser = Parse(input: Substring.self) { TimeParser() }
        let time = try parser.parse(&content)
        expectNoDifference(time, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_failure() throws {
        var content = "12:34;56.789"[...]
        let parser = Parse(input: Substring.self) { TimeParser() }
        #expect(throws: (any Error).self) { try parser.parse(&content) }
        expectNoDifference(content, ";56.789")
    }

    @Test func print() throws {
        var content = ""[...]
        let time = SRT.Time(hours: 12, minutes: 34, seconds: 56, milliseconds: 789)
        let parser = Parse(input: Substring.self) { TimeParser() }
        try parser.print(time, into: &content)
        expectNoDifference(content, "12:34:56,789")
    }
}
