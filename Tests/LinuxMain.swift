import XCTest
@testable import SwiftggerTests

XCTMain([
    testCase(OpenAPIInfoBuilderTests.allTests),
    testCase(OpenAPISchemasBuilderTests.allTests),
    testCase(OpenAPISecurityBuilderTests.allTests),
    testCase(OpenAPIServersBuilderTests.allTests),
    testCase(OpenAPITagsBuilderTests.allTests),
    testCase(OpenAPIPathsBuilderTests.allTests)
])
