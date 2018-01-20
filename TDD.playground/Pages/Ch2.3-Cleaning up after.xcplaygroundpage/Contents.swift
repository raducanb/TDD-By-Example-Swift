import Foundation
import XCTest

/* Backlog:
 * OK - Invoke test method
 * OK - Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 * **Log string in WasRun**
 */

class TestCase: NSObject {
    let testMethodSelector: Selector

    init(_ testMethodSelector: Selector) {
        self.testMethodSelector = testMethodSelector
    }

    func setup() { }

    func run() {
        setup()
        self.perform(self.testMethodSelector)
    }
}

class WasRun: TestCase {
    var log = String()

    override init(_ testMethodSelector: Selector) {
        super.init(testMethodSelector)
    }

    override func setup() {
        log = "setup"
    }

    @objc func testMethod() {
        self.log += " testMethod"
    }
}

class TestCaseTest: TestCase {
    var test: WasRun!

    override func setup() {
        self.test = WasRun(#selector(WasRun.testMethod))
    }

    @objc func testTemplateMethod() {
        self.test.run()
        XCTAssertTrue(self.test.log == "setup testMethod")
    }
}

TestCaseTest(#selector(TestCaseTest.testTemplateMethod)).run()
