module Index exposing (view)

import Accessibility as Html exposing (..)
import Data.Author
import Date
import Html.Attributes as Attr exposing (class, href)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)


view :
    List ( PagePath Pages.PathKey, Metadata )
    -> Html msg
view posts =
    div [ Attr.class "flex flex-col" ]
        (posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        Metadata.Page meta ->
                            Nothing

                        Metadata.Author _ ->
                            Nothing

                        Metadata.Article meta ->
                            if meta.draft then
                                Nothing

                            else
                                Just ( path, meta )

                        Metadata.BlogIndex ->
                            Nothing
                )
            |> List.sortBy
                (\( _, metadata ) ->
                    metadata.published
                        |> Date.toRataDie
                )
            |> List.reverse
            |> List.map postSummary
        )


postSummary :
    ( PagePath Pages.PathKey, Metadata.ArticleMetadata )
    -> Html msg
postSummary ( postPath, post ) =
    articleIndex post
        |> linkToPost postPath


linkToPost : PagePath Pages.PathKey -> Html msg -> Html msg
linkToPost postPath content =
    a [ Attr.href (PagePath.toString postPath) ]
        [ content
        ]


title : String -> Html msg
title str =
    h2 [ Attr.class "text-3xl font-bold mb-8" ] [ text str ]


articleIndex : Metadata.ArticleMetadata -> Html msg
articleIndex metadata =
    article
        [ class "bg-secondary mb-8 layered-box-shadow" ]
        [ postPreview metadata ]


readMoreLink =
    text "Continue reading >>"


postPreview : Metadata.ArticleMetadata -> Html msg
postPreview post =
    div
        [ class "p-8" ]
        [ title post.title
        , div [ class "mb-8" ]
            [ div [ class "text-xl" ] [ text post.description ]
            , Html.hr [ class "my-4" ] []
            , text (post.published |> Date.format "MMMM ddd, yyyy")
            , text " by "
            , text post.author.name
            ]
        , readMoreLink
        ]
