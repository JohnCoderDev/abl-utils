class classes.Excel.Errors.WorkbookIndexOutsideRange inherits Progress.Lang.AppError:
    constructor WorkbookIndexOutsideRange(pIndex as integer, pMaxValue as integer):
        addMessage('it was expected an index between 1 and ' + string(pMaxValue) + ', but received ' + string(pIndex), -5107).
    end constructor.
end class.
