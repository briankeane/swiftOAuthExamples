//
//  GenericOAuthHandlerProtocol.swift
//  playolaIphone
//
//  Created by Brian D Keane on 12/7/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation
import OAuthSwift
import PromiseKit
import SafariServices

protocol GenericOAuthHandlerProtocol: SFSafariViewControllerDelegate
{
    // MARK: required
    var oauthSwift: OAuth2Swift? { get set }
    
    /// the UserDefaults key for retrieving the stored accessToken
    var accessTokenKey:String! { get set }
    
    /// the UserDefaults key for retrieving the stored refreshToken.  This is an
    /// optional because the refreshToken may not exist
    var refreshTokenKey:String? { get set }
    
    func generateOAuth() -> OAuth2Swift
    
    /// if successful, resolves to a promise containing the accessTokenString and
    /// refreshTokenString if it exists
    func authorize() -> Promise<(String, String?)>
    
    // MARK: default implementations provided in extension
    var defaults:UserDefaults { get }
    
    func checkForStoredTokens()
    
    /// if successful, resolves to a promise containing the accessTokenString
    /// and the refreshTokenString if it exists
    func signIn(presentingViewController:UIViewController) -> Promise<(String, String?)>
    
    func signOut()
    
    func isSignedIn() -> Bool
    
    func accessToken() -> String?
    
    func refreshToken() -> String?
    
    func clearTokens()
    
    func storeTokens(accessTokenString:String, refreshTokenString:String?)
}

extension GenericOAuthHandlerProtocol
{
    
    
    
}

