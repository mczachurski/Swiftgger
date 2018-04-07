//
//  OpenAPISchemasBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

class Vehicle {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct Spaceship {
    var name: String
    var speed: Double?

    init(name: String, speed: Double) {
        self.name = name
        self.speed = speed
    }
}

/**
    Tests for schames part of OpenAPI standard (/components/schemas).

    ```
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
    ```
 */
class OpenAPISchemasBuilderTests: XCTestCase {

    func testSchemaNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"], "Schema name not exists")
    }

    func testSchemaTypeShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("object", openAPIDocument.components?.schemas!["Vehicle"]?.type)
    }

    func testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"], "String property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"]?.type)
        XCTAssertEqual("Ford", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["name"]?.example)
    }

    func testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"], "Integer property not exists in schema")
        XCTAssertEqual("int", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"]?.type)
        XCTAssertEqual("21", openAPIDocument.components?.schemas!["Vehicle"]?.properties!["age"]?.example)
    }

    func testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["Vehicle"]?.required?.contains("name") == true, "Required property not exists in schema")
    }

    func testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssert(openAPIDocument.components?.schemas!["Vehicle"]?.required?.contains("age") == false, "Not required property exists in schema")
    }

    func testSchemaStructTypeShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Spaceship(name: "Star Trek", speed: 923211))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas!["Spaceship"], "Schema name not exists")
        XCTAssertEqual("string", openAPIDocument.components?.schemas!["Spaceship"]?.properties!["name"]?.type)
        XCTAssertEqual("Star Trek", openAPIDocument.components?.schemas!["Spaceship"]?.properties!["name"]?.example)
        XCTAssertEqual("double", openAPIDocument.components?.schemas!["Spaceship"]?.properties!["speed"]?.type)
        XCTAssertEqual("923211.0", openAPIDocument.components?.schemas!["Spaceship"]?.properties!["speed"]?.example)
    }

    static var allTests = [
        ("testSchemaNameShouldBeTranslatedToOpenAPIDocument", testSchemaNameShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaTypeShouldBeTranslatedToOpenAPIDocument", testSchemaTypeShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument", testSchemaStringPropertyShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument", testSchemaIntegerPropertyShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument", testSchemaRequiredFieldsShouldBeTranslatedToOpenAPIDocument),
        ("testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument", testSchemaNotRequiredFieldsShouldNotBeTranslatedToOpenAPIDocument),
        ("testSchemaStructTypeShouldBeTranslatedToOpenAPIDocument", testSchemaStructTypeShouldBeTranslatedToOpenAPIDocument)
    ]
}
