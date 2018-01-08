/*:
 * **$5 + 10 CHF = $10 if rate is 2:1**
 * OK - $5 * 2 = $10
 * OK - Make “amount” private
 * OK - Dollar side effects?
 * Money rounding?
 * OK - equals()
 * hashCode()
 * Equal null
 * Equal object
 * OK - 5 CHF * 2 = 10 CHF
 * OK - Dollar/Franc duplication
 * OK - Common equals
 * OK - Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * OK - Delete testFrancMultiplication?
 */

import Foundation
import XCTest

protocol Expression { }

class Money: Equatable, Expression {
    fileprivate var amount: Int
    public var currency: String

    init(_ amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    func times(_ by: Int) -> Money {
        return Money(self.amount * by, currency: currency)
    }

    func plus(_ money: Money) -> Expression {
        return Money(self.amount + money.amount, currency: self.currency)
    }
}

extension Money {
    static func dollar(_ amount: Int) -> Money {
        return Money(amount, currency: "USD")
    }

    static func franc(_ amount: Int) -> Money {
        return Money(amount, currency: "CHF")
    }
}

func == <T: Money>(lhs: T, rhs: T) -> Bool {
    return lhs.amount == rhs.amount
        && lhs.currency == rhs.currency
}

class Bank {
    func reduce(_ expression: Expression, to currency: String) -> Money {
        return Money.dollar(10)
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Money.dollar(5)
        XCTAssertEqual(Money.dollar(5 * 2), five.times(2))
        XCTAssertEqual(Money.dollar(5 * 3), five.times(3))
    }

    func testEquality() {
        XCTAssertEqual(Money.dollar(5), Money.dollar(5))
        XCTAssertNotEqual(Money.dollar(5), Money.dollar(6))
        XCTAssertNotEqual(Money.dollar(5), Money.franc(5))
    }

    func testCurrency() {
        XCTAssertEqual("USD", Money.dollar(1).currency)
        XCTAssertEqual("CHF", Money.franc(1).currency)
    }

    func testSimpleAddition() {
        let five = Money.dollar(5)
        let sum = five.plus(five)
        let bank = Bank()
        let reduced = bank.reduce(sum, to: "USD")
        XCTAssertEqual(Money.dollar(10), reduced)
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
 * OK - Dollar/Franc duplication
 * OK - Common equals
 * OK - Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * OK - Delete testFrancMultiplication?
 */

/*:
 We've done the following:
 * Reduced a big test to a smaller test that represented progress ($5 + 10 CHF to $5 + $5)
 * Thought carefully about the possible metaphors for our computation
 * Rewrote our previous test based on our new metaphor
 * Got the test to compile quickly
 * Made it run
 * Looked forward with a bit of trepidation to the refactoring necessary to make the implementation real
 */

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
DollarTests.defaultTestSuite.run()

