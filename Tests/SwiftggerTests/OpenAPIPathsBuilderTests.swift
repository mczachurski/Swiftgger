//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable type_body_length file_length

class Animal: Encodable {
    var name: String
    var age: Int?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

/**
    Tests for paths components in OpenAPI standard (/paths).

    ```
    "paths": {
        "/animals": {
            "get": {
                "summary": "Returns all pets",
                "description": "Returns all pets from the system that the user has access to",
                "responses": {
                    "200": {
                        "description": "A list of pets.",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "array",
                                        "items": {
                                            "$ref": "#/components/schemas/pet"
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
            "post": {
                "summary": "Create new pet",
                "description": "Create new pet to the system",
                "requestBody": {
                    "description": "A list of pets.",
                    "content": {
                        "application/json": {
                            "schema": {
                                "$ref": "#/components/schemas/pet"
                            }
                        }
                    }
                }
                "responses": {
                    "200": {
                        "description": "A list of pets."
                    }
                }
            }
        }
    }
    ```
 */
class OpenAPIPathsBuilderTests: XCTestCase {

    func testActionRouteShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action route should be added to the tree.")
    }

    func testActionMethodShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"], "Action method should be added to the tree.")
    }

    func testActionSummaryShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Action summary", openAPIDocument.paths["/animals"]?.get?.summary)
    }

    func testActionDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Action description", openAPIDocument.paths["/animals"]?.get?.description)
    }

    func testActionCodeResponseShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"], "Action response code should be added to the tree.")
    }

    func testActionResponseDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                          APIResponse(code: "200", description: "Response description")
                        ]
            )
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Response description", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.description)
    }

    func testActionResponseContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content, "Response content should be added to the tree.")
    }

    func testActionDefaultResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"],
            "Default response content type should be added to the tree.")
    }

    func testActionCustomResponseContentTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self), contentType: "application/xml")
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/xml"],
            "Custom response content type should be added to the tree.")
    }

    func testActionResponseSchemaShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema,
            "Response schema should be added to the tree.")
    }

    func testActionArrayResponseTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self, asCollection: true))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("array", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
    }

    func testActionObjectResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.ref)
    }

    func testActionArrayResponseReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self, asCollection: true))
                        ]
            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal",
            openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.ref)
    }

    func testActionRequestBodyShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .object(Animal.self), description: "Animal request")

                )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody,
                        "Request body should be added to the tree.")
    }

    func testActionRequestBodyDefaultContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .object(Animal.self), description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"],
                        "Default request content type should be added to the tree.")
    }

    func testActionRequestBodyCustomContentShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .object(Animal.self), description: "Animal request", contentType: "application/xml")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/xml"],
                        "Custom request content type should be added to the tree.")
    }

    func testActionRequestBodyDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .object(Animal.self), description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Animal request", openAPIDocument.paths["/animals"]?.get?.requestBody?.description)
    }

    func testActionObjectRequestReferenceShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .object(Animal.self), description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/Animal", openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"]?.schema?.ref)
    }
    
    func testActionRequestValueTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", request: APIRequest(type: .value("Lion"), description: "Animal request")

            )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21))
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("string", openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"]?.schema?.type)
        XCTAssertEqual("Lion", openAPIDocument.paths["/animals"]?.get?.requestBody?.content?["application/json"]?.schema?.example)
    }

    func testActionParameterNameShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                    APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                                 required: true, deprecated: true, allowEmptyValue: true)
                ])
            ])
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("id", openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].name)
    }

    func testActionParameterLocationShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                    APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                                 required: true, deprecated: true, allowEmptyValue: true)
                    ])
                ])
        )

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(APILocation.path, openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].parameterLocation)
    }

    func testActionParameterDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals/{id}", summary: "Action summary", description: "Action description", parameters: [
                APIParameter(name: "id", parameterLocation: .path, description: "Parameter description",
                             required: true, deprecated: true, allowEmptyValue: true)
            ])
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Parameter description", openAPIDocument.paths["/animals/{id}"]?.get?.parameters![0].description)
    }

    func testActionObjectResponseReferenceWithCustomNameShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/animals", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .object(Animal.self))
                      ]
                     )
        ]))
        .add([
            APIObject(object: Animal(name: "Dog", age: 21), customName: "CustomAnimal")
        ])

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("#/components/schemas/CustomAnimal", openAPIDocument.paths["/animals"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.ref)
    }
    
    func testActionStringValueTypeResponseShouldBeAddedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/version", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .value("1.0.0"), contentType: "application/text")
                      ]
                     )
        ]))
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("string", openAPIDocument.paths["/version"]?.get?.responses?["200"]?.content?["application/text"]?.schema?.type)
        XCTAssertEqual("1.0.0", openAPIDocument.paths["/version"]?.get?.responses?["200"]?.content?["application/text"]?.schema?.example)
    }
    
    func testActionStringArrayValueTypeResponseShouldBeAddedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/certificates", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .value(["EURO 6", "ABS"]), contentType: "application/json")
                      ]
                     )
        ]))
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("array", openAPIDocument.paths["/certificates"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
        XCTAssertEqual("string", openAPIDocument.paths["/certificates"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.type)
        
        let example = openAPIDocument.paths["/certificates"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.example?.value as? [String]
        XCTAssertNotNil(example, "Example array not exists")
        XCTAssertEqual("EURO 6", example![0])
        XCTAssertEqual("ABS", example![1])
    }
    
    func testActionNumberValueTypeResponseShouldBeAddedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/temperature", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .value(43.5), contentType: "application/text")
                      ]
                     )
        ]))
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("number", openAPIDocument.paths["/temperature"]?.get?.responses?["200"]?.content?["application/text"]?.schema?.type)
        XCTAssertEqual(43.5, openAPIDocument.paths["/temperature"]?.get?.responses?["200"]?.content?["application/text"]?.schema?.example)
    }
    
    func testActionNumberArrayValueTypeResponseShouldBeAddedToOpenAPIDocument() {
        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
            APIAction(method: .get, route: "/temperature", summary: "Action summary",
                      description: "Action description", responses: [
                        APIResponse(code: "200", description: "Response description", type: .value([32.4, 42.1]), contentType: "application/json")
                      ]
                     )
        ]))
        
        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("array", openAPIDocument.paths["/temperature"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
        XCTAssertEqual("number", openAPIDocument.paths["/temperature"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.type)
        
        let example = openAPIDocument.paths["/temperature"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.example?.value as? [Double]
        XCTAssertNotNil(example, "Example array not exists")
        XCTAssertEqual(32.4, example![0])
        XCTAssertEqual(42.1, example![1])
    }
}
