/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * Make “amount” private
 * **Dollar side effects?**
 * Money rounding?
*/

import Foundation
import XCTest

class Dollar {
    var amount: Int

    init(_ amount: Int) {
        self.amount = amount
    }

    func times(_ by: Int) -> Dollar {
        return Dollar(self.amount * by)
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Dollar(5)
        var product = five.times(2)
        XCTAssertEqual(5 * 2, product.amount)
        product = five.times(3)
        XCTAssertEqual(5 * 3, product.amount)
    }
}

/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 * 2 = $10
 * Make “amount” private
 * OK - Dollar side effects?
 * Money rounding?
 */

/*:
 We've done the following:
 * Translated a design objection (side effects) into a test case that failed because of the objection
 * Got the code to compile quickly with a stub implementation
 * Made the test work by typing in what seemed to be the right code
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

