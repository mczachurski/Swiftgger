//
//  APIObject.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 02.04.2018.
//

import Foundation

/// Information about (request/response) Swift object.
public class APIObject {
    var object: Any?
  var customName: String?

  public init(object: Any? = nil, customName: String? = nil) {
        self.object = object
        self.customName = customName
    }
}
