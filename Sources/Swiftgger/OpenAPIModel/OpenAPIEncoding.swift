//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// A single encoding definition applied to a single schema property.
public class OpenAPIEncoding: Codable {

    public private(set) var contentType: String?
    public private(set) var headers: [String: OpenAPIHeader]?
    public private(set) var style: String?
    public private(set) var explode: Bool = false
    public private(set) var allowReserved: Bool = false

    init(
        contentType: String? = nil,
        headers: [String: OpenAPIHeader]? = nil,
        style: String? = nil,
        explode: Bool = false,
        allowReserved: Bool = false
    ) {
        self.contentType = contentType
        self.headers = headers
        self.style = style
        self.explode = explode
        self.allowReserved = allowReserved
    }
}
