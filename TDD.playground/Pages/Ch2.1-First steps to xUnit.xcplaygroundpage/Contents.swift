import Foundation
import XCTest

/* Backlog:
 * **Invoke test method**
 * Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

class TestCase: NSObject {
    let testMethodSelector: Selector

    init(_ testMethodSelector: Selector) {
        self.testMethodSelector = testMethodSelector
    }

    func run() {
        self.perform(self.testMethodSelector)
    }
}

class WasRun: TestCase {
    var wasRun: Bool

    override init(_ testMethodSelector: Selector) {
        self.wasRun = false
        super.init(testMethodSelector)
    }

    @objc func testMethod() {
        self.wasRun = true
    }
}

class TestCaseTest: TestCase {
    @objc func testCaseRunning() {
        let test = WasRun(#selector(WasRun.testMethod))
        XCTAssertFalse(test.wasRun)
        test.run()
        XCTAssertTrue(test.wasRun)
    }
}

TestCaseTest(#selector(TestCaseTest.testCaseRunning)).run()

/* Backlog:
 * OK - Invoke test method
 * Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

/*:
 Learnings:
 * After a couple of hubris-fueled false starts, figured out how to begin with a tiny little step
 * Implemented functionality, by first hardwiring it, and then making it more general by replacing constants with variables
 * Used Pluggable Selector, which we promise not to use again for four months, minimum, because it makes code hard to analyze statically
 * Bootstrapped our testing framework, all in tiny steps
 */

