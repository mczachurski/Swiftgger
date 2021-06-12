//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

enum OptionType: String {
    case help = "-h"
    case version = "-v"
    case file = "-f"
    case url = "-u"
    case output = "-o"
    case unknown

    init(value: String) {
        switch value {
        case "-h": self = .help
        case "-v": self = .version
        case "-f": self = .file
        case "-u": self = .url
        case "-o": self = .output
        default: self = .unknown
        }
    }
}
