module Hw1 where

type Mapping = [(String, String, String)]
data AST = EmptyAST | ASTNode String AST AST deriving (Show, Read)

writeExpression :: (AST, Mapping) -> String
evaluateAST :: (AST, Mapping) -> (AST, String)
-- DO NOT MODIFY OR DELETE THE LINES ABOVE -- 
-- IMPLEMENT writeExpression and evaluateAST FUNCTION ACCORDING TO GIVEN SIGNATURES -- 


helper :: AST -> Mapping -> Bool -> String
helper ast (x:xs) True = "let " ++ getVarName x ++ "=" ++ getVarValue x ++ helper ast xs False ++ " in " ++ writeExpression (ast, [])
helper ast (x:xs) False = ";" ++ getVarName x ++ "=" ++ getVarValue x ++ helper ast xs False
helper _ [] False = ""

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


evaluateAST _ = (EmptyAST, "")

getVarName (name, _, _) = name
getVarType (_, t, _) = t
getVarValue (_, _, val) = val

{-
writeExpression ((ASTNode "plus" (ASTNode "num" (ASTNode "333" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "667" EmptyAST EmptyAST) EmptyAST)), [])

writeExpression ((ASTNode "negate" ((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "C" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "Eng" EmptyAST EmptyAST) EmptyAST)) EmptyAST)) EmptyAST), [])
(ASTNode "negate" ((ASTNode "len" (ASTNode "cat" (ASTNode "str" (ASTNode "C" EmptyAST EmptyAST) EmptyAST) (ASTNode "str" (ASTNode "Eng" EmptyAST EmptyAST) EmptyAST)) EmptyAST)) EmptyAST)

writeExpression ((ASTNode "times" (ASTNode "plus" (ASTNode "num" (ASTNode "333" EmptyAST EmptyAST) EmptyAST) (ASTNode "num" (ASTNode "667" EmptyAST EmptyAST) EmptyAST)) (ASTNode "y" EmptyAST EmptyAST)), [("y", "num", "14")])

-}