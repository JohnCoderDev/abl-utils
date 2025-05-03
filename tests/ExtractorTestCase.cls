block-level on error undo, throw.
using classes.Tester.* from propath.
using classes.StringUtil.* from propath.

class tests.ExtractorTestCase inherits ABLTestCase:
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testExtract1():
        assertEqual(Extractor:extract('single (left but right)', '(', ')'), 'left but right').
    end method.
    
    method public void testExtract2():
        assertEqual(Extractor:extract('single (left (but right))', '(', ')'), 'but right').
    end method.
    
    method public void testExtract3():
        assertEqual(
            Extractor:extract('(something really weird) fields(field-one field-two field-three)', 'fields(', ')'),
            'field-one field-two field-three'
        ).
    end method.
    
    method public void testExtract4():
        assertEqual(Extractor:extract('nothing to extract', '(', ')'), '').
    end method.
    
    method public void testExtract5():
        assertEqual(Extractor:extract('another (extraction', '(', ')'), '').
    end method.
    
    method public void testExtract6():
        assertEqual(Extractor:extract('nothing (left (but right)', '(', ')', true), '(but right)').
    end method.
end class.
