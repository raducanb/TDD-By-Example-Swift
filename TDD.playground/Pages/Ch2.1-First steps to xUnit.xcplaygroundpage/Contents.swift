/* Backlog:
 * **Invoke test method**
 * Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

class WasRun {
    let wasRun: Bool

    init(_ testMethod: String) {
        self.wasRun = false
    }

    func testMethod() {
        
    }
}

let test = WasRun("testMethod")
print(test.wasRun)
test.testMethod()
print(test.wasRun)
