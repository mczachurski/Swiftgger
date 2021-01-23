//
//  OpenAPIServersBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

/**
    Tests for server part of OpenAPI standard (/servers).

    ```
    "servers" : [{
        "url" : "http://localhost:8181",
        "description" : "Main server"
    },
    {
        "url" : "http://localhost:{port}/{basePath}",
        "variables" : {
            "port" : {
                "default" : "80",
                "description" : "Port to the API",
                "enum" : [
                    "80",
                    "443"
                ]
            },
            "basePath" : {
                "default" : "v1",
                "description" : "Base path to the server API"
            }
        },
        "description" : "Secure server"
    }]
    ```
 */
class OpenAPIServersBuilderTests: XCTestCase {

    func testServerUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription"))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("ServerUrl", openAPIDocument.servers![0].url)
    }

    func testServerDescriptionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription"))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("ServerDescription", openAPIDocument.servers![0].description)
    }

    func testServerVariableNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
            APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
            APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertNotNil(openAPIDocument.servers![0].variables?["var01"], "Server variable not exists")
    }

    func testServerVariableDescriptionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
            APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
            APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("Variables description", openAPIDocument.servers![0].variables?["var01"]?.description)
    }

    func testServerVariableDefaultShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
            APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
            APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("val01", openAPIDocument.servers![0].variables?["var01"]?.defaultValue)
    }

    func testServerVariableEnumsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
            APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01", "val02"], description: "Variables description"),
            APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03", "val04"], description: "Second description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual("val01", openAPIDocument.servers![0].variables?["var01"]?.enumValues![0])
        XCTAssertEqual("val02", openAPIDocument.servers![0].variables?["var01"]?.enumValues![1])
    }

    func testServerVariablesShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .add(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
            APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01", "val02"], description: "Variables description"),
            APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03", "val04"], description: "Second description")
        ]))

        // Act.
        let openAPIDocument = openAPIBuilder.built()

        // Assert.
        XCTAssertEqual(2, openAPIDocument.servers![0].variables?.count)
    }
}
