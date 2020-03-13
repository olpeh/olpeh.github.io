module Data.Author exposing (Author, all, decoder, view)

import Accessibility as Html exposing (..)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (Decoder)
import List.Extra
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)


type alias Author =
    { name : String
    , avatar : ImagePath Pages.PathKey
    , bio : String
    }


all : List Author
all =
    [ { name = "Olavi Haapala"
      , avatar = Pages.images.author.olavi
      , bio = "Web software developer with a passion for web performance and accessibility."
      }
    ]


decoder : Decoder Author
decoder =
    Decode.string
        |> Decode.andThen
            (\lookupName ->
                case List.Extra.find (\currentAuthor -> currentAuthor.name == lookupName) all of
                    Just author ->
                        Decode.succeed author

                    Nothing ->
                        Decode.fail ("Couldn't find author with name " ++ lookupName ++ ". Options are " ++ String.join ", " (List.map .name all))
            )


view : Author -> Html msg
view author =
    img author.name
        [ Attr.src (ImagePath.toString author.avatar), Attr.width 70, Attr.class "avatar" ]
