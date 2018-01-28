import Foundation
import XCTest

/* Backlog:
 * OK - Invoke test method
 * OK - Invoke setUp first
 * OK - Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * **Report collected results**
 * OK - Log string in WasRun
 */

class TestCase: NSObject {
//    let testMethodSelector: Selector

    init(_ testMethodSelector: Selector?) {
//        self.testMethodSelector = testMethodSelector
    }

    func setup() { }

    func run() { }

    func tearDown() { }
}

class WasRun: TestCase {
    var log = String()

    override init(_ testMethodSelector: Selector?) {
        super.init(testMethodSelector)
    }

    override func run() {
        self.setup()
        self.testMethod()
        self.tearDown()
    }

    override func setup() {
        self.log = "setup"
    }

    func testMethod() {
        self.log += " testMethod"
    }

    override func tearDown() {
        self.log += " tearDown"
    }
}

class TestCaseTest: TestCase {
    override func run() {
        self.setup()
        self.testTemplateMethod()
    }

    func testTemplateMethod() {
        let test = WasRun(nil)
        test.run()
        XCTAssertTrue("setup testMethod tearDown" == test.log)
    }

    func testSummary() {
        let test = WasRun(nil)
        let result = test.run()
        XCTAssertTrue("1 success. 0 failed" == result.summary)
    }
}

let a = TestCaseTest(nil)
a.run()
