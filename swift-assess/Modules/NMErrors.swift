// Module for Custom Error for Error Handling
import Foundation

enum NMErrors:Error{
    case noInternet
    case serverError404
    case requestError
    case couldNotDecode
}
