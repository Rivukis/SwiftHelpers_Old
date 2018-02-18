import Foundation

public class BTNode<T: Equatable & Comparable & CustomStringConvertible> {
    public var leftChild: BTNode?
    public var rightChild: BTNode?
    public var value: T

    public init(_ value: T, leftChild: BTNode<T>? = nil, rightChild: BTNode<T>? = nil) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
    }

    public func deepCopy() -> BTNode {
        return BTNode(self.value, leftChild: self.leftChild?.deepCopy(), rightChild: self.rightChild?.deepCopy())
    }
}

extension BTNode: Equatable {
    public static func ==(lhs: BTNode<T>, rhs: BTNode<T>) -> Bool {
        guard lhs.value == rhs.value else {
            return false
        }

        return lhs.leftChild == rhs.leftChild && lhs.rightChild == rhs.rightChild
    }
}

extension BTNode: Comparable {
    public static func <(lhs: BTNode<T>, rhs: BTNode<T>) -> Bool {
        return lhs.value < rhs.value
    }
}

extension BTNode: CustomStringConvertible {
    public var description : String {
        let leftChildDescription = leftChild != nil ? String(describing: leftChild!) + " <-- " : ""
        let rightChildDescription = rightChild != nil ? " --> " + String(describing: rightChild!) : ""

        return leftChildDescription + String(describing: value) + rightChildDescription
    }
}
