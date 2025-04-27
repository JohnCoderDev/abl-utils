block-level on error undo, throw.
using classes.Tester.* from propath.
using classes.StringUtil.* from propath.

class tests.MatcherTestCase inherits ABLTestCase:
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testStartsWith():
        assertTrue(Matcher:startswith('--abc', '--')).
    end method.
    
    method public void testEndsWith():
        assertTrue(Matcher:endswith('some000a', '0a')).
    end method.
    
    method public void testStartsWithOneOf():
        assertTrue(Matcher:startsWithOneOf('abclllo', 'lo,--,ab')).
    end method.
    
    method public void testEndsWithOneOf():
        assertFalse(Matcher:endsWithOneOf('abldl', 'lo,--')).
    end method.
    
    method public void testEndsWithOneOfTrue():
        assertTrue(Matcher:endsWithOneOf('abldl', 'dl,lo,---')).
    end method.
    
    method public void testContains():
        assertTrue(Matcher:contains('something strange', 'thing')).
    end method.
    
    method public void testContainsOneOf():
        assertFalse(Matcher:containsOneOf('nothing here', 'abs,tha')).
    end method.
    
    method public void testTrueContainsAll():
        assertTrue(Matcher:containsAll('absolute cinema', 'nem,lute')).
    end method.
    
    method public void testFalseContainsAll():
        assertFalse(Matcher:containsAll('absolute cinema', 'lu,ine,mam')).
    end method.
    
    method public void testHasNumbers():    
        assertTrue(Matcher:hasNumbers('ab 1so 2ll')).
    end method.
    
    method public void testHasAlpha():
        assertTrue(Matcher:hasAlpha('128739718421ч')).
    end method.
    
    method public void testNullFalseHasAlpha():
        assertFalse(Matcher:hasAlpha('')).
    end method.
    
    method public void testFalseHasAlpha():
        assertFalse(Matcher:hasAlpha('  182038')).
    end method.
    
    method public void testNullFalseHasNumbers():
        assertFalse(Matcher:hasNumbers('')).
    end method.
    
    method public void testFalseHasNumbers():
        assertFalse(Matcher:hasNumbers('something really strange.')).
    end method.
    
    method public void testHasPunctuaction():
        assertTrue(Matcher:hasPunctuation('this is a, very, very long phrase.')).
    end method.
    
    method public void testNullFalseHasPunct():
        assertFalse(Matcher:hasPunctuation('')).
    end method.
    
    method public void testFalseHasPunctuation():
        assertFalse(Matcher:hasPunctuation('phrase without puncts 1234')).
    end method.
    
    method public void testHasAlphaNumWithNums():
        assertTrue(Matcher:hasAlphaNum('1234')).
    end method.
    
    method public void testHasAlphaNumWithAlpha():
        assertTrue(Matcher:hasAlphaNum('abc something')).
    end method.
    
    method public void testHasAlphaNumWithBoth():
        assertTrue(Matcher:hasAlphaNum('test 1234')).
    end method.
    
    method public void testHasAlphaNumWithAccentChars():
        assertTrue(Matcher:hasAlphaNum('ущ')).
    end method.
    
    method public void testHasAlphaNumWithSpaces():
        assertFalse(Matcher:hasAlphaNum('    ')).
    end method.
    
    method public void testHasOnlyNumbersTrue():
        assertTrue(Matcher:hasOnlyNumbers('12348889230')).
    end method.
    
    method public void testHasOnlyNumbersFalse():
        assertFalse(Matcher:hasOnlyNumbers('1234 5141')).
    end method.
    
    method public void testHasOnlyNumbersEmpty():
        assertFalse(Matcher:hasOnlyNumbers('')).
    end method.
    
    method public void testSensitivityOff():
        assign Matcher:sensitive = false.
        assertTrue(Matcher:equal('abc', 'ABC')).
    end method.
    
    method public void testSensitivityOn():
        assign Matcher:sensitive = true.
        assertFalse(Matcher:equal('abc', 'ABC')).
    end method.
    
    method public void testMeanMatchSensitive():
        assertEqual(Matcher:meanMatch('abcd', 'Ab'), 0.25).
    end method.
    
    method public void testMeanMatchInsensitive():
        Matcher:sensitive = false.
        assertEqual(Matcher:meanMatch('abcd', 'Ab'), 0.5).
    end method.
    
    method public void testMeanMatch100():
        assertEqual(Matcher:meanMatch('abc', 'abc'), 1).
    end method.
end class.
