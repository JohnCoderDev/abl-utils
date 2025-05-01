using classes.Tester.* from propath.

new ABLTestCollection()
    /*:addTest("tests.SanitizerTestCase")
    :addTest("tests.MatcherTestCase")
    :addTest("tests.ArgumentSplitterTestCase")
    :addTest("tests.MaskerTestCase")*/
    :addTest('tests.BufferTestCase')
    :runTests()
    :writeFile("C:\Users\vboxuser\programming\projects\abl-utils\tests-results.html").

    
