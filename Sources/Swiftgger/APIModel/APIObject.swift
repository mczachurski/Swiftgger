//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public protocol APIObjectProtocol {
    var anyObject: Any { get }
    var defaultName: String { get }
    var customName: String? { get }
}

/// Information about (request/response) Swift object.
public class APIObject<T: Encodable>: APIObjectProtocol {
    public let object: T
    public let defaultName: String
    public let customName: String?

    public var anyObject: Any { return object as Any }
    
    public init(object: T, customName: String? = nil) {
        self.object = object
        self.customName = customName
        self.defaultName = String(describing: type(of: object))
    }
}
