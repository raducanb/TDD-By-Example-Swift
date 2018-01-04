import Foundation
import XCTest

class Dollar {
    var amount: Int

    init(_ amount: Int) {
        self.amount = amount
    }

    func times(_ by: Int) {
        self.amount *= by
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Dollar(5)
        var product = five.times(2)
        XCTAssertEqual(5 * 2, five.amount)
        product = five.times(3)
        XCTAssertEqual(5 * 3, five.amount)
    }
}

// Running the tests
class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
DollarTests.defaultTestSuite.run()

