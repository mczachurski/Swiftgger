//
//  OpenAPITagsBuilderTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 26.03.2018.
//

import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class OpenAPITagsBuilderTests: XCTestCase {

    func testControllerNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )
        .addController(APIController(name: "ControllerName", description: "ControllerDescription"))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("ControllerName", openAPIDocument.tags![0].name)
    }

    func testControllerDescriptionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription"))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("ControllerDescription", openAPIDocument.tags![0].description)
    }

    func testControllerLinkUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription",
                                         externalDocs: APILink(url: "http://some.link", description: "LinkDescription")))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("http://some.link", openAPIDocument.tags![0].externalDocs?.url)
    }

    func testControllerLinkDescriptionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
            )
            .addController(APIController(name: "ControllerName", description: "ControllerDescription",
                                         externalDocs: APILink(url: "http://some.link", description: "LinkDescription")))

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("LinkDescription", openAPIDocument.tags![0].externalDocs?.description)
    }

    static var allTests = [
        ("testControllerNameShouldBeTranslatedToOpenAPIDocument", testControllerNameShouldBeTranslatedToOpenAPIDocument),
        ("testControllerDescriptionShouldBeTranslatedToOpenAPIDocument", testControllerDescriptionShouldBeTranslatedToOpenAPIDocument),
        ("testControllerLinkUrlShouldBeTranslatedToOpenAPIDocument", testControllerLinkUrlShouldBeTranslatedToOpenAPIDocument),
        ("testControllerLinkDescriptionShouldBeTranslatedToOpenAPIDocument", testControllerLinkDescriptionShouldBeTranslatedToOpenAPIDocument)
    ]
}
