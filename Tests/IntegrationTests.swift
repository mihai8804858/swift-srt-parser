@testable import SRTParser
import CustomDump
import Foundation
import Testing

struct IntegrationTests {
    @Test func integration() throws {
        let resourcesURL = try #require(Bundle.module.resourceURL?.appendingPathComponent("Subtitles"))
        let fileNames = try FileManager.default.contentsOfDirectory(atPath: resourcesURL.path)
        for fileName in fileNames.sorted() {
            do {
                let filePath = resourcesURL.appendingPathComponent(fileName)
                let contents = try String(contentsOf: filePath)
                _ = try SRTParser().parse(contents)
                print("Succesfully parsed \"\(fileName)\" file")
            } catch {
                Issue.record("File \"\(fileName)\" failed to parse with error:\n\(error)")
            }
        }
    }
}
