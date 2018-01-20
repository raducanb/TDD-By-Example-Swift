/* Backlog:
 * **Invoke test method**
 * Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

class WasRun {
    var wasRun: Bool

    init(_ testMethod: String) {
        self.wasRun = false
    }

    func testMethod() {
        self.wasRun = true
    }

    func run() {
        self.testMethod()
    }
}

let test = WasRun("testMethod")
print(test.wasRun)
test.run()
print(test.wasRun)
