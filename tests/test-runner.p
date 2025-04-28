using classes.Tester.* from propath.

new ABLTestCollection()
    :addTest("tests.SanitizerTestCase")
    :addTest("tests.MatcherTestCase")
    :addTest("tests.ArgumentSplitterTestCase")
    :addTest("tests.MaskerTestCase")
    :runTests()
    :writeFile("C:\Users\vboxuser\programming\projects\utils-lib\tests-results.html").
