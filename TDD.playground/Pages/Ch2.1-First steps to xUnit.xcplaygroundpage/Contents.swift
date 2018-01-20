/* Backlog:
 * **Invoke test method**
 * Invoke setUp first
 * Invoke tearDown afterward
 * Invoke tearDown even if the test method fails
 * Run multiple tests
 * Report collected results
 */

let test = WasRun("testMethod")
print(test.wasRun)
test.testMethod()
print(test.wasRun)
