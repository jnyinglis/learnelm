module Widgets exposing (sparkChart)

import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)

sparkChart : Int -> Int -> List Int -> Svg msg
sparkChart width height values =
    values
        |> sparklines
        |> renderSvg width height

sparklines : (List Int) -> List (Svg msg)
sparklines values = 
    let
        isPositive = ((<) 0)

        barLargestPositiveValue =
            values
                |> List.filter isPositive
                |> List.maximum
                |> Maybe.withDefault 0

        barY barHeight =
            case isPositive barHeight of
                True -> barLargestPositiveValue - barHeight
                False -> barLargestPositiveValue
        
        barWidth = 3
        barPadding = 2
    in
        List.length values
            |> List.range 0
            |> List.map (\n -> n * (barWidth + barPadding))
            |> List.map2 (,) values
            |> List.map (\(barHeight, barPosition) -> (sparklineBar (abs barHeight) (barY barHeight) barWidth barPosition))

sparklineBar : Int -> Int -> Int -> Int -> Svg msg
sparklineBar barHeight barY barWidth barPosition =
    g   [ transform (translateToString barPosition barY) ]
        [ rect [ height (toString barHeight), y (toString 0), width (toString barWidth) ] [ ] ]

translateToString : Int -> Int -> String
translateToString x y =
    "translate(" ++ (toString x) ++ "," ++ (toString y) ++ ")"

renderSvg : Int -> Int -> List (Svg msg) -> Html.Html msg
renderSvg svgWidth svgHeight values =
    svg
        [ width (toString svgWidth), height (toString svgHeight), viewBox "0 0 120 120" ]
        values
