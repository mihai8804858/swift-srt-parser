@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class BOMParserTests: XCTestCase {
    func test_parse_bom() throws {
        let contentWithBOM = "﻿1\r\n00:00:30,324 --> 00:00:33,898\r\nUN JOC DE ZARURI\r\n\r\n"
        let expected = SRT(cues: [
            SRT.Cue(
                counter: 1,
                metadata: SRT.CueMetadata(timing: SRT.Timing(
                    start: SRT.Time(hours: 0, minutes: 0, seconds: 30, milliseconds: 324),
                    end: SRT.Time(hours: 0, minutes: 0, seconds: 33, milliseconds: 898)
                ), coordinates: nil, position: nil),
                text: .init(components: [
                    .plain(text: "UN JOC DE ZARURI")
                ])
            )
        ])
        let parser = SRTParser()
        let srt = try parser.parse(contentWithBOM)
        XCTAssertNoDifference(srt, expected)
    }
}
