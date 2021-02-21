//
//  Program.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import Swiftgger

class Program {
    let consoleIO = ConsoleIO()
    let modelSerializer = ModelSerializer()

    var inputPath: String = ""
    var inputUrl: String = ""
    var outputPath: String = "output"

    func run() -> Bool {
        do {

            let (shouldBreak, resultCode) = self.proceedCommandLineArguments()
            if shouldBreak {
                return resultCode
            }
            
            let data = try self.readOpenApiJson()
            let openApiDocument = try JSONDecoder().decode(OpenAPIDocument.self, from: data)
            
            try self.modelSerializer.generate(openApiDocument: openApiDocument, outputPath: self.outputPath)

        } catch (let error as SwiftggerError) {
            self.consoleIO.writeMessage("Unexpected error occurs: \(error.message)", to: .error)
            return false
        } catch {
            self.consoleIO.writeMessage("Unexpected error occurs: \(error)", to: .error)
            return false
        }
        
        return true
    }
    
    private func readOpenApiJson() throws -> Data {
        if self.inputUrl != "" {
            return try self.readOpenApiJsonUrl()
        } else {
            return try self.readOpenApiJsonFile()
        }
    }
    
    private func readOpenApiJsonUrl() throws -> Data {
        guard let url = URL(string: inputUrl) else {
            throw SwiftggerError.incorrectUrl(url: self.inputUrl)
        }

        let request = URLRequest(url: url)
        let response = URLSession.shared.synchronousDataTask(urlrequest: request)
        
        if let error = response.error {
            throw SwiftggerError.requestError(error: error)
        }
        
        guard let data = response.data else {
            throw SwiftggerError.dataNotDownloaded
        }
        
        return data
    }
    
    private func readOpenApiJsonFile() throws -> Data {
        let inputUrl = URL(fileURLWithPath: inputPath)
        let inputFileContents = try Data(contentsOf: inputUrl)
        
        return inputFileContents
    }
    
    private func proceedCommandLineArguments() -> (Bool, Bool) {
        if CommandLine.arguments.count == 1 {
            self.printUsage()
            return (true, false)
        }

        var optionIndex = 1
        while optionIndex < CommandLine.arguments.count {

            let option = CommandLine.arguments[optionIndex]
            let optionType = OptionType(value: option)

            switch optionType {
            case .help:
                self.printUsage()
                return (true, true)
            case .version:
                self.printVersion()
                return (true, true)
            case .file:
                let inputPathIndex = optionIndex + 1
                if inputPathIndex < CommandLine.arguments.count {
                    self.inputPath = CommandLine.arguments[inputPathIndex]
                }

                optionIndex = inputPathIndex
            case .url:
                let inputUrlIndex = optionIndex + 1
                if inputUrlIndex < CommandLine.arguments.count {
                    self.inputUrl = CommandLine.arguments[inputUrlIndex]
                }

                optionIndex = inputUrlIndex
                break
            case .output:
                let outputPathIndex = optionIndex + 1
                if outputPathIndex < CommandLine.arguments.count {
                    self.outputPath = CommandLine.arguments[outputPathIndex]
                }

                optionIndex = outputPathIndex
            default:
                break;
            }

            optionIndex = optionIndex + 1
        }

        if self.inputPath == "" && self.inputUrl == "" {
            self.consoleIO.writeMessage("unknown input file name or url.", to: .error)
            return (true, false)
        }

        return (false, false)
    }

    private func printVersion() {
        self.consoleIO.writeMessage("1.5.0")
    }

    private func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent

        self.consoleIO.writeMessage("\(executableName): [command_option] [-f jsonFile] [-u url] [-o path]")
        self.consoleIO.writeMessage("Command options are:")
        self.consoleIO.writeMessage(" -h\t\t\tshow this message and exit")
        self.consoleIO.writeMessage(" -v\t\t\tshow program version and exit")
        self.consoleIO.writeMessage(" -f\t\t\tinput .json file with OpenAPI description")
        self.consoleIO.writeMessage(" -u\t\t\tinput URL which returns .json with OpenAPI description")
        self.consoleIO.writeMessage(" -o\t\t\toutput directory (default is 'output')")
    }
}
