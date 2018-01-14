//
//  GenericOAuthHandler.swift
//  playolaIphone
//
//  Created by Brian D Keane on 11/6/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import UIKit
import OAuthSwift
import SafariServices
import PromiseKit

@objc class GenericOAuthHandler: NSObject, SFSafariViewControllerDelegate
{
    let defaults:UserDefaults = UserDefaults.standard
    var accessTokenKey:String! = ""
    var refreshTokenKey:String?
    var oauthSwift:OAuth2Swift?
    
    // override
    func generateOAuth() -> OAuth2Swift
    {
        return OAuth2Swift(parameters: [:])!
    }
    
    // override
    func authorize() -> Promise<(String, String?)>
    {
        return Promise(value: ("overrideLater", nil))
    }
    
    
    func checkForStoredTokens()
    {
        if let accessToken = defaults.string(forKey: self.accessTokenKey)
        {
            self.oauthSwift = self.generateOAuth()
            self.oauthSwift?.client.credential.oauthToken = accessToken
            
            if let refreshTokenKey = self.refreshTokenKey
            {
                if let refreshToken = defaults.string(forKey: refreshTokenKey)
                {
                    self.oauthSwift?.client.credential.oauthRefreshToken = refreshToken
                }
            }
        }
    }
    
    public func signIn(presentingViewController:UIViewController) -> Promise<(String, String?)>
    {
        self.oauthSwift = self.generateOAuth()
        
        //        let internalWebViewController = CustomOAuthWebViewController()
        
        let internalWebViewController = SafariURLHandler(viewController: presentingViewController, oauthSwift: self.oauthSwift!)
        internalWebViewController.delegate = self
        self.oauthSwift?.authorizeURLHandler = internalWebViewController
        
        //        presentingViewController.addChildViewController(internalWebViewController)
        
        return self.authorize()
    }
    
    public func signOut()
    {
        self.oauthSwift = nil
        self.clearTokens()
        Swift.print("Logged out of: \(self.accessTokenKey!)")
    }
    
    public func isSignedIn() -> Bool
    {
        return (self.oauthSwift != nil)
    }
    
    public func accessToken() -> String?
    {
        return self.oauthSwift?.client.credential.oauthToken
    }
    
    public func refreshToken() -> String?
    {
        return self.oauthSwift?.client.credential.oauthRefreshToken
    }
    
    func clearTokens()
    {
        defaults.set(nil, forKey: self.accessTokenKey)
        if let refreshTokenKey = self.refreshTokenKey
        {
            defaults.set(nil, forKey: refreshTokenKey)
        }
    }
    
    func storeTokens(accessTokenString:String, refreshTokenString:String?=nil)
    {
        defaults.set(accessTokenString, forKey: self.accessTokenKey)
        
        if let refreshTokenString = refreshTokenString
        {
            if let refreshTokenKey = self.refreshTokenKey
            {
                defaults.set(refreshTokenString, forKey: refreshTokenKey)
            }
        }
    }
}
