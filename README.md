# elm-csv

Decode CSV in the most boring way possible.
Other CSV libraries have exciting, innovative APIs... not this one!
Pretend you're writing a [JSON decoder](https://package.elm-lang.org/packages/elm/json/latest/), gimme your data, get on with your life.

```elm
import Csv.Decode as Decode exposing (Decoder)


decoder : Decoder ( Int, Int, Int )
decoder =
    Decode.map3 (\r g b -> ( r, g, b ))
        (Decode.column 0 Decode.int)
        (Decode.column 1 Decode.int)
        (Decode.column 2 Decode.int)


csv : String
csv =
    "0,128,128\r\n112,128,144"


Decode.decodeCsv Decode.NoFieldNames decoder csv
--> Ok
-->     [ ( 0, 128, 128 )
-->     , ( 112, 128, 144 )
-->     ]
```

However, in an effort to avoid a common problem with `elm/json` ("How do I decode a record with more than 8 fields?") this library also exposes a pipeline-style decoder ([inspired by `NoRedInk/elm-json-decode-pipeline`](https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest/)) for records:

```elm
import Csv.Decode as Decode exposing (Decoder)


type alias Pet =
    { id : Int
    , name : String
    , species : String
    , weight : Maybe Float
    }


decoder : Decoder Pet
decoder =
    Decode.into Pet
        |> Decode.pipeline (Decode.field "id" Decode.int)
        |> Decode.pipeline (Decode.field "name" Decode.string)
        |> Decode.pipeline (Decode.field "species" Decode.string)
        |> Decode.pipeline (Decode.field "weight" (Decode.blank Decode.float))


csv : String
csv =
    "id,name,species,weight\r\n1,Atlas,cat,14.5\r\n2,Pippi,dog,"


Decode.decodeCsv Decode.FieldNamesFromFirstRow decoder csv
--> Ok
-->     [ { id = 1, name = "Atlas", species = "cat", weight = Just 14.5 }
-->     , { id = 2, name = "Pippi", species = "dog", weight = Nothing }
-->     ]
```

## FAQ

### Can this do TSVs too? What about European-style CSVs that use semicolon instead of comma?

Yes to both!
Use `decodeCustom`.
It takes a field and row separator string, which can be whatever you need.

### Aren't there like (*checks*) 8 other CSV libraries already?

Yes, there are!
While I appreciate the hard work that other people have put into those, there are a couple problems:

First, you need to put together multiple libraries to successfully parse CSV.
Before this package was published, you had to pick one package for parsing to `List (List String)` and another to decode from that into something you actually cared about.
Props to those authors for making their hard work available, of course, but this situation bugs me!

I don't want to have to pick different libraries for parsing and converting.
I just want it to work like `elm/json` where I write a decoder, give the package a string, and handle a `Result`.
This should not require so much thought!

The second thing, and the one that prompted me to publish this package, is that none of the libraries available at the time implemented `andThen`.
Sure, you can use a `Result` to do whatever you like, but there's not a good way to make a decoding decision for one field dependent on another.

## Contributing

This project uses [Nix](https://nixos.org/download.html) to manage versions (but just need a `nix` installation, not NixOS, so this will work on macOS.)
Install that, then run `nix-shell` to get into a development environment.

Things I'd appreciate help with:

- **Testing the parser on many kinds of CSV and TSV data.**
  If you find that some software produces something that this library can't handle, please open an issue with a sample!

- **Feedback on speed.**
  If you find that this library has become a bottleneck in your application, please open an issue.

- **Feedback on decoders for things you find necessary** (but please open an issue and talk through it instead of jumping straight to a PR!)
  Some things I've thought of: `parse : Parser.Parser a -> Decoder a` and `json : Json.Decode.Decoder a -> Decoder a`.
  The reason they're not in the library now is because a) `fromResult` exists to make those easier and b) I don't want to add new package-level dependencies without a good reason.
  If you find yourself writing things like this constantly, though, let's talk about them!

- **Docs.**
  Always docs.
  Forever docs.

## Climate Action

I want my open-source work to support projects addressing the climate crisis (for example, projects in clean energy, public transit, reforestation, or sustainable agriculture.)
If you are working on such a project, and find a bug or missing feature in any of my libraries, **please let me know and I will treat your issue as high priority.**
I'd also be happy to support such projects in other ways.
In particular, I've worked with Elm for a long time and would be happy to advise on your implementation.

## License

`elm-csv` is licensed under the BSD 3-Clause license, located at `LICENSE`.
