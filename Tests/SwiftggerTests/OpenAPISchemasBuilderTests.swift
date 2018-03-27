//
//  OpenAPISchemasBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class Vehicle {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

/*
    Tests for schames part of OpenAPI standard (/components/schemas).

    "components": {
        "schemas": {
            "Vehicle" : {
                 "type": "object",
                 "properties": {
                     "age": {
                         "type": "int",
                     },
                     "name": {
                        "type": "string"
                     }
                 },
                 "required": [
                    "name"
                 ],
                 "example": {
                     "name": "Ford",
                     "age": 21
                 }
            }
        }
    }
 */
class OpenAPISchemasBuilderTests: XCTestCase {

    func testSchemaNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/api/action", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: car))
        ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"], "Schema name not exists")
    }

    func testSchemaTypeShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: car))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("object", openAPIDocument.components?.schemas!["Vehicle"]?.type)
    }

    func testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/api/action", summary: "Action summary",
                      description: "Action description", request: APIRequest(object: car))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"], "String property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"]?.type)
        XCTAssertEqual("Ford", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"]?.example)
    }

    func testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: car))
            ]
        ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"], "Integer property not exists in schema")
        XCTAssertEqual("int", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"]?.type)
        XCTAssertEqual("21", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"]?.example)
    }

    func testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: car))
                ]
            ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["Vehicle"]?.required?.contains("name") == true, "Required property not exists in schema")
    }

    func testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let car = Vehicle(name: "Ford", age: 21)
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/api/action", summary: "Action summary",
                          description: "Action description", request: APIRequest(object: car))
                ]
            ))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["Vehicle"]?.required?.contains("age") == false, "Not required property exists in schema")
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
