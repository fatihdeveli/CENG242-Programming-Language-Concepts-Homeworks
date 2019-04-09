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


eagerEvaluation ast = eagerHelper ast []

--eagerHelper :: AST -> [(String, String)] -> ASTResult
eagerHelper (ASTNode (ASTLetDatum var) ast1 ast2) evaluatedVars
    | hasError (eagerHelper ast1 evaluatedVars) = eagerHelper ast1 evaluatedVars
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars

eagerHelper (ASTNode (ASTLetDatum var) ast1 ast2) evaluatedVars = ASTJust (result, typ, calcSteps) where
    result = if (getEagerBinding var evaluatedVars) == ""
        then getValue (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getValue (eagerHelper ast2 (replaceEagerBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))
    typ = if (getEagerBinding var evaluatedVars) == ""
        then getType (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getType (eagerHelper ast2 (replaceEagerBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))
    calcSteps = if (getEagerBinding var evaluatedVars) == ""
        then getSteps (eagerHelper ast1 evaluatedVars) + 
            getSteps (eagerHelper ast2 ((var, getValue (eagerHelper ast1 evaluatedVars)):evaluatedVars))
        else getSteps (eagerHelper ast1 evaluatedVars) + 
            getSteps (eagerHelper ast2 (replaceEagerBinding (var, (getValue (eagerHelper ast1 evaluatedVars))) evaluatedVars))

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
eagerHelper (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum op1) _ _) (ASTNode (ASTSimpleDatum op2) _ _)) _
    | op1 == "str" || op2 == "str" = ASTError ("plus operation is not defined between " ++ op1 ++ " and " ++ op2 ++ "!")
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
    | hasError (eagerHelper ast2 evaluatedVars) = eagerHelper ast2 evaluatedVars
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
        result = getEagerBinding var evaluatedVars
        typ = if isNumber result then "num" else "str"

hasError (ASTError _) = True -- Evaluation of an erroneous input returns ASTError
hasError (ASTJust _) = False -- A valid evaluation returns ASTJust

getValue (ASTJust (val, _, _)) = val -- Get the value from an ASTJust
getType (ASTJust (_, t, _)) = t -- Get the type from an ASTJust
getSteps (ASTJust (_, _, steps)) = steps -- Get the step number from an ASTJust

getEagerBinding :: String -> [(String, String)] -> String
getEagerBinding _ [] = ""
getEagerBinding varName (x:xs) = if fst x == varName then snd x else getEagerBinding varName xs

getNormalBinding :: String -> [(String, AST)] -> AST
getNormalBinding _ [] = EmptyAST
getNormalBinding varName (x:xs) = if fst x == varName then snd x else getNormalBinding varName xs

replaceEagerBinding :: (String, String) -> [(String, String)] -> [(String, String)]
replaceEagerBinding _ [] = []
replaceEagerBinding newBinding (x:xs) = if fst x == fst newBinding
                                   then newBinding:xs
                                   else x:(replaceEagerBinding newBinding xs)
replaceNormalBinding :: (String, AST) -> [(String, AST)] -> [(String, AST)]
replaceNormalBinding _ [] = []
replaceNormalBinding newBinding (x:xs) = if fst x == fst newBinding
                                   then newBinding:xs
                                   else x:(replaceNormalBinding newBinding xs)

isEmptyAST EmptyAST = True
isEmptyAST _ = False

---------- NORMAL EVALUATION ----------

normalEvaluation ast = normalHelper ast []

normalHelper :: AST -> [(String, AST)] -> ASTResult
normalHelper (ASTNode (ASTLetDatum var) ast1 ast2) unEvaluatedVars
    | hasError (normalHelper ast1 unEvaluatedVars) = normalHelper ast1 unEvaluatedVars
    | hasError (normalHelper ast2 unEvaluatedVars) = normalHelper ast2 unEvaluatedVars

normalHelper (ASTNode (ASTLetDatum var) ast1 ast2) unEvaluatedVars = ASTJust (result, typ, calcSteps) where
    result = if isEmptyAST (getNormalBinding var unEvaluatedVars) -- Variable was not defined before
        then getValue (normalHelper ast2 ((var, ast1):unEvaluatedVars))
        else getValue (normalHelper ast2 (replaceNormalBinding (var, ast1) unEvaluatedVars))
    typ = if isEmptyAST (getNormalBinding var unEvaluatedVars)
        then getType (normalHelper ast2 ((var, ast1):unEvaluatedVars))
        else getValue (normalHelper ast2 (replaceNormalBinding (var, ast1) unEvaluatedVars))
    calcSteps = if isEmptyAST (getNormalBinding var unEvaluatedVars)
        then getSteps (normalHelper ast2 ((var, ast1):unEvaluatedVars))
        else getSteps (normalHelper ast2 (replaceNormalBinding (var, ast1) unEvaluatedVars))

normalHelper (ASTNode (ASTSimpleDatum "num") (ASTNode (ASTSimpleDatum val) _ _) _) _ = 
    if isNumber val then (ASTJust (val, "num", 0)) else ASTError ("the value '" ++ val ++ "' is not a number!")
normalHelper (ASTNode (ASTSimpleDatum "str") (ASTNode (ASTSimpleDatum val) _ _) _) _ = ASTJust (val, "str", 0)

-- Erroneous cases with negate operation
normalHelper (ASTNode (ASTSimpleDatum "negate") ast _) unEvaluatedVars
    | hasError (normalHelper ast unEvaluatedVars) = normalHelper ast unEvaluatedVars
normalHelper (ASTNode (ASTSimpleDatum "negate") (ASTNode (ASTSimpleDatum "str") _ _) _) unEvaluatedVars
    = ASTError ("negate operation is not defined on str!")

normalHelper (ASTNode (ASTSimpleDatum "negate") ast _) unEvaluatedVars = ASTJust (result, "num", calcSteps) where
    result = "-" ++ getValue (normalHelper ast unEvaluatedVars)
    calcSteps = getSteps (normalHelper ast unEvaluatedVars) + 1

-- Erroneous cases with plus operation
normalHelper (ASTNode (ASTSimpleDatum "plus") ast1 ast2) unEvaluatedVars 
    | hasError (normalHelper ast1 unEvaluatedVars) = normalHelper ast1 unEvaluatedVars
    | hasError (normalHelper ast2 unEvaluatedVars) = normalHelper ast2 unEvaluatedVars
normalHelper (ASTNode (ASTSimpleDatum "plus") (ASTNode (ASTSimpleDatum op1) _ _) (ASTNode (ASTSimpleDatum op2) _ _)) _
    | op1 == "str" || op2 == "str" = ASTError ("plus operation is not defined between " ++ op1 ++ " and " ++ op2 ++ "!")
-- Valid plus operation
normalHelper (ASTNode (ASTSimpleDatum "plus") ast1 ast2) unEvaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (operand1 + operand2) where
        operand1 = read (getValue (normalHelper ast1 unEvaluatedVars))::Int
        operand2 = read (getValue (normalHelper ast2 unEvaluatedVars))::Int
    calcSteps = getSteps (normalHelper ast1 unEvaluatedVars) + getSteps (normalHelper ast2 unEvaluatedVars) + 1


-- Erroneous cases with times operation
normalHelper (ASTNode (ASTSimpleDatum "times") ast1 ast2) unEvaluatedVars
    | hasError (normalHelper ast1 unEvaluatedVars) = normalHelper ast1 unEvaluatedVars
    | hasError (normalHelper ast2 unEvaluatedVars) = normalHelper ast2 unEvaluatedVars
normalHelper (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum "str") _ _) (ASTNode (ASTSimpleDatum op) _ _)) _
    = ASTError ("times operation is not defined between str and " ++ op ++ "!")
normalHelper (ASTNode (ASTSimpleDatum "times") (ASTNode (ASTSimpleDatum op) _ _) (ASTNode (ASTSimpleDatum "str") _ _)) _
    = ASTError ("times operation is not defined between " ++ op ++ " and str!")
-- Valid times operation
normalHelper (ASTNode (ASTSimpleDatum "times") ast1 ast2) unEvaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (operand1 * operand2) where
        operand1 = read (getValue (normalHelper ast1 unEvaluatedVars))::Int
        operand2 = read (getValue (normalHelper ast2 unEvaluatedVars))::Int
    calcSteps = getSteps (normalHelper ast1 unEvaluatedVars) + getSteps (normalHelper ast2 unEvaluatedVars) + 1

-- Erroneous cases with cat operation
normalHelper (ASTNode (ASTSimpleDatum "cat") ast1 ast2) unEvaluatedVars
    | hasError (normalHelper ast1 unEvaluatedVars) = normalHelper ast1 unEvaluatedVars
    | hasError (normalHelper ast2 unEvaluatedVars) = normalHelper ast2 unEvaluatedVars
normalHelper (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum "num") _ _) (ASTNode (ASTSimpleDatum op) _ _)) _
    = ASTError ("cat operation is not defined between num and " ++ op ++ "!")
normalHelper (ASTNode (ASTSimpleDatum "cat") (ASTNode (ASTSimpleDatum op) _ _) (ASTNode (ASTSimpleDatum "num") _ _)) _
    = ASTError ("cat operation is not defined between " ++ op ++ " and num!")
-- Valid cat operation
normalHelper (ASTNode (ASTSimpleDatum "cat") ast1 ast2) unEvaluatedVars = ASTJust (result, "str", calcSteps) where
    result = operand1 ++ operand2 where
        operand1 = getValue (normalHelper ast1 unEvaluatedVars)
        operand2 = getValue (normalHelper ast2 unEvaluatedVars)
    calcSteps = getSteps (normalHelper ast1 unEvaluatedVars) + getSteps (normalHelper ast2 unEvaluatedVars) + 1

-- Erroneous cases with len operation
normalHelper (ASTNode (ASTSimpleDatum "len") ast _) unEvaluatedVars
    | hasError (normalHelper ast unEvaluatedVars) = normalHelper ast unEvaluatedVars
normalHelper (ASTNode (ASTSimpleDatum "len") (ASTNode (ASTSimpleDatum "num") _ _) _) _ 
    = ASTError "len operation is not defined on num!"
-- Valid len operation
normalHelper (ASTNode (ASTSimpleDatum "len") ast _) unEvaluatedVars = ASTJust (result, "num", calcSteps) where
    result = show (length (getValue (normalHelper ast unEvaluatedVars)))
    calcSteps = getSteps (normalHelper ast unEvaluatedVars) + 1

normalHelper (ASTNode (ASTSimpleDatum var) EmptyAST EmptyAST) unEvaluatedVars
    = ASTJust (result, typ, calcSteps) where
        result = getValue (normalHelper (getNormalBinding var unEvaluatedVars) unEvaluatedVars)
        typ = if isNumber result then "num" else "str"
        calcSteps = getSteps (normalHelper (getNormalBinding var unEvaluatedVars) unEvaluatedVars)
