import Foundation

extension String {
    func trimmingEdges(while predicate: (Element) throws -> Bool) rethrows -> String {
        try String(self[...].trimmingEdges(while: predicate))
    }

    func trimmingBOM() -> String {
        String(self[...].trimmingEdges(while: \.containsBOM))
    }
}

extension CharacterSet {
    func containsUnicodeScalars(of character: Character) -> Bool {
        character.unicodeScalars.allSatisfy(contains)
    }
}

extension Character {
    var containsBOM: Bool {
        !Set(unicodeScalars).isDisjoint(with: UnicodeScalar.byteOrderMarks)
    }
}

extension Substring {
    func trimmingEdges(while predicate: (Element) throws -> Bool) rethrows -> Substring {
        try trimmingPrefix(while: predicate).trimmingSuffix(while: predicate)
    }

    func trimmingSuffix(while predicate: (Element) throws -> Bool) rethrows -> Substring {
        var result = self
        while let last = result.last, try predicate(last) {
            result.removeLast()
        }

        return result
    }

    func prefix(upTo terminatorSet: CharacterSet, count: Int = 1, includeTerminator: Bool = false) -> Substring {
        var result = Substring()
        var terminator = Substring()
        var occurences = 0
        for char in self {
            if terminatorSet.containsUnicodeScalars(of: char) {
                terminator.append(char)
                occurences += 1
                if occurences == count { break }
            } else {
                result.append(contentsOf: terminator)
                result.append(char)
                terminator.removeAll()
                occurences = 0
            }
        }
        if includeTerminator {
            result.append(contentsOf: terminator)
        }

        return result
    }
}

extension UnicodeScalar {
    static let byteOrderMarks = Set([
        UnicodeScalar(0xEFBBBF),
        UnicodeScalar(0xFFFE),
        UnicodeScalar(0xFEFF)
    ].compactMap { $0 })
}
