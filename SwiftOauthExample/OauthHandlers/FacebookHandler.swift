//
//  FacebookHandler.swift
//  playolaIphone
//
//  Created by Brian D Keane on 11/3/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import OAuthSwift
import PromiseKit

@objc class FacebookHandler:GenericOAuthHandler, GenericOAuthHandlerProtocol
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
            consumerKey:    FacebookSecrets.appID,
            consumerSecret: FacebookSecrets.consumerSecret,
            authorizeUrl:   "https://www.facebook.com/dialog/oauth",
            accessTokenUrl: "https://graph.facebook.com/oauth/access_token",
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
                    withCallbackURL: URL(string: "https://api.playola.fm/auth/facebook/mobileRedirectIOS")!,   // this is a fake url, since facebook does not allow local app urls.  It is
                    scope: "public_profile",
                    state: state,                            // intercepted in CustomOAuthWebViewController
                    success:
                    {
                        (credential, response, parameters) -> Void in
                        self.storeTokens(accessTokenString: credential.oauthToken)
                        fulfill((credential.oauthToken, nil))
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
    
    func setupTokenKeys()
    {
        self.accessTokenKey = "facebookAccessToken"
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
