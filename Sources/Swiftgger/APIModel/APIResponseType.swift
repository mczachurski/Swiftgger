//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

/// Possible response types.
public enum APIResponseType {
    case object(Any.Type, asCollection: Bool = false)
    case value(Any)
}
