module Main exposing (main)

import Color
import Data.Author as Author
import Date
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Region
import Feed
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes as Attr
import Index
import Json.Decode
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
import Palette


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
    Element Msg



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
                Html.div [] [ Markdown.toHtml [] markdownBody ]
                    |> Element.html
                    |> List.singleton
                    |> Element.paragraph [ Element.width Element.fill ]
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
                        |> Element.layout
                            [ Element.width Element.fill
                            , Font.size 20
                            , Font.family [ Font.typeface "Roboto" ]
                            , Font.color (Element.rgba255 0 0 0 0.8)
                            , Element.Background.color Palette.color.secondaryBackground
                            ]
                }
        , head = head page.frontmatter
        }


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Element Msg }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ header page.path
                , Element.column
                    [ Element.padding 50
                    , Element.spacing 60
                    , Element.Region.mainContent
                    ]
                    [ viewForPage
                    ]
                , footer
                ]
                    |> Element.textColumn
                        [ Element.width Element.fill
                        ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body =
                Element.column [ Element.width Element.fill ]
                    [ header page.path
                    , Element.column
                        [ Element.padding 30
                        , Element.spacing 40
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        (Element.column [ Element.spacing 10 ]
                            [ Element.row [ Element.spacing 10 ]
                                [ Author.view [] metadata.author
                                , Element.column [ Element.spacing 10, Element.width Element.fill ]
                                    [ Element.paragraph [ Font.bold, Font.size 24 ]
                                        [ Element.text metadata.author.name
                                        ]
                                    , Element.paragraph [ Font.size 16 ]
                                        [ Element.text metadata.author.bio ]
                                    ]
                                ]
                            ]
                            :: (publishedDateView metadata |> Element.el [ Font.size 16, Font.color (Element.rgba255 0 0 0 0.6) ])
                            :: Palette.blogHeading metadata.title
                            :: articleImageView metadata.image metadata.altText
                            :: imageCreditsView metadata.credits
                            :: [ viewForPage ]
                        )
                    , footer
                    ]
            }

        Metadata.Author author ->
            { title = author.name
            , body =
                Element.column
                    [ Element.width Element.fill
                    ]
                    [ header page.path
                    , Element.column
                        [ Element.padding 30
                        , Element.spacing 20
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        [ Palette.blogHeading author.name
                        , Author.view [] author
                        , Element.paragraph [ Element.centerX, Font.center ] [ viewForPage ]
                        ]
                    , footer
                    ]
            }

        Metadata.BlogIndex ->
            { title = "olavihaapala.fi – a personal blog"
            , body =
                Element.column
                    [ Element.width Element.fill
                    ]
                    [ header page.path
                    , Element.column [ Element.padding 20, Element.centerX ] [ Index.view siteMetadata ]
                    , footer
                    ]
            }


articleImageView : ImagePath Pages.PathKey -> String -> Element msg
articleImageView articleImage altText =
    Element.image [ Element.width Element.fill ]
        { src = ImagePath.toString articleImage
        , description = altText
        }


imageCreditsView : Maybe String -> Element msg
imageCreditsView credits =
    case credits of
        Just str ->
            Element.text str

        Nothing ->
            -- TODO: is there a better way than empty string
            Element.text ""


header : PagePath Pages.PathKey -> Element msg
header currentPath =
    Element.row
        [ Element.padding 40
        , Element.spaceEvenly
        , Element.width Element.fill
        , Element.Region.navigation
        , Element.Background.color Palette.color.primary
        ]
        [ Element.wrappedRow
            [ Element.padding 16
            , Element.spaceEvenly
            , Element.centerX
            , Element.width
                (Element.fill
                    |> Element.maximum 650
                )
            ]
            [ Element.link
                [ Font.color Palette.color.secondary
                , Font.bold
                ]
                { url = "/"
                , label = Element.text (String.toUpper "Home")
                }
            , highlightableLink currentPath pages.blog.directory "Blog"
            , highlightableLink currentPath pages.contact.directory "Contact"
            , highlightableLink currentPath pages.projects.directory "Projects"
            ]
        ]


highlightableLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Element msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            currentPath |> Directory.includes linkDirectory
    in
    Element.link
        (if isHighlighted then
            [ Font.underline
            , Font.color Palette.color.secondary
            ]

         else
            [ Font.color Palette.color.secondary
            ]
        )
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Element.text (String.toUpper displayName)
        }


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
    Element.text
        (metadata.published
            |> Date.format "MMMM ddd, yyyy"
        )


footer : Element msg
footer =
    Element.row
        [ Element.padding 80
        , Element.spaceEvenly
        , Element.width Element.fill
        , Element.Region.footer
        , Element.Background.color Palette.color.primaryBackground
        ]
        [ Element.wrappedRow
            [ Element.spaceEvenly
            , Element.centerX
            , Element.width
                (Element.fill
                    |> Element.maximum 650
                )
            ]
            [ footerLink "/blog/feed.xml" "RSS Feed"
            , footerLink "https://github.com/olpeh/olpeh.github.io" "GitHub"
            , footerLink "https://twitter.com/0lpeh" "Twitter"
            , footerLink "https://twitter.com/0lpeh" "Twitter"
            , footerLink "mailto:contact@olavihaapala.fi" "Email"
            , footerLink "https://www.linkedin.com/in/olavi-haapala-b7b752162" "LinkedIn"
            ]
        ]


footerLink : String -> String -> Element msg
footerLink href displayName =
    Element.link
        [ Element.padding 16
        , Font.color
            Palette.color.primary
        ]
        { url = href
        , label = Element.text (String.toUpper displayName)
        }
