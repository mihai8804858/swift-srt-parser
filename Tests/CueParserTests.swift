@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class CueParserTests: XCTestCase {
    func test_parse_success() throws {
        var content = """
        1
        00:02:17,440 --> 00:02:20,375 X1:12 X2:34 Y1:56 Y2:78
        Hello, world!
        How are you?
        """[...]
        let expected = SRT.Cue(
            counter: 1,
            metadata: .init(
                timing: .init(
                    start: .init(hours: 0, minutes: 02, seconds: 17, milliseconds: 440),
                    end: .init(hours: 0, minutes: 02, seconds: 20, milliseconds: 375)
                ),
                position: .init(x1: 12, x2: 34, y1: 56, y2: 78)
            ),
            text: .init(components: [
                .plain(text: "Hello, world!\nHow are you?")
            ])
        )
        let parser = Parse(input: Substring.self) { CueParser() }
        let component = try parser.parse(&content)
        XCTAssertNoDifference(component, expected)
        XCTAssertNoDifference(content, "")
    }

    func test_parse_failure() throws {
        var content = """
        A
        00:02:17,440 -->
        ???
        """[...]
        let parser = Parse(input: Substring.self) { CueParser() }
        XCTAssertThrowsError(try parser.parse(&content))
        XCTAssertNoDifference(content, """
        A
        00:02:17,440 -->
        ???
        """)
    }

    func test_print() throws {
        var content = ""[...]
        let cue = SRT.Cue(
            counter: 1,
            metadata: .init(
                timing: .init(
                    start: .init(hours: 0, minutes: 02, seconds: 17, milliseconds: 440),
                    end: .init(hours: 0, minutes: 02, seconds: 20, milliseconds: 75)
                ),
                position: .init(x1: 12, x2: 34, y1: 56, y2: 78)
            ),
            text: .init(components: [
                .plain(text: "Hello, world!\nHow are you?")
            ])
        )
        let parser = Parse(input: Substring.self) { CueParser() }
        try parser.print(cue, into: &content)
        XCTAssertNoDifference(content, """
        1
        00:02:17,440 --> 00:02:20,075 X1:12 X2:34 Y1:56 Y2:78
        Hello, world!
        How are you?
        """)
    }
}
