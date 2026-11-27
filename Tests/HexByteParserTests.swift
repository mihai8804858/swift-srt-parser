@testable import SRTParser
import Parsing
import CustomDump
import Testing

struct HexByteParserTests {
    @Test func parse_success() throws {
        var content = "3A"[...]
        let expected = UInt8(0x3A)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        let byte = try parser.parse(&content)
        expectNoDifference(byte, expected)
        expectNoDifference(content, "")
    }

    @Test func parse_outOfBounds() throws {
        var content = "HI"[...]
        let parser = Parse(input: Substring.self) { HexByteParser() }
        #expect(throws: (any Error).self) { try parser.parse(&content) }
        expectNoDifference(content, "HI")
    }

    @Test func parse_shortLength() throws {
        var content = "1"[...]
        let parser = Parse(input: Substring.self) { HexByteParser() }
        #expect(throws: (any Error).self) { try parser.parse(&content) }
        expectNoDifference(content, "1")
    }

    @Test func print_singleCharacter() throws {
        var content = ""[...]
        let byte = UInt8(0xC)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        try parser.print(byte, into: &content)
        expectNoDifference(content, "0C")
    }

    @Test func print_twoCharacters() throws {
        var content = ""[...]
        let byte = UInt8(0x4B)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        try parser.print(byte, into: &content)
        expectNoDifference(content, "4B")
    }
}
