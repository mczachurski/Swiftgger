//
//  main.swift
//  SwiftggerApp
//
//  Created by Marcin Czachurski on 21/10/2021.
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation
import Swiftgger

let program = Program()
let result = program.run()

exit(result ? EXIT_SUCCESS : EXIT_FAILURE)
