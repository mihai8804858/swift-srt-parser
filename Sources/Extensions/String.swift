extension String {
    func trimmingEdges(while predicate: (Element) throws -> Bool) rethrows -> Substring {
        try self
            .trimmingPrefix(while: predicate)
            .trimmingSuffix(while: predicate)
    }

    func prefix(upTo substring: Substring) -> Substring {
        guard let range = range(of: substring) else { return self[...] }
        return self[..<range.lowerBound]
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
