//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import Foundation

class TemplateFileGenerator {
    func generate(outputPath: String) throws {
        try saveTemplate(name: "URLSession", outputPath: outputPath)
    }
    
    private func saveTemplate(name: String, outputPath: String) throws {
        guard let urlSessionDataURL = Bundle.module.url(forResource: name, withExtension: "template") else {
            return
        }
        
        let urlSessionData = try Data(contentsOf: urlSessionDataURL)
        let urlSesionString = String(data: urlSessionData, encoding: .utf8)
        try urlSesionString?.saveTo(fileName: name, andPath: outputPath)
    }
}
