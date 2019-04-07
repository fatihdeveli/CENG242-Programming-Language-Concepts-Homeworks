module Hw1 where

type Mapping = [(String, String, String)]
data AST = EmptyAST | ASTNode String AST AST deriving (Show, Read)

writeExpression :: (AST, Mapping) -> String
evaluateAST :: (AST, Mapping) -> (AST, String)
-- DO NOT MODIFY OR DELETE THE LINES ABOVE -- 
-- IMPLEMENT writeExpression and evaluateAST FUNCTION ACCORDING TO GIVEN SIGNATURES -- 

writeExpression (EmptyAST, _) = ""
writeExpression (ast, (x:xs)) = "let " ++ helper ast (x:xs) ++ " in " ++ writeExpression (ast, [])
writeExpression (ASTNode "num" (ASTNode number _ _) _, []) = number
writeExpression (ASTNode "str" (ASTNode string _ _) _, []) = show string
writeExpression (ASTNode "plus" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "+" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode "times" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "*" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode "negate" exp1 _, []) = "(" ++ "-" ++ writeExpression (exp1, []) ++ ")"
writeExpression (ASTNode "len" exp1 _, []) = "(length " ++ writeExpression(exp1, []) ++ ")"
writeExpression (ASTNode "cat" exp1 exp2, []) = "(" ++ writeExpression (exp1, []) ++ "++" ++ writeExpression (exp2, []) ++ ")"
writeExpression (ASTNode variable _ _, []) = variable

-- Helper deals with the variables in the expression
helper :: AST -> Mapping -> String
helper ast [(name, typ, val)] = name ++ "=" ++ (if typ == "str" then show (val) else val) -- Only one element in mapping, no ';' at the end
helper ast ((name, typ, val):xs) = name ++ "=" ++ (if typ == "str" then show (val) else val) ++ ";" ++ helper ast xs -- more than 2 elements

evaluateAST (ast, []) = (ast, (evaluate ast))
evaluateAST (ast, mapping) = (substitutedAST, (evaluate substitutedAST)) where substitutedAST = substitute (ast, mapping)

-- Substitute the variables in the expression with corresponding ASTNode with variable value
substitute :: (AST, Mapping) -> AST
substitute (EmptyAST, mapping) = EmptyAST
substitute (ASTNode str ast1 ast2, mapping)
    | isVariable str mapping = ASTNode (typeOfVarName str mapping) (ASTNode (valueOfVarName str mapping) EmptyAST EmptyAST) EmptyAST
    | otherwise = ASTNode str (substitute (ast1, mapping)) (substitute (ast2, mapping))

-- Get the value of a given variable name in the mapping list
valueOfVarName :: String -> Mapping -> String
valueOfVarName str [] = str
valueOfVarName str ((name, _, val):xs) = if str == name then val else valueOfVarName str xs

-- Get the type of a given variable name in the mapping list
typeOfVarName :: String -> Mapping -> String
typeOfVarName str ((name, typ, _):xs) = if str == name then typ else typeOfVarName str xs

-- Check if given string is a variable name in the mappings list
isVariable :: String -> Mapping -> Bool
isVariable _ [] = False
isVariable str ((name, _, _):xs) = str == name || isVariable str xs

evaluate :: AST -> String
evaluate (ASTNode "num" (ASTNode val _ _) _) = val
evaluate (ASTNode "str" (ASTNode val _ _) _) = val
evaluate (ASTNode "plus" ast1 ast2) = show ((read (evaluate ast1)::Int) + (read (evaluate ast2)::Int))
evaluate (ASTNode "times" ast1 ast2) = show ((read (evaluate ast1)::Int) * (read (evaluate ast2)::Int))
evaluate (ASTNode "negate" ast _) = "-" ++ evaluate ast
evaluate (ASTNode "cat" ast1 ast2) = (evaluate ast1) ++ (evaluate ast2)
evaluate (ASTNode "len" ast _) = show (length (evaluate ast))

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