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

let test = WasRun(#selector(WasRun.testMethod))
XCTAssertFalse(test.wasRun)
test.run()
XCTAssertTrue(test.wasRun)

