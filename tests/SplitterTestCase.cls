block-level on error undo, throw.
using classes.Tester.* from propath.
using classes.StringUtil.* from propath.

class tests.SplitterTestCase inherits ABLTestCase:
    def public property c as char no-undo get. set.
    
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testSplitAfter1():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textAfter(c, ', '), '1234').
    end method.
    
    method public void testSplitterAfter2():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textAfter(c, ','), ' 1234').
    end method.
    
    method public void testSplitterAfter3():
        assign c = 'test, 1234, 456'.
        assertEqual(Splitter:textAfter(c, ', ', 2), '456').
    end method.
    
    method public void testSplitterAfter4():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textAfter(c, ';'), '').
    end method.
    
    method public void testSplitterAfter5():
        assign c = ''.
        assertEqual(Splitter:textAfter(c, ','), '').
    end method.
    
    method public void testSplitterAfter6():
        assign c = 'test 1234'.
        assertEqual(Splitter:textAfter(c, ''), '').
    end method.
    
    method public void testSplitterAfter7():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textAfter(c, ',', 2), '').
    end method.
    
    method public void testSplitterBefore1():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textBefore(c, ','), 'test').
    end method.
    
    method public void testSplitterBefore2():
        assign c = 'test, 1234, 456'.
        assertEqual(Splitter:textBefore(c, ','), 'test, 1234').
    end method.
    
    method public void testSplitterBefore3():
        assign c = 'test, 1234, 456'.
        assertEqual(Splitter:textBefore(c, ',', 2), 'test').
    end method.
    
    method public void testSplitterBefore4():
        assign c = ''.
        assertEqual(Splitter:textBefore(c, ','), '').
    end method.
    
    method public void testSplitterBefore5():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textBefore(c, ''), '').
    end method.
    
    method public void testSplitterBefore6():
        assign c = 'test, 1234'.
        assertEqual(Splitter:textBefore(c, ',', 2), '').
    end method.
end class.
