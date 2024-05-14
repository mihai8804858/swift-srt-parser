import SRTParser
import XCTest

final class SRTParserTests: XCTestCase {
    func test_parse() throws {
        let parser = SRTParser()
        let contents = ""
        _ = try parser.parse(content: contents)
    }
}
