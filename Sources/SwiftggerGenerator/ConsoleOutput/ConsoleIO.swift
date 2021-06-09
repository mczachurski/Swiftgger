//
//  ConsoleIO.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 20/02/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public class ConsoleIO {
    
    public init() {
    }
    
    public func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print(message)
        case .debug:
            fputs("\(message)", stdout)
            fflush(stdout)
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
}
