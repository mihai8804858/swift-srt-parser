@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class HexByteParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = "3A"[...]
        let expected = UInt8(0x3A)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        let byte = try parser.parse(&content)
        XCTAssertNoDifference(byte, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_outOfBounds() throws {
        var content = "HI"[...]
        let parser = Parse(input: Substring.self) { HexByteParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "HI")
    }

    func test_parse_shortLength() throws {
        var content = "1"[...]
        let parser = Parse(input: Substring.self) { HexByteParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, "1")
    }

    func test_print_singleCharacter() throws {
        var content = ""[...]
        let byte = UInt8(0xC)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        try parser.print(byte, into: &content)
        XCTAssertNoDifference(content, "0C")
    }

    func test_print_twoCharacters() throws {
        var content = ""[...]
        let byte = UInt8(0x4B)
        let parser = Parse(input: Substring.self) { HexByteParser() }
        try parser.print(byte, into: &content)
        XCTAssertNoDifference(content, "4B")
    }
}
