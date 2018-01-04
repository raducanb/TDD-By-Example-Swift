import Foundation
import XCTest

class Dollar {
    var amount: Int = 10

    init(_ amount: Int) {
        self.amount = 5 * 2
    }

    func times(_ by: Int) {

    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Dollar(5)
        five.times(2)
        XCTAssertEqual(5 * 2, five.amount)
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
