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
 * **Dollar/Franc duplication**
 * OK - Common equals
 * Common times
 * OK - Compare Francs with Dollars
 * Currency?
 */

import Foundation
import XCTest

class Money: Equatable {
    fileprivate var amount: Int

    init(_ amount: Int) {
        self.amount = amount
    }

    func times(_ by: Int) -> Money {
        return Dollar(self.amount * by)
    }
}

extension Money {
    static func dollar(_ amount: Int) -> Money {
        return Dollar(amount)
    }

    static func franc(_ amount: Int) -> Money {
        return Franc(amount)
    }
}

func == <T: Money>(lhs: T, rhs: T) -> Bool {
    return lhs.amount == rhs.amount
        && String(describing: lhs.self) == String(describing: rhs.self)
}

class Dollar: Money {
    override func times(_ by: Int) -> Money {
        return Dollar(self.amount * by)
    }
}

class Franc: Money {
    override func times(_ by: Int) -> Money {
        return Franc(self.amount * by)
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

