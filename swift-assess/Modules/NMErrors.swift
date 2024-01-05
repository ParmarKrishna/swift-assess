//
//  NMErrors.swift
//  swift-assess
//
//  Created by Admin on 05/01/24.
//

import Foundation

enum NMErrors:Error{
    case noInternet
    case serverError404
    case requestError
    case couldNotDecode
}
