//
//  OpenAPISecurityScheme.swift
//  Swiftgger
//
//  Created by Marcin Czachurski on 19.03.2018.
//

import Foundation

// Defines a security scheme that can be used by the operations. Supported schemes are HTTP authentication,
// an API key (either as a header or as a query parameter), OAuth2's common flows (implicit, password,
// application and access code) as defined in RFC6749, and OpenID Connect Discovery.
class OpenAPISecurityScheme: Encodable {

    public private(set) var ref: String?
    public private(set) var type: String?
    public private(set) var description: String?
    public private(set) var name: String?
    public private(set) var parameterLocation: APILocation = APILocation.path
    public private(set) var scheme: String?
    public private(set) var bearerFormat: String?
    public private(set) var flows: OpenAPIOAuthFlows?
    public private(set) var openIdConnectUrl: String?

    init(ref: String) {
        self.ref = ref
    }

    init(
        type: String? = nil,
        description: String? = nil,
        name: String? = nil,
        parameterLocation: APILocation = APILocation.path,
        scheme: String? = nil,
        bearerFormat: String? = nil,
        flows: OpenAPIOAuthFlows? = nil,
        openIdConnectUrl: String? = nil
    ) {
        self.type = type
        self.description = description
        self.name = name
        self.parameterLocation = parameterLocation
        self.scheme = scheme
        self.bearerFormat = bearerFormat
        self.flows = flows
        self.openIdConnectUrl = openIdConnectUrl
    }

    private enum CodingKeys: String, CodingKey {
        case ref = "$ref"
        case type
        case description
        case name
        case parameterLocation = "in"
        case scheme
        case bearerFormat
        case flows
        case openIdConnectUrl
    }
}
