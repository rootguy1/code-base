posn  ::  Eq a => a -> [a] -> Maybe Int
posn r xs 
    | null xs   = Nothing
    | otherwise        = helper r zs 
      where 
        zs = zip [0..] xs 
        helper r ((i,c):zs) 
            | c == r    = Just i
            | null zs   = Nothing
            | otherwise = helper r zs 
