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
 * Common times
 * OK - Compare Francs with Dollars
 * **Currency?**
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
        fatalError("Must Override")
    }
}

extension Money {
    static func dollar(_ amount: Int) -> Money {
        return Dollar(amount, currency: "USD")
    }

    static func franc(_ amount: Int) -> Money {
        return Franc(amount, currency: "CHF")
    }
}

func == <T: Money>(lhs: T, rhs: T) -> Bool {
    return lhs.amount == rhs.amount
        && String(describing: lhs.self) == String(describing: rhs.self)
}

class Dollar: Money {
    override func times(_ by: Int) -> Money {
        return Money.dollar(self.amount * by)
    }
}

class Franc: Money {
    override func times(_ by: Int) -> Money {
        return Money.franc(self.amount * by)
    }
}

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

    func testCurrency() {
        XCTAssertEqual("USD", Money.dollar(1).currency);
        XCTAssertEqual("CHF", Money.franc(1).currency);
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
 * Common times
 * OK - Compare Francs with Dollars
 * OK - Currency?
 * Delete testFrancMultiplication?
 */

/*:
 We've done the following:
 * Were a little stuck on big design ideas, so we worked on something small we noticed earlier
 * Reconciled the two constructors by moving the variation to the caller (the factory method)
 * Interrupted a refactoring for a little twist, using the factory method in times()
 * Repeated an analogous refactoring (doing to Dollar what we just did to Franc) in one big step
 * Pushed up the identical constructors
 */

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
DollarTests.defaultTestSuite.run()

