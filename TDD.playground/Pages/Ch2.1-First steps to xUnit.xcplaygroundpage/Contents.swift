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

class WasRun: NSObject {
    var wasRun: Bool
    let testMethodSelector: Selector

    init(_ testMethodSelector: Selector) {
        self.wasRun = false
        self.testMethodSelector = testMethodSelector
    }

    @objc func testMethod() {
        self.wasRun = true
    }

    func run() {
        testMethod()
//        self.perform(self.testMethodSelector)
    }
}

let test = WasRun(#selector(WasRun.testMethod))
XCTAssertFalse(test.wasRun)
test.run()
XCTAssertTrue(test.wasRun)

