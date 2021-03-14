//
//  File.swift
//  
//
//  Created by Marcin Czachurski on 14/03/2021.
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
