//
//  FacebookSignInViewController.swift
//  SwiftOauthExample
//
//  Created by Brian D Keane on 1/14/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class FacebookSignInViewController: UIViewController
{
    @IBOutlet weak var signInOutButton: UIButton!
    
    @IBOutlet weak var accessTokenLabel: UILabel!
    @IBOutlet weak var refreshTokenLabel: UILabel!
    
    
    @objc var facebookHandler:FacebookHandler = FacebookHandler.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupListeners()
        self.refreshDisplays()
    }

    func setupListeners()
    {
        NotificationCenter.default.addObserver(forName: facebookHandler.signInStatusChanged, object: nil, queue: .main)
        {
            (notification) -> Void in
            self.refreshDisplays()
        }
    }
    
    func refreshDisplays()
    {
        self.refreshSignInButton()
        self.refreshTokenLabels()
    }
    
    //------------------------------------------------------------------------------
    
    func refreshTokenLabels()
    {
        DispatchQueue.main.async
        {
            if let accessToken = self.facebookHandler.accessToken()
            {
                self.accessTokenLabel.text = "accessToken: \(accessToken)"
            }
            else
            {
                self.accessTokenLabel.text = "accessToken: nil"
            }
            
            if let refreshToken = self.facebookHandler.refreshToken()
            {
                self.refreshTokenLabel.text = "refreshToken :\(refreshToken)"
            }
            else
            {
                self.refreshTokenLabel.text = "refreshToken: nil"
            }
        }
    }
    
    //------------------------------------------------------------------------------
    
    func refreshSignInButton()
    {
        var text = "Sign In"
        if (self.facebookHandler.isSignedIn())
        {
            text = "Sign Out"
        }
        if self.signInOutButton.titleLabel!.text != text
        {
            DispatchQueue.main.async
            {
                self.signInOutButton.setTitle(text, for: .normal)
            }
        }
    }
    
    @IBAction func signInOutButtonPressed(_ sender: Any)
    {
        if (self.facebookHandler.isSignedIn())
        {
            self.facebookHandler.signOut()
        }
        else
        {
            self.facebookHandler.signIn(presentingViewController: self)
        }
    }
    
}
