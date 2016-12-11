use "ponytest"

use "./range"
use "./solver"
use "./version"

actor Main is TestList

  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(TestRange)
    test(TestSolver)
    test(TestVersionComparison)
    test(TestVersionParsing)
    test(TestVersionStringification)
    test(TestVersionValidation)
