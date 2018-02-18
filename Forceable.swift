
protocol Forceable {
    associatedtype ForceCastJustification
    static func cast<T, U>(object instance: T, to _: U.Type, justification: ForceCastJustification) -> U
    static func cast<T, U>(object instance: T?, to _: U.Type, justification: ForceCastJustification) -> U

    associatedtype ForceUnwrapJustification
    static func unwrap<T>(object instance: T?, justification: ForceCastJustification) -> T
}

extension Forceable {
    static func cast<T, U>(object: T, to _: U.Type, justification: ForceCastJustification) -> U {
        guard let castedObject = object as? U else {
            fatalError("Force casting \(String(describing: object)) to \(U.self) did not work. Justification given: \(justification)")
        }

        return castedObject
    }

    static func cast<T, U>(object: T?, to _: U.Type, justification: ForceCastJustification) -> U {
        guard let castedObject = object as? U else {
            fatalError("Force casting \(String(describing: object)) to \(U.self) did not work. Justification given: \(justification)")
        }

        return castedObject
    }

    static func unwrap<T>(object: T?, justification: ForceCastJustification) -> T {
        guard let castedObject = object else {
            fatalError("Force unwrapping \(String(describing: object)) did not work. Justification given: \(justification)")
        }

        return castedObject
    }
}
