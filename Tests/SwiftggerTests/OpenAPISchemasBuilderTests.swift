//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import XCTest
@testable import Swiftgger

@propertyWrapper final class Flag<Value>: Encodable {
    let name: String
    var wrappedValue: Value

    fileprivate init(name: String, defaultValue: Value) {
        self.name = name
        self.wrappedValue = defaultValue
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

@propertyWrapper
struct NullEncodable<T>: Encodable where T: Encodable {
    
    var wrappedValue: T?

    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value): try container.encode(value)
        case .none: try container.encodeNil()
        }
    }
}

class Vehicle: Encodable {
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

struct Fuel: Encodable {
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

struct Spaceship: Encodable {
    var name: String
    var speed: Double?
    var fuel: Fuel?

    init(name: String, speed: Double?, fuel: Fuel? = nil) {
        self.name = name
        self.speed = speed
        self.fuel = fuel
    }
}

class Alien: Encodable {
    var spaceship: Spaceship
    @NullEncodable var age: Int?
    
    init(spaceship: Spaceship, age: Int? = nil) {
        self.spaceship = spaceship
        self.age = age
    }
}

class User: Encodable {
    var vehicles: [Vehicle]
    var family: [String: Alien]?
    var birthDate: Date?

    init(vehicles: [Vehicle], family: [String: Alien]? = nil, birthDate: Date? = nil) {
        self.vehicles = vehicles
        self.family = family
        self.birthDate = birthDate
    }
}

class VehicleKeys: Encodable {
    var singleId: UUID
    var arrayIds: [UUID]
    
    init(singleId: UUID, arrayIds: [UUID]) {
        self.singleId = singleId
        self.arrayIds = arrayIds
    }
}

struct Species: Encodable
{
    var id = 12
    var name: String
    var countryOfOrigin: String

    enum CodingKeys: String, CodingKey {
        case name
        case countryOfOrigin = "country_of_origin"
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
        XCTAssertEqual("int32", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"]?.format)
        XCTAssertEqual(21, openAPIDocument.components?.schemas?["Vehicle"]?.properties?["age"]?.example)
    }
    
    func testSchemaDatePropertyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: "2012-04-23T18:25:43.511Z")!
        
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: User(vehicles: [], family: [:], birthDate: date))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["User"]?.properties?["birthDate"], "Integer property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["User"]?.properties?["birthDate"]?.type)
        XCTAssertEqual("date-time", openAPIDocument.components?.schemas?["User"]?.properties?["birthDate"]?.format)
        XCTAssertEqual("2012-04-23T18:25:43.511Z", openAPIDocument.components?.schemas?["User"]?.properties?["birthDate"]?.example)
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
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedString"]?.type)
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedString"]?.properties?["name"]?.type)
        // XCTAssert(openAPIDocument.components?.schemas?["Vehicle"]?.required?.contains("wrappedString") == true, "Required property not exists in schema")
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
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"]?.type)
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Vehicle"]?.properties?["wrappedFuel"]?.properties?["name"]?.type)
    }
    
    func testSchemaPropertyWrapperSingleValueContainerShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Spaceship(name: "UFO", speed: 12)),
            APIObject(object: Alien(spaceship: Spaceship(name: "UFO", speed: 12), age: 21))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Alien"]?.properties?["age"], "Wrapped struct property not exists in schema")
        XCTAssertEqual("integer", openAPIDocument.components?.schemas?["Alien"]?.properties?["age"]?.type)
        XCTAssertEqual("int32", openAPIDocument.components?.schemas?["Alien"]?.properties?["age"]?.format)
    }
    
    func testSchemaWithArrayOfStringShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Fuel(level: 1, type: "", parameters: ["power", "speed"]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Fuel"], "Fuel schema not exists")
        XCTAssertEqual("array", openAPIDocument.components?.schemas?["Fuel"]?.properties?["parameters"]?.type)
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Fuel"]?.properties?["parameters"]?.items?.type)
        
        let example = openAPIDocument.components?.schemas?["Fuel"]?.properties?["parameters"]?.example?.value as? [String]
        XCTAssertNotNil(example, "Example array not exists")
        XCTAssertEqual("power", example![0])
        XCTAssertEqual("speed", example![1])
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
            APIObject(object: User(vehicles: [], family: ["Fred": Alien(spaceship: Spaceship(name: "", speed: 12))])),
            APIObject(object: Alien(spaceship: Spaceship(name: "", speed: 12))),
            APIObject(object: Spaceship(name: "", speed: 12))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["User"], "Fuel schema not exists")
        XCTAssertEqual("object", openAPIDocument.components?.schemas?["User"]?.properties?["family"]?.type)
        XCTAssertEqual("#/components/schemas/Alien", openAPIDocument.components?.schemas?["User"]?.properties?["family"]?.additionalProperties?.ref)
    }
    
    func testSchemaWithUUIDProperyShouldBeTranslatedToOpenApiDocument() {
        // Arrange.
        let singleId = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: VehicleKeys(singleId: singleId, arrayIds: [UUID(), UUID()]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["VehicleKeys"], "VehicleKeys schema not exists")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["singleId"]?.type)
        XCTAssertEqual("uuid", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["singleId"]?.format)
        XCTAssertEqual("E621E1F8-C36C-495A-93FC-0C247A3E6E5F", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["singleId"]?.example)
    }
    
    func testSchemaWithArrayOfUUIDProperyShouldBeTranslatedToOpenApiDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: VehicleKeys(singleId: UUID(), arrayIds: [
                UUID(uuidString: "CE30476C-B335-41A8-9E68-1C0C98DCEB60")!,
                UUID(uuidString: "B5728916-CD90-4A88-ABFD-23576BA563DA")!
            ]))
        ])
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["VehicleKeys"], "VehicleKeys schema not exists")
        XCTAssertEqual("array", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["arrayIds"]?.type)
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["arrayIds"]?.items?.type)
        XCTAssertEqual("uuid", openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["arrayIds"]?.items?.format)
        
        let example = openAPIDocument.components?.schemas?["VehicleKeys"]?.properties?["arrayIds"]?.example?.value as? [String]
        XCTAssertNotNil(example, "Example array not exists")
        XCTAssertEqual("CE30476C-B335-41A8-9E68-1C0C98DCEB60", example![0])
        XCTAssertEqual("B5728916-CD90-4A88-ABFD-23576BA563DA", example![1])
    }
    
    func testSchemaWithCodingKeysShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: Species(name: "Ant", countryOfOrigin: "Africa"))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()
        
        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Species"]?.properties?["name"], "Name property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Species"]?.properties?["name"]?.type)
        XCTAssertEqual("Ant", openAPIDocument.components?.schemas?["Species"]?.properties?["name"]?.example)
        
        XCTAssertNotNil(openAPIDocument.components?.schemas?["Species"]?.properties?["country_of_origin"], "Country of origin property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["Species"]?.properties?["country_of_origin"]?.type)
        XCTAssertEqual("Africa", openAPIDocument.components?.schemas?["Species"]?.properties?["country_of_origin"]?.example)
    }
    
    func testSchemaWithCustomEncodingStrategyShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add([
            APIObject(object: User(vehicles: [], family: [:], birthDate: Date()))
        ])
        .use(keyEncodingStrategy: .convertToSnakeCase)

        // Act.
        let openAPIDocument = openAPIBuilder.built()
        
        // Assert.
        XCTAssertNotNil(openAPIDocument.components?.schemas?["User"]?.properties?["birth_date"], "birth_date property not exists in schema")
        XCTAssertEqual("string", openAPIDocument.components?.schemas?["User"]?.properties?["birth_date"]?.type)
        XCTAssertEqual("date-time", openAPIDocument.components?.schemas?["User"]?.properties?["birth_date"]?.format)
    }
}
