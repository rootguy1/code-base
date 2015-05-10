pick  ::  Int -> [a] -> Maybe a
pick n xs 
    | null xs || n < 0 = Nothing
    | otherwise        = helper n zs 
      where 
        zs = zip [0..] xs 
        helper n ((i,c):zs) 
            | i == n    = Just c
            | null zs   = Nothing
            | otherwise = helper n zs 