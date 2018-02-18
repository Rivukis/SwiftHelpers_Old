
public class LLNode<T: Equatable & Comparable & CustomStringConvertible> {
    public var next: LLNode<T>?
    public var value: T

    public init(value: T, next: LLNode<T>? = nil) {
        self.value = value
        self.next = next
    }

    public func deepCopy() -> LLNode {
        return LLNode(value: value, next: next?.deepCopy())
    }
}

extension LLNode: Equatable {
    public static func ==(lhs: LLNode<T>, rhs: LLNode<T>) -> Bool {
        guard lhs.value == rhs.value else {
            return false
        }

        return lhs.next == rhs.next
    }
}

extension LLNode: Comparable {
    public static func <(lhs: LLNode<T>, rhs: LLNode<T>) -> Bool {
        return lhs.value < rhs.value
    }
}

extension LLNode: CustomStringConvertible {
    public var description : String {
        let nextDescription = next != nil ? " --> " + String(describing: next!) : ""

        return String(describing: value) + nextDescription
    }
}
