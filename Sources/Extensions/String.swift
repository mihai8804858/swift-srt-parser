extension String {
    func trimmingEdges(while predicate: (Element) throws -> Bool) rethrows -> Substring {
        try self
            .trimmingPrefix(while: predicate)
            .trimmingSuffix(while: predicate)
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
