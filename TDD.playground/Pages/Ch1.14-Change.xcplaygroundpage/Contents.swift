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
    func reduce(withBank bank: Bank, to currency: String) -> Money
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
    func reduce(withBank bank: Bank, to currency: String) -> Money {
        let rate = bank.rate(from: self.currency, to: currency)
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
        
        return self.rates[Pair(from: from, to: to)]!
    }
}

class Sum: Expression {
    let augend: Money
    let addend: Money

    init(_ augend: Money, _ addend: Money) {
        self.augend = augend
        self.addend = addend
    }

    func reduce(withBank bank: Bank, to currency: String) -> Money {
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
 * OK - $5 + $5 = $10
 * Return Money from $5 + $5
 * OK - Bank.reduce(Money)
 * OK - Reduce Money with conversion**
 * OK - Reduce(Bank, String)
 */

/*:
 We've done the following:
 * Added a parameter, in seconds, that we expected we would need
 * Factored out the data duplication between code and tests
 * Introduced a private helper class without distinct tests of its own
 * Made a mistake in a refactoring and chose to forge ahead, writing another test to isolate the problem
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

