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
    , twitterHandle : String
    , bio : String
    }


all : List Author
all =
    [ { name = "Olavi Haapala"
      , avatar = Pages.images.author.olavi
      , twitterHandle = "0lpeh"
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
    div [ Attr.class "flex bg-tertiary p-4 border-b border-primary" ]
        [ img author.name
            [ Attr.src (ImagePath.toString author.avatar), Attr.width 70, Attr.class "rounded-full layered-box-shadow" ]
        , div [ Attr.class "flex flex-col justify-center ml-4" ]
            [ h2 [ Attr.class "text-xl font-bold" ]
                [ text author.name
                , text " | "
                , a [ Attr.class "underline", Attr.href ("https://twitter.com/" ++ author.twitterHandle), Attr.target "_blank" ]
                    [ text ("@" ++ author.twitterHandle)
                    ]
                ]
            , p [ Attr.class "" ]
                [ Html.text author.bio ]
            ]
        ]
