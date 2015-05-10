unique :: (Eq a) => [a] -> Bool
unique [] = False
unique (x:xs) 
  | x== head(xs) = False
  | otherwise =  unique xs