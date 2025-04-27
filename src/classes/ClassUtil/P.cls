block-level on error undo, throw.
using Progress.Lang.* from propath.
using classes.ClassUtil.* from propath.


class classes.ClassUtil.P:
    def public property count as int init 0 no-undo get. private set.
    
    def temp-table params
        field val as char
        field type as char
        field obj as object.
        
    method public P add(pValue as char):
        create params.
        assign 
            count = count + 1
            params.val = pValue
            params.type = 'character'.
        return this-object.    
    end method.
    
    method public P add(pValue as int):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'integer'.
        return this-object.    
    end method.
    
    method public P add(pValue as int64):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'int64'.
        return this-object.    
    end method.
    
    method public P add(pValue as log):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'integer'.
        return this-object.    
    end method.
    
    method public P add(pValue as dec):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'decimal'.
        return this-object.    
    end method.
    
    method public P add(pValue as datetime-tz):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'datetime-tz'.
        return this-object.    
    end method.
    
    method public P add(pValue as datetime):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'datetime'.
        return this-object.    
    end method.
    
    method public P add(pValue as date):
        create params.
        assign 
            count = count + 1
            params.val = string(pValue)
            params.type = 'date'.
        return this-object.    
    end method.
    
    method public P add(pValue as object):
        create params.
        assign
            count = count + 1
            params.type = pValue:getClass():typeName
            params.obj = pValue.
        return this-object.
    end method.    
    
    method public ParameterList build():
        def var list as ParameterList no-undo.
        def var i as int no-undo.
        
        assign list = new ParameterList(count).
        
        for each params:
            assign i = i + 1.
            case params.type:
                when 'character' then do:
                    list:setParameter(i, params.type, 'input', params.val).
                end.
                when 'logical' then do:
                    list:setParameter(i, params.type, 'input', logical(params.val)).
                end.    
                when 'integer' then do:
                    list:setParameter(i, params.type, 'input', int(params.val)).
                end. 
                when 'int64' then do:
                    list:setParameter(i, params.type, 'input', int64(params.val)).
                end. 
                when 'decimal' then do:
                    list:setParameter(i, params.type, 'input', dec(params.val)).
                end. 
                when 'date' then do:
                    list:setParameter(i, params.type, 'input', date(params.val)).
                end. 
                when 'datetime' then do:
                    list:setParameter(i, params.type, 'input', datetime(params.val)).
                end. 
                when 'datetime-tz' then do:
                    list:setParameter(i, params.type, 'input', datetime-tz(params.val)).
                end. 
                otherwise do:
                    list:setParameter(i, params.type, 'input', params.obj). 
                end.
            end case.    
        end.
        
        return list.
    end method.
end class.
