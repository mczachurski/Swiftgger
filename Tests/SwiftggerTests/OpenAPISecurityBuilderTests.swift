//
//  OpenAPISecurityBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class OpenAPISecurityBuilderTests: XCTestCase {

    func testAPIBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_basic"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("basic", securitySchema?.scheme)
        XCTAssertEqual("Basic authorization", securitySchema?.description)
    }

    func testAPIBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_jwt"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("bearer", securitySchema?.scheme)
        XCTAssertEqual("jwt", securitySchema?.bearerFormat)
        XCTAssertEqual("JWT authorization", securitySchema?.description)
    }

    static var allTests = [
        ("testAPIBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument", testAPIBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testAPIBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument", testAPIBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument)
    ]
}
