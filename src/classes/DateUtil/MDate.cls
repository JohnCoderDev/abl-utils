block-level on error undo, throw.
using classes.DateUtil.* from propath.
class classes.DateUtil.MDate:
    def public property dateValue as date no-undo init today get. protected set.
    def public static property yesterday as date
        get:
            return today - 1.
        end.
    
    def public static property tomorrow as date
        get:
            return today + 1.
        end.
        
    def public static property startOfMonth as date
        get:
            return startOfMonth(today).
        end.
        
    def public static property endOfMonth as date
        get:
            return endOfMonth(today).
        end.
        
    def public static property startOfYear as date
        get:
            return startOfYear(today).
        end.
    
    def public static property endOfYear as date
        get:
            return endOfYear(today).
        end.    
    
    constructor MDate():
    end constructor.
    
    constructor MDate(pDate as date):
        parseDate(pDate).
    end constructor.
    
    method public MDate parseDate(pDate as date):
        assign dateValue = pDate.
        return this-object.
    end method.
    
    method public static date Add(pDate as date, pCount as int, pUnit as char):
        return add-interval(pDate, pCount, pUnit).
    end method.
    
    method public date startOfMonth():
        return startOfMonth(dateValue).
    end method.
    
    method public static date startOfMonth(pDate as date):
        return date('01/' 
            + string(month(pDate)) + '/' 
            + string(year(pDate))
        ).
    end method.
    
    method public date startOfYear():
        return startOfYear(dateValue).
    end method.
    
    method public static date startOfYear(pDate as date):
        return date('01/01/' + string(year(pDate))).
    end method.
    
    method public date endOfMonth():
        return endOfMonth(dateValue).
    end method.
    
    method public static date endOfMonth(pDate as date):
        return startOfMonth(MDate:add(pDate, 1, 'month')) - 1.
    end method.
    
    method public date endOfYear():
        return endOfYear(dateValue).
    end method.
    
    method public static date endOfYear(pDate as date):
        return date('31/12/' + string(year(pDate))).
    end method.
    
    method public date yesterday():
        return yesterday(dateValue).
    end method.
    
    method public date yesterday(pDate as date):
        return pDate - 1.
    end method.
    
    method public date tomorrow():
        return tomorrow(dateValue).
    end method.
    
    method public date tomorrow(pDate as date):
        return pDate + 1.
    end method.
end class.
