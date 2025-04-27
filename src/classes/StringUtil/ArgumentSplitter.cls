block-level on error undo, throw.
using classes.StringUtil.* from propath.

class classes.StringUtil.ArgumentSplitter:
    def public property argument as char no-undo get. private set.
    def public property delimiter as char no-undo init ' ' get. private set.
    def public property argumentNameIndicator as char no-undo init '-,--' get. private set.
    
    def private temp-table arguments
        field argName as char
        field argValue as char.
    
    constructor ArgumentSplitter():
    end constructor.
    
    constructor ArgumentSplitter(pArgument as char):
        parse(pArgument).
    end constructor.
    
    method public ArgumentSplitter parse(pArgument as char):
        reset().
        assign argument = Sanitizer:wipeSpaces(pArgument).
        parseTable().
        return this-object.
    end method.
    
    method protected void parseTable():
        def var i as int no-undo.
        def var arg as char no-undo.
        def var nextArg as char no-undo.
        
        do i = 1 to count():
            create arguments.
            assign 
                arg = get(i)
                nextArg = get(i + 1).
            
            if Matcher:startsWithOneOf(arg, argumentNameIndicator) then do:
                if not Matcher:startsWithOneOf(nextArg, argumentNameIndicator) and nextArg <> '' then do:                
                    assign
                        arguments.argName = Sanitizer:shiftLeft(arg, argumentNameIndicator)
                        arguments.argValue = nextArg
                        i = i + 1.
                end.
                else do:
                    assign
                        arguments.argName = Sanitizer:shiftLeft(arg, argumentNameIndicator)
                        arguments.argValue = 'true'.
                end.
            end.
            else do:
                assign
                    arguments.argValue = arg.
            end.
        end.
    end method.
    
    method public char get():
        return get('').
    end method.
    
    method public char get(pName as char):
        if findArg(pName) then do:
            return arguments.argValue.
        end.
        
        return ''.
    end method.
    
    method public char next():
        return this-object:next('').
    end method.
    
    method public char next(pName as char):
        if not avail arguments then do:
            return get(pName).
        end.
        if findNextArg(pName) then do:
            return arguments.argValue.
        end.
        return ''.
    end method.
    
    method protected log findArg(pName as char):
        find first arguments
            where arguments.argName = pName
            no-error.
        return avail arguments.    
    end method.
    
    method public log findNextArg(pName as char):
        find next arguments
            where arguments.argName = pName
            no-error.
        return avail arguments.    
    end method.
    
    method public char get(pIndex as int):
        if count() < pIndex then return ''.
        return entry(pIndex, argument, this-object:delimiter).
    end method.
    
    method public int index(pSearched as char):
        def var i as int no-undo.
        
        do i = 1 to count():
            if get(i) = pSearched then return i.
        end.
        
        return 0.
    end method.
    
    method public int count():
        return num-entries(argument, this-object:delimiter).
    end method.
    
    
    method public void reset():
        empty temp-table arguments.
        assign argument = ''.
    end method.
    
    destructor ArgumentSplitter():
        reset().
    end destructor.
end class.
