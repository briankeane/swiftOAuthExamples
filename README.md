# OAuthSwift Examples
Working examples of OAuthSwift implementations, including making authenticated requests. 
### Why?

I had some trouble with the specific implementations of some of these oAuth flows, so I decided to extract the authorization flow only to a sample app, so that when issues arise I can figure them out here instead of in my production code.

### How to Use
Clone the repo, add the SecretsSample file to the main target, replace the app-identifying information in that file with your own app's info.  Then it should work!

### Note for Spotify:
Spotify requires you to host your own token service.  There is a skeleton version of this service included in the `spotifyServer` folder.
