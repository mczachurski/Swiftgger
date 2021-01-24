//
//  OpenAPISecurityBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

/**
    Tests for security schemes list (/components/securitySchemes).

    ```
    components: {
        "securitySchemes" : {
            "auth_jwt" : {
                "bearerFormat" : "jwt",
                "in" : "header",
                "type" : "http",
                "description" : "You can get token from *sign-in* action from *Account* controller.",
                "scheme" : "bearer"
            }
        }
    }
    ```
 */
class OpenAPISecurityBuilderTests: XCTestCase {

    func testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_basic"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("basic", securitySchema?.scheme)
        XCTAssertEqual("Basic authorization", securitySchema?.description)
    }
    
    func testApiKeyAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.apiKey(description: "Api key authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["api_key"]
        XCTAssertEqual("apiKey", securitySchema?.type)
        XCTAssertEqual(nil, securitySchema?.scheme)
        XCTAssertEqual("Api key authorization", securitySchema?.description)
        XCTAssertEqual(APILocation.header, securitySchema?.parameterLocation)
        XCTAssertEqual("X-API-KEY", securitySchema?.name)
    }
    
    func testApiKeyAuthorizationsWithCustomParametersShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.apiKey(description: "Api key authorization", keyName: "api_header", location: .query)]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["api_key"]
        XCTAssertEqual("apiKey", securitySchema?.type)
        XCTAssertEqual(nil, securitySchema?.scheme)
        XCTAssertEqual("Api key authorization", securitySchema?.description)
        XCTAssertEqual(APILocation.query, securitySchema?.parameterLocation)
        XCTAssertEqual("api_header", securitySchema?.name)
    }

    func testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_jwt"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("bearer", securitySchema?.scheme)
        XCTAssertEqual("jwt", securitySchema?.bearerFormat)
        XCTAssertEqual("JWT authorization", securitySchema?.description)
    }
    
    func testOAuth2AuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [
                .oauth2(description: "OAuth authorization", flows: [
                    .implicit(APIAuthorizationFlow(authorizationUrl: "https://oauth2.com", tokenUrl: "https://oauth2.com/token", scopes: [:]))
                ])
            ]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["oauth2"]
        XCTAssertEqual("oauth2", securitySchema?.type)
        XCTAssertNotNil(securitySchema?.flows)
        XCTAssertNotNil(securitySchema?.flows?.implicit)
        XCTAssertEqual("https://oauth2.com", securitySchema?.flows?.implicit?.authorizationUrl)
        XCTAssertEqual("https://oauth2.com/token", securitySchema?.flows?.implicit?.tokenUrl)
    }
    
    func testOpenIdAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [
                .openId(description: "OpenIdConnect authorization", openIdConnectUrl: "https//opeind.com")
            ]
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["openId"]
        XCTAssertEqual("openIdConnect", securitySchema?.type)
        XCTAssertEqual("https//opeind.com", securitySchema?.openIdConnectUrl)
    }

    func testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", authorization: true)
            ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["auth_jwt"], "Bearer authorization should be enabled")

    }

    func testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", authorization: true)
            ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["auth_basic"], "Basic authorization should be enabled")
    }
    
    func testApiKeyAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.apiKey(description: "Api key authorization")]
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", authorization: true)
            ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["api_key"], "Api key authorization should be enabled")
    }
    
    func testOAuth2AuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [
                .oauth2(description: "OAuth authorization", flows: [
                    .implicit(APIAuthorizationFlow(authorizationUrl: "https://oauth2.com", tokenUrl: "https://oauth2.com/token", scopes: [:]))
                ])
            ]
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", authorization: true)
            ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["oauth2"], "OAuth2 authorization should be enabled")
    }
    
    func testOpenIdAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [
                .openId(description: "OpenIdConnect authorization", openIdConnectUrl: "https//opeind.com")
            ]
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", authorization: true)
            ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.security![0]["openId"], "OpenId authorization should be enabled")
    }
}
