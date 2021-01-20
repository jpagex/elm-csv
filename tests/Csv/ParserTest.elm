module Csv.ParserTest exposing (..)

import Csv.Parser as Parser exposing (parse)
import Expect
import Test exposing (..)


parseTest : Test
parseTest =
    describe "parse"
        [ test "a single value" <|
            \_ ->
                parse "a"
                    |> Expect.equal (Ok [ [ "a" ] ])
        ]