//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

/// Information about server where API is hosted.
public class APIServer {

    var url: String
    var description: String?
    var variables: [APIVariable]?

    public init(url: String, description: String? = nil, variables: [APIVariable]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}
