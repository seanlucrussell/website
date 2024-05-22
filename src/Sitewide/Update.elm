module Sitewide.Update exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Navigation
import Char exposing (toUpper)
import Css exposing (..)
import Dict exposing (Dict)
import List exposing (filter)
import Pages.SamplePage
import Sitewide.Types exposing (..)
import Url exposing (Url)


commandMap : SitewideModel -> Dict String SitewideMsg
commandMap model =
    Dict.fromList
        [ ( "NAV", SelectPage NavigationPage )
        , ( "TEST", SelectPage SamplePage )
        , ( "TOGGLE"
          , SelectPage
                (if model.currentPage == NavigationPage then
                    SamplePage

                 else
                    NavigationPage
                )
          )
        , ( "INC", Increment )
        , ( "DEC", Decrement )
        ]


urlPageRelation : List ( String, Page )
urlPageRelation =
    [ ( "/NAV", NavigationPage )
    , ( "/TEST", SamplePage )
    ]


urlToPage : Url -> Page
urlToPage url =
    case filter (\( u, _ ) -> u == url.path) urlPageRelation of
        ( _, page ) :: _ ->
            page

        _ ->
            MissingPage


pageToUrl : Page -> String
pageToUrl page =
    case filter (\( _, p ) -> p == page) urlPageRelation of
        ( url, _ ) :: _ ->
            url

        _ ->
            "/MISSING"


update : SitewideMsg -> SitewideModel -> ( SitewideModel, Cmd SitewideMsg )
update message model =
    case message of
        SelectPage p ->
            ( { model | currentPage = p }, Navigation.pushUrl model.key (pageToUrl p) )

        UrlChange url ->
            ( { model | currentPage = urlToPage url }, Cmd.none )

        UrlRequest (Internal url) ->
            update (SelectPage (urlToPage url)) model

        UrlRequest (External url) ->
            ( model, Navigation.load url )

        CommandBarChanged t ->
            ( { model | commandText = t }, Cmd.none )

        CommandSubmitted ->
            case Dict.get (String.map toUpper model.commandText) (commandMap model) of
                Just cmd ->
                    update cmd { model | commandText = "" }

                Nothing ->
                    ( { model | commandText = "" }, Cmd.none )

        _ ->
            case model.currentPage of
                SamplePage ->
                    Pages.SamplePage.update message model

                _ ->
                    ( model, Cmd.none )