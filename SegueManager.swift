import UIKit

/**
 The delegate of a SegueManager. The conformer of this should be a subclass of UIViewController.

 - important: Must call `SegueManager`'s `prepare(for:sender:)` in conforming `UIViewControllers`'s `prepare(for:sender:)`.
 */
protocol SegueManagerDelegate: class {
    /**
     Replica of UIViewController's performSegue() function.

     Shouldn't have to implement this if UIViewController is conforming to `SegueManagerDelegate`
     */
    func performSegue(withIdentifier identifier: String, sender: Any?)
}

/**
 This object's makes seguing cleaner, safer, and easier to do.

\<I>: The type of the enum used to list all segue identifiers. Should be definied by the `UIViewController` conforming to `SegueManagerDelegate`

 Example UIViewController Implementation:
 ```
 class MyViewController: UIViewController, SegueManagerDelegate {
     enum SegueIdentifier: String {
         case routeToSomewhere
         case routeToSomewhereElse
     }

     var segueManager: SegueManager<SegueIdentifier>

     func doRouting() {
         segueManager.performSegue(.routeToSomewhere) { (destinationViewController: DestinationViewController) in
             destinationViewController.configure(with: "custom stuff")
         }
     }
 }
 ```
 */
class SegueManager<I: RawRepresentable> where I.RawValue == String {
    weak var delegate: SegueManagerDelegate?
    private var prepareHandlers: [String: (UIViewController) -> Void] = [:]

    /**
     Performs a segue from the `SegueManagerDelegate`.

     - parameter identifier: the segue's identifier.
     - parameter file: Used when reporting out `fatalError()`. Use default value.
     - parameter line: Used when reporting out `fatalError()`. Use default value.
     - parameter prepareHandler: the handler that is called during `prepare(for:sender:)`. The view controller passed in is the destination view controller. The type of the destination view controller needs to be specified by the caller of this function.

     Example:
     ```
     segueManager.performSegue(.routeToSomewhere) { (destinationViewController: DestinationViewController) in
         destinationViewController.configure(with: "custom stuff")
     }
     ```
     */
    func performSegue<VC: UIViewController>(_ identifier: I, file: StaticString = #file, line: UInt = #line, prepareHandler: @escaping (VC) -> Void) {
        prepareHandlers[identifier.rawValue] = { (viewController: UIViewController) in
            guard let destinationViewController = viewController as? VC else {
                fatalError("Expected destination view controller of type \(VC.self). Instead got \(type(of: viewController))", file: file, line: line)
            }

            prepareHandler(destinationViewController)
        }

        delegate?.performSegue(withIdentifier: identifier.rawValue, sender: self)
    }

    /**
     Used to call the appropriate prepare handler.

     This only works if the segue was initiated using the same instance of `SegueManager` as the one used to perform the segue.

     - important: Must call this in the `SegueManagerDelegate`'s `prepare(for:sender:)`
     */
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? SegueManager,
              sender === self,
              let identifier = segue.identifier,
              let prepareHandler = prepareHandlers[identifier] else {
            fatalError("Should segue using SegueManager")
        }

        prepareHandler(segue.destination)
    }
}



// MARK: - Playground Example

/*
class BasicViewController: UIViewController {
    func configure(string: String) {
        print("\(type(of: self)) has been configured with \(string)")
    }
}

class DifferentViewController: UIViewController {
    func configure(string: String) {
        print("\(type(of: self)) has been configured with \(string)")
    }
}



class MyViewController: UIViewController, SegueManagerDelegate {
    enum SegueIdentifier: String {
        case routeToBasic
        case routeToDifferent
    }

    var segueManager: SegueManager<SegueIdentifier>!

    func inject(segueManager: SegueManager<SegueIdentifier>) {
        self.segueManager = segueManager
        segueManager.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueManager.prepare(for: segue, sender: sender)
    }

    func tapBasicButton() {
        segueManager.performSegue(.routeToBasic) { (destVC: BasicViewController) in
            destVC.configure(string: "basic stuff")
        }
    }

    func tapDifferentButton() {
        segueManager.performSegue(.routeToDifferent) { (destVC: DifferentViewController) in
            destVC.configure(string: "different stuff")
        }
    }

    // Needed for Playgrounds
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        print("started sseguing")

        let destVC = identifier == "routeToDifferent" ? DifferentViewController() : BasicViewController()

        let segue = UIStoryboardSegue(identifier: identifier, source: self, destination: destVC)
        prepare(for: segue, sender: sender)

        print("finished seguing")
    }
}



let viewController = MyViewController()
let segueManager = SegueManager<MyViewController.SegueIdentifier>()
viewController.inject(segueManager: segueManager)

viewController.tapBasicButton()

print("")

viewController.tapDifferentButton()

*/
