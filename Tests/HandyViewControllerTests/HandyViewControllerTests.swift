import XCTest
@testable import HandyViewController

final class HandyViewControllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HandyViewController().text, "Hello, World!")
    }
    
    static var allTests = [
        ("testExample", testExample)
    ]
}
