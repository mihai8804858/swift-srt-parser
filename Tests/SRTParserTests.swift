@testable import SRTParser
import Parsing
import CustomDump
import XCTest

final class SRTParserTests: XCTestCase {
    func test_parse() throws {
        // swiftlint:disable trailing_whitespace
        let content = """
        1
        00:02:17,440 --> 00:02:20,375
        Senator, we're making
        our <b>final</b> approach into {u}Coruscant{/u}.
        
        2
        00:02:20,476 --> 00:02:22,501
        {b}Very good, {i}Lieutenant{/i}{/b}.
        
        3
        00:02:24,948 --> 00:02:26,247 X1:201 X2:516 Y1:397 Y2:423
        <font color="#fbff1c">Whose side is time on?</font>
        
        4
        00:02:36,389 --> 00:02:39,290 X1:203 X2:511 Y1:359 Y2:431
        {\\an2}v

        5
        00:02:41,000 --> 00:02:43,295
        [speaks Icelandic]
        
        6
        00:02:45,000 --> 00:02:48,295
        {\\an1}[man 3] <i>♪The admiral
        begins his expedition♪</i>


        """
        // swiftlint:enable trailing_whitespace

        let expected = SRT(cues: [
            SRT.Cue(
                counter: 1,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 17, milliseconds: 440),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 375)
                    ),
                    coordinates: nil,
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "Senator, we're making\nour "),
                    .bold(children: [.plain(text: "final")]),
                    .plain(text: " approach into "),
                    .underline(children: [.plain(text: "Coruscant")]),
                    .plain(text: ".")
                ])
            ),
            SRT.Cue(
                counter: 2,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 476),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 22, milliseconds: 501)
                    ),
                    coordinates: nil,
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .bold(children: [
                        .plain(text: "Very good, "),
                        .italic(children: [.plain(text: "Lieutenant")])
                    ]),
                    .plain(text: ".")
                ])
            ),
            SRT.Cue(
                counter: 3,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 24, milliseconds: 948),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 26, milliseconds: 247)
                    ),
                    coordinates: SRT.Coordinates(x1: 201, x2: 516, y1: 397, y2: 423),
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .color(color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)), children: [
                        .plain(text: "Whose side is time on?")
                    ])
                ])
            ),
            SRT.Cue(
                counter: 4,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 36, milliseconds: 389),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 39, milliseconds: 290)
                    ),
                    coordinates: SRT.Coordinates(x1: 203, x2: 511, y1: 359, y2: 431),
                    position: .bottomCenter
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "v")
                ])
            ),
            SRT.Cue(
                counter: 5,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 41, milliseconds: 0),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 43, milliseconds: 295)
                    ),
                    coordinates: nil,
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "[speaks Icelandic]")
                ])
            ),
            SRT.Cue(
                counter: 6,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 45, milliseconds: 0),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 48, milliseconds: 295)
                    ),
                    coordinates: nil,
                    position: .bottomLeft
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "[man 3] "),
                    .italic(children: [.plain(text: "♪The admiral\nbegins his expedition♪")])
                ])
            )
        ])
        let parser = SRTParser()
        let srt = try parser.parse(content)
        expectNoDifference(srt, expected)
    }

    func test_print() throws {
        let srt = SRT(cues: [
            SRT.Cue(
                counter: 1,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 17, milliseconds: 440),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 375)
                    ),
                    coordinates: nil,
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "Senator, we're making\nour "),
                    .bold(children: [.plain(text: "final")]),
                    .plain(text: " approach into "),
                    .underline(children: [.plain(text: "Coruscant")]),
                    .plain(text: ".")
                ])
            ),
            SRT.Cue(
                counter: 2,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 20, milliseconds: 476),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 22, milliseconds: 501)
                    ),
                    coordinates: nil,
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .bold(children: [
                        .plain(text: "Very good, "),
                        .italic(children: [.plain(text: "Lieutenant")])
                    ]),
                    .plain(text: ".")
                ])
            ),
            SRT.Cue(
                counter: 3,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 24, milliseconds: 948),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 26, milliseconds: 247)
                    ),
                    coordinates: SRT.Coordinates(x1: 201, x2: 516, y1: 397, y2: 423),
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .color(color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)), children: [
                        .plain(text: "Whose side is time on?")
                    ])
                ])
            ),
            SRT.Cue(
                counter: 4,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 36, milliseconds: 389),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 39, milliseconds: 290)
                    ),
                    coordinates: SRT.Coordinates(x1: 203, x2: 511, y1: 359, y2: 431),
                    position: nil
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "v")
                ])
            ),
            SRT.Cue(
                counter: 5,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 41, milliseconds: 0),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 43, milliseconds: 295)
                    ),
                    coordinates: nil,
                    position: .bottomCenter
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "[speaks Icelandic]")
                ])
            ),
            SRT.Cue(
                counter: 6,
                metadata: SRT.CueMetadata(
                    timing: SRT.Timing(
                        start: SRT.Time(hours: 0, minutes: 2, seconds: 45, milliseconds: 0),
                        end: SRT.Time(hours: 0, minutes: 2, seconds: 48, milliseconds: 295)
                    ),
                    coordinates: nil,
                    position: .topRight
                ),
                text: SRT.StyledText(components: [
                    .plain(text: "[man 3] "),
                    .italic(children: [.plain(text: "♪The admiral\nbegins his expedition♪")])
                ])
            )
        ])
        let content = try SRTParser().print(srt)
        expectNoDifference(content, """
        1
        00:02:17,440 --> 00:02:20,375
        Senator, we're making
        our <b>final</b> approach into <u>Coruscant</u>.

        2
        00:02:20,476 --> 00:02:22,501
        <b>Very good, <i>Lieutenant</i></b>.

        3
        00:02:24,948 --> 00:02:26,247 X1:201 X2:516 Y1:397 Y2:423
        <font color="#FBFF1C">Whose side is time on?</font>

        4
        00:02:36,389 --> 00:02:39,290 X1:203 X2:511 Y1:359 Y2:431
        v

        5
        00:02:41,000 --> 00:02:43,295
        {\\an2}[speaks Icelandic]

        6
        00:02:45,000 --> 00:02:48,295
        {\\an9}[man 3] <i>♪The admiral
        begins his expedition♪</i>
        """)
    }
}
