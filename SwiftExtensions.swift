import Foundation
import Darwin

// MARK: - String

extension String {
    public func substring(from: Int? = nil, to: Int? = nil) -> String {
        let fromIndex: String.Index
        if let from = from {
            fromIndex = self.index(self.startIndex, offsetBy: from)
        } else {
            fromIndex = self.startIndex
        }

        let toIndex: String.Index
        if let to = to {
            toIndex = self.index(self.startIndex, offsetBy: to + 1)
        } else {
            toIndex = self.endIndex
        }

        return String(self[fromIndex..<toIndex])
    }
}

// MARK: - Int

extension Int {
    public static func random(from: UInt32 = 0, to: UInt32 = 100) -> Int {
        precondition(to > from, "'to' is not greater than 'from'")

        return Int(arc4random_uniform(to - from + 1) + from)
    }

    func toThe(exp: Int) -> Int {
        var result = 1

        for _ in 0..<exp {
            result *= self
        }

        return result
    }
}

// MARK: - Bool

extension Bool {
    func toInt() -> Int {
        return self ? 1 : 0
    }
}

// MARK: - Array

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }

    public func groupBy<K: Hashable>(_ keyClosure: (Element) -> K) -> [K: [Element]] {
        var result: [K: [Element]] = [:]

        self.forEach { element in
            let key = keyClosure(element)
            if var group = result[key] {
                group.append(element)
                result[key] = group
            } else {
                result[key] = [element]
            }
        }

        return result
    }

    public mutating func removeFirst(where predicate: (Element) -> Bool) {
        let enumeration = enumerated().first { predicate($0.element) }

        if let index = enumeration?.offset {
            remove(at: index)
        }
    }

    public static func +(lhs: Element, rhs: [Element]) -> [Element] {
        var rhs = rhs
        rhs.insert(lhs, at: 0)

        return rhs
    }

    public static func +(lhs: [Element], rhs: Element) -> [Element] {
        var lhs = lhs
        lhs.append(rhs)

        return lhs
    }
}

// MARK: - Dictionary

extension Dictionary {
    public func mapValues<T>(_ mapClosure: (Value) -> T) -> [Key: T] {
        var result: [Key: T] = [:]

        self.forEach { key, value in
            result[key] = mapClosure(value)
        }

        return result
    }

    public func mapKeys<T: Hashable>(_ mapClosure: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]

        self.forEach { key, value in
            result[mapClosure(key)] = value
        }

        return result
    }

    public static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var lhs = lhs

        rhs.forEach { key, value in
            lhs[key] = value
        }

        return lhs
    }
}

extension Dictionary where Value: Hashable {
    func flip() -> [Value: Key] {
        var flipped: [Value: Key] = [:]

        self.forEach { (key, value) in
            flipped[value] = key
        }

        return flipped
    }
}

// MARK: - Date

extension Date {
    func isBefore(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }

    func isAfter(_ date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }
}

// MARK: - Equatable Stuff

public struct EquatableArray<T: Equatable>: Equatable {
    private let wrappedArray: [T]

    init?(_ array: [T]?) {
        guard let array = array else {
            return nil
        }

        self.wrappedArray = array
    }

    public static func == (lhs: EquatableArray<T>, rhs: EquatableArray<T>) -> Bool {
        return lhs.wrappedArray == rhs.wrappedArray
    }
}

public struct EquatableDictionary<K: Hashable, V: Equatable>: Equatable {
    private let wrappedDictionary: [K: V]

    init?(_ dictionary: [K: V]?) {
        guard let dictionary = dictionary else {
            return nil
        }

        self.wrappedDictionary = dictionary
    }

    public static func == (lhs: EquatableDictionary<K, V>, rhs: EquatableDictionary<K, V>) -> Bool {
        return lhs.wrappedDictionary == rhs.wrappedDictionary
    }
}

// MARK: - Debug Functions

/**
 Loud Print

 Puts ' ===> ' before the print for easy finding in console output and for filtering the console output.

 Converts optionals into either "nil" or the wrapped value (thus removing 'Optional(...)`).
 */
public func lprint(_ values: Any?..., loudText: String = "===>") {
    let string = values.map { value -> String in
        guard let value = value else {
            return "nil"
        }

        return "\(value)"
        }
        .joined(separator: " ")

    print(" \(loudText) \(string)")
}

public func todo(_ string: String, line: Int = #line) {
    lprint("TODO: (\(line)) - \(string)")
}

public func endOfFile() {
    print("\n  EOF")
}
