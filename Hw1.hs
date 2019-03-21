module Hw1 where

type Mapping = [(String, String, String)]
data AST = EmptyAST | ASTNode String AST AST deriving (Show, Read)

writeExpression :: (AST, Mapping) -> String
evaluateAST :: (AST, Mapping) -> (AST, String)
-- DO NOT MODIFY OR DELETE THE LINES ABOVE -- 
-- IMPLEMENT writeExpression and evaluateAST FUNCTION ACCORDING TO GIVEN SIGNATURES -- 

writeExpression (EmptyAST, _) = ""
writeExpression (ast, (x:xs)) = helper ast (x:xs) True
writeExpression (ASTNode "num" (ASTNode number _ _) _, []) = number
writeExpression (ASTNode "str" (ASTNode string _ _) _, []) = "\"" ++ string ++ "\""
writeExpression (ASTNode "plus" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "+" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode "times" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "*" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode "negate" exp1 _, []) = "(" ++ "-" ++ writeExpression (exp1, []) ++ ")"
writeExpression (ASTNode "len" exp1 _, []) = "(length" ++ writeExpression(exp1, []) ++ ")"
writeExpression (ASTNode "cat" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "++" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode variable _ _, []) = variable

helper :: AST -> Mapping -> Bool -> String
helper ast (x:xs) True = "let " ++ getVarName x ++ "=" ++ getVarValue x ++ helper ast xs False ++ " in " ++ writeExpression (ast, [])
helper ast (x:xs) False = ";" ++ getVarName x ++ "=" ++ getVarValue x ++ helper ast xs False
helper _ [] False = ""


-- Get the name of the variable from the given mapping tuple
getVarName (name, _, _) = name

-- Get the value of the variable from the given mapping tuple
getVarValue (_, t, val)
    | t == "str" = "\"" ++ val ++ "\""
    | t == "num" = val

-- Get the type of the variable from the given mapping tuple
getVarType (_, t, _) = t

evaluateAST _ = (EmptyAST, "")

-- Substitute the variables in the expression with corresponding ASTNode with variable value
substitute :: (AST, Mapping) -> AST
substitute (ast, []) = ast
substitute (EmptyAST, mapping) = EmptyAST
substitute (ASTNode str ast1 ast2, mapping)
    | isVariable str mapping = ASTNode (getTypeOfVar str mapping) (ASTNode (getValueOfVar str mapping) EmptyAST EmptyAST) EmptyAST
    | otherwise = ASTNode str (substitute (ast1, mapping)) (substitute (ast2, mapping))



-- Get the value of a given variable name
getValueOfVar :: String -> Mapping -> String
getValueOfVar str [] = str
getValueOfVar str (x:xs) = if str == (getVarName x) then getVarValue x else getValueOfVar str xs

-- Get the type of a given variable name
getTypeOfVar :: String -> Mapping -> String
getTypeOfVar str (x:xs) = if str == (getVarName x) then getVarType x else getTypeOfVar str xs

-- Check if given string is a variable name in the mappings list
isVariable :: String -> Mapping -> Bool
isVariable _ [] = False
isVariable str (x:xs) = str == getVarName x || isVariable str xs

{-

---- TEST CASES ----

-- writeExpression --
*Hw1> writeExpression ((ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST), [])
"3"

*Hw1> writeExpression ((ASTNode "x" EmptyAST EmptyAST), [("x", "num", "17")])
"let x=17 in x"

*Hw1> writeExpression ((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), [])
"(3+5)"

*Hw1> writeExpression ((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [])
"(3+(-5))"

*Hw1> writeExpression ((ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), [])
"(7*5)"

*Hw1> writeExpression ((ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)), [])
"(\"CENG\"++\"242\")"

*Hw1> writeExpression ((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST), [])
"(length (\"CENG\"++\"242\"))"

*Hw1> writeExpression ((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [("x", "num", "9")])
"let x=9 in (x+(-2))"

*Hw1> writeExpression ((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "y" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9"), ("y", "num", "19")])
"let x=9;y=19 in (x+(-y))"

*Hw1> writeExpression ((ASTNode "times" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "x" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9")])
"let x=9 in (x*(-x))"

*Hw1> writeExpression ((ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "department" EmptyAST EmptyAST) (ASTNode "course_code" EmptyAST EmptyAST)) EmptyAST) EmptyAST), [("department", "str", "CENG"), ("course_code", "str", "242")])
"let department=\"CENG\";course_code=\"242\" in (-(length (department++course_code)))"

*Hw1> writeExpression ((ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST))), [])
"((-(length (\"CENG\"++\"242\")))*(8+14))"


-- evaluateAST --
*Hw1> evaluateAST ((ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST), [])
(ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST,"3")

*Hw1> evaluateAST ((ASTNode "x" EmptyAST EmptyAST), [("x", "num", "17")])
(ASTNode "num" (ASTNode "17" EmptyAST EmptyAST) EmptyAST,"17")

*Hw1> evaluateAST ((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), [])
(ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST),"8")

*Hw1> evaluateAST ((ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [])
(ASTNode "plus" (ASTNode "num" (ASTNode "3" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-2")

*Hw1> evaluateAST ((ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST)), [])
(ASTNode "times" (ASTNode "num" (ASTNode "7" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "5" EmptyAST EmptyAST) EmptyAST),"35")

*Hw1> evaluateAST ((ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)), [])
(ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST),"CENG242")

*Hw1> evaluateAST ((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST), [])
(ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST,"7")

*Hw1> evaluateAST ((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST)), [("x", "num", "9")])
(ASTNode "plus" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "2" EmptyAST EmptyAST) EmptyAST) EmptyAST),"7")

*Hw1> evaluateAST ((ASTNode "plus" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "y" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9"), ("y", "num", "19")])
(ASTNode "plus" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "19" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-10")

*Hw1> evaluateAST ((ASTNode "times" (ASTNode "x" EmptyAST EmptyAST) (ASTNode "negate" (ASTNode "x" EmptyAST EmptyAST) EmptyAST)), [("x", "num", "9")])
(ASTNode "times" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) (ASTNode "negate" (ASTNode "num" (ASTNode "9" EmptyAST EmptyAST) EmptyAST) EmptyAST),"-81")

*Hw1> evaluateAST ((ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "department" EmptyAST EmptyAST) (ASTNode "course_code" EmptyAST EmptyAST)) EmptyAST) EmptyAST), [("department", "str", "CENG"), ("course_code", "str", "242")])
(ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST,"-7")

*Hw1> evaluateAST ((ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST))), [])
(ASTNode "times" (ASTNode "negate" (ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "CENG" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "242" EmptyAST EmptyAST) EmptyAST)) EmptyAST) EmptyAST) (ASTNode "plus" (ASTNode "num" (ASTNode "8" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "14" EmptyAST EmptyAST) EmptyAST)),"-154")
-}