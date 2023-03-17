module Lib
    ( distance,
    listToTriple,
    loop,
    printFinalColors,
    createFinalList,
    Color,
    Point,
    Pixel
    ) where

import Data.List
import Data.Traversable
import Data.Maybe

type Color = (Int, Int, Int)
type Point = (Int, Int)
type Pixel = (Point, Color)

distance :: Floating a => (Int, Int, Int) -> (Int, Int, Int) -> a
distance (a,b,c) (d,e,f) = sqrt . fromIntegral
    $(a - d) ^ 2 + (b - e) ^ 2 + (c - f) ^ 2

listToTriple :: [Int] -> Color
listToTriple (a:b:c:_) = (a,b,c)

averageInt :: (Integral a) => [a] -> Int
averageInt xs = round $fromIntegral (sum xs) / fromIntegral (length xs)

mapTriple :: (a -> b) -> (a, a, a) -> (b, b, b)
mapTriple f (a1, a2, a3) = (f a1, f a2, f a3)

getArray :: Floating a => [Color] -> Color -> [a]
getArray xs b = map (`distance` b) xs

getAverage :: [Color] -> Color
getAverage list = mapTriple averageInt (unzip3 list)

getCentroidIndex :: [Color] -> Color -> Maybe Int
getCentroidIndex centroid point = elemIndex (minimum a) a
    where a = getArray centroid point

insertAt :: a -> Maybe Int -> [[a]] -> [[a]]
insertAt newElement _ [] = []
insertAt _ Nothing _ = []
insertAt newElement (Just 0) (a:as) = (newElement:a) : as
insertAt newElement (Just i) (a:as) = a : insertAt newElement (Just (i - 1)) as

createList :: [Color] -> [Color] -> [[Color]] -> [[Color]]
createList centroid [] list = list
createList centroid (c:cs) list = createList centroid cs
    (insertAt c (getCentroidIndex centroid c) list)

createFinalList :: [Color] -> [Pixel] -> [[Pixel]] -> [[Pixel]]
createFinalList centroid [] list = list
createFinalList centroid (c:cs) list = createFinalList centroid cs
    (insertAt c (getCentroidIndex centroid $ snd c) list)

recenterCentroids :: [[Color]] -> [Color]
recenterCentroids = fmap getAverage

printFinalColors :: [Color] -> Color -> IO ()
printFinalColors centroids color = print $centroids!!fromJust
    (getCentroidIndex centroids color)

recalculateCentroids :: [Color] -> [Color] -> [Color]
recalculateCentroids centroids colors = recenterCentroids
    $createList centroids colors $(: []) <$> centroids

loop :: [Color] -> [Color] -> [[Color]]
loop centroids colors = list : loop list colors
    where list = recalculateCentroids centroids colors
