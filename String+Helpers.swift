extension Optional where Wrapped == String  {

    /*
    NOTE: Since this extends Optional rather than the possible String,
    you don't use the "?" when calling it `isEmptyOrNil()`
    Example:
      var myString: String? = ""
      myString.isEmptyOrNil  // Evaluates to true.
      myString = nil
      myString.isEmptyOrNil  // Also evaluates to true.
      myString?.isEmptyOrNil // Will not compile.
    */
    
    var isEmptyOrNil: Bool {
        switch self {
        case .some(let string):
            return string == ""
        case .none:
            return true
        }
    }
    
    /*
    This allows you to use nil coalescing to on a string, whether it's nil or just empty. 
    Example:
      var myString: String? = ""
      var nonNilString: String = myString.nilIfEmpty() ?? "WOOT"  // nonNilString will equal "WOOT"
      myString = nil
      nonNilString: String = myString.nilIfEmpty() ?? "NEATO"     // nonNilString will equal "NEATO"
    */
    
    func nilIfEmpty() -> String? {
        return isEmptyOrNil ? nil : self!
    }
}
