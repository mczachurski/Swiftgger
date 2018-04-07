//
//  OpenAPIPath.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/**
    Describes the operations available on a single path. A Path Item MAY be empty, due to ACL constraints.
    The path itself is still exposed to the documentation viewer but they will not know which operations
    and parameters are available.
 */
public class OpenAPIPathItem: Encodable {

    public private(set) var ref: String?
    public private(set) var summary: String?
    public private(set) var description: String?
    public private(set) var get: OpenAPIOperation?
    public private(set) var put: OpenAPIOperation?
    public private(set) var post: OpenAPIOperation?
    public private(set) var delete: OpenAPIOperation?
    public private(set) var options: OpenAPIOperation?
    public private(set) var head: OpenAPIOperation?
    public private(set) var patch: OpenAPIOperation?
    public private(set) var trace: OpenAPIOperation?
    public private(set) var servers: [OpenAPIServer]?
    public private(set) var parameters: [OpenAPIParameter]?

    init(ref: String) {
        self.ref = ref
    }

    init(summary: String? = nil, description: String? = nil) {
        self.summary = summary
        self.description = description
    }

    func addOperation(method: APIHttpMethod, operation: OpenAPIOperation) {
        switch method {
        case .get:
            self.get = operation
        case .post:
            self.post = operation
        case .put:
            self.put = operation
        case .delete:
            self.delete = operation
        case .patch:
            self.patch = operation
        case .options:
            self.options = operation
        case .trace:
            self.trace = operation
        case .head:
            self.head = operation
        default:
            print("Not implemented")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case summary
        case description
        case ref = "$ref"
        case get
        case put
        case post
        case delete
        case options
        case head
        case patch
        case trace
        case servers
        case parameters
    }
}
