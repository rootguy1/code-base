find   :: (a -> Bool) -> [a] -> Maybe Int
find _ [] = 0

find p (x:xs)
	| p x = helper p zs
	| otherwise = Nothing
	where
	zs = zip [0..] xs 
	helper p ((i,c):zs) 
	| p c  = Just i 
	| null zs   = Nothing
	| otherwise = helper p zs 
