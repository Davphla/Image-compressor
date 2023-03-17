module Main where


import Data.Semigroup ((<>))
import Options.Applicative
import System.Random
import Lib
import Data.List
import Parse
import Control.Concurrent
import System.Exit
import Options.Applicative
import System.Environment (getArgs, getProgName)
import System.IO (hPutStr, stderr)
import Control.Exception

tryMain  :: IO Sample
tryMain = execParser opts `catch` handler where
    opts = info (sample <**> helper)
      ( fullDesc
     <> progDesc "K-Means algorithm"
     <> header "USAGE:" )
    handler :: SomeException -> IO Sample
    handler _ = exitWith (ExitFailure 84)

tryTest :: Sample -> IO ()
tryTest a = test a `catch` handler where
    handler :: SomeException -> IO ()
    handler _ = exitWith (ExitFailure 84)

main :: IO ()
main = tryTest =<< tryMain

test :: Sample -> IO ()
test (Sample n f fp) = do
    g <- getStdGen
    parsedValue <- parseFile fp
    let centroids = getFinalCentroids f
          (loop (generateCentroids n $ generateInfinite g)
          $ map snd parsedValue) (map snd parsedValue)
    let finalList = createFinalList centroids parsedValue
          $replicate (length centroids) []
    printImage centroids finalList


showColor :: Pixel -> String
showColor (coord, color) = show coord ++ " " ++ show color ++ "\n"

showColorList :: [Pixel] -> String
showColorList = (foldl' (++) "") . (map showColor)

printImage :: [Color] -> [[Pixel]] -> IO()
printImage [] _ = return ()
printImage (c:cs) (px:pxs) = putStrLn "--" >> print c >>
  putStrLn "-" >> putStr (showColorList px) >> printImage cs pxs

getFinalCentroids :: Float -> [[Color]] -> [Color] -> [Color]
getFinalCentroids convergence (a:b:c) color | checkMovement convergence a b = a
                                             | otherwise = getFinalCentroids
                                             convergence (b:c) color

finalLoop :: Float -> [[Color]] -> [Color] -> [IO()]
finalLoop convergence centroids colors = printFinalColors centroids'
  <$> colors where centroids' = getFinalCentroids convergence centroids colors

generateInfinite :: StdGen -> [Int]
generateInfinite = randomRs (0 :: Int, 255)

generateTriple :: [Int] -> Color
generateTriple l = listToTriple $ take 3 l

generateCentroids :: Int -> [Int] -> [Color]
generateCentroids i list | i > 0 = generateTriple
  list : generateCentroids (i-1) (drop 3 list)
                         | otherwise = []

checkMovement :: Float -> [Color] -> [Color] -> Bool
checkMovement max a b = all (<= max) (zipWith distance a b)

data Sample = Sample
  { columnNumber      :: Int
  , convergenceLimit      :: Float
  , filepath :: String }

sample :: Parser Sample
sample = Sample
      <$> option auto ( short 'n'
         <> metavar "N"
         <> help "number of Color in the final image" )
      <*> option auto (short 'l'
          <> metavar "L"
         <> help "convergence limit" )
      <*> strOption ( short 'f'
          <> metavar "F"
         <> help "path to the file containing the Color of the pixels")
