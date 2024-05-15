extension String {
    func trimmingEdges(while predicate: (Element) throws -> Bool) rethrows -> String {
        let trimmed = try trimmingPrefix(while: predicate).trimmingSuffix(while: predicate)
        return String(trimmed)
    }

    func prefix(upTo substring: Substring) -> String {
        guard let range = range(of: substring) else { return self }
        return String(self[..<range.lowerBound])
    }
}

extension Substring {
    func trimmingSuffix(while predicate: (Element) throws -> Bool) rethrows -> Substring {
        var result = self
        while let last = result.last, try predicate(last) {
            result.removeLast()
        }

        return result
    }
}
