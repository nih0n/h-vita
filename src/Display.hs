module Display where

import Data.Matrix
import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Simulate
import GameOfLife
import Types

createGrid :: Int -> Int -> [Location] -> Matrix Cell
createGrid rows cols positions = matrix rows cols getCellState
    where
        centerRow = (rows + 1) `div` 2
        centerCol = (cols + 1) `div` 2

        index :: Int -> Int -> Location
        index x y = (centerRow - x, y - centerCol)

        getCellState :: Location -> Cell
        getCellState (x, y)
            | index x y `elem` positions = alive
            | otherwise = dead

render :: DisplayCellSize -> Grid -> Picture
render (width, height) grid = Pictures $ toList $ mapPos cellToRect grid
    where 
        xAxis column width = (fromIntegral column) * width + borderSize * (fromIntegral column)
        yAxis row height = (* (-1)) $ (fromIntegral row) * height + borderSize * (fromIntegral row)
        borderSize = 2
        cellToRect (row, column) cell
            | cell == dead = Blank
            | otherwise    = Translate (xAxis column width) (yAxis row height)
                             $ rectangleSolid width height 

advanceGame :: ViewPort -> Float -> Grid -> Grid
advanceGame _ _ = advanceGridGeneration

playGame :: Grid -> IO ()
playGame game
    = simulate 
        (InWindow "h-vita" (800, 600) (10, 10)) -- Setting up window for the game
        white                                   -- Background color of the board
        2                                       -- Number of steps per second
        game                                    -- Initial state of the game
        (render (10.0, 10.0))                   -- Function to convert grid to a Picture
        advanceGame                             -- Function to advance generation of the grid
