module Hw2 where

data ASTResult = ASTError String | ASTJust (String, String, Int) deriving (Show, Read)
data ASTDatum = ASTSimpleDatum String | ASTLetDatum String deriving (Show, Read)
data AST = EmptyAST | ASTNode ASTDatum AST AST deriving (Show, Read)

isNumber :: String -> Bool
eagerEvaluation :: AST -> ASTResult
normalEvaluation :: AST -> ASTResult
-- DO NOT MODIFY OR DELETE THE LINES ABOVE -- 
-- IMPLEMENT isNumber, eagerEvaluation and normalEvaluation FUNCTIONS ACCORDING TO GIVEN SIGNATURES -- 


isNumber [] = False
isNumber (x:xs) = if x == '-' && xs /= [] then isNumberHelper xs else isNumberHelper (x:xs)
isNumberHelper [] = True
isNumberHelper (x:xs) = elem x ['0'..'9'] && isNumberHelper xs

normalEvaluation _ = ASTError "dummy"

eagerEvaluation ast = eagerHelper ast []


eagerHelper :: AST -> [(String, String)] -> ASTResult

eagerHelper (ASTNode (ASTLetDatum var) ast1 ast2) evaluatedVars
    | hasError (eagerHelper ast1 evaluatedVars) = eagerHelper ast1 evaluatedVars
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars

eagerHelper (ASTNode (ASTLetDatum var) ast1 ast2) evaluatedVars = ASTJust (result, typ, calcSteps) where
    result = if (getBinding var evaluatedVars) == ""
        then getValue (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getValue (eagerHelper ast2 (replaceBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))
    typ = if (getBinding var evaluatedVars) == ""
        then getType (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getType (eagerHelper ast2 (replaceBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))
    calcSteps = if (getBinding var evaluatedVars) == ""
        then getSteps (eagerHelper ast1 evaluatedVars) + 
            getSteps (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getSteps (eagerHelper ast1 evaluatedVars) + 
            getSteps (eagerHelper ast2 (replaceBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))

eagerHelper (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum val) _ _) _) _ = 
    if isNumber val then (ASTJust (val, "num", 0)) else ASTError ("the value '" ++ val ++ "' is not a number!")
eagerHelper (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum val) _ _) _) _ = ASTJust (val, "str", 0)

-- Erroneous cases with negate operation
eagerHelper (ASTNode (ASTSimpleDatum "negate") ast _) evaluatedVars
    | hasError (eagerHelper ast evaluatedVars) = eagerHelper ast evaluatedVars
eagerHelper (ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "str") _ _) _) evaluatedVars
    = ASTError ("negate operation is not defined on str!")


eagerHelper (ASTNode (ASTSimpleDatum "negate") ast _) evaluatedVars = ASTJust (result, "num", calcSteps) where
    result = "-" ++ getValue (eagerHelper ast evaluatedVars)
    calcSteps = getSteps (eagerHelper ast evaluatedVars) + 1

-- Erroneous cases with plus operation
eagerHelper (ASTNode (ASTSimpleDatum "plus") ast1 ast2) evaluatedVars
    | hasError (eagerHelper ast1 evaluatedVars) = eagerHelper ast1 evaluatedVars
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars
{-    | op1 == "str" || op2 == "str" = ASTError ("plus operation is not defined between " ++ op1 ++ " and " ++ op2 ++ "!")
    | otherwise = ASTJust (result, "num", calcSteps) where
        result = show (operand1 + operand2) where
            operand1 = read (getValue (eagerHelper ast1 evaluatedVars))::Int
            operand2 = read (getValue (eagerHelper ast2 evaluatedVars))::Int
        calcSteps = getSteps (eagerHelper ast1 evaluatedVars) + getSteps (eagerHelper ast2 evaluatedVars) + 1
-}

eagerHelper (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "str") _ _) (ASTNode (ASTSimpleDatum op) _ _)) _
    = ASTError ("plus operation is not defined between str and " ++ op ++ "!")
eagerHelper (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum op) _ _) (ASTNode (ASTSimpleDatum "str") _ _)) _
    = ASTError ("plus operation is not defined between " ++ op ++ " and str!")


-- Valid plus operation
eagerHelper (ASTNode (ASTSimpleDatum "plus") ast1 ast2) evaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (operand1 + operand2) where
        operand1 = read (getValue (eagerHelper ast1 evaluatedVars))::Int
        operand2 = read (getValue (eagerHelper ast2 evaluatedVars))::Int
    calcSteps = getSteps (eagerHelper ast1 evaluatedVars) + getSteps (eagerHelper ast2 evaluatedVars) + 1



-- Erroneous cases with times operation
eagerHelper (ASTNode (ASTSimpleDatum "times") ast1 ast2) evaluatedVars
    | hasError (eagerHelper ast1 evaluatedVars) = eagerHelper ast1 evaluatedVars
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars

eagerHelper (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "str") _ _) (ASTNode (ASTSimpleDatum op) _ _)) _
    = ASTError ("times operation is not defined between str and " ++ op ++ "!")
eagerHelper (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum op) _ _) (ASTNode (ASTSimpleDatum "str") _ _)) _
    = ASTError ("times operation is not defined between " ++ op ++ " and str!")


-- Valid times operation
eagerHelper (ASTNode (ASTSimpleDatum "times") ast1 ast2) evaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (operand1 * operand2) where
        operand1 = read (getValue (eagerHelper ast1 evaluatedVars))::Int
        operand2 = read (getValue (eagerHelper ast2 evaluatedVars))::Int
    calcSteps = getSteps (eagerHelper ast1 evaluatedVars) + getSteps (eagerHelper ast2 evaluatedVars) + 1

-- Erroneous cases with cat operation
eagerHelper (ASTNode (ASTSimpleDatum "cat") ast1 ast2) evaluatedVars
    | hasError (eagerHelper ast1 evaluatedVars) = eagerHelper ast1 evaluatedVars
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars -- If there are no errors, keep on with the computation
eagerHelper (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum "num") _ _) (ASTNode (ASTSimpleDatum op) _ _)) _
    = ASTError ("cat operation is not defined between num and " ++ op ++ "!")
eagerHelper (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum op) _ _) (ASTNode (ASTSimpleDatum "num") _ _)) _
    = ASTError ("cat operation is not defined between " ++ op ++ " and num!")


-- Valid cat operation
eagerHelper (ASTNode (ASTSimpleDatum "cat") ast1 ast2) evaluatedVars = ASTJust (result, "str", calcSteps) where
    result = operand1 ++ operand2 where
        operand1 = getValue (eagerHelper ast1 evaluatedVars)
        operand2 = getValue (eagerHelper ast2 evaluatedVars)
    calcSteps = getSteps (eagerHelper ast1 evaluatedVars) + getSteps (eagerHelper ast2 evaluatedVars) + 1

-- Erroneous cases with len operation
eagerHelper (ASTNode (ASTSimpleDatum "len") ast _) evaluatedVars
    | hasError (eagerHelper ast evaluatedVars) = eagerHelper ast evaluatedVars
eagerHelper (ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "num") _ _) _) _ 
    = ASTError "len operation is not defined on num!"


-- Valid len operation
eagerHelper (ASTNode (ASTSimpleDatum "len") ast _) evaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (length (getValue (eagerHelper ast evaluatedVars)))
    calcSteps = getSteps (eagerHelper ast evaluatedVars) + 1

eagerHelper (ASTNode (ASTSimpleDatum var) EmptyAST EmptyAST) evaluatedVars
    = ASTJust (result, typ, 0) where
        result = getBinding var evaluatedVars
        typ = if isNumber result then "num" else "str"

hasError (ASTError _) = True -- Evaluation of an erroneous input returns ASTError
hasError (ASTJust _) = False -- A valid evaluation returns ASTJust

getValue (ASTJust (val, _, _)) = val -- Get the value from an ASTJust
getType (ASTJust (_, t, _)) = t -- Get the type from an ASTJust
getSteps (ASTJust (_, _, steps)) = steps -- Get the step number from an ASTJust

getBinding :: String -> [(String, String)] -> String
getBinding _ [] = ""
getBinding varName (x:xs) = if fst x == varName then snd x else getBinding varName xs

replaceBinding :: (String, String) -> [(String, String)] -> [(String, String)]
replaceBinding _ [] = []
replaceBinding newBinding (x:xs) = if fst x == fst newBinding
                                   then newBinding:xs
                                   else x:(replaceBinding newBinding xs)

{-
-- TEST CASES --

*Hw2> eagerEvaluation 

(ASTNode 
    (ASTSimpleDatum "plus") 
    (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "abc") EmptyAST EmptyAST) EmptyAST) 
    (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "123") EmptyAST EmptyAST) EmptyAST))

ASTError "the value 'abc' is not a number!"




eagerEvaluation (ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "5") EmptyAST EmptyAST) EmptyAST)) (ASTNode (ASTLetDatum "x") (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "7") EmptyAST EmptyAST) EmptyAST) (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) (ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST))))

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
ASTJust ("14","num",2)



(ASTNode 
	(ASTLetDatum "x") 
	(ASTNode 
		(ASTSimpleDatum "plus") 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST) 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST)
	)
	(ASTNode (ASTLetDatum "x") 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST) 
		(ASTNode (ASTSimpleDatum "plus") 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST)
		)
	)
)
ASTJust ("8","num",2)

(ASTNode (ASTLetDatum "x") 
	(ASTNode (ASTSimpleDatum "plus")
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST) 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "3") EmptyAST EmptyAST) EmptyAST)) 
	(ASTNode (ASTLetDatum "x") 
		(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "4") EmptyAST EmptyAST) EmptyAST) 
		(ASTNode (ASTSimpleDatum "plus") 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST))))
ASTJust ("8","num",1)


(ASTNode (ASTLetDatum "x") 
	((ASTNode (ASTSimpleDatum "negate")
		(ASTNode (ASTSimpleDatum "times")
			(ASTNode (ASTSimpleDatum "plus")
				(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "1") EmptyAST EmptyAST) EmptyAST)
				(ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum "2") EmptyAST EmptyAST) EmptyAST)) 
			(ASTNode (ASTSimpleDatum "len") 
				(ASTNode (ASTSimpleDatum "cat") 
					(ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "CE") EmptyAST EmptyAST) EmptyAST) 
					(ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum "NG") EmptyAST EmptyAST) EmptyAST)) EmptyAST)) EmptyAST)) 
	(ASTNode (ASTSimpleDatum "times") 
		(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) 
		(ASTNode (ASTSimpleDatum "plus") 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST) 
			(ASTNode (ASTSimpleDatum "x") EmptyAST EmptyAST))))
ASTJust ("288","num",17)

-}