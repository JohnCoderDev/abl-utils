block-level on error undo, throw.

class classes.BrazilUtil.FiscalOperationNature:
    def public static property sellOperations as char no-undo 
        get:
            return "5101,5102,5103,5104,5105,5106,5107,5108,5109,5110,5111,5112,5113,5114,5115,5116,"
                + "5117,5118,5119,5120,5121,5122,5123,6101,6102,6103,6104,6105,6106,6107,6108,6109,6110,"
                + "6111,6112,6113,6114,6115,6116,6117,6118,6119,6120,6121,6122,6123,6401,6402,6403,7101,"
                + "7102,7105,7106".
        end.
        
    def public static property devolutionOperations as char no-undo
        get:
            return '1201,1202,1203,1204,2201,2202,2203,2204'.
        end.
end class.
