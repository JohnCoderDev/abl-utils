block-level on error undo, throw.
using classes.Html.* from propath.

class classes.Html.TagBuilder:
    define public property tagName as character no-undo get. set.
    
    define private temp-table styles
        field styleName as character
        field styleValue as character
        index idxName as primary unique styleName.
        
    define private temp-table properties
        field propertyName as character
        field propertyValue as character
        index idxName as primary unique propertyName.
    
    constructor TagBuilder(pTag as character):
        assign tagName = pTag.
    end constructor.
    
    method public TagBuilder addStyle(pName as character, pValue as character):
        find first styles
            where styles.styleName = pName
            no-error.
        
        if not available styles then do:
            create styles.
        end.
        
        assign
            styles.styleName = pName
            styles.styleValue = pValue.
        
        return this-object.
    end method.
    
    method public TagBuilder addProperty(pName as character):
        return addProperty(pName, "").
    end method.
    
    method public TagBuilder addProperty(pName as character, pValue as character):
        find first properties
            where properties.propertyName = pName
            no-error.
            
        if not available properties then do:
            create properties.            
        end.
        
        assign
            properties.propertyName = pName
            properties.propertyValue = pValue.
            
        return this-object.    
    end method.
    
    method public character getOpenTag():
        define variable resultTag as character no-undo.
        
        assign resultTag = "<" + tagName.
        
        if temp-table styles:has-records then do:
            define variable tagStyle as character no-undo.
            for each styles:
                assign tagStyle = tagStyle + styles.styleName + ":" + styles.styleValue + ";".
            end.
            assign resultTag = resultTag + " style=" + quoter(tagStyle).
        end.
        
        if temp-table properties:has-records then do:
            define variable tagProperties as character no-undo.
            for each properties:
                assign tagProperties = tagProperties + " " + properties.propertyName + 
                    (if properties.propertyValue = "" or properties.propertyValue = ? then "" else "=" + quoter(properties.propertyValue)).
            end.
            assign resultTag = resultTag + tagProperties.
        end.
        
        assign resultTag = resultTag + ">".
        return resultTag.
    end method.
    
    method public character getCloseTag():
        define variable resultTag as character no-undo.
        assign resultTag = "</" + tagName + ">".
        return resultTag.
    end method.
end class.
