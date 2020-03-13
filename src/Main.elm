module Main exposing (main)

import Accessibility as Html exposing (..)
import Color
import Data.Author as Author
import Date
import Feed
import Head
import Head.Seo as Seo
import Html.Attributes exposing (class, href, src, style)
import Index
import Markdown
import Metadata exposing (Metadata)
import MySitemap
import Pages exposing (images, pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.StaticHttp as StaticHttp


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "elm-pages-starter - A statically typed site generator."
    , iarcRatingId = Nothing
    , name = "elm-pages-starter"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "elm-pages-starter"
    , sourceIcon = images.iconPng
    }


type alias Rendered =
    Html Msg



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> ()
        , generateFiles = generateFiles
        , internals = Pages.internals
        }


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        List
            (Result String
                { path : List String
                , content : String
                }
            )
generateFiles siteMetadata =
    [ Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    , MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    ]


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                div [] [ Markdown.toHtml [] markdownBody ]
                    |> Ok
        }


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.succeed
        { view =
            \model viewForPage ->
                let
                    { title, body } =
                        pageView model siteMetadata page viewForPage
                in
                { title = title
                , body =
                    body
                }
        , head = head page.frontmatter
        }


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Html Msg }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                div []
                    [ headerView page.path
                    , main_ []
                        [ viewForPage
                        ]
                    , footerView
                    ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body =
                div []
                    [ headerView page.path
                    , main_ []
                        [ div []
                            [ Author.view metadata.author
                            , text metadata.author.name
                            , p []
                                [ Html.text metadata.author.bio ]
                            ]
                        , publishedDateView metadata
                        , text metadata.title
                        , articleImageView metadata.image metadata.altText
                        , imageCreditsView metadata.credits
                        , viewForPage
                        ]
                    , footerView
                    ]
            }

        Metadata.Author author ->
            { title = author.name
            , body =
                div
                    []
                    [ headerView page.path
                    , main_
                        []
                        [ text author.name
                        , Author.view author
                        , div [] [ viewForPage ]
                        ]
                    , footerView
                    ]
            }

        Metadata.BlogIndex ->
            { title = "olavihaapala.fi – a personal blog"
            , body =
                div
                    []
                    [ headerView page.path
                    , Index.view siteMetadata
                    , footerView
                    ]
            }


articleImageView : ImagePath Pages.PathKey -> String -> Html msg
articleImageView articleImage altText =
    img altText [ src (ImagePath.toString articleImage) ]


imageCreditsView : Maybe String -> Html msg
imageCreditsView credits =
    case credits of
        Just str ->
            Html.text str

        Nothing ->
            Html.text ""


headerView : PagePath Pages.PathKey -> Html msg
headerView currentPath =
    main_ []
        [ a
            [ class "mb-16"
            , href "/"
            ]
            [ text (String.toUpper "Home") ]
        , highlightableLink currentPath pages.blog.directory "Blog"
        , highlightableLink currentPath pages.contact.directory "Contact"
        , highlightableLink currentPath pages.projects.directory "Projects"
        ]


highlightableLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Html msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            currentPath |> Directory.includes linkDirectory
    in
    a
        [ class "mb-16"
        , href
            (linkDirectory
                |> Directory.indexPath
                |> PagePath.toString
            )
        ]
        [ text (String.toUpper displayName) ]


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Page meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Article meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages starter"
                        , image =
                            { url = meta.image
                            , alt = meta.description
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.description
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Metadata.Author meta ->
                    let
                        ( firstName, lastName ) =
                            case meta.name |> String.split " " of
                                [ first, last ] ->
                                    ( first, last )

                                [ first, middle, last ] ->
                                    ( first ++ " " ++ middle, last )

                                [] ->
                                    ( "", "" )

                                _ ->
                                    ( meta.name, "" )
                    in
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = meta.avatar
                            , alt = meta.name ++ "'s elm-pages articles."
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.bio
                        , locale = Nothing
                        , title = meta.name ++ "'s elm-pages articles."
                        }
                        |> Seo.profile
                            { firstName = firstName
                            , lastName = lastName
                            , username = Nothing
                            }

                Metadata.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "elm-pages blog"
                        }
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-pages-starter.netlify.com"


siteTagline : String
siteTagline =
    "Starter blog for elm-pages"


publishedDateView metadata =
    Html.text
        (metadata.published
            |> Date.format "MMMM ddd, yyyy"
        )


footerView : Html msg
footerView =
    footer
        []
        [ footerLink "/blog/feed.xml" "RSS Feed"
        , footerLink "https://github.com/olpeh/olpeh.github.io" "GitHub"
        , footerLink "https://twitter.com/0lpeh" "Twitter"
        , footerLink "https://twitter.com/0lpeh" "Twitter"
        , footerLink "mailto:contact@olavihaapala.fi" "Email"
        , footerLink "https://www.linkedin.com/in/olavi-haapala-b7b752162" "LinkedIn"
        ]


footerLink : String -> String -> Html msg
footerLink linkTo displayName =
    a
        [ href linkTo
        ]
        [ text (String.toUpper displayName)
        ]
