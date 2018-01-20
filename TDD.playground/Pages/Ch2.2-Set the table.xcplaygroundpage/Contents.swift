import Foundation
import XCTest

/* Backlog:
 * OK - Invoke test method
 * **Invoke setUp first**
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

    func setup() { }

    func run() {
        setup()
        self.perform(self.testMethodSelector)
    }
}

class WasRun: TestCase {
    var wasRun = false
    var wasSetup = false

    override init(_ testMethodSelector: Selector) {
        super.init(testMethodSelector)
    }

    override func setup() {
        self.wasSetup = true
    }

    @objc func testMethod() {
        self.wasRun = true
    }
}

class TestCaseTest: TestCase {
    var test: WasRun!

    override func setup() {
        self.test = WasRun(#selector(WasRun.testMethod))
    }

    @objc func testCaseRunning() {
        self.test.run()
        XCTAssertTrue(self.test.wasRun)
    }

    @objc func testSetup() {
        self.test.run()
        XCTAssertTrue(self.test.wasSetup)
    }
}

TestCaseTest(#selector(TestCaseTest.testCaseRunning)).run()
TestCaseTest(#selector(TestCaseTest.testSetup)).run()

/* Backlog:
 * OK - Invoke test method
 * OK - Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

/* Learnings:
 * Decided that simplicity of test writing was more important than performance for the moment
 * Tested and implemented setUp()
 * Used setUp() to simplify the example test case
 * Used setUp() to simplify the test cases checking the example test case (I told you this would become like self-brain-surgery.)
 */
