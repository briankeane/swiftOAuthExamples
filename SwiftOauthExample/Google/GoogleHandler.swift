//
//  GoogleHandler.swift
//  playolaIphone
//
//  Created by Brian D Keane on 11/3/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import OAuthSwift
import PromiseKit

@objc class GoogleHandler: GenericOAuthHandler, GenericOAuthHandlerProtocol
{
    var observers: [NSObjectProtocol] = Array()
    
    override init()
    {
        super.init()
        self.setupTokenKeys()
        self.checkForStoredTokens()
    }
    
    // required override
    
    override func generateOAuth() -> OAuth2Swift
    {
        return OAuth2Swift(
            consumerKey:    GoogleSecrets.clientID,
            consumerSecret: GoogleSecrets.consumerSecret,
            authorizeUrl:   "https://accounts.google.com/o/oauth2/auth",
            accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
            responseType:   "code"
        )
    }
    
    override func authorize() -> Promise<(String, String?)>
    {
        return Promise
            {
                (fulfill, reject) -> Void in
                let state = generateState(withLength: 20)
                let _ = self.oauthSwift?.authorize(
                    withCallbackURL: URL(string: "fm.playola.playola:/oauth2Callback")!,
                    scope: self.scopes(),
                    state: state,
                    success:
                    {
                        (credential, response, parameters) in
                        self.storeTokens(accessTokenString: credential.oauthToken, refreshTokenString: credential.oauthRefreshToken)
                        fulfill((credential.oauthToken, credential.oauthRefreshToken))
                        self.onSuccessfulLogin(credential: credential, response: response, parameters: parameters)
                },
                    failure:
                    {
                        (error) in
                        print(error.localizedDescription, terminator: "")
                })
        }
    }
    
    func onSuccessfulLogin(credential:OAuthSwiftCredential, response:OAuthSwiftResponse?, parameters:OAuthSwift.Parameters)
    {
        if let accessToken = self.oauthSwift?.client.credential.oauthToken
        {
            // logged into google!
            puts ("logged into google!")
        }
    }
    
    func setupTokenKeys()
    {
        self.accessTokenKey = "googleAccessTokenKey"
        self.refreshTokenKey = "googleRefreshTokenKey"
    }
    
    func scopes() -> String
    {
        return [
            "https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/contacts.readonly"
            ].joined(separator: " ")
    }
    
    var signInStatusChanged: Notification.Name = Notification.Name(rawValue: "GoogleSignInStatusChanged")
    //------------------------------------------------------------------------------
    // Singleton
    //------------------------------------------------------------------------------
    public static var _instance:GoogleHandler?
    public static func sharedInstance() -> GoogleHandler
    {
        if let instance = self._instance
        {
            return instance
        }
        self._instance = GoogleHandler()
        return self._instance!
    }
}
