/**
 Simulate Name Spacing - advanced usage:

 extension UIColor: AppCompatible {}
 
 // In ModuleOne

 class ModuleOneColors {
     static var red: UIColor {
         return UIColor(colorLiteralRed: 1.0, green: 0.4, blue: 0, alpha: 1)
     }
 }

 extension AppBase where Base: UIColor {
     static var moduleOne: ModuleOneColors.Type {
         return ModuleOneColors.self
     }

     var moduleOne: ModuleOneColors {
         return ModuleOneColors()
     }
 }


 // In ModuleTwo

 class ModuleTwoColors {
     static var red: UIColor {
         return UIColor(colorLiteralRed: 1.0, green: 0, blue: 0.4, alpha: 1)
     }
 }

 extension AppBase where Base: UIColor {
     static var moduleTwo: ModuleTwoColors.Type {
         return ModuleTwoColors.self
     }

     var moduleTwo: ModuleTwoColors {
         return ModuleTwoColors()
     }
 }

 func iNeedColorsFromBothModules() {
     UIColor.app.moduleOne.red
     UIColor.app.moduleTwo.red
 }
 */

/**
 This class is extended to add App specific behavior. Constrain `Base` to a specific type in each extention.
 
 When adding instance functions and/or read-only properties, use `base` to get the underlying instance.
 
 ## Example ##
 ```swift
 extention AppBase where Base: UIColor {
     static var red: UIColor {
         return UIColor(colorLiteralRed: 1.0, green: 0, blue: 0.4, alpha: 1)
     }
 
     func rgbaComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
         var red: CGFloat = 0.0
         var green: CGFloat = 0.0
         var blue: CGFloat = 0.0
         var alpha: CGFloat = 0.0
 
         // here `base` is of type `UIColor` and will be the exact instance that is calling this function on its `.app` property.
         base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

         return (Double(red), Double(green), Double(blue), Double(alpha))
     }
 }
 ```
 */
class AppBase<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

/**
 Every type wanting to be extended through `AppBase` must first conform to `AppCompatible`.
 
 ## Example ##
 ```swift
 extension UIColor: AppCompatible {}
 ```
 */
protocol AppCompatible {
    associatedtype CompatibleType
    var app: AppBase<CompatibleType> { get }
    static var app: AppBase<CompatibleType>.Type { get }
}

/**
 `.app` is how each type gets access to the functions and read-only properties added in the corresponding `AppBase` extension.
 
 ## Example ##
 ```swift
 let customRed = UIColor.app.red
 
 let color: UIColor
 let components = color.rgbaComponents()
 ```
 */
extension AppCompatible {
    var app: AppBase<Self> {
        return AppBase(self)
    }

    static var app: AppBase<Self>.Type {
        return AppBase<Self>.self
    }
}
