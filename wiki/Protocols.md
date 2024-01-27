# Protocols 📚

## Table of contents 📖

1. [20.10.2023 Project Proposal](#20102023-1545---1600-project-proposal)
2. [23.10.2023 Weekly Meeting](#23102023-1800---1900-weekly-meeting)
3. [24.10.2023 Weekly Meeting with the tutor](#24102023-1600---1700-weekly-meeting-with-the-tutor)
4. [27.10.2023 Weekly Meeting](#27102023-1400---1515-weekly-meeting)
5. [30.10.2023 Weekly Meeting](#30102023-1800---1900-weekly-meeting)
6. [31.10.2023 Weekly Meeting with the tutor](#31102023-1615---1715-weekly-meeting-with-the-tutor)
7. [02.11.2023 Weekly Meeting with the tutor](#31102023-1615---1715-weekly-meeting-with-the-tutor)
8. [03.11.2023 Weekly Meeting](#03112023-1000----weekly-meeting)
9. [03.11.2023 MR1](#03112023-1700---1900-mr1)
10. [06.11.2023 Weekly Meeting](#06112023-1800---1915-weekly-meeting)
11. [07.11.2023 Weekly Meeting with the tutor](#07112023-1615---1715-weekly-meeting-with-the-tutor)
12. [10.11.2023 Weekly Meeting with the tutor](#10112023-1400---1500-weekly-meeting-with-the-tutor)
13. [10.11.2023 Meeting before "Weekly Meeting with the Tutor"](#17112023-1030-1100-meeting-before-weekly-meeting-with-the-tutor)
14. [10.11.2023 Weekly Meeting with the tutor](#17112023-1100-1130-weekly-meeting-with-the-tutor)
15. [21.11.2023 Weekly Meeting](#21112023-1800---1900-weekly-meeting-with-the-tutor)
16. [24.11.2023 Internal Review 1 (IR1)](#24112023-1400---1530-internal-review)
17. [04.12.2023 Weekly Meeting](#04122023-1800---1930-weekly-meeting)
18. [15.12.2023 Weekly Meeting with the tutor](#15122023-1400---1530-weekly-meeting-with-the-tutor)



## 20.10.2023, 15:45 - 16:00: Project Proposal

Present: All, Place: Zoom-Meeting

Feedback to presentation:
 * Functionality of algorithms must be transparent and shown in tests
 * Provide notifications in the web browser

## 23.10.2023, 18:00 - 19:00: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics

Moritz and Tobias role switch
* Tobias: Documentation coordinator
* Moritz: Test Coordinator

#### Plan overview

* Monday, 18:00: Small summary of what was done during the weekend
  * 30min review, then ...
* Tuesday, 16:00: Sprint review with the tutor
* Friday, 14:00: Sprint Grooming (Everyone summarizes what they have done)

#### Project planning

**Milestones:** Epics - contains multiple tickets

**Labels:** 
1. Sprints - Will contain tickets
2. Story Points

Initiating first issues:
 * User creation
 * Login Page
 * Authorization
 * Create with Figma our first design, based on which functionalities can be derived
 * CI/CD 

#### Commit convention
 * Create Branches with the same name, as made by GitLab under "Issues".

```
[issue-<issue_nr>] short summary

what was implemented
```

#### Language convention

All comments and commits to be done in English.

### TODO's until next week
 * Bartek:
   1. Databases
   2. CI/CD
 * Anna, Moritz, Tobias: Figma Design
 * Moritz, Christoph: Project Planning
 * User Stories: Define all important functionalities

### Questions for next meeting: 
* How to get a time tracking table that provides a summary, just like during SEPM?

## 24.10.2023, 16:00 - 17:00: Weekly Meeting with the Tutor

Present: All, Place: Zoom-Meeting

Important to have a metric, based on which it can be determined if people
are a good match.
 * Points system would be a viable option
 * Anzahl von matches
 * Distanz
 * Interests
   * Maybe add option to weigh, how much an algorithm would determine matches.
     E.g., you don't want to match people say from Vorallberg, even if
     they are perfect, same goes the other way, meaning if the person is from
     Vienna, but does not match at all.

Uncertainty regarding the calendar from the tutor side:
 * Idea: You chat with a person and if you want to schedule a date, you can
   open your calendar and receive suggestions instantly from the application
    * When matching with someone, you can send over the calendar when the meeting
      would occur
    * You could make it more calendar-centric by setting days on which ones
      you would

It would be appreciated if it were also a phone application
 * Flutter
 * React, React Native

If the application would be also a mobile phone, then the elaborate calendar
feature could be left out.

Technology transfer suggestion: 
 * Backend using Java, could be also Python (Flask, FastAPI)
 * Frontend using React, Angular, Svelte, etc.

MR1 Project Contract
 * Presentation of each team member
 * Present each point in the project contract in a PowerPoint presentation

MR2: 2/3 of the project should be finished

MR3: The whole project should be finished and presentable.

Monday, 30.10 - Friday 03.11
Monday till Thursday from 18 o'clock, Friday from 15 o'clock
Official date: Friday 17 - 19 o'clock
1. Alternative date:	Friday 15 - 17 o'clock
2. Alternative date:	Monday	18 - 20 o'clock

### Dates

* IR1 20.11 - 24.11
* MR2 11.12 - 15.12
* IR2 08.01 - 12.01
* MR3 22.01 - 25.01

### TODO's
 * Bartek:
   1. Databases
   2. CI/CD
 * Anna, Moritz, Tobias: Figma Design
 * Moritz, Christoph: Project Planning
 * User Stories: Define all important functionalities

#### New TODO's
 * Slides

## 27.10.2023, 14:00 - 15:15: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics

* Tech Stack
* Strategies / Algorithms
* Project Contract

#### Tech Stack

* **Backend: Python FastAPI**
  * Python Pro's: Simplicity, tutor can help out quickly
  * Python Con's: Potential Spaghetti code
  * Java SpringBoot Pro's: Everyone is familiar with it
  * Java SpringBoot Con's: Over the top complicated
  * Kotlin Pro's: Standard in mobile app development? 
  * Kotlin Con's: Only 1/5 team members familiar with Kotlin 
* **Frontend (mobile + web app): Flutter**
* **Database: PostgreSQL**

##### Responsibilities of Backend & Frontend
* **Backend**
  * Returns a list of people based on the location
  * Retrieves the amount of swipes left for the user
* **Frontend** 
  * Calls for the swipes and the data from the data and would calculate and sort

Querying people based on location has to be done in the database.

Location would be set by the users in the settings

#### Strategies

3 strategies:
1. Distance based strategy (always applied)
2. Interest based strategy
   * For every person we would calculate the preference 
3. Decision based strategy
   * Based on the swipes of a user
   * Would be computed based on, for example, text length, the preferences, etc.

The order in which the people would appear in your area would be randomized.

In order to prove, the tutor suggested that we could use dev mode to have a clearer view of the utilized strategies.
* For now will be omitted for now.

#### Database

User
* Each user has 5 pictures

### TODO's

* Team members should suggest additional attributes or objects
* Project Contract: 
  * Do the part they have been assigned to in the project in the corresponding Latex Project
  * Each team member should add their part to the presentation, after everything is added then finish
    the design
* Python backbone + Flutter frontend to be pushed onto Git

## 30.10.2023, 18:00 - 19:00: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics

* User Stories
* Database Design
* Project Contract

#### User Stories
* Should the functionality to report a user be omitted?
* What is the rating system?
  * A user could rate another user, e.g., from 1-5 stars
  * Should it be left out? Might be challenging to implement

Advanced features:
* Chat
* Algorithms (counts as two)
* Rating
* Mobile App
* Kubernetes Deployment

#### Functional vs. Non-functional requirements
Keep it simple and generic, instead of going too much into detail

#### Implementations by Bartek
##### ingres.yaml
Works like an nginx, is a router. We will have a develop and release version.

### TODO's:
* Everyone writes down within the "Iceberg" section within the Project Contract until Tuesday

### Next meeting

Tuesday, 31.10.2023 during the meeting with the tutor at 16:15, and if necessary, afterwards

## 31.10.2023, 16:15 - 17:15: Weekly Meeting with the tutor

Present: All, Place: In person

### Topics
* How will the presentation occur
* Algorithms
* Which features ought to be pushed to the optional section

#### Presentation
* Not all User Stories should be added to the presentation
* Figma mockups would be greatly appreciated (in other words: a must)
* **IMPORTANT:** How will the rating be in detail?

#### Implementation
* Functionalities such as "filtering messages", whereby they are not a high priority, should be put into a section such
  as "Optional functionalities"
* Careful when defining features:
  * "Easy to use UI" is vague, e.g., just because something is easy for an IT student, does not mean it is going to be 
     for an 80-year old person.
    * Therefore, define what as "easy to use" means, such as we are following standards and which groups of people are expected to be used. 
* Iceberg list should refer to app-relevant features

#### Algorithms
Distance based algorithm: Radius within which people are chosen, the user can pick the radius
* THEN: User can omit other algorithms or add additional algorithms, meaning:
  * Interest-based algorithm: How many interests are the same?
  * Decision-based algorithm: Matching based on what others like
* WHEN algorithms switched is undecided yet, meaning if it is just on one day or one week
* Tutor: Combining interest-based and decision-based might become a bit convoluted

Location would be roughly saved using Google API's for the latitude and longitude, and based on the radius that the user
has provided we would write a query for the longitude and latitude.
* The user would only switch location manually, unlike Tinder, where
* **Tutor:** Add dynamic location as an optional feature

#### How will the MR's influence the grades?
* MR1: 10-20%
* MR2: Slightly more than MR1
* MR3: 50%

#### Branches
One branch per person, meaning you should if more than 1 person is expected to work on a feature, then it should be
divided into further branches.

#### Rating
* Each user could rate another user (e.g., with 1-5 stars), or one could also split the rating system?
* The rating of another person will only occur after the two matched persons have met.

#### Optional features
* Reporting: Could be a simple database entry.
  * Admin feature might be needed to check it out.
  * Could also include a security feature
* **Tutor:** Add dynamic location as an optional feature
* Filtering messages within a chat

#### Does Python/FastAPI have the risk of turning code into spaghetti code quickly?
FastAPI is very good with Dependency Management, as long as object-oriented coding guidelines are upheld it should be fine.
* For Unit-Tests, OOP is required anyway.

### TODO's
* **Tobias:** Wiki + domain model
* **Bartosz, Christoph, Anna:** Figma - Ideally mobile app 
  * Does not have to be Figma, can be PowerPoint too
* **Moritz:** Presentation
* **Together:** Proofread project contract + presentation

#### Plus
Look at SQL model for OEM
* Recommended:AsyncPG, PsychoPG bit more "boring"

### Presentation
Friday, 17:00 o'clock at usual place as the Weekly Meetings with the Tutor

## 02.11.2023, 19:00 - 20:30: Weekly Meeting with the tutor

Present: All, Place: In person

Topics:
* Domain Model/Database Diagram
  * Preferences 
* Presentation

### Domain Model/Database Diagram

### Strategies
#### Distance-based strategy
* Saving location automatically is optional
* Using Google-Maps API, we save the longitude automatically

#### Interest-based strategy
* Fetch n people (n referring to the daily limit) that are within the distance radius

### Presentation
#### Overview over the subjects
Will contain the following parts: 
* Project contract
* Figma design
  * We should decide in the future on the color
* Optional: Algorithms elaborated

#### Dividing slides among members
* 1-5 slides (Introduction - Innovative Ideas): Christoph
* 6-11 slides (Principal Features - Rating): Moritz
* 12-14 slides (Multi-Platform Accessibility​, Architecture): Bartek
* 15-19 slides (database model): Tobias
* 20-23 slides (non-functional requirements): Anna

Then Figma by Bartosz

#### TODO's
* Presentation: Target Audience - Moritz
* PDF/Overleaf: Christoph/Moritz
* Wiki: Tobias

### Meeting before the presentation
* 10:00 online meeting, otherwise meeting at 16:00 at INSO room
* 16:45 meeting before the presentation

## 03.11.2023, 10:00 - 11:00: Weekly Meeting

Present: All, Place: Zoom-Meeting

### Topics
* MR1 Presentation

### MR1 Presentation
* **Christoph**
  * Team
  * Project Idea
  * Innovative Ideas
  * Principal Features
* **Moritz**
  * Principal Features
  * User Management
  * Matching and Discovery
  * Communication
  * Rating System
* **Bartosz**
  * Multi-Platform Accessibility
  * Architecture/Used Technologies
  * Database Diagram
* **Tobias**
  * Database Diagram
  * Non-functional requirements: Performance, Reliability
  * Non-functional requirements: Security
  * Non-functional requirements: Usability
* Bartosz: Figma presentation
* **Anna**
  * Problems & Challenges
  * Risk Assessment - General Risks
  * Risk Assessment - Project-Specific Risks

#### Meeting time for presentation
16:45, 15 minutes before the start of the presentation

## 03.11.2023, 17:00 - 19:00: MR1

Present: All, Place: In person

It's important to get feedback from customers as quickly as possible (often times ignored by start-ups), and in the end
something gets implemented, which is not wanted.
* Therefore, get feedback from the customers quickly.

After each sprint there should be added value for the customer

It is important to have unit and integration tests, in addition revision tests too for new features.
* Through test-protocols provable
* Automated tests + manual tests should be successful with the customer.
  * If the program crashes on the first try, it makes a bad impression.
  * In short: Test properly

The app should be properly implemented, meaning the REST architectural style should be used, as intended
Furthermore there should be a proper layer model, e.g., if the database is integrated too closely to the backend, and you wish to
switch from relational database to another, then it will be tough

PostgreSQL plugin for geolocation might come in handy.

Instead of a 2 second backend response time, we should have as requirement a 95% response success rate

How will be safe against database leaks in detail?
Chats may contain very sensitive information, it would be a good idea to encrypt the messages
 * Solution: Public/Private key structure

Star Rating of other users should be changed to rating simply a user as either "safe"/"not safe":
 * Confirm the rating before the meeting, instead of after
 * When clicking on the button, there should be a confirmation

Kubernetes Deployment:
 * Development Environment
 * Release Environment

### Algorithms
 * Let the user decide, what is important for him/her

### Fetching users
 * Instead of fetching 50 people, fetch 1 person and decide then liking him/her
   * Fetching one by one after each swipe
   * This would allow switching algorithms any time
   * Will this take more time? We could pre-load another person (not fetching for example 10), because
     then the user could extract the data and it is a security concerns

### Further feedback from the assistant
 * Pretty good understanding, is content with the presentation

## 06.11.2023, 18:00 - 19:15: Weekly Meeting

Present: All, Place: In person

### Topics
* Define Sprints
* Diagram
* Insomnia (Postman alternative)
* Rating system
* Photo Implementation
* API-design

## IMPORTANT
* Ask Tutor about moving the weekly meeting with the tutor to fridays

#### Database
Matches
* Needs a "timestamp" entry

#### Sprint #1 (6.11.2023 - 13.11.2023)
* Formulating the most important stories
* Database Implementation in Python
  * Adjust the rating system in the designs
* API Design
* Frontend Backbone
  * Unit Tests
  * Connection to the backend
* Figma design adjustment
* CI/CD

#### Sprint 2 (13.11.2023 - 20.11.2023)
* API Coding

#### Sprint 3
* Chat
  * Requires first Login, Authorization etc. before implementation (dependant on Sprint 2)

#### Distribution of Issues

| Issue                                                                        | People     | Reviewer   |
|------------------------------------------------------------------------------|------------|------------|
| Translating user stories into tickets (Gitlab) + short detailed descriptions | Anna, Tobi | Bartek     |
| Database Implementation in Python                                            | Anna, Tobi | Chris, Mo  |
| API Design (Stoplight)                                                       | Chris, Mo  | Anna, Tobi |
| Frontend Backbone                                                            | Chris, Mo  | Anna, Tobi |
| Figma design adjustment (not priority for Sprint #1)                         | Bartek     | Mo         |
| CI/CD                                                                        | Bartek     | -          |
| Backend/Frontend Onboarding                                                  | All        | -          |

Reviews: Bartek

#### Additional Info
* Friday: Short presentation of the current state of the issue
* Chat encryption
  * Potentially use real time chat API's?

#### Rating System
* Instead of 5 stars, have a button "safe"
  * Additionally, the option to write further elaboration
* Similar to a verification system in Twitter, users would have a label with safe if often labelled as safe
  * Based on the percentage matched/safe
* The "agreement" before the meeting to rate each other before the meeting will not be included

#### Photo Implementation
* Option to see all the pictures a user has on his/her profile.
  * NOT per picture.
* Each user decides for themselves, if they allow the other person to see their images.
  * Per match, not globally.

#### API-design
Main Endpoints:
* User: Login, Create etc.
* Users: Fetch users, algorithms
* Matches: Like someone

#### Further TODO's
* Figma Design
* Change the rating system
* Photos 
  * Users should have the option to pick, whether to be able to see the pics after a match

## 07.11.2023, 16:15 - 17:15: Weekly Meeting with the Tutor

Present: All, Place: In person

### Topics
* Switching date of weekly meeting of tutor
* How should the planning + review be distributed

#### Distribution of weekly's

**Monday:** Planning and review

**Fridays:** Serves the purpose of catching up with the team in regard to the status of each issue a team member is assigned.

#### Ratings-Feature


#### Database
* Can simply use FastAPI/Swagger/SQLModel

#### API-Endpoints
* Give more thoughts to the API's, routes.
* OpenAPI - GenerateClients: Automatically generates the models and endpoints within the frontend for the backend.
  * https://fastapi.tiangolo.com/advanced/generate-clients/

#### What is expected for MR2
* Ticket division into story-points, user stories can be used to assess how much of the project is finished.
* At least 2/3 of the project should be done

#### How should the chat approximately look like in the database?
* Per chat a public-private key
* Message content

## IMPORTANT
Put less emphasis on API's, instead greater focus on the frontend


## 10.11.2023, 14:00 - 15:00: Weekly Meeting with the Tutor

Present: All, Place: Zoom

### Topics
* Current state of each branch within the project
  * Database/Backend
  * Frontend

#### Details
##### Database
* Adjust within database the dependency injections
* Suggestion by tutor: Pydantic methods for the repository layer
* SwaggerUI: Useful tool to generate HTTP methods

##### Frontend
* Uses libraries and dependencies that need to be downloaded

## 17.11.2023, 10:30-11:00: Meeting before "Weekly Meeting with the Tutor"

Present: All, Place: Zoom

### Topics
* Database Setup
* New Issues
* Current Issues

#### Database Setup
* Before the schemas are created, the user needs to create manually the database "development" right now.
  * **NEW ISSUE** 
    * Create database **development** by hand.
    * Automatically reset schema if it is changed.

### NEW ISSUES
* Automatically create the database **development** when running the backend + automatically create the new schemas if
  it is changed, currently needs to be done by hand.

## 17.11.2023, 11:00-11:30: Meeting before "Weekly Meeting with the Tutor"

Present: All, Place: Zoom

### Topics
* Database Setup
* New Issues
* Current Issues
* Each topic a person did

#### Each of the users tasks this week
* Anna: Involvement more next week
* Bartek: JWT-Tokens
* Chris: Frontend Login
* Mo: Algorithms
* Tobias: JWT-Tokens, Matching-refactoring

## 21.11.2023, 18:00 - 19:00: Weekly Meeting with the Tutor

Present: All, Place: Zoom

### Topics
* Tobias
  * Rating system - how does it specifically work?
  * Having next weekly an hour earlier?
* Christoph
  * Frontend - problems if a different phone
  * Frontend - changed layers from feature to layer-based
* Bartek
  * Websockets + chat functionality
* Anna
  * Migrations using alembic
* Moritz
  * Working on Posgresql geolocation functionality

* Planning for next sprint

#### Division of labor
* Bartek: Chat functionality
* Anna: Rating (safe) after MR2
* Tobias: Matching algorithms
* Moritz: Matching algorithms

#### Frontend 
* Use a specific emulator for the frontend
* Changed the layers from a feature to a layer-based feature

#### Chat functionality
* Created a temporary frontend port which showcases real time chat

#### Alembic Migrations
* Basic functionality implemented that automatically adjusts schemas when making changes
* Will do wiki-entries

#### Geolocation Database
* PostGIS used
* PostGIS calculates the latitude, longitude, and the location point
  * These three values would then also be stored within the database
  * Address will still be useful for frontend/display purposes

#### Next Sprint
* Frontend functionality
* Logistic-regression model + test data

#### IR1
* Chat functionality
* Deployment using clusters
* Afterward release-branch

#### New Issues
* Christoph: [backend] location endpoint
* Basic Algorithm Functionality
  * Updating the preferences after each swipe? Or storing it based on different parameters

## 24.11.2023, 14:00 - 15:30: Internal Review

Present: All, Place: In person

### Important note
* This meeting did not influence the grade of the course

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

## 04.12.2023, 18:00 - 19:30: Weekly Meeting

Present: All, Place: Zoom

## Topics
Provide with users the interests also
Presentation
Chat finalization
 * Integration between web-sockets in the frontend 
Routing

## What has each person done?
### Anna
* Location for the user
* Swipe Limits
  * Do not work properly right now (e.g., with 2 swipes 

### Bartek
* Routing on the HOME page required

### Moritz
* Expert system model and backend
* service/user.py

### Tobias
* Adjusting the design for the profile

### Chris
* Concept for the algorithm created
* Planning to create the endpoint

### Misc
* Additional issues that require all of us?
  * For chat there are still issues that need to be designed
* For new ideas, please assign to sprint 5


## 15.12.2023, 14:00 - 15:30: Weekly Meeting with the Tutor

Present: All, Place: Teams

### Overview of Topics
* IR2 is occurring on the 12.01.2024, 14:00
* What needs finishing

#### Needs finishing
* Registration page needs review
* How to upload and save images
* How to implement refresh tokens
* How to upload images over the chat
* Add encryption
* Deleting of profile (not priority as it would require a lot of effort)

##### Roughly ordered
1. Registration
2. Upload of images on profile/registration
3. Upload of images within the chat

#### Should not be started before open issues
* Matches
* Should be the chat with images be provided before encryption?
  * Uploading images should be done BEFORE encryption

#### Tutor suggestions
* If swipe limit reached a locked icon
* If swiping you can see if there are other cards left

#### Potential issues for team members
* Anna: Default picked algorithm - save the user's algorithm he/she picked

#### Manual testing
* Create a wiki-page for manual tests

#### TODO's
* Anna: Default picked algorithm - save the user's algorithm he/she picked
* Chris: Review of Registration Page, if there are no users we display something
* Toby: Registration Endpoint