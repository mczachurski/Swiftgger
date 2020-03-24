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

    static var allTests = [
        ("testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument", testBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument", testBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testBearerAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument),
        ("testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testBasicAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument),
        ("testApiKeyAuthorizationsShouldBeTranslatedToOpenAPIDocument", testApiKeyAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testApiKeyAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument", testApiKeyAuthorizationForActionsShouldBeTranslatedToOpenAPIDocument)
    ]
}
