/*:
 * $5 + 10 CHF = $10 if rate is 2:1
 * **$5 + $5 = $10**
 * Return Money from $5 + $5
 * Money rounding?
 * hashCode()
 * Equal null
 * Equal object
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
        return Sum(self, money)
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
        let sum = expression as! Sum
        let amount = sum.augend.amount + sum.addend.amount
        return Money(amount, currency: currency)
    }
}

class Sum: Expression {
    let augend: Money
    let addend: Money

    init(_ augend: Money, _ addend: Money) {
        self.augend = augend
        self.addend = addend
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

    func testAdditionReturnsSum() {
        let five = Money.dollar(5)
        let result = five.plus(five)
        let sum: Sum = result as! Sum
        XCTAssertEqual(sum.augend, five)
        XCTAssertEqual(sum.addend, five)
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

