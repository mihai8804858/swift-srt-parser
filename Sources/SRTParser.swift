import Parsing

public struct SRTParser {
    public init() {}

    public func parse(content: String) throws -> SRT {
        throw SRTParserError.cantParse
    }
}
