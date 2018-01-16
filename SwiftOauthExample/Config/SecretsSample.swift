//
//  SecretsSample.swift
//  SwiftOauthExample
//
//  Created by Brian D Keane on 1/14/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import Foundation

public class FacebookSecrets
{
    public static var appID:String = "REPLACE_WITH_YOUR_GOOGLE_APP_ID"
    public static var consumerSecret:String = "REPLACE_WITH_YOUR_GOOGLE_CONSUMER_SECRET"
}

public class GoogleSecrets
{
    public static var clientID:String = "REPLACE_WITH_YOUR_CLIENT_ID"
    public static var consumerSecret:String = "REPLACE_WITH_YOUR_GOOGLE_CONSUMER_SECRET"
}

public class SpotifySecrets
{
    public static var clientID = "REPLACE_WITH_YOUR_SPOTIFY_CLIENT_ID"
    public static var clientSecret = "REPLACE_WITH_YOUR_SPOTIFY_CLIENT_SECRET"
    
    // if you are deploying your app, you must deploy your own tokenSwap
    // service similar to the one in the spotifyServer folder of this project.
    // in that case, change this address to your server's address.
    public static var accessTokenURL = "http://localhost:3500/swapToken"
    
    // register this callbackURL with Spotify and also add the
    // base (in this case, 'oauth-example') to the URL Types in your
    // Target/Info settings
    public static var callbackURL = "oauth-example//spotify"
}
