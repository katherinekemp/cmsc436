# CMSC436 Milestone 2: Theatr

## Project Team 10

 * Austin Hwa
 * Katie Kemp
 * Sahir Mody

## App Description

This app will allow a user to find movies near them and share their interests with their friends. A host can create a session with a date and time in mind and share the session id with their friends. Once joining the session, members can vote on what movie they want to see. Theaters are recommended based on GPS location.

## Accomplished So Far

For Milestone 2, we have expanded the functionality of the application. Originally, we wanted to implement a sessions option that allowed numerous participants to vote remotely on their own device. However, after trying to implement sessions, we realized that the implementation would likely take us longer to implement than we had originally anticipated. As a result, we have removed session IDs and joining sessions from our goals. Our goals have also been updated to reflect the changes in our plans.

Additionally, we tried to implement the Fandango API, but upon research online, we found that Fandango had been purchased by Gracenote, and had thus removed any public access to their API. Consequently, we switched over to using AMC's Developer's resources that allow us to get a list of showtimes given a location. We were, however, unable to implement the API since they only deploy new keys once per week, and the deadline has since expired for this milestone, causing us to need to push back the goal of importing and displaying the movie data to Milestone 3. However, we were able to semi-test the API endpoints on Postman, and it seems as though it should work. 

#### Milestone 1

 * Basic homepage
 * Text box for sessions (not functional yet)
 * List of movies (test data)

#### Milestone 2

 * Getting location data from GPS


## Updated Project Timeline

### Milestone 3

 * Voting
 * Results page
 * Import movie data from AMC API
 * Update movie list based on location/time

At this point, we will begin working on the stretch goals

### Final submission

Stretch goals completed, project submitted, and a demonstration
scheduled.

## Minimal Goals

The app will contain a list theaters with movies showing nearby. A host can create a session and share with friends. Members of the session can vote on which movie they'd like to see. Votes are compiled and results are displayed.

## Stretch Goals

We have identified the following stretch goals:

 * Movie previews in app
 * Chat and commenting features
 * Recommendations based on history
 * Collect profile data
