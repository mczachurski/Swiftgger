//
//  OpenAPISchemasBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger


@propertyWrapper final class Flag<Value> {
    let name: String
    var wrappedValue: Value

    fileprivate init(name: String, defaultValue: Value) {
        self.name = name
        self.wrappedValue = defaultValue
    }
}

class Vehicle {
    var name: String
    var age: Int?
    var fuels: [Fuel]?

    @Flag(name: "feature1", defaultValue: "ws") var wrappedString: String?
    @Flag(name: "feature2", defaultValue: nil) var wrappedFuel: Fuel?

    init(name: String, age: Int, fuels: [Fuel]? = nil, wrappedString: String? = nil, wrappedFuel: Fuel? = nil) {
        self.name = name
        self.age = age
        self.fuels = fuels
        self.wrappedString = wrappedString
        self.wrappedFuel = wrappedFuel
    }
}

struct Fuel {
    var level: Int
    var type: String
    
    init(level: Int, type: String) {
        self.level = level
        self.type = type
    }
}

struct Spaceship {
    var name: String
    var speed: Double?
    var fuel: Fuel?

    init(name: String, speed: Double, fuel: Fuel? = nil) {
        self.name = name
        self.speed = speed
        self.fuel = fuel
    }
}

class Alien {
    var spaceship: Spaceship
    
    init(spaceship: Spaceship) {
        self.spaceship = spaceship
    }
}

class User {
    var vehicles: [Vehicle]

    init(vehicles: [Vehicle]) {
        self.vehicles = vehicles
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
                         "type": "integer",
                         "format": "int64"
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
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"], "Schema name not exists")
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
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["Vehicle"]?.type)
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
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"]?.properties?["name"], "String property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["name"]?.type)
        XCTAssertEqual("Ford", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["name"]?.example)
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
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"], "Integer property not exists in schema")
        XCTAssertEqual("integer", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"]?.type)
        XCTAssertEqual("int64", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"]?.format)
        XCTAssertEqual(21, openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"]?.example)
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
        XCTAssert(openAPIDocument.components?.schemas?["Vehicle"]?.required?.contains("name") == true, "Required property not exists in schema")
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
        XCTAssert(openAPIDocument.components?.schemas?["Vehicle"]?.required?.contains("age") == false, "Not required property exists in schema")
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
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Spaceship"], "Schema name not exists")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["name"]?.type)
        XCTAssertEqual("Star Trek", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["name"]?.example)
        XCTAssertEqual("number", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["speed"]?.type)
        XCTAssertEqual("double", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["speed"]?.format)
        XCTAssertEqual(923211.0, openAPIDocument.components?.schemas?["Spaceship"]?.properties?["speed"]?.example)
    }

    func testSchemaWithCustomNameShouldHaveCorrectNameinOenAPIDocument() {
      // Arrange.
      let openAPIBuilder = OpenAPIBuilder(
        title: "Title",
        version: "1.0.0",
        description: "Description"
      ).add([
          APIObject(object: Spaceship(name: "Star Trek", speed: 923211), customName: "CustomSpaceship")
      ])

      // Act.
      let openAPIDocument = openAPIBuilder.built()

      // Assert.
      XCTAssertNotNil(openAPIDocument.components?.schemas?["CustomSpaceship"], "Custom Schema name not exists")
    }

    func testSchemaWithNestedObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: Alien(spaceship: Spaceship(name: "Star Trek", speed: 2122)))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Spaceship"], "Spaceship schema not exists")
        XCTAssertEqual("#/components/schemas/Spaceship", openAPIDocument.components?.schemas?["Alien"]?.properties?["spaceship"]?.ref)
    }

    func testSchemaWithNestedArrayOfObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: User(vehicles: [Vehicle(name: "Star Trek", age: 3)]))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"], "Vehicle schema not exists")
        XCTAssertEqual("#/components/schemas/Vehicle", openAPIDocument.components?.schemas?["User"]?.properties?["vehicles"]?.items?.ref)
    }

    func testSchemaWithOptionalNestedObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: Alien(spaceship: Spaceship(name: "Star Trek", speed: 2122))),
            APIObject(object: Spaceship(name: "Star Trek", speed: 2122, fuel: Fuel(level: 90, type: "E95")))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["fuel"]?.ref)
    }
    
    func testSchemaWithOptionalNestedArrayOfObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: Vehicle(name: "Star Trek", age: 3, fuels: [Fuel(level: 10, type: "GAS")]))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["fuels"]?.items?.ref)
    }
    
    func testSchemaWithNonInitializedOptionalNestedObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: Alien(spaceship: Spaceship(name: "Star Trek", speed: 2122))),
            APIObject(object: Spaceship(name: "Star Trek", speed: 2122)),
            APIObject(object: Fuel(level: 90, type: "E95"))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Spaceship"]?.properties?["fuel"]?.ref)
    }
    
    func testSchemaWithNonInitializedOptionalNestedArrayOfObjectsShouldBeTranslatedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
          title: "Title",
          version: "1.0.0",
          description: "Description"
        ).add([
            APIObject(object: Vehicle(name: "Star Trek", age: 3)),
            APIObject(object: Fuel(level: 10, type: "GAS"))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["fuels"]?.items?.ref)
    }
    
    func testSchemaPropertyWrapperForStringShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "First name"))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedString"], "Wrapped string property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedString"]?.type)
    }
    
    func testSchemaPropertyWrapperForStructShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedFuel: Fuel(level: 1, type: "")))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"], "Wrapped struct property not exists in schema")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"]?.ref)
    }
}
