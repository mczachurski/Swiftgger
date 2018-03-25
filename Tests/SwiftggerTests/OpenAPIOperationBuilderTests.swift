import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class OpenAPIOperationBuilderTests: XCTestCase {

    func testControllerTitleShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("Title", openAPIDocument.info.title)
    }

    func testControllerVersionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("1.0.0", openAPIDocument.info.version)
    }

    func testControllerDescriptionShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("Description", openAPIDocument.info.description)
    }

    func testControllerTermsOfServiceShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            termsOfService: "Terms of service"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("Terms of service", openAPIDocument.info.termsOfService)
    }

    func testControllerContactNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            name: "John Doe"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("John Doe", openAPIDocument.info.contact?.name)
    }

    func testControllerContactEmailShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            email: "john.doe@email.com"
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("john.doe@email.com", openAPIDocument.info.contact?.email)
    }

    func testControllerContactUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            url: URL(string: "http://contact.url/")
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual(URL(string: "http://contact.url/"), openAPIDocument.info.contact?.url)
    }

    func testControllerBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.basic(description: "Basic authorization")]
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_basic"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("basic", securitySchema?.scheme)
        XCTAssertEqual("Basic authorization", securitySchema?.description)
    }

    func testControllerBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            authorizations: [.jwt(description: "JWT authorization")]
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        let securitySchema = openAPIDocument.components?.securitySchemes!["auth_jwt"]
        XCTAssertEqual("http", securitySchema?.type)
        XCTAssertEqual("bearer", securitySchema?.scheme)
        XCTAssertEqual("jwt", securitySchema?.bearerFormat)
        XCTAssertEqual("JWT authorization", securitySchema?.description)
    }

    static var allTests = [
        ("testControllerTitleShouldBeTranslatedToOpenAPIDocument", testControllerTitleShouldBeTranslatedToOpenAPIDocument),
        ("testControllerVersionShouldBeTranslatedToOpenAPIDocument", testControllerVersionShouldBeTranslatedToOpenAPIDocument),
        ("testControllerDescriptionShouldBeTranslatedToOpenAPIDocument", testControllerDescriptionShouldBeTranslatedToOpenAPIDocument),
        ("testControllerTermsOfServiceShouldBeTranslatedToOpenAPIDocument", testControllerTermsOfServiceShouldBeTranslatedToOpenAPIDocument),
        ("testControllerContactNameShouldBeTranslatedToOpenAPIDocument", testControllerContactNameShouldBeTranslatedToOpenAPIDocument),
        ("testControllerContactEmailShouldBeTranslatedToOpenAPIDocument", testControllerContactEmailShouldBeTranslatedToOpenAPIDocument),
        ("testControllerContactUrlShouldBeTranslatedToOpenAPIDocument", testControllerContactUrlShouldBeTranslatedToOpenAPIDocument),
        ("testControllerBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument", testControllerBasicAuthorizationsShouldBeTranslatedToOpenAPIDocument),
        ("testControllerBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument", testControllerBearerAuthorizationsShouldBeTranslatedToOpenAPIDocument)
    ]
}
