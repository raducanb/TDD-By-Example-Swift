/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * $5 + $5 = $10
 * Return Money from $5 + $5
 * OK - Bank.reduce(Money)
 * **Reduce Money with conversion**
 * Reduce(Bank, String)
 */

import Foundation
import XCTest

protocol Expression {
    func reduce(to currency: String) -> Money
}

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

    func plus(_ money: Money) -> Expression {
        return Sum(self, money)
    }
}

extension Money: Expression {
    func reduce(to currency: String) -> Money {
        var rate = 1
        if self.currency == "CHF" && currency == "USD" {
            rate = 2
        }
        return Money(amount / rate, currency: currency)
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
        return expression.reduce(to: currency)
    }

    func addRate(from toCurrency: String, to fromCurrency: String, _ value: Int) {

    }

    }
}

class Sum: Expression {
    let augend: Money
    let addend: Money

    init(_ augend: Money, _ addend: Money) {
        self.augend = augend
        self.addend = addend
    }

    func reduce(to currency: String) -> Money {
        return Money(augend.amount + addend.amount, currency: currency)
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

    func testReduceSum() {
        let sum = Sum(Money.dollar(3), Money.dollar(4))
        let bank = Bank()
        let reduced = bank.reduce(sum, to: "USD")
        XCTAssertEqual(Money.dollar(7), reduced)
    }

    func testReduceMoney() {
        let five = Money.dollar(5)
        let bank = Bank()
        let reduced = bank.reduce(five, to: "USD")
        XCTAssertEqual(reduced, five)
    }

    func testAdditionReturnsSum() {
        let five = Money.dollar(5)
        let result = five.plus(five)
        let sum: Sum = result as! Sum
        XCTAssertEqual(sum.augend, five)
        XCTAssertEqual(sum.addend, five)
    }

    func testReduceMoneyWithDifferentCurrency() {
        let bank = Bank()
        bank.addRate(from: "CHF", to: "USD", 2)
        let result = bank.reduce(Money.franc(2), to: "USD")
        XCTAssertEqual(Money.dollar(1), result)
    }
}

/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * **$5 + $5 = $10**
 * Return Money from $5 + $5
 * OK - Bank.reduce(Money)
 * Reduce Money with conversion
 * Reduce(Bank, String)
 * Money rounding?
 * hashCode()
 * Equal null
 * Equal object
 */

/*:
 We've done the following:
 * Didn't mark a test as done because the duplication had not been eliminated
 * Worked forward instead of backward to realize the implementation
 * Wrote a test to force the creation of an object we expected to need later (Sum)
 * Started implementing faster (the Sum constructor)
 * Implemented code with casts in one place, then moved the code where it belonged once the tests were running
 * Introduced polymorphism to eliminate explicit class checking
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

