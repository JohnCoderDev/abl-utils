using classes.StringUtil.* from propath.
using classes.Tester.* from propath.

class tests.SanitizerTestCase inherits ABLTestCase:
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testNumbersMethod():
        def var s as char no-undo.
        assign s = ' 1234abc-çc;.,/ 8809 '.
        assertEqual(Sanitizer:numbers(s), '12348809').
    end method.
end class.
