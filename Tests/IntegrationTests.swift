@testable import SRTParser
import CustomDump
import XCTest

final class IntegrationTests: XCTestCase {
    func test_integration() throws {
        let resourcesURL = try XCTUnwrap(Bundle.module.resourceURL?.appendingPathComponent("Subtitles"))
        let fileNames = try FileManager.default.contentsOfDirectory(atPath: resourcesURL.path)
        for fileName in fileNames {
            do {
                let filePath = resourcesURL.appendingPathComponent(fileName)
                let contents = try String(contentsOf: filePath)
                _ = try SRTParser().parse(contents)
            } catch {
                XCTFail("File \"\(fileName)\" failed to parse with error:\n\(error)")
            }
        }
    }
}
