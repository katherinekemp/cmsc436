# CMSC436 Milestone 3: Theatr

## Project Team 10

 * Austin Hwa
 * Katie Kemp
 * Sahir Mody

## App Description

This app will allow a user to find movies near them and click a link to purchase the ticket. Theaters are recommended based on GPS location.

## Accomplished So Far

For Milestone 3, we focused on using the AMC API to get information about actual movies based on our GPS location which we retrieved in Milestone 2 using the `LocationManager`. This proved to be a bit tricky due to the formatting of the location provided by the location manager and the delay in time for receiving access to the API. We also had to figure out how to attach header information to a `GET` request in Swift, which we used `URLRequest` for. We were able to get information back from the API, but we are stilling working on fully decoding the information because it's not as easy as in other request libraries like those we have used before.

#### Milestone 1

 * Basic homepage
 * Text box for sessions (not functional yet)
 * List of movies (test data)

#### Milestone 2

 * Getting location data from GPS

#### Milestone 3

 * Adding API calls to get actual movie data
 * Added swipe to refresh feature

## Updated Project Timeline

### Final submission

* Decoding API calls
* Improved styling for different orientations, etc.
* Look into whether any of our stretch goals could realistically be implmeneted
* Project submitted

## Minimal Goals

The app will contain a list of theaters with movies showing nearby.

## Stretch Goals

We have identified the following stretch goals:

 * Links to purchasing tickets
 * Movie previews in app
 * Chat and commenting features
 * Recommendations based on history
 * Collect profile data
