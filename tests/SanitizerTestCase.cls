block-level on error undo, throw.
using classes.StringUtil.* from propath.
using classes.Tester.* from propath.

class tests.SanitizerTestCase inherits ABLTestCase:
    method public override void setup():
    end method.
    
    method public override void teardown():
    end method.
    
    method public void testNumbersMethod():
        assertEqual(Sanitizer:numbers(' 1234abc-çc;.,/ 8809 '), '12348809').
    end method.
    
    method public void testAlphaMethod():
        assertEqual(Sanitizer:alpha(' 1234abc-çc;.,/ 8809 '), 'abcc').
    end method.
    
    method public void testAlphaNumMethod():
        assertEqual(Sanitizer:alphanum(' 1234abc-çc;.,/ 8809 '), '1234abcc8809').
    end method.
    
    method public void testRemoveSpecials():
        assertEqual(Sanitizer:removeSpecial(' 1234abc-çc;.,/ 8809 '), ' 1234abcçc 8809 ').
    end method.       
    
    method public void testRemoveSpaces():
        assertEqual(Sanitizer:removeSpaces(' 1234abc-çc;.,/ 8809 '), '1234abc-çc;.,/8809').
    end method.
    
    method public void testReplaceAccentChars():
        assertEqual(Sanitizer:replaceAccentChars('associação de séries'), 'associacao de series').
    end method.
    
    method public void testWipeSpaces():
        assertEqual(Sanitizer:wipeSpaces('  very    spaced  chars     '), 'very spaced chars').
    end method.
    
    method public void testCapitalize():
        assertEqual(Sanitizer:capitalize('capitalized chars In PhRasE'), 'Capitalized Chars In Phrase').
    end method.
    
    method public void testPascalCase():
        assertEqual(Sanitizer:pascalCase('phrase to pascal'), 'PhraseToPascal').
    end method.
    
    method public void testCamelCase():
        assertEqual(Sanitizer:camelCase('phrase to camel'), 'phraseToCamel').
    end method.
    
    method public void testCamelCaseWithNumbers():
        assertEqual(Sanitizer:camelCase('0123 phrase to camel'), 'phraseToCamel').
    end method.
    
    method public void testKebabCase():
        assertEqual(Sanitizer:kebabCase('phrase to KEBAB'), 'phrase-to-kebab').
    end method.
    
    method public void testShiftLeft():
        assertEqual(Sanitizer:shiftLeft('0001234abc', '0'), '1234abc').
    end method.
    
    method public void testFilterChars():
        assertEqual(Sanitizer:filterChars('abeedefllkkmno', 'abek'), 'abeeekk').
    end method.
    
    method public void testFilterCharsReversed():
        assertEqual(Sanitizer:filterChars('abeedefllkkmno', 'abek', true), 'dfllmno').
    end method.
    
    method public void testReplaceChars():
        assertEqual(Sanitizer:replaceChars('aaabbeeedef', 'ed', 'kn'), 'aaabbeeenef').
    end method.
    
    method public void testReplaceCharsThrow():
        assertThrow(this-object, 'throwReplaceChars').
    end method.
    
    method public void throwReplaceChars():
        Sanitizer:replaceChars('abc', 'a', '').
    end method.
end class.
