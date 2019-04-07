module Hw2 where

data ASTResult = ASTError String | ASTJust (String, String, Int) deriving (Show, Read)
data ASTDatum = ASTSimpleDatum String | ASTLetDatum String deriving (Show, Read)
data AST = EmptyAST | ASTNode ASTDatum AST AST deriving (Show, Read)

isNumber :: String -> Bool
--eagerEvaluation :: AST -> ASTResult
--normalEvaluation :: AST -> ASTResult
-- DO NOT MODIFY OR DELETE THE LINES ABOVE -- 
-- IMPLEMENT isNumber, eagerEvaluation and normalEvaluation FUNCTIONS ACCORDING TO GIVEN SIGNATURES -- 

isNumber [] = False
isNumber (x:xs) = if x == '-' && xs /= [] then isNumberHelper xs else isNumberHelper (x:xs)
isNumberHelper [] = True
isNumberHelper (x:xs) = elem x ['0'..'9'] && isNumberHelper xs

--eagerEvaluation (ASTNode (ASTLetDatum var) varExp realExp) = 

-- TODO: create eagerevaluation helper function
-- give the evaluated variable(s) in a list to helper function


evaluate (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum val) _ _) _) = val
evaluate (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum val) _ _) _) = val
evaluate (ASTNode (ASTSimpleDatum "negate") ast _) = "-" ++ evaluate ast 
evaluate (ASTNode (ASTSimpleDatum "plus") ast1 ast2) = show ((read (evaluate ast1)::Int) + (read (evaluate ast2)::Int))
evaluate (ASTNode (ASTSimpleDatum "times") ast1 ast2) = show ((read (evaluate ast1)::Int) * (read (evaluate ast2)::Int))
evaluate (ASTNode (ASTSimpleDatum "cat") ast1 ast2) = (evaluate ast1) ++ (evaluate ast2)
evaluate (ASTNode (ASTSimpleDatum "len") ast _) = show (length (evaluate ast))




{-
(ASTNode 
	(ASTLetDatum "x") 
	(ASTNode 
		(ASTSimpleDatum "plus") 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST) 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "5") EmptyAST EmptyAST) EmptyAST)
	)
    (ASTNode 
    	(ASTLetDatum "x") 
    	(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "7") EmptyAST EmptyAST) EmptyAST)
        (ASTNode 
        	(ASTSimpleDatum "plus") 
        	(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)
        	(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)
        )
    )
)
-}