//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

/// Possible response types.
public enum APIBodyType {
    /// HTTP body is a dictionary. Dictionary key is always String. Parameter is a type which is a value in dictionary.
    case dictionary(Any.Type)
    
    /// HTTP body is a object (or array of objects). Here we have to specify object defined in `APIObject` collection.
    case object(Any.Type, asCollection: Bool = false)
    
    /// HPPT body is a simple type (string, integer etc.) or array of simple types.
    case value(Any)
}
