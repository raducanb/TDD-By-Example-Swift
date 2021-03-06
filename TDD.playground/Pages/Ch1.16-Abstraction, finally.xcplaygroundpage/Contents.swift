/*:
 * OK -$5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 + $5 = $10
 * Return Money from $5 + $5
 * OK - Bank.reduce(Money)
 * OK - Reduce Money with conversion**
 * OK - Reduce(Bank, String)
 * **Sum.plus**
 * Expression.times
 */

import Foundation
import XCTest

protocol Expression {
    func reduce(withBank bank: Bank, to currency: String) -> Money
    func plus(_ addend: Expression) -> Expression
    func times(_ by: Int) -> Expression
}

class Money: Equatable {
    fileprivate var amount: Int
    public var currency: String

    init(_ amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}

extension Money: Expression {
    func reduce(withBank bank: Bank, to currency: String) -> Money {
        let rate = bank.rate(from: self.currency, to: currency)
        return Money(amount / rate, currency: currency)
    }

    func plus(_ addend: Expression) -> Expression {
        return Sum(self, addend)
    }

    func times(_ by: Int) -> Expression {
        return Money(self.amount * by, currency: currency)
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

func == <T: Bank.Pair>(lhs: T, rhs: T) -> Bool {
    return lhs.from == rhs.from
        && lhs.to == rhs.to
}

class Bank {
    class Pair: Hashable, Equatable {
        let from: String
        let to: String

        init(from: String, to: String) {
            self.from = from
            self.to = to
        }

        var hashValue: Int = 0
    }
    private var rates = [Pair: Int]()

    func reduce(_ expression: Expression, to currency: String) -> Money {
        return expression.reduce(withBank: self, to: currency)
    }

    func addRate(from fromCurrency: String, to toCurrency: String, _ value: Int) {
        self.rates[Pair(from: fromCurrency, to: toCurrency)] = value
    }

    func rate(from: String, to: String) -> Int {
        if from == to {
            return 1
        }

        if let rate = self.rates[Pair(from: from, to: to)] {
            return rate
        }

        XCTFail("rate not found \(from) \(to)")
        return 1
    }
}

class Sum: Expression {
    let augend: Expression
    let addend: Expression

    init(_ augend: Expression, _ addend: Expression) {
        self.augend = augend
        self.addend = addend
    }

    func reduce(withBank bank: Bank, to currency: String) -> Money {
        let amount = augend.reduce(withBank: bank, to: currency).amount
            + addend.reduce(withBank: bank, to: currency).amount
        return Money(amount, currency: currency)
    }

    func plus(_ addend: Expression) -> Expression {
        return Sum(self, addend)
    }

    func times(_ by: Int) -> Expression {
        return Sum(augend.times(by), addend.times(by))
    }
}

class DollarTests: XCTestCase {
    func testMultiplication() {
        let five = Money.dollar(5)
        XCTAssertEqual(Money.dollar(5 * 2), five.times(2) as! Money)
        XCTAssertEqual(Money.dollar(5 * 3), five.times(3) as! Money)
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
        XCTAssertEqual(sum.augend as! Money, five)
        XCTAssertEqual(sum.addend as! Money, five)
    }

    func testReduceMoneyWithDifferentCurrency() {
        let bank = Bank()
        bank.addRate(from: "CHF", to: "USD", 2)
        let result = bank.reduce(Money.franc(2), to: "USD")
        XCTAssertEqual(Money.dollar(1), result)
    }

    func testMixedAddition() {
        let fiveDollars: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate(from: "CHF", to: "USD", 2)
        let result = bank.reduce(fiveDollars.plus(tenFrancs), to: "USD")
        XCTAssertEqual(result, Money.dollar(10))
    }

    func testSumPlusMoney() {
        let fiveDollars: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate(from: "CHF", to: "USD", 2)
        let sum = Sum(fiveDollars, tenFrancs).plus(fiveDollars)
        let result = bank.reduce(sum, to: "USD")
        XCTAssertEqual(result, Money.dollar(15))
    }

    func testSumTimes() {
        let fiveDollars: Expression = Money.dollar(5)
        let tenFrancs: Expression = Money.franc(10)
        let bank = Bank()
        bank.addRate(from: "CHF", to: "USD", 2)
        let sum = Sum(fiveDollars, tenFrancs).times(2)
        let result = bank.reduce(sum, to: "USD")
        XCTAssertEqual(result, Money.dollar(20))

    }
}

/*:
 * OK -$5 + 10 CHF = $10 if rate is 2:1
 * OK - $5 + $5 = $10
 * OK - Return Money from $5 + $5
 * OK - Bank.reduce(Money)
 * OK - Reduce Money with conversion**
 * OK - Reduce(Bank, String)
 * OK - Sum.plus
 * OK - Expression.times
 */

/*:
 We've done the following:
 * Wrote a test with future readers in mind
 * Suggested an experiment comparing TDD with your current programming style
 * Once again had changes of declarations ripple through the system, and once again followed the compiler's advice to fix them
 * Tried a brief experiment, then discarded it when it didn't work out
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

