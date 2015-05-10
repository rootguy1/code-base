positive :: [Int] -> Int 
positive  [] 	=0
positive  (x:xs)	
	| x > 0 =  1+ (positive xs)
	| otherwise = positive xs
 

