import Data.Char
cap = unwords . map capitalizeWord . words
  where capitalizeWord [] = []
        capitalizeWord (c:cs) = toUpper c : map toLower cs