block-level on error undo, throw.

class classes.StringUtil.Alphabet:
    def public static property alpha as char no-undo init 'abcdefghijklmnopqrstuvwxyz' get. private set.
    def public static property numbers as char no-undo init '0123456789' get. private set.
    def public static property accentChars as char no-undo init 'áàâãäéèêëíìîïóòõôöúùûüçñÿı' get. private set.
    def public static property accentCharsReplacement as char no-undo init 'aaaaaeeeeiiiiooooouuuucnyy' get. private set.
    def public static property special as char no-undo init '~'"!@#$%¨&*()_+¹²³£¢¬§-´[`ª~{~~^}]º:;?/°,.<>|\' get. private set.
    def public static property blankchars as char no-undo init ' ~t~n' get. private set.
    def public static property commonPuncts as char no-undo init ',.;:?!$()' get. private set.
    def public static property mathOperators as char init '+-*/' no-undo get. private set.
    def public static property wrappers as char init '()~{}[]' no-undo get. private set.
    def public static property space as char init ' ' no-undo get. private set.
    def public static property tab as char init '~t' no-undo get. private set.
    def public static property newline as char init '~n' no-undo get. private set.
    
    def public static property accentAlpha as char no-undo get. private set.
    def public static property accentAlphanum as char no-undo get. private set.
    def public static property commonText as char no-undo get. private set.
    def public static property accentCommonText as char no-undo get. private set.
    def public static property alphanum as char no-undo get. private set.
    
    constructor static Alphabet():
        assign 
            alphanum = alpha + numbers 
            accentAlpha = alpha + accentChars 
            accentAlphaNum = accentAlpha + numbers
            commonText = alphanum + blankchars + commonPuncts
            accentCommonText = commonText + accentChars .
    end constructor.
end class.
