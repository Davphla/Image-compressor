module Parse
    ( parseFile
    ) where

import Lib

readPoint :: String -> Point
readPoint = read

readColor :: String -> Color
readColor = read

readData :: [String] -> Pixel
readData [a,b] = (readPoint a, readColor b)

parseFile :: String -> IO [Pixel]
parseFile filepath = do
    contents <- readFile filepath
    return $readData <$> (words <$> lines contents)
