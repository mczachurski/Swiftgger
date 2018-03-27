import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

/*
    Tests for info part of OpenAPI schema.

    "info": 
    {
        "title": "Sample Pet Store App",
        "description": "This is a sample server for a pet store.",
        "termsOfService": "http://example.com/terms/",
        "contact": {
            "name": "API Support",
            "url": "http://www.example.com/support",
            "email": "support@example.com"
        },
        "license": {
            "name": "Apache 2.0",
            "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
        },
        "version": "1.0.1"
    }
*/
class OpenAPIInfoBuilderTests: XCTestCase {

    func testAPITitleShouldBeTranslatedToOpenAPIDocument() {

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

    func testAPIVersionShouldBeTranslatedToOpenAPIDocument() {

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

    func testAPIDescriptionShouldBeTranslatedToOpenAPIDocument() {

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

    func testAPITermsOfServiceShouldBeTranslatedToOpenAPIDocument() {

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

    func testAPIContactNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            contact: APIContact(name: "John Doe")
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("John Doe", openAPIDocument.info.contact?.name)
    }

    func testAPIContactEmailShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            contact: APIContact(email: "john.doe@email.com")
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("john.doe@email.com", openAPIDocument.info.contact?.email)
    }

    func testAPIContactUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            contact: APIContact(url: URL(string: "http://contact.url/"))
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual(URL(string: "http://contact.url/"), openAPIDocument.info.contact?.url)
    }

    func testAPILicenseNameShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            license: APILicense(name: "MIT")
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual("MIT", openAPIDocument.info.license?.name)
    }

    func testAPILicenseUrlShouldBeTranslatedToOpenAPIDocument() {

        // Arrange.
        let openAPIBuilder = OpenAPIBuilder(
            title: "Title",
            version: "1.0.0",
            description: "Description",
            license: APILicense(name: "MIT", url: URL(string: "http://mit.license"))
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual(URL(string: "http://mit.license"), openAPIDocument.info.license?.url)
    }

    static var allTests = [
        ("testAPITitleShouldBeTranslatedToOpenAPIDocument", testAPITitleShouldBeTranslatedToOpenAPIDocument),
        ("testAPIVersionShouldBeTranslatedToOpenAPIDocument", testAPIVersionShouldBeTranslatedToOpenAPIDocument),
        ("testAPIDescriptionShouldBeTranslatedToOpenAPIDocument", testAPIDescriptionShouldBeTranslatedToOpenAPIDocument),
        ("testAPITermsOfServiceShouldBeTranslatedToOpenAPIDocument", testAPITermsOfServiceShouldBeTranslatedToOpenAPIDocument),
        ("testAPIContactNameShouldBeTranslatedToOpenAPIDocument", testAPIContactNameShouldBeTranslatedToOpenAPIDocument),
        ("testAPIContactEmailShouldBeTranslatedToOpenAPIDocument", testAPIContactEmailShouldBeTranslatedToOpenAPIDocument),
        ("testAPIContactUrlShouldBeTranslatedToOpenAPIDocument", testAPIContactUrlShouldBeTranslatedToOpenAPIDocument)
    ]
}
