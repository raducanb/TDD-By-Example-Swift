import Foundation
import XCTest

/* Backlog:
 * OK - Invoke test method
 * OK - Invoke setUp first
 * **Invoke tearDown afterward**
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 * **Log string in WasRun**
 */

class TestCase: NSObject {
//    let testMethodSelector: Selector

    init(_ testMethodSelector: Selector?) {
//        self.testMethodSelector = testMethodSelector
    }

    func setup() { }

    func run() { }

    func testMethod() {}
    func testTemplateMethod() {}
}

class WasRun: TestCase {
    var log = String()

    override init(_ testMethodSelector: Selector?) {
        super.init(testMethodSelector)
    }

    override func run() {
        self.setup()
        self.testMethod()
    }

    override func setup() {
        self.log = "setup"
    }

    override func testMethod() {
        self.log += " testMethod"
    }

    override func testTemplateMethod() {}
}

class TestCaseTest: TestCase {
    override func run() {
        self.setup()
        self.testTemplateMethod()
    }

    override func testTemplateMethod() {
        let test = WasRun(nil)
        test.run()
        XCTAssertTrue(test.log == "setup testMethod")
    }
}

let a = TestCaseTest(nil)
a.run()

