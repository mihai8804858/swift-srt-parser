@testable import SRTParser
import Parsing
import CustomDump
import Testing

struct ColorParserTests {
    @Test func parse_named_success() throws {
        var content = "red"[...]
        let expected = SRT.Color.named("red")
        let parser = Parse(input: Substring.self) { ColorParser() }
        let color = try parser.parse(&content)
        expectNoDifference(color, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_hex_success() throws {
        var content = "#FBFF1C"[...]
        let expected = SRT.Color.rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C))
        let parser = Parse(input: Substring.self) { ColorParser() }
        let color = try parser.parse(&content)
        expectNoDifference(color, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_failure() throws {
        var content = ""[...]
        let parser = Parse(input: Substring.self) { ColorParser() }
        #expect(throws: (any Error).self) { try parser.parse(&content) }
        expectNoDifference(content, "")
    }

    @Test func named_print() throws {
        var content = ""[...]
        let color = SRT.Color.named("blue")
        let parser = Parse(input: Substring.self) { ColorParser() }
        try parser.print(color, into: &content)
        expectNoDifference(content, "blue")
    }

    @Test func hex_print() throws {
        var content = ""[...]
        let color = SRT.Color.rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C))
        let parser = Parse(input: Substring.self) { ColorParser() }
        try parser.print(color, into: &content)
        expectNoDifference(content, "#FBFF1C")
    }
}
