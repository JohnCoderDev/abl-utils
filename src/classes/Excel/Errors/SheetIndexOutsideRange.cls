class classes.Excel.Errors.SheetIndexOutsideRange inherits Progress.Lang.AppError:
    constructor SheetIndexOutsideRange(pIndex as integer, pMaxValue as integer):
        addMessage('it was expected an index between 1 and ' + string(pMaxValue) + ', but received ' + string(pIndex), -5108).
    end constructor.
end class.
