//
//  Swift+Ext.swift
//  O-Mart
//
//  Created by Ô Chợ Việt on 9/7/17.
//  Copyright © 2017 Ô Chợ Việt. All rights reserved.
//

import Foundation

// Anything that can hold a value (strings, arrays, etc)
protocol Occupiable {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

extension Optional {
    var hasValue: Bool {
        switch self {
        case .none:
            return false
        case .some(_):
            return true
        }
    }
}

// Give a default implementation of isNotEmpty, so conformance only requires one implementation
extension Occupiable {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Occupiable { }

// I can't think of a way to combine these collection types. Suggestions welcome.
extension Array: Occupiable { }
extension Dictionary: Occupiable { }
extension Set: Occupiable { }

// Extend the idea of occupiability to optionals. Specifically, optionals wrapping occupiable things.
extension Optional where Wrapped: Occupiable {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
    
    var isNotNilNotEmpty: Bool {
        return !isNilOrEmpty
    }
}
