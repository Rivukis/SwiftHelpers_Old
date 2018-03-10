
public final class LLNode<T> {
    public var next: LLNode<T>?
    public var value: T
    
    public required init(value: T, next: LLNode<T>? = nil) {
        self.value = value
        self.next = next
    }
}

public protocol Copiable: class {
    func copy() -> Self
}

extension LLNode: Copiable where T: Copiable {
    public func copy() -> LLNode {
        return LLNode(value: value.copy(), next: next?.copy())
    }
}

extension LLNode: Equatable where T: Equatable {
    public static func ==(lhs: LLNode<T>, rhs: LLNode<T>) -> Bool {
        guard lhs.value == rhs.value else {
            return false
        }
        
        return lhs.next == rhs.next
    }
}

extension LLNode: CustomStringConvertible where T: CustomStringConvertible {
    public var description : String {
        let nextDescription = next != nil ? " --> " + String(describing: next!) : ""
        
        return String(describing: value) + nextDescription
    }
}

extension LLNode: Sequence {
    public final class LLIterator<T>: IteratorProtocol {
        var head: LLNode
        
        init(head: LLNode) {
            self.head = head
        }
        
        public func next() -> T? {
            return nil
        }
    }
    
    public func makeIterator() -> LLIterator<T> {
        return LLIterator(head: self)
    }
}
