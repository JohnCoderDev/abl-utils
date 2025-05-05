block-level on error undo, throw.
using Progress.Json.ObjectModel.* from propath.
using classes.Tester.* from propath.
using classes.BufferUtil.* from propath.

class tests.QueryTestCase inherits ABLTestCase:
    def public property queryObject as Query no-undo get. protected set.
    def temp-table tt1
        field c1 as char
        field c2 as int.
        
    def temp-table tt2
        field c1 as char
        field c3 as date.
    
    method public override void setup():
        create tt1.
        create tt2.
        
        assign
            tt1.c1 = 'something'
            tt1.c2 = 1234
            
            tt2.c1 = 'something'
            tt2.c3 = today.
            
        create tt2.
        assign
            tt2.c1 = 'another thing'
            tt2.c3 = today + 1.
    end method.
    
    method public override void teardown():
        empty temp-table tt1.
        empty temp-table tt2.
    end method.
    
    method public void testQueryString1():
        assign queryObject = new Query('for each emitente').
        assertEqual(queryObject:queryString(), 'for each emitente no-lock').
    end method.
    
    method public void testQueryString2():
        assign queryObject = new Query('for each emitente share-lock').
        assertEqual(queryObject:queryString(), 'for each emitente share-lock').
    end method.
    
    method public void testQueryString3():
        assign queryObject = new Query('for each emitente where emitente.cod-emitente = 1234').
        assertEqual(queryObject:queryString(), 'for each emitente no-lock where emitente.cod-emitente = 1234').
    end method.
    
    method public void testQueryString4():
        assign queryObject = new Query('for each emitente of country').
        assertEqual(queryObject:queryString(), 'for each emitente of country no-lock').
    end method.
    
    method public void testQueryString5():
        assign queryObject = new Query('for each emitente fields(cod-emitente nome-abrev)').
        assertEqual(queryObject:queryString(), 'for each emitente fields(cod-emitente nome-abrev) no-lock').
    end method.
    
    method public void testQueryString6():
        assign queryObject = new Query('for each emitente fields(cod-emitente nome-abrev) except(nome-emit)').
        assertEqual(queryObject:queryString(), 'for each emitente fields(cod-emitente nome-abrev) except(nome-emit) no-lock').
    end method.
    
    method public void testQueryString7():
        assign queryObject = new Query('for each country, first state where state.country_code = country.code').
        assertEqual(queryObject:queryString(), 'for each country no-lock,first state no-lock where state.country_code = country.code').
    end method.
    
    method public void testQueryString8():
        assign queryObject = new Query('emitente').
        assertEqual(queryObject:queryString(), 'for each emitente no-lock').
    end method.
    
    method public void testQueryString9():
        assign queryObject = new Query('emitente break by emitente.country').
        assertEqual(queryObject:queryString(), 'for each emitente no-lock break by emitente.country').
    end method.
    
    method public void testQueryString10():
        assign queryObject = new Query('emitente break by emitente.country by emitente.code ascending by emitente.name descending').
        assertEqual(queryObject:queryString(), 'for each emitente no-lock break by emitente.country by emitente.code ascending by emitente.name descending').
    end method.
    
    method public void testQueryValue1():
        assign queryObject = new Query('tt1').
        queryObject:setBuffer(buffer tt1:handle).    
        queryObject:first().
        assertEqual(queryObject:getValue('c1'), 'something').
    end method.
    
    method public void testQueryValue2():
        assign queryObject = new query('tt2').
        queryObject:setBuffer(buffer tt2:handle).
        assertTrue(queryObject:next():getValue('c1') = 'something' and queryObject:next():getValue('c1') = 'another thing').
    end method.
    
    method public void testQueryWhere1():
        assign queryObject = new Query('for each tt1, each tt2 where tt2.c1 = tt1.c1').
        queryObject
            :setBuffer(buffer tt1:handle)
            :setBuffer(buffer tt2:handle).
        
        queryObject:first().
        assertTrue(queryObject:getValue('c1') = 'something' and queryObject:getValue('c3') = string(today)).
    end method.
    
    method public void testQueryJson1():
        def var json as JsonObject no-undo.
        assign queryObject = new Query('for each tt1').
        queryObject:setBuffer(buffer tt1:handle):first().
        assign json = queryObject:toJson().
        assertTrue(json:has('tt1') and json:getJsonObject('tt1'):has('c1') and json:getJsonObject('tt1'):has('c2')).
    end method.
    
    method public void testQueryJson2():
        def var json as JsonObject no-undo.
        assign queryObject = new Query('tt1, first tt2 where tt2.c1 = tt1.c1').
        queryObject
            :setBuffer(buffer tt1:handle)
            :setBuffer(buffer tt2:handle)
            :first().
        
        assign json = queryObject:toJson().
        assertTrue(json:has('tt1') and json:has('tt2')).
    end method.
    
    method public void testQueryJson3():
        def var json as JsonArray no-undo.
        assign queryObject = new Query('tt2').
        queryObject:setBuffer(buffer tt2:handle).
        
        assign json = queryObject:toJsonArray().
        assertEqual(json:length, 2).
    end method.
    
    method public void testQueryJson4():
        def var json as JsonObject no-undo.
        assign queryObject = new Query('tt1, tt2 where tt2.c1 = tt1.c1').
        queryObject
            :setBuffer(buffer tt2:handle)
            :setBuffer(buffer tt1:handle).
        
        assign json = queryObject:first():toJson('merge').
        assertTrue(json:has('c1') and json:has('c2') and json:has('c3')).
    end method.
    
    method public void testQueryJson5():
        def var json as JsonObject no-undo.
        assign queryObject = new Query('tt1, tt2 where tt2.c1 = tt1.c1').
        queryObject
            :setBuffer(buffer tt1:handle)
            :setBuffer(buffer tt2:handle).
        
        assign json = queryObject:first():toJson('join').
        assertTrue(json:has('c1') and json:has('c1-2') and json:has('c2') and json:has('c3')).
    end method.    
    
    method public void testQueryJson6():
        def var json as JsonArray no-undo.
        assign json = new Query('tt1, tt2 where tt1.c1 = tt2.c1')
            :setBuffer(buffer tt1:handle)
            :setBuffer(buffer tt2:handle)
            :first()
            :toJsonArray('join', false).
        assertEqual(json:length, 1).
    end method.
end class.
