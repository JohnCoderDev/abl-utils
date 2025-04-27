block-level on error undo, throw.
using classes.Tester.* from propath.
using classes.StringUtil.* from propath.

class tests.ArgumentSplitterTestCase inherits ABLTestCase:
    def public property splitter as ArgumentSplitter no-undo get. set.
    
    method public override void setup():
        assign splitter = new ArgumentSplitter().
    end method.
    
    method public override void teardown():
        delete object splitter.
    end method.
    
    method public void testParseConstructor():
        assign splitter = new ArgumentSplitter('test abc -p 1234').
        assertEqual(splitter:get('p'), '1234').
    end method.
    
    method public void testParse():
        splitter:parse('test -p abc -b something').
        assertEqual(splitter:get('b'), 'something').
    end method.
    
    method public void testGetEmpty():
        splitter:parse('test abc --one-view log').
        assertEqual(splitter:get(''), 'test').
    end method.
    
    method public void testGetNextEmpty():
        splitter:parse('test --one-view log abc').
        splitter:next().
        assertEqual(splitter:next(), 'abc').
    end method.
    
    method public void testSequenceFirstNamedArgs():
        splitter:parse('test --one-view -single-mode').
        assertEqual(splitter:get('one-view'), 'true').
    end method.
    
    method public void testSequenceSecondNamedArgs():
        splitter:parse('test --one-view -single-mode').
        assertEqual(splitter:get('single-mode'), 'true').
    end method.
    
    method public void testGetByIndex():
        splitter:parse('test    --one-view').
        assertEqual(splitter:get(2), '--one-view').
    end method.
    
    method public void testUseFirstNext():
        splitter:parse('test abc').
        assertEqual(splitter:next(), 'test').
    end method.
    
    method public void testUseSecondNext():
        splitter:parse('test abc').
        splitter:next().
        assertEqual(splitter:next(), 'abc').
    end method.
    
    method public void testThirdBlankNext():
        splitter:parse('test abc').
        splitter:next().
        splitter:next().
        assertEqual(splitter:next(), '').
    end method.
end class.
