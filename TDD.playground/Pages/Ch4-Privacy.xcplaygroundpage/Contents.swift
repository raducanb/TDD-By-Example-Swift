/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * **Make “amount” private**
 * OK - Dollar side effects?
 * Money rounding?
 * OK - equals()
 * hashCode()
 * Equal null
 * Equal object
 */

import Foundation
import XCTest

class Dollar: Equatable {
    var amount: Int

    init(_ amount: Int) {
        self.amount = amount
    }

    func times(_ by: Int) -> Dollar {
        return Dollar(self.amount * by)
    }

    static func ==(lhs: Dollar, rhs: Dollar) -> Bool {
        return lhs.amount == rhs.amount
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Dollar(5)
        var product = five.times(2)
        XCTAssertEqual(Dollar(5 * 2), product)
        product = five.times(3)
        XCTAssertEqual(Dollar(5 * 3), product)
    }

    func testEquality() {
        XCTAssertEqual(Dollar(5), Dollar(5))
        XCTAssertNotEqual(Dollar(5), Dollar(6))
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

