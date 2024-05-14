extension Substring {
    func trimmingSuffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        var result = self
        while let last = result.last, try predicate(last) {
            result.removeLast()
        }

        return result
    }
}
