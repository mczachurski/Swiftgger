//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

extension String {
    
    static var empty: String {
        get {
            return ""
        }
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func saveTo(fileName: String, andPath outputPath: String) throws {
        guard let data = self.data(using: .utf8) else {
            throw SwiftggerError.dataNotDownloaded
        }
        
        let location = URL(fileURLWithPath: "\(outputPath)/\(fileName).swift")
        try data.write(to: location)
    }
    
    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func lowercaseFirstLetter() {
        self = self.lowercasingFirstLetter()
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
