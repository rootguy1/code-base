isMono :: [Int] -> Bool
isMono = isMonoBy (<=)

isMonoBy :: (Int -> Int -> Bool) -> [Int] -> Bool
isMonoBy lte = loop
  where
    loop []       = True
    loop [_]      = True
    loop (x:y:zs) = (x `lte` y) && loop (y:zs)
