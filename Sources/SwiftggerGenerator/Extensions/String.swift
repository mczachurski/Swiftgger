//
//  String.swift
//  SwiftggerGenerator
//
//  Created by Marcin Czachurski on 20/02/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//


import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
