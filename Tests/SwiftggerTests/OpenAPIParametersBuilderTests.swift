//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import XCTest
@testable import Swiftgger

/**
    Tests for paths components in OpenAPI standard (/paths).

    ```
    "paths": {
        "/animals/{animalId}": {
            "get": {
                "summary": "Returns a pet by Id",
                "description": "Returns a pet by Id from the system that the user has access to",
                "parameters": [
                  {
                    "schema" : {
                      "type" : "string"
                    },
                    "in" : "path",
                    "allowEmptyValue" : false,
                    "deprecated" : false,
                    "description" : "Pet Id",
                    "required" : true,
                    "name" : "animalId"
                  }
                ],
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
                "summary": "Update an existing pet",
                "description": "Update an existing pet in the system",
                "parameters": [
                  {
                    "schema" : {
                      "type" : "string"
                    },
                    "in" : "path",
                    "allowEmptyValue" : false,
                    "deprecated" : false,
                    "description" : "Pet Id",
                    "required" : true,
                    "name" : "animalId"
                  }
                ],
                "requestBody": {
                    "description": "A pet.",
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
                        "description": "A pet."
                    }
                }
            }
        }
    }
    ```
 */
class OpenAPIParametersBuilderTests: XCTestCase {

    func testParameterShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId")
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.paths["/animals"]?.get?.parameters?.first, "Parameter should be added to the tree.")
    }

    func testParameterNameShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId")
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("animalId", openAPIDocument.paths["/animals"]?.get?.parameters?.first?.name)
    }

    func testParameterRequiredShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", required: true)
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(true, openAPIDocument.paths["/animals"]?.get?.parameters?.first?.required)
    }

    func testParameterDescriptionShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", description: "Animal ID")
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Animal ID", openAPIDocument.paths["/animals"]?.get?.parameters?.first?.description)
    }

    func testParameterLocationShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", parameterLocation: .query)
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(APILocation.query, openAPIDocument.paths["/animals"]?.get?.parameters?.first?.parameterLocation)
    }

    func testParameterEmptyValueShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", allowEmptyValue: true)
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(true, openAPIDocument.paths["/animals"]?.get?.parameters?.first?.allowEmptyValue)
    }

    func testParameterDeprecationShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", deprecated: true)
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(true, openAPIDocument.paths["/animals"]?.get?.parameters?.first?.deprecated)
    }

    func testParameterSchemaTypeShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId")
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("string", openAPIDocument.paths["/animals"]?.get?.parameters?.first?.schema?.type)
    }

    func testParameterSchemaFormatShouldBeAddedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .add(APIController(name: "ControllerName", description: "ControllerDescription", actions: [
                APIAction(method: .get, route: "/animals", summary: "Action summary",
                          description: "Action description", parameters: [
                            APIParameter(name: "animalId", dataType: .int64)
                    ])
                ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("int64", openAPIDocument.paths["/animals"]?.get?.parameters?.first?.schema?.format)
    }
}
