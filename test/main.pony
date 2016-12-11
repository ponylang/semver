use "ponytest"

actor Main is TestList

  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(TestVersionComparison)
    test(TestVersionParse)
    test(TestVersionRange)
    test(TestVersionString)
    test(TestVersionValidation)
