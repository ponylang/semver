use "ponytest"

use "./test/range"
use "./test/solver"
use "./test/utils"
use "./test/version"

actor Main is TestList

  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(TestRangeInclusionRules)
    test(TestRangeMatching)
    test(TestRangeMerging)
    test(TestRangeOverlapDetection)
    test(TestRangeStringification)

    test(TestSolverEngine)
    test(TestSolverSupportClasses)

    test(TestUtilsComparableMixin)
    test(TestUtilsIterators)
    test(TestUtilsStrings)

    test(TestVersionComparison)
    test(TestVersionParsing)
    test(TestVersionStringification)
    test(TestVersionValidation)
