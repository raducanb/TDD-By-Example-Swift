/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * $5 * 2 = $10
 * Make “amount” private
 * Dollar side-effects?
 * Money rounding?
 */

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
        five.times(2)
        XCTAssertEqual(5 * 2, five.amount)
    }
}

/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * Make “amount” private
 * Dollar side-effects?
 * Money rounding?
 */

/*:
 We've done the following:
 * Made a list of the tests we knew we needed to have working
 * Told a story with a snippet of code about how we wanted to view one operation
 * Ignored the details of JUnit for the moment
 * Made the test compile with stubs
 * Made the test run by committing horrible sins
 * Gradually generalized the working code, replacing constants with variables
 * Added items to our to-do list rather than addressing them all at once
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
