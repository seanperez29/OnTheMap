# OnTheMap

OnTheMap is a Udacity student project which posts user-generated location
information to a shared map and retrieves those locations of fellow Nanodegree
students with their associated custom messages about themselves or their
learning experiences.

## Usage

* Login Screen - The initial screen upon app launch will present the user with a 
login screen. If the user has a Udacity account with username and password, they 
will enter them on this screen in order to be verified and logged into the app. 
If the user does not yet have an account they can select the 'Sign Up' button in 
order to be redirected to Udacity's website for account creation. After 
successfully completing this step the user will be redirected back to the app.

* Map - After successfully being logged into the app, the first screen of the 
tabbed application the user will be presented with is a map showcasing all of 
the user-generated locations. Upon pin selection, an annotation will be 
displayed with the user's name and URL that they have shared. Upon selection of 
the annotation the app will redirect the user to the associated URL. 

* Table View - Once the second tab of the app is selected the user will be able
to see all of the information that is outlined from the map screen, but in a 
table view format. Selecting a row will redirect the user to the associated URL.

* Adding a Post - In order to add a post of the user's own, the location icon in
the top right corner can be selected. This will modally present a screen to
enter in a location. The location will be geocoded to display a pin of the
location entered. From here a user then enters a URL of their choice and posts
the information. Once completed the user can logout if they wish and this will
bring them back to the login screen.
