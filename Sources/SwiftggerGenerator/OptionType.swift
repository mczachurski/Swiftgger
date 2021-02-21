//
//  OptionType.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 20/02/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
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
