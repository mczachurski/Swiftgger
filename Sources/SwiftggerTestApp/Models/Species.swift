//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import Foundation

struct Species: Encodable
{
    var name: String
    var countryOfOrigin: String

    enum CodingKeys: String, CodingKey {
        case name
        case countryOfOrigin = "country_of_origin"
    }
}
