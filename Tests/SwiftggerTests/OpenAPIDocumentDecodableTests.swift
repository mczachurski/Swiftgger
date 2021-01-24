//
//  OpenAPIDocumentDecodableTests.swift
//  SwiftggerTests
//
//  Created by Marcin Czachurski on 23/01/2021.
//

import Foundation

import XCTest
@testable import Swiftgger

/**
    Tests for decoding OpenAPI JSON into OpenAPIDocument.
 */
class OpenAPIDocumentDecodableTests: XCTestCase {

    var openApiDocument: OpenAPIDocument! = nil
    
    override func setUp() {
        let jsonDataURL = Bundle.module.url(forResource: "openapi", withExtension: "json")
        let jsonData = try! Data(contentsOf: jsonDataURL!)
        self.openApiDocument = try! JSONDecoder().decode(OpenAPIDocument.self, from: jsonData)
    }
    
    func testDecodeOpenAPIInfo() {
        XCTAssertNotNil(self.openApiDocument.info)
        XCTAssertEqual("1.0.0", self.openApiDocument.info.version)
        XCTAssertEqual("Tasker server", self.openApiDocument.info.title)
    }
    
    func testDecodeOpenAPITags() {
        XCTAssertNotNil(self.openApiDocument.tags)
        XCTAssertEqual(5, self.openApiDocument.tags?.count)
        XCTAssertEqual("Health", self.openApiDocument.tags?[0].name)
        XCTAssertEqual("Controller which returns service health information.", self.openApiDocument.tags?[0].description)
        XCTAssertEqual("Tasks", self.openApiDocument.tags?[1].name)
        XCTAssertEqual("Controller for managing tasks.", self.openApiDocument.tags?[1].description)
        XCTAssertEqual("Users", self.openApiDocument.tags?[2].name)
        XCTAssertEqual("Controller for managing users.", self.openApiDocument.tags?[2].description)
        XCTAssertEqual("Account", self.openApiDocument.tags?[3].name)
        XCTAssertEqual("Controller for managing user accout (registering/signing in/password).", self.openApiDocument.tags?[3].description)
        XCTAssertEqual("OpenAPI", self.openApiDocument.tags?[4].name)
        XCTAssertEqual("Controller for OpenAPI metadata", self.openApiDocument.tags?[4].description)
    }
    
    func testDecodedOpenAPIServers() {
        XCTAssertNotNil(self.openApiDocument.servers)
        XCTAssertEqual(2, self.openApiDocument.servers?.count)
        
        XCTAssertEqual("http://localhost:8181", self.openApiDocument.servers?[0].url)
        XCTAssertEqual("Main server", self.openApiDocument.servers?[0].description)
        
        XCTAssertEqual("http://localhost:{port}/{basePath}", self.openApiDocument.servers?[1].url)
        XCTAssertEqual("Secure server", self.openApiDocument.servers?[1].description)

        XCTAssertEqual("v1", self.openApiDocument.servers?[1].variables?["basePath"]?.defaultValue)
        XCTAssertEqual("Base path to the server API", self.openApiDocument.servers?[1].variables?["basePath"]?.description)

        XCTAssertEqual("80", self.openApiDocument.servers?[1].variables?["port"]?.defaultValue)
        XCTAssertEqual("Port to the API", self.openApiDocument.servers?[1].variables?["port"]?.description)
        XCTAssertEqual("80", self.openApiDocument.servers?[1].variables?["port"]?.enumValues?[0])
        XCTAssertEqual("443", self.openApiDocument.servers?[1].variables?["port"]?.enumValues?[1])
    }
    
    func testDecodedOpenAPIPaths() {
        XCTAssertNotNil(self.openApiDocument.paths)
        XCTAssertEqual(9, self.openApiDocument.paths.count)
        
        XCTAssertNotNil(self.openApiDocument.paths["/users"])
        XCTAssertNotNil(self.openApiDocument.paths["/users"]?.get)
        XCTAssertEqual("Action for getting all users from server", self.openApiDocument.paths["/users"]?.get?.description)
        
        XCTAssertNotNil(self.openApiDocument.paths["/users"]?.get?.responses)
        XCTAssertNotNil(self.openApiDocument.paths["/users"]?.get?.responses?["200"])
        XCTAssertNotNil(self.openApiDocument.paths["/users"]?.get?.responses?["200"]?.content)
        XCTAssertNotNil(self.openApiDocument.paths["/users"]?.get?.responses?["200"]?.content?["application/json"])
        XCTAssertEqual("array", self.openApiDocument.paths["/users"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.type)
        XCTAssertEqual("#/components/schemas/UserDto", self.openApiDocument.paths["/users"]?.get?.responses?["200"]?.content?["application/json"]?.schema?.items?.ref)
    }
    
    func testDecodedOpenAPIComponents() {
        XCTAssertNotNil(self.openApiDocument.components)
        XCTAssertEqual(7, self.openApiDocument.components?.schemas?.count)
        XCTAssertNotNil(self.openApiDocument.components?.schemas?["UserDto"])
        XCTAssertNotNil(self.openApiDocument.components?.schemas?["UserDto"]?.properties)
        XCTAssertEqual(6, self.openApiDocument.components?.schemas?["UserDto"]?.properties?.count)
        XCTAssertEqual("email@test.com", self.openApiDocument.components?.schemas?["UserDto"]?.properties?["email"]?.example)
        XCTAssertEqual("string", self.openApiDocument.components?.schemas?["UserDto"]?.properties?["email"]?.type)
    }
}
