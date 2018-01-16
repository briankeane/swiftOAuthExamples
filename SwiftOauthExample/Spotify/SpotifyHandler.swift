//
//  SpotifyHandler.swift
//  playolaIphone
//
//  Created by Brian D Keane on 11/3/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import OAuthSwift
import PromiseKit
import Alamofire


// Spotify's api is a little different in that you have to provide your own
// token exchange on your backend.  An example of this is included with this
// project in the spotifyServer folder.
//
// to start the spotifyServer, cd into the spotifyServer and run:
// `npm install`
// then cd back out to the main folder and run `node spotifyServer`
// to switch to a custom port, type `PORT=9000 node spotifyServer`

@objc class SpotifyHandler:GenericOAuthHandler, GenericOAuthHandlerProtocol
{
    // dependency injections
    var observers:[NSObjectProtocol] = Array()
    
    
    override init()
    {
        super.init()
        self.setupTokenKeys()
        self.checkForStoredTokens()
    }
    
    //------------------------------------------------------------------------------
    
    override func generateOAuth() -> OAuth2Swift
    {                                           
        return OAuth2Swift(
            consumerKey:    SpotifySecrets.clientID,
            consumerSecret: SpotifySecrets.clientSecret,
            authorizeUrl:   "https://accounts.spotify.com/authorize",
            accessTokenUrl: SpotifySecrets.accessTokenURL,
            responseType:   "code"
        )
    }
    
    //------------------------------------------------------------------------------
    
    override func authorize() -> Promise<(String, String?)>
    {
        return Promise
        {
            (fulfill, reject) -> Void in
            let state = generateState(withLength: 20)
            let _ = self.oauthSwift?.authorize(
                withCallbackURL: URL(string: "oauth-example://spotify")!,   // this is a fake url, since facebook does not allow local app urls.  It is
                scope: "user-library-modify",
                state: state,                            // intercepted in CustomOAuthWebViewController
                success:
                {
                    (credential, response, parameters) -> Void in
                    self.storeTokens(accessTokenString: credential.oauthToken, refreshTokenString: credential.oauthRefreshToken)
                    NotificationCenter.default.post(name: self.signInStatusChanged, object: nil, userInfo: nil)
                    fulfill((credential.oauthToken, credential.oauthRefreshToken))
                },
                failure:
                {
                    (error) -> Void in
                    print(error.localizedDescription, terminator: "")
                    reject(error)
                })
        }
    }
    
    //------------------------------------------------------------------------------
    
    func searchTracks(searchString:String) -> Promise<String?>
    {
        return Promise
        {
            (fulfill, reject) -> Void in
            self.oauthSwift!.startAuthorizedRequest("https://api.spotify.com/v1/search", method: .GET, parameters: [
                "limit": 50,
                "type": "track",
                "q": searchString
                ], success: { (response) in
                    fulfill(response.dataString())
            }, failure: { (error) in
                puts("error")
                reject(error)
            })
        }
    }
    
    //------------------------------------------------------------------------------
    
    override func signOut() {
        super.signOut()
        NotificationCenter.default.post(name: self.signInStatusChanged, object: nil, userInfo: nil)
    }
    
    //------------------------------------------------------------------------------
    
    public var signInStatusChanged:Notification.Name = Notification.Name(rawValue: "SpotifySignInStatusChanged")
    
    //------------------------------------------------------------------------------
    
    func setupTokenKeys()
    {
        self.accessTokenKey = "spotifyAccessToken"
        self.refreshTokenKey = "spotifyRefreshToken"
    }
    
    //------------------------------------------------------------------------------
    // Singleton
    //------------------------------------------------------------------------------
    public static var _instance:FacebookHandler?
    public static func sharedInstance() -> FacebookHandler
    {
        if let instance = self._instance
        {
            return instance
        }
        self._instance = FacebookHandler()
        return self._instance!
    }
}
