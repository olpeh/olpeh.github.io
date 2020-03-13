module Main exposing (main)

import Accessibility as Html exposing (..)
import Accessibility.Aria exposing (currentPage)
import Color
import Data.Author as Author
import Date
import Feed
import Head
import Head.Seo as Seo
import Html.Attributes exposing (class, href, src, target)
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
                div [ class "flex min-h-screen flex-col" ]
                    [ headerView page.path
                    , main_ [ class "max-w-4xl py-16 mx-auto" ]
                        [ viewForPage
                        ]
                    , footerView
                    ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body =
                div
                    [ class "flex min-h-screen flex-col"
                    ]
                    [ headerView page.path
                    , main_ [ class "max-w-4xl py-16 mx-auto" ]
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
                    [ class "flex min-h-screen flex-col" ]
                    [ headerView page.path
                    , main_ [ class "max-w-4xl py-16 mx-auto" ]
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
                    [ class "flex min-h-screen flex-col" ]
                    [ headerView page.path
                    , main_ [ class "max-w-4xl py-16 mx-auto" ]
                        [ Index.view siteMetadata ]
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
    header [ class "bg-primary py-8" ]
        [ nav
            [ class "max-w-xl mx-auto" ]
            [ ul [ class "flex justify-evenly" ]
                [ li []
                    [ highlightableLink (currentPath == pages.index) "/" "Home" ]
                , li []
                    [ highlightableElmPagesLink currentPath pages.blog.directory "Blog" ]
                , li []
                    [ highlightableElmPagesLink currentPath pages.contact.directory "Contact" ]
                , li []
                    [ highlightableElmPagesLink currentPath pages.projects.directory "Projects" ]
                ]
            ]
        ]


highlightableElmPagesLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Html msg
highlightableElmPagesLink currentPath linkDirectory displayName =
    let
        isCurrent =
            currentPath |> Directory.includes linkDirectory

        linkTo =
            linkDirectory
                |> Directory.indexPath
                |> PagePath.toString
    in
    highlightableLink isCurrent linkTo displayName


highlightableLink isCurrent linkTo displayName =
    let
        defaultAttributes =
            [ href linkTo
            , class "text-secondary text-2xl font-bold"
            ]

        attributes =
            if isCurrent then
                defaultAttributes
                    ++ [ currentPage
                       , class "border-b-4"
                       ]

            else
                defaultAttributes
    in
    a
        attributes
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
    footer [ class "bg-footer py-16" ]
        [ nav
            [ class "p-16 mx-auto" ]
            [ ul [ class "flex justify-evenly" ]
                [ li [] [ footerLink "/blog/feed.xml" "RSS Feed" ]
                , li [] [ footerLink "https://github.com/olpeh/olpeh.github.io" "GitHub" ]
                , li [] [ footerLink "https://twitter.com/0lpeh" "Twitter" ]
                , li [] [ footerLink "https://twitter.com/0lpeh" "Twitter" ]
                , li [] [ footerLink "mailto:contact@olavihaapala.fi" "Email" ]
                , li [] [ footerLink "https://www.linkedin.com/in/olavi-haapala-b7b752162" "LinkedIn" ]
                ]
            ]
        ]


footerLink : String -> String -> Html msg
footerLink linkTo displayName =
    a
        [ href linkTo
        , class "text-primary text-xl font-bold"
        , target "_blank"
        ]
        [ text (String.toUpper displayName)
        ]
