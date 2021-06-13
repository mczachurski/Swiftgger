//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import Foundation

extension Encodable {
    func openedEncode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
