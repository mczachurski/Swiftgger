//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about (request/response) Swift object.
public class APIObject {
    let object: Any
    let defaultName: String
    let customName: String?

    public init(object: Any, customName: String? = nil) {
        self.object = object
        self.customName = customName
        self.defaultName = String(describing: type(of: object))
    }
}
