## 24.11.2023, 14:00 - 15:30: Internal Review

Present: All, Place: In person

### Topics
* What has each person done this week?
  * Anna: Migrations + Swiping functionality
  * Bartek: Chat functionality
  * Chris: 
    * Retrieving the location of a user
    * Storing location in the database 
    * Location retrieval available for the "Random match algorithm"
  * Mo: Algorithms
* Current state of the application
* Every person shows what they did in detail

#### Questions by the Assistant

##### Misc
* Do the "preferences" have weights?
* Is there a reporting feature for the rating system?
  * Currently option
* From how many swipes is the user marked as safe?
* How is the chat going to be encrypted?
* How many connections can a user have at the same time?
* If the user refreshes the page, is the connection closed?
* What happens if the user loses a connection to Wi-Fi?
* If the client is long time not active, what to do then?
* Per user there should be 5-10 connections

##### Location
* How should be location stored?
  * Uses PostGIS
  * Latitude, Longitude, Hash
* What to do if the user declines to share their location?
  * Introduce "Terms of Use" that expect the user to agree with them.
  * LocationAPI, asking once per minute/once per day
    * EventListener - Update location every day
* Define which browsers are used for testing purposes, and on which browser the app is supposed to work in
* Potential Integration tests? How does the app run on different browsers?

##### Algorithms
* Limited amount of input parameters
* How could the models understand, that if a personality is not likable to me, it is recognized by the expert system?
  * ExSys learns from the Matching system, not Unmatching system
  * Example: Two persons with literally same preferences, etc. But one woman has a likable personality, the other not.
    Can this be noted?
* Can a person see the same person multiple times? 
  * No.
* What if a person swipes too quickly?
  * Solution: Give a user a timeout to read a person profile.
    * Corresponds to our definition of the dating app, where interaction is supposed to be meaningful

##### Images
* BLOB extensions can cause problems. If 100 people save an image at the same time can cause issues.
  * Use threads + queues how to store images
* Two diverse databases: one images, one for data

##### Tests
* JWT.io: Can the user change his/her ID
  * Potential weaknesses: Null-algorithms
* Cascade deletion of chats, if a user deletes their account

### Feedback
* Root directory has backend, that only src and not test
  * We should put requirements.txt in the backend folder
  * Files such as ``token.py`` which contain hard-coded variables, should be put in a ``config.py``-file.
* Remove from service-layer the "depends"-dependencies, move all to the endpoint service.
  * Allows for better testing
  * Is not dependent on FastAPI
    * Useful for "serial task runner"
* Have just one exception's file to limit the amount of imports
  * Could import everything into ``init.py``.
* service > validation folder can be omitted, with pydantic can the check be done.
* Remove password-hashes
* Use the python-logger, instead of a custom one
* Define an additional folder for the backend
  * Domain: Login - Endpoint, Service, Repository, Validations etc.
    * Did not work too well in the frontend, is not mandatory. Pick what works for you the best

#### Websockets
* Look into further details into the edge cases
* End-to-End Encryption: What to look out for with multiple users.

#### MR2
* Will expect:
  * Presentation
  * Sprint recap
  * Show that 2/3rds have been done
  * Display the features, how they work
  * Most important part: A live demo
  * Frontend is not a priority
  * 24h before MR2 the code should be the latest state, tag branch and create a release