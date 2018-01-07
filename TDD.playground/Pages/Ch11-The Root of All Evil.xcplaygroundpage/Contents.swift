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
 * OK - Common equals
 * OK - Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * Delete testFrancMultiplication?
 *//*:
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
 * **Dollar/Franc duplication**
 * OK - Common equals
 * OK - Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * Delete testFrancMultiplication?
 */

import Foundation
import XCTest

class Money: Equatable {
    fileprivate var amount: Int
    public var currency: String

    init(_ amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    func times(_ by: Int) -> Money {
        return Money(self.amount * by, currency: currency)
    }
}

extension Money {
    static func dollar(_ amount: Int) -> Money {
        return Money(amount, currency: "USD")
    }

    static func franc(_ amount: Int) -> Money {
        return Franc(amount, currency: "CHF")
    }
}

func == <T: Money>(lhs: T, rhs: T) -> Bool {
    return lhs.amount == rhs.amount
        && lhs.currency == rhs.currency
}

class Dollar: Money { }

class Franc: Money { }

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Money.dollar(5)
        XCTAssertEqual(Money.dollar(5 * 2), five.times(2))
        XCTAssertEqual(Money.dollar(5 * 3), five.times(3))
    }

    func testFrancMultiplication() {
        let five = Money.franc(5)
        XCTAssertEqual(Money.franc(5 * 2), five.times(2))
        XCTAssertEqual(Money.franc(5 * 3), five.times(3))
    }

    func testEquality() {
        XCTAssertEqual(Money.dollar(5), Money.dollar(5))
        XCTAssertNotEqual(Money.dollar(5), Money.dollar(6))
        XCTAssertEqual(Money.franc(5), Money.franc(5))
        XCTAssertNotEqual(Money.franc(5), Money.franc(6))
        XCTAssertNotEqual(Money.dollar(5), Money.franc(5))
    }

    func testDifferentClassEquality() {
        XCTAssertEqual(Money(10, currency: "CHF"), Franc(10, currency: "CHF"));
    }

    func testCurrency() {
        XCTAssertEqual("USD", Money.dollar(1).currency)
        XCTAssertEqual("CHF", Money.franc(1).currency)
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
 * OK - Common equals
 * OK - Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * Delete testFrancMultiplication?
 */

/*:
 We've done the following:
 * Reconciled two methods—times()—by first inlining the methods they called and then replacing constants with variables
 * Wrote a toString() without a test just to help us debug
 * Tried a change (returning Money instead of Franc) and let the tests tell us whether it worked
 * Backed out an experiment and wrote another test. Making the test work made the experiment work
 */

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
DollarTests.defaultTestSuite.run()

