//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

public enum SwiftggerError: Error {
    case incorrectUrl(url: String)
    case requestError(error: Error)
    case dataNotDownloaded
    
    public var message: String {
        switch self {
        case .incorrectUrl(let url):
            return "Incorrect URL '\(url)'."
        case .requestError(let error):
            return "Error during downloading file \(error)."
        case .dataNotDownloaded:
            return "Data has not been downloaded"
        }
    }
}
