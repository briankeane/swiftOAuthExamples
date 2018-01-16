//
//  SpotifyViewController.swift
//  SwiftOauthExample
//
//  Created by Brian D Keane on 1/14/18.
//  Copyright © 2018 Brian D Keane. All rights reserved.
//

import UIKit

class SpotifyViewController: UIViewController
{
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accessTokenLabel: UILabel!
    @IBOutlet weak var refreshTokenLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var responseTextView: UITextView!
    
    var handler:SpotifyHandler = SpotifyHandler()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupListeners()
        self.refreshUI()
    }
    
    func setupListeners()
    {
        NotificationCenter.default.addObserver(forName: self.handler.signInStatusChanged, object: nil, queue: .main)
        {
            (notification) -> Void in
            self.refreshUI()
        }
    }
    
    func refreshUI()
    {
        self.refreshSignInButton()
        self.refreshLabels()
    }
    
    func refreshLabels()
    {
        var accessTokenText = "accessToken: --------"
        var refreshTokenText = "refreshToken: -------"
        
        if let accessToken = self.handler.accessToken()
        {
            accessTokenText = "accessToken: \(accessToken)"
        }
        
        if let refreshToken = self.handler.refreshToken()
        {
            refreshTokenText = "refreshToken: \(refreshToken)"
        }
        
        DispatchQueue.main.async {
            self.accessTokenLabel.text = accessTokenText
            self.refreshTokenLabel.text = refreshTokenText
        }
    }
    
    func refreshSignInButton()
    {
        if (self.handler.isSignedIn() == true)
        {
            DispatchQueue.main.async
            {
                self.signInButton.setTitle("Sign Out", for: .normal)
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                self.signInButton.setTitle("Sign In", for: .normal)
            }
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any)
    {
        if (self.handler.isSignedIn())
        {
            self.handler.signOut()
        }
        else
        {
            self.handler.signIn(presentingViewController: self)
            .then
            {
                (responseText) -> Void in
                
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any)
    {
        if let text = self.searchTextField.text
        {
            DispatchQueue.main.async
            {
                self.responseTextView.text = ""
            }
            
            self.handler.searchTracks(searchString: text)
            .then
            {
                (responseString) -> Void in
                // default is no string responded
                var displayString = "----------- NO STRING RESPONSE ------------"
                if let responseString = responseString
                {
                    displayString = responseString
                }
                DispatchQueue.main.async
                {
                    self.responseTextView.text = displayString
                }
            }
            .catch
            {
                (error) -> Void in
                DispatchQueue.main.async
                {
                    self.responseTextView.text = "error: \(error.localizedDescription)"
                }
            }
        }
    }
}
