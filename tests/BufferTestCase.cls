block-level on error undo, throw.
using classes.Tester.* from propath.
using classes.BufferUtil.* from propath.

class tests.BufferTestCase inherits ABLTestCase:
    def public property btt1 as Buffer no-undo get. set.
    def public property btt2 as Buffer no-undo get. set.
    def public property btt3 as Buffer no-undo get. set.
    def public property btt4 as Buffer no-undo get. set.
    
    def private temp-table tt1
        field c1 as char
        field c2 as int
        field c3 as char extent 2
        field c4 as int extent 2
        field c5 as date
        field c6 as date extent 2.
    
    def private temp-table tt2 like tt1.
    
    def private temp-table tt3
        field c1 as char extent 2
        field c2 as int extent 2
        field c3 as char
        field c4 as int
        field c5 as char extent 3
        field c6 as char.
        
    def private temp-table tt4
        field c5 as int extent 2.
        
    method public override void setup():
        create tt1.
        create tt2.
        create tt3.
        create tt4.
        
        assign
            tt1.c1 = 'test1'
            tt1.c2 = 123
            tt1.c3[1] = 'abc-test-1'
            tt1.c3[2] = 'def-test-1'
            tt1.c4[1] = 456
            tt1.c4[2] = 578
            tt1.c5 = today
            tt1.c6[1] = today - 30
            tt1.c6[2] = today - 28
            
            tt2.c1 = 'test2'
            tt2.c2 = 189
            tt2.c3[1] = 'abc-test-2'
            tt2.c3[2] = 'def-test-2'
            tt2.c4[1] = 234
            tt2.c4[2] = 82
            tt2.c5 = today - 1
            tt2.c6[1] = today + 30
            tt2.c6[2] = today + 28
            
            tt3.c1[1] = 'test-abc-3'
            tt3.c1[2] = 'test-def-3'
            tt3.c2[1] = 92
            tt3.c2[2] = 67238
            tt3.c3 = 'luggage'
            tt3.c4 = 1237
            tt3.c5[1] = '8932'
            tt3.c5[2] = 'ligs'
            tt3.c6 = 'test-efg-3'
            
            tt4.c5[1] = 783
            tt4.c5[2] = 928
            
            btt1 = new Buffer(buffer tt1:handle)
            btt2 = new Buffer(buffer tt2:handle)
            btt3 = new Buffer(buffer tt3:handle)
            btt4 = new Buffer(buffer tt4:handle).    
    end method.
    
    method public override void teardown():
        empty temp-table tt1.
        empty temp-table tt2.
        empty temp-table tt3.
        
        delete object btt1.
        delete object btt2.
        delete object btt3.
    end method.
    
    method public void testBufferCopyFieldC1():
        btt2:fieldCopy(btt1, 'c1').
        assertEqual(btt1:value('c1'), btt2:value('c1')).
    end method.
    
    method public void testBufferCopyFieldC2():
        btt2:fieldCopy(btt1, 'c2').
        assertEqual(btt1:value('c2'), btt2:value('c2')).
    end method.
    
    method public void testCopyStrategyAvailable1():
        btt2:fieldCopy(btt1, 'c1', 'available').
        assertEqual(btt2:value('c1'), 'test2').
    end method.
    
    method public void testCopyStrategyAvailable2():
        btt2:updateField('c1', '').
        btt2:fieldCopy(btt1, 'c1', 'available').
        assertEqual(btt1:value('c1'), btt2:value('c1')).
    end method.
    
    method public void testCopyStrategyAvailable3():
        btt1:updateField('c1', '').
        btt2:fieldCopy(btt1, 'c1', 'available').
        assertEqual(btt2:value('c1'), 'test2').
    end method.
    
    method public void testCopyStrategyAvailable4():
        btt2:updateField('c3', '', 2).
        btt2:fieldCopy(btt1, 'c3', 'available').
        assertTrue(btt2:value('c3', 1) = 'abc-test-2' and btt2:value('c3', 2) = btt1:value('c3', 1)).
    end method.
    
    method public void testCopyStrategyAvailable5():
        btt1:updateField('c3', '', 1).
        btt1:updateField('c3', '', 2).
        btt2:fieldCopy(btt1, 'c3', 'available').
        assertTrue(btt2:value('c3', 1) = 'abc-test-2' and btt2:value('c3', 2) = 'def-test-2').
    end method.
    
    method public void testCopyStrategyAvailable6():
        btt2:updateField('c3', '', 1).
        btt2:updateField('c3', '', 2).
        
        btt2:fieldCopy(btt1, 'c3', 'available').
        assertTrue(btt2:fieldEqual(btt1, 'c3')).
    end method.
    
    method public void testCopyStrategyAvailable7():
        btt2:updateField('c3', '', 2).
        
        btt2:fieldCopy(btt1, 'c3', 'available').
        assertTrue(btt2:value('c3', 1) = 'abc-test-2' and btt2:value('c3', 2) = btt1:value('c3', 1)).
    end method.
    
    method public void testCopyStrategyAvailable8():
        btt2:fieldCopy(btt1, 'c4', 'available').
        assertTrue(btt2:field('c4'):buffer-value(1) = 234 and btt2:field('c4'):buffer-value(2) = 82).
    end method.
    
    method public void testCopyStrategyAvailable9():
        btt2:setInitial('c4', 1).
        
        btt2:fieldCopy(btt1, 'c4', 'available').
        assertTrue(btt2:value('c4', 1) = btt1:value('c4', 1) and btt2:value('c4', 2) = '82').
    end method.
    
    method public void testCopyStrategyAvailable10():
        btt2:setInitial('c4').
        btt2:fieldCopy(btt1, 'c4', 'available').
        assertTrue(btt2:fieldEqual(btt1, 'c4')).
    end method.
    
    method public void testCopyStrategyAvailable11():
        btt2:setInitial('c6').
        btt2:fieldCopy(btt1, 'c6', 'available').
        assertTrue(btt2:fieldEqual(btt1, 'c6')).
    end method.
    
    method public void testCopyStrategyAvailable12():
        btt2:setInitial('c6', 1).
        btt2:fieldCopy(btt1, 'c6', 'available').
        assertTrue(btt2:field('c6'):buffer-value(1) = btt1:field('c6'):buffer-value(1) and btt2:field('c6'):buffer-value(2) = today + 28).
    end method.
    
    method public void testCopyStrategyAvailable13():
        btt1:setInitial('c1').
        btt1:fieldCopy(btt3, 'c1', 'available').
        assertTrue(btt1:field('c1'):buffer-value = btt3:field('c1'):buffer-value(1)).
    end method.
    
    method public void testCopyStrategyAvailable14():
        btt1:fieldCopy(btt3, 'c1', 'available').
        assertTrue(btt1:field('c1'):buffer-value = 'test1').
    end method.
    
    method public void testCopyStrategyAvailable15():
        btt3:setInitial('c1').
        btt3:fieldCopy(btt1, 'c1', 'available').
        assertTrue(btt3:field('c1'):buffer-value(1) = btt1:field('c1'):buffer-value and btt3:fieldHasInitial('c1', 2)).
    end method.
    
    method public void testCopyStrategyAvailable16():
        btt3:setInitial('c1', 2).
        btt3:fieldCopy(btt1, 'c1', 'available').
        assertTrue(btt3:field('c1'):buffer-value(1) = 'test-abc-3' and btt1:field('c1'):buffer-value = btt3:field('c1'):buffer-value(2)).
    end method.
    
    method public void testCopyStrategyAvailable17():
        btt3:fieldCopy(btt1, 'c1', 'available').
        assertTrue(btt3:value('c1', 1) = 'test-abc-3' and btt3:value('c1', 2) = 'test-def-3').
    end method.
    
    method public void testCopyStrategyAvailable18():
        btt3:fieldCopy(btt1, 'c5', 'available').
        assertTrue(btt3:value('c5', 3) = btt1:value('c5')).
    end method.
    
    method public void testCopyStrategyAvailable19():
        btt3:setInitial('c5').
        btt3:fieldCopy(btt1, 'c5', 'available').
        assertTrue(btt3:value('c5', 1) = btt1:value('c5') and btt3:fieldHasInitial('c5', 2) and btt3:fieldHasInitial('c5', 3)).
    end method.
    
    method public void testCopyStrategyAvailable20():
        btt3:updateField('c5', today, 3).
        btt3:fieldCopy(btt1, 'c5', 'available').
        assertTrue(btt3:value('c5', 1) = '8932' and btt3:value('c5', 2) = 'ligs' and btt3:value('c5', 3) = string(today)).
    end method.
    
    method public void testCopyStrategyAvailable21():
        btt1:setInitial('c5').
        btt3:updateField('c5', today - 23, 1).
        btt3:updateField('c5', today + 60, 2).
        btt3:updateField('c5', today - 60, 3).
        
        btt1:fieldCopy(btt3, 'c5', 'available').
        assertEqual(btt1:value('c5'), btt3:value('c5', 1)).
    end method.
    
    method public void testCopyStrategyAvailable22():
        btt1:setInitial('c5').
        btt3:setInitial('c5').
        btt3:updateField('c5', today + 22, 2).
        btt1:fieldCopy(btt3, 'c5', 'available').
        assertEqual(btt1:value('c5'), btt3:value('c5', 2)).
    end method.
    
    method public void testCopyStrategyAvailable23():
        btt4:fieldCopy(btt3, 'c5', 'available').
        assertTrue(btt4:value('c5', 1) = '783' and btt4:value('c5', 2) = '928').
    end method.
    
    method public void testCopyStrategyAvailable24():
        btt4:setInitial('c5').
        btt3:updateField('c5', '1234', 1).
        btt3:updateField('c5', '8923', 2).
        btt3:updateField('c5', '2378', 3).
        btt4:fieldCopy(btt3, 'c5', 'available').
        
        assertTrue(btt4:value('c5', 1) = btt3:value('c5', 1) and btt4:value('c5', 2) = btt3:value('c5', 2)).
    end method.
    
    method public void testCopyStrategyAvailable25():
        btt4:setInitial('c5', 2).
        btt3:setInitial('c5').
        btt3:updateField('c5', 8293, 3).
        btt4:fieldCopy(btt3, 'c5', 'available').
        
        assertEqual(btt3:value('c5', 3), btt4:value('c5', 2)).
    end method.
    
    method public void testCopyStrategyAvailable26():
        btt4:setInitial('c5').
        btt4:fieldCopy(btt3, 'c5', 'available').
        
        assertTrue(btt4:value('c5', 1) = btt3:value('c5', 1) and btt4:fieldHasInitial('c5', 2)).
    end method.
    
    method public void testCopyStrategyAvailable27():
        btt3:setInitial('c5').
        btt3:fieldCopy(btt4, 'c5', 'available').
        
        assertTrue(btt3:value('c5', 1) = btt4:value('c5', 1) and btt3:value('c5', 2) = btt4:value('c5', 2)).
    end method.
    
    method public void testCopyStrategyMerge1():
        btt1:copy(btt2, 'merge').
        assertTrue(btt1:fieldEqual(btt2, 'c2')).
    end method.
    
    method public void testCopyStrategyMerge2():
        btt2:setInitial('c1').
        btt1:copy(btt2, 'merge').
        assertEqual(btt1:value('c1'), 'test1').
    end method.
    
    method public void testCopyStrategyMerge3():
        btt2:setInitial('c3', 1).
        btt1:copy(btt2, 'merge').
        assertTrue(btt1:value('c3', 1) = btt2:value('c3', 2) and btt1:value('c3', 2) = 'def-test-1').
    end method.
    
    method public void testCopyStrategyMerge4():
        btt2:setInitial('c3').
        btt1:copy(btt2, 'merge').
        assertTrue(btt1:value('c3', 1) = 'abc-test-1' and btt1:value('c3', 2) = 'def-test-1').
    end method.
end class.
