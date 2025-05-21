block-level on error undo, throw.
using Progress.Lang.* from propath.

class classes.VariableUtil.VariableDump:
    method public static int variableExtent(pVariable as char extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as datetime extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as date extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as datetime-tz extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as int extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as int64 extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as log extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as dec extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as object extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as raw extent):
        return extent(pVariable).
    end method.
    
    method public static int variableExtent(pVariable as memptr extent):
        return extent(pVariable).
    end method.
end class.
