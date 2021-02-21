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

    @Flag(name: "feature1", defaultValue: "ws") var wrappedString: String
    @Flag(name: "feature2", defaultValue: nil) var wrappedFuel: Fuel?

    init(name: String, age: Int, wrappedString: String, fuels: [Fuel]? = nil, wrappedFuel: Fuel? = nil) {
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
    var parameters: [String]
    var tags: [String: String]?
    
    init(level: Int, type: String, parameters: [String], tags: [String: String]? = nil) {
        self.level = level
        self.type = type
        self.parameters = parameters
        self.tags = tags
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
    var family: [String: Alien]?

    init(vehicles: [Vehicle], family: [String: Alien]? = nil) {
        self.vehicles = vehicles
        self.family = family
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something"))
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
            APIObject(object: User(vehicles: [Vehicle(name: "Star Trek", age: 3, wrappedString: "something")]))
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
            APIObject(object: Spaceship(name: "Star Trek", speed: 2122, fuel: Fuel(level: 90, type: "E95", parameters: ["power"])))
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
            APIObject(object: Vehicle(name: "Star Trek", age: 3, wrappedString: "something", fuels: [Fuel(level: 10, type: "GAS", parameters: ["power"])]))
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
            APIObject(object: Fuel(level: 90, type: "E95", parameters: ["power"]))
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
            APIObject(object: Vehicle(name: "Star Trek", age: 3, wrappedString: "something")),
            APIObject(object: Fuel(level: 10, type: "GAS", parameters: ["power"]))
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
        XCTAssert(openAPIDocument.components?.schemas?["Vehicle"]?.required?.contains("wrappedString") == true, "Required property not exists in schema")
    }
    
    func testSchemaPropertyWrapperForStructShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Vehicle(name: "Ford", age: 21, wrappedString: "something", wrappedFuel: Fuel(level: 1, type: "", parameters: ["power"])))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"], "Wrapped struct property not exists in schema")
        XCTAssertEqual("#/components/schemas/Fuel", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"]?.ref)
    }
    
    func testSchemaWithArrayOfStringShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Fuel(level: 1, type: "", parameters: ["power"]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Fuel"]?.properties?["parameters"]?.items?.type)
    }
    
    func testSchemaWithDictionaryOfStringShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Fuel(level: 1, type: "", parameters: ["power"], tags: ["key": "value"]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["Fuel"]?.properties?["tags"]?.type)
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Fuel"]?.properties?["tags"]?.additionalProperties?.type)
    }
    
    func testSchemaWithDictionaryOfObjectsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: User(vehicles: [], family: ["Fred": Alien(spaceship: Spaceship(name: "", speed: 12))]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["User"], "Fuel schema not exists")
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["User"]?.properties?["family"]?.type)
        XCTAssertEqual("#/components/schemas/Alien", openAPIDocument.components?.schemas?["User"]?.properties?["family"]?.additionalProperties?.ref)
    }
}
