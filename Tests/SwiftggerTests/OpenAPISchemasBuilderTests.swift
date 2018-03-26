//
//  OpenAPISchemasBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class TestClass {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class OpenAPISchemasBuilderTests: XCTestCase {

    func testSchemaNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/api/action", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: testClass))
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["TestClass"], "Schema name not exists")
    }

    func testSchemaTypeShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: testClass))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("object", openAPIDocument.components?.schemas!["TestClass"]?.type)
    }

    func testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/api/action", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: testClass))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["TestClass"]?.properties!["name"], "String property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas!["TestClass"]?.properties!["name"]?.type)
        XCTAssertEqual("Test name", openAPIDocument.components?.schemas!["TestClass"]?.properties!["name"]?.example)
    }

    func testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: testClass))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["TestClass"]?.properties!["age"], "Integer property not exists in schema")
        XCTAssertEqual("int", openAPIDocument.components?.schemas!["TestClass"]?.properties!["age"]?.type)
        XCTAssertEqual("21", openAPIDocument.components?.schemas!["TestClass"]?.properties!["age"]?.example)
    }

    func testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: testClass))
                ]
            ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["TestClass"]?.required?.contains("name") == true, "Required property not exists in schema")
    }

    func testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let testClass = TestClass(name: "Test name", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: testClass))
                ]
            ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["TestClass"]?.required?.contains("age") == false, "Not required property exists in schema")
    }

    static var allTests = [
        ("testSchemaNameShouldBeTranslatedToOpenAPIDocument", testSchemaNameShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaTypeShouldBeTranslatedToOpenAPIDocument", testSchemaTypeShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument", testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument", testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument", testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument", testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument)
    ]
}
