@testable import SRTParser
import CustomDump
import XCTest

final class StyledTextParserTests: XCTestCase {
    func test_parse() throws {
        let content = """
        Senator, we're making
        our <b>final</b> approach into {u}Coruscant{/u}.
        {b}Very good, {i}Lieutenant{/i}{/b}.
        <font color="#fbff1c">Whose side is time on?</font>
        v
        [speaks Icelandic]
        [man 3] <i>♪The admiral
        begins his expedition♪</i>
        """
        let expected = SRT.StyledText(components: [
            .plain(text: "Senator, we're making\nour "),
            .bold(children: [.plain(text: "final")]),
            .plain(text: " approach into "),
            .underline(children: [.plain(text: "Coruscant")]),
            .plain(text: ".\n"),
            .bold(children: [
                .plain(text: "Very good, "),
                .italic(children: [.plain(text: "Lieutenant")])
            ]),
            .plain(text: ".\n"),
            .color(color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)), children: [
                .plain(text: "Whose side is time on?")
            ]),
            .plain(text: "\nv\n[speaks Icelandic]\n[man 3] "),
            .italic(children: [.plain(text: "♪The admiral\nbegins his expedition♪")])
        ])
        let parser = StyledTextParser()
        let components = try parser.parse(content)
        XCTAssertNoDifference(components, expected)
    }

    func test_print() throws {
        let text = SRT.StyledText(components: [
            .plain(text: "Senator, we're making\nour "),
            .bold(children: [.plain(text: "final")]),
            .plain(text: " approach into "),
            .underline(children: [.plain(text: "Coruscant")]),
            .plain(text: ".\n"),
            .bold(children: [
                .plain(text: "Very good, "),
                .italic(children: [.plain(text: "Lieutenant")])
            ]),
            .plain(text: ".\n"),
            .color(color: .rgb(.init(red: 0xFB, green: 0xFF, blue: 0x1C)), children: [
                .plain(text: "Whose side is time on?")
            ]),
            .plain(text: "\nv\n[speaks Icelandic]\n[man 3] "),
            .italic(children: [.plain(text: "♪The admiral\nbegins his expedition♪")])
        ])
        let content = try StyledTextParser().print(text)
        XCTAssertNoDifference(content, """
        Senator, we're making
        our <b>final</b> approach into <u>Coruscant</u>.
        <b>Very good, <i>Lieutenant</i></b>.
        <font color="#FBFF1C">Whose side is time on?</font>
        v
        [speaks Icelandic]
        [man 3] <i>♪The admiral
        begins his expedition♪</i>
        """)
    }
}
