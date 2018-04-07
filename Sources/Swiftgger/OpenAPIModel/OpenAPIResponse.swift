//
//  OpenAPIResponse.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

/**
    Describes a single response from an API Operation, including design-time,
    static links to operations based on the response.
 */
public class OpenAPIResponse: Encodable {

    public private(set) var ref: String?
    public private(set) var description: String?
    public private(set) var headers: [String: OpenAPIHeader]?
    public private(set) var content: [String: OpenAPIMediaType]?
    public private(set) var links: [String: OpenAPILink]?

    init(ref: String) {
        self.ref = ref
    }

    init(description: String, headers: [String: OpenAPIHeader]? = nil, content: [String: OpenAPIMediaType]? = nil, links: [String: OpenAPILink]? = nil) {
        self.description = description
        self.headers = headers
        self.content = content
        self.links = links
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case description
        case headers
        case content
        case links
    }
}
