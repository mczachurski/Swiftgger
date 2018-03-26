import XCTest
@testable import Swiftgger

// swiftlint:disable force_try

class OpenAPIOperationBuilderTests: XCTestCase {

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
            name: "John Doe"
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
            email: "john.doe@email.com"
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
            url: URL(string: "http://contact.url/")
        )

        // Act.
        let openAPIDocument = try! openAPIBuilder.build()

        // Assert.
        XCTAssertEqual(URL(string: "http://contact.url/"), openAPIDocument.info.contact?.url)
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
