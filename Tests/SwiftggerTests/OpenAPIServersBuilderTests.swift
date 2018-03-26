//
//  OpenAPIServersBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class OpenAPIServersBuilderTests: XCTestCase {

    func testServerUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addServer(APIServer(url: "ServerUrl", description: "ServerDescription"))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription"))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
                APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
                APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
            ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
                APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
                APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
                ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
                APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01, val02"], description: "Variables description"),
                APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03, val04"], description: "Second description")
                ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
                APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01", "val02"], description: "Variables description"),
                APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03", "val04"], description: "Second description")
                ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

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
            .addServer(APIServer(url: "ServerUrl", description: "ServerDescription", variables: [
                APIVariable(name: "var01", defaultValue: "val01", enumValues: ["val01", "val02"], description: "Variables description"),
                APIVariable(name: "var02", defaultValue: "val03", enumValues: ["val03", "val04"], description: "Second description")
                ]))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual(2, openAPIDocument.servers![0].variables?.count)
    }

    static var allTests = [
        ("testServerUrlShouldBeTranslatedToOpenAPIDocument", testServerUrlShouldBeTranslatedToOpenAPIDocument),
        ("testServerDescriptionShouldBeTranslatedToOpenAPIDocument", testServerDescriptionShouldBeTranslatedToOpenAPIDocument),
        ("testServerVariableNameShouldBeTranslatedToOpenAPIDocument", testServerVariableNameShouldBeTranslatedToOpenAPIDocument),
        ("testServerVariableDescriptionShouldBeTranslatedToOpenAPIDocument", testServerVariableDescriptionShouldBeTranslatedToOpenAPIDocument),
        ("testServerVariableDefaultShouldBeTranslatedToOpenAPIDocument", testServerVariableDefaultShouldBeTranslatedToOpenAPIDocument),
        ("testServerVariableEnumsShouldBeTranslatedToOpenAPIDocument", testServerVariableEnumsShouldBeTranslatedToOpenAPIDocument),
        ("testServerVariablesShouldBeTranslatedToOpenAPIDocument", testServerVariablesShouldBeTranslatedToOpenAPIDocument)
    ]
}
