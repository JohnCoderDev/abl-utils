class classes.Excel.Errors.ExcelInvalidHandle inherits Progress.Lang.AppError:
    constructor ExcelInvalidHandle():
        AddMessage('it was not possible to find a valid handle for the excel object', -5106).
    end constructor.
end class.
