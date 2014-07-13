{-# OPTIONS_GHC -Wall                      #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing   #-}
{-# OPTIONS_GHC -fno-warn-type-defaults    #-}
{-# OPTIONS_GHC -fno-warn-unused-do-bind   #-}
{-# OPTIONS_GHC -fno-warn-missing-methods  #-}
{-# OPTIONS_GHC -fno-warn-orphans          #-}

module KalmanChart (
    diagPartFilter
  ) where

import Control.Lens hiding ( (#) )
import Graphics.Rendering.Chart
import Graphics.Rendering.Chart.Backend.Diagrams
import Diagrams.Backend.Cairo.CmdLine
import Diagrams.Prelude hiding ( render, Renderable )
import Data.Default.Class

import System.IO.Unsafe


denv :: DEnv
denv = unsafePerformIO $ defaultEnv vectorAlignmentFns 500 500

diagPartFilter :: [(Double, Double)] -> Int -> QDiagram Cairo R2 Any
diagPartFilter ls n =
  fst $ runBackend denv (render (chartPartFilter ls n) (500, 500))

chartPartFilter :: [(Double, Double)] -> Int -> Renderable ()
chartPartFilter lineVals n = toRenderable layout
  where

    fitted = plot_lines_values .~ [lineVals]
              $ plot_lines_style  . line_color .~ opaque blue
              $ plot_lines_title .~ "Trajectory"
              $ def

    layout = layout_title .~ "Gibbs Sampling Bivariate Normal (" ++ (show n) ++ " samples)"
           $ layout_y_axis . laxis_generate .~ scaledAxis def (-3,3)
           $ layout_x_axis . laxis_generate .~ scaledAxis def (0,100)

           $ layout_plots .~ [toPlot fitted]
           $ def
