/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * OK - Make “amount” private
 * OK - Dollar side effects?
 * Money rounding?
 * OK - equals()
 * hashCode()
 * Equal null
 * Equal object
 * **5 CHF * 2 = 10 CHF**
 */

import Foundation
import XCTest

class Dollar: Equatable {
    private var amount: Int

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

class Franc: Equatable {
    private var amount: Int

    init(_ amount: Int) {
        self.amount = amount
    }

    func times(_ by: Int) -> Franc {
        return Franc(self.amount * by)
    }

    static func ==(lhs: Franc, rhs: Franc) -> Bool {
        return lhs.amount == rhs.amount
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Dollar(5)
        XCTAssertEqual(Dollar(5 * 2), five.times(2))
        XCTAssertEqual(Dollar(5 * 3), five.times(3))
    }

    func testFrancMultiplication() {
        let five = Franc(5)
        XCTAssertEqual(Franc(5 * 2), five.times(2))
        XCTAssertEqual(Franc(5 * 3), five.times(3))
    }

    func testEquality() {
        XCTAssertEqual(Dollar(5), Dollar(5))
        XCTAssertNotEqual(Dollar(5), Dollar(6))
    }
}

/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * OK - Make “amount” private
 * OK - Dollar side effects?
 * Money rounding?
 * OK - equals()
 * hashCode()
 * Equal null
 * Equal object
 * OK - 5 CHF * 2 = 10 CHF
 * Dollar/Franc duplication
 * Common equals
 * Common times
 */

/*:
 We've done the following:
 * Couldn't tackle a big test (Franc duplication), so we invented a small test that represented progress
 * Wrote the test by shamelessly duplicating and editing
 * Even worse, made the test work by copying and editing model code wholesale
 * Promised ourselves we wouldn't go home until the duplication was gone
 */

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

