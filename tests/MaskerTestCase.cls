block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.Tester.* from propath.

class tests.MaskerTestCase inherits ABLTestCase:
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testMask():
        def var masked as char no-undo.
        assign masked = Masker:mask('1234', '####-####', '#', '0').
        assertEqual(masked, '0000-1234').
    end method.
    
    method public void testMaskFillingEmpty():
        def var masked as char no-undo.
        assign masked = Masker:mask('1234', '####-####', '#').
        assertEqual(masked, '-1234').
    end method.
    
    method public void testMaskWithEmptyMask():
        assertEqual(Masker:mask('1234', '', '#'), '').
    end method.
    
    method public void testMaskWithEmptySource():
        assertEqual(Masker:mask('', '##-##', '#'), '-').
    end method.
end class.
