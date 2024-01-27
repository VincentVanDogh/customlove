## Testing 
The following section outlines a precise set of test cases designed to comprehensively evaluate the functionality and user experience of the Custom Love app. Each test case is categorized into specific aspects of the application, including Login, Swiping, Registration, and Chat. These test cases aim to ensure the robustness, reliability, and user-friendliness of the app across various scenarios.

#### Global Pre Requirements
- The app is installed on a compatible device with the latest version.
- The user's device has sufficient battery power or is connected to a power source.
- User has a stable internet connection
- User allows Location tracking

#### Login
<!-- This is one Test Case section -->
<details>
<summary> 1. Valid Credentials Login: </summary>

###### Pre Requirement
- User is already registered on the platform.

###### Test
- Launch the application.
- Navigate to the login screen.
- Enter a valid email address in the email field.
- Enter the corresponding password in the password field.
- Click or tap the 'Sign In' button.

###### Post Requirement
- User's location is being tracked as per the app's functionality (verify if necessary).
- User's session is started and maintained.
- User can view and interact with the swiping stack.
- User's login state is persisted when navigating to different sections of the app or after minimizing the app.
</details>

---

<!-- End Test Case section -->

<!-- This is one Test Case section -->

<details>
<summary> 2. Invalid Password Login: </summary>

###### Pre Requirement
- User is already registered on the platform.

###### Test
- Enter the registered email address in the email field.
- Enter an incorrect password in the password field.
- Click the 'Sign In' button.

###### Post Requirement
- Display a "Wrong Password" pop-up notification.
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->

<details>
<summary> 3. Invalid Email Login: </summary>

###### Pre Requirement
- No user registered with this email.

###### Test
- Enter email and password.
- Click the 'Sign In' button.

###### Post Requirement
- Display a "Wrong Email" pop-up notification.
</details>

---
<!-- End Test Case section -->


#### Swiping

<!-- This is one Test Case section -->

<details>
<summary> 1. Swipe Left/Right Distance-Based: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new swipe card
- Swiping timer is reset
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 2. Swipe Left/Right Interest-Based: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new swipe card
- Swiping timer is reset
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->

<details>
<summary> 3. Swipe Left/Right Decision-Based: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new swipe card
- Swiping timer is reset
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->

<details>
<summary> 4. Swipe Left/Right Distance-Based → Match: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired
- Other User liked this user

###### Test
- User clicks like button

###### Post Requirement
- User gets Notification that the other User liked him/her too
- User can discard
- User can open conversation
- Swiping timer is reset

</details>

---
<!-- End Test Case section -->



<!-- This is one Test Case section -->
<details>
<summary> 5. Swipe Left/Right Interest-Based → Match:</summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired
- Other User liked this user

###### Test
- User clicks like button

###### Post Requirement
- User gets Notification that the other User liked him/her too
- User can discard
- User can open conversation
- Swiping timer is reset

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 6. Swipe Left/Right Decision-Based → Match: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired
- Other User liked this user

###### Test
- User clicks like button

###### Post Requirement
- User gets Notification that the other User liked him/her too
- User can discard
- User can open conversation
- Swiping timer is reset

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 7. Swipe Left/Right Distance-Based → No Swipes Left: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new card with the following text "Sorry - No Swipes Left"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 8. Swipe Left/Right Interest-Based → No Swipes Left: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new card with the following text "Sorry - No Swipes Left"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 9. Swipe Left/Right Decision-Based → No Swipes Left: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees new card with the following text "Sorry - No Swipes Left"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 10. Swipe Left/Right Distance-Based → No User in Radius: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees card with the following text "No users in the area"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 11. Swipe Left/Right Interest-Based → No User in Radius: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees card with the following text "No users in the area"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 12. Swipe Left/Right Decision-Based → No User in Radius: </summary>

###### Pre Requirement
- User is logged in
- Swiping timer is expired

###### Test
- User clicks reject/like button

###### Post Requirement
- User sees card with the following text "No users in the area"
- User can not swipe this card
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 13. No Swipes Left → Reset Swipe Limit → Swipe Left/Right Distance-Based: </summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "Sorry - No Swipes Left"

###### Test
- User is waiting one day

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 14. No Swipes Left → Reset Swipe Limit → Swipe Left/Right Interest-Based: </summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "Sorry - No Swipes Left"

###### Test
- User is waiting one day

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 15. No Swipes Left → Reset Swipe Limit → Swipe Left/Right Decision-Based: </summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "Sorry - No Swipes Left"

###### Test
- User is waiting one day

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 16. No User in Radius → Increase Radius → Swipe Left/Right Distance-Based:</summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "No users in the area"

###### Test
- User increases search radius

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 17. No User in Radius → Increase Radius → Swipe Left/Right Interest-Based: </summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "No users in the area"

###### Test
- User increases search radius

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 18. No User in Radius → Increase Radius → Swipe Left/Right Decision-Based: </summary>

###### Pre Requirement
- User is logged in
- User sees card with the following text "No users in the area"

###### Test
- User increases search radius

###### Post Requirement
- User gets swiping cards
</details>

---
<!-- End Test Case section -->

#### Registration

<!-- This is one Test Case section -->
<details>
<summary> 1. Valid Registration: </summary>

###### Pre Requirement
- User is not registered yet

###### Test
- User clicks on "Register now"
- Users Location gets fetched
- User clicks "Next"
- User sets a valid Search Radius
- User clicks "Next"
- User enters his First Name, Last Name, Email, Password
- User clicks "Next"
- User enters Gender, Preference, Birthday
- User clicks "Next"
- User sets Profile Pictures
- User clicks "Next"
- User sets interests between 3 and 5
- User clicks "Next"
- User sets Profile Bio
- User clicks "Next"
- User sees Profile summary
- User clicks "Submit"

###### Post Requirement
- User is now registered
- User sees the Onboarding page

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 2. Invalid Email Format:</summary>

###### Pre Requirement
- User clicks on "Register now"
- App retrievs location
- User clicks on "Next"
- User sets search radius
- User clicks on "Next"
- User is on Profile Name page

###### Test
- User enters an invalid Email format
- User clicks "Next"

###### Post Requirement
- User gets "Invalid email format" notification 
- User is still on the Profile Name page

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 3. Duplicate Email: </summary>

###### Pre Requirement
- User clicks on "Register now"
- App retrievs location
- User clicks on "Next"
- User sets search radius
- User clicks on "Next"
- User is on Profile Name page

###### Test
- User enters an already existing Email 
- User clicks "Next"

###### Post Requirement
- User gets "Email already exists" notification 
- User is still on the Profile Name page

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 4. Profile Picture Upload: </summary>

###### Pre Requirement
- User clicks on "Register now"
- App retrievs location
- User clicks on "Next"
- User sets search radius
- User clicks on "Next" to Profile Pictures page

###### Test
- User clicks on image to upload image
- User uploads image

###### Post Requirement
- User sees image displayed on the Profile Pictures page

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 5. Age Verification: </summary>

###### Pre Requirement
- User clicks on "Register now"
- App retrievs location
- User clicks on "Next"
- User sets search radius
- User clicks on "Next" to Profile Details Page

###### Test
- User clicks on Birtday
- User sees Calender to choose Date
- Only dates are choosable where the person is already 18
- User chooses date

###### Post Requirement
- User sees birthday on Profile Details page 

</details>

---
<!-- End Test Case section -->


#### Onboarding

<!-- This is one Test Case section -->
<details>
<summary> 1. User performs Onboarding: </summary>

###### Pre Requirement
- User has finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User swipes all users
- User sees "All Set!" page
- User clicks on next arrow
- User sees "Discover Your Match, Your Way!" page
- User clicks on next arrow
- User sees "Take Your Time to Connect" page
- User clicks on next arrow
- User sees "Limited Swipes, Unlimited Conections!" page
- User clicks on next arrow
- User sees "Congratulations!" page
- User clicks on "Done"

###### Post Requirement
- User finished the Onboarding
- User lands on his swiping page

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 2. Swipe full swipe stack: </summary>

###### Pre Requirement
- User has finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User swipes one user
- User sees "All Set!" page
- User clicks on next arrow
- User sees "Discover Your Match, Your Way!" page
- User clicks on next arrow
- User sees "Take Your Time to Connect" page
- User clicks on next arrow
- User sees "Limited Swipes, Unlimited Conections!" page
- User clicks on next arrow
- User sees "Congratulations!" page
- User clicks on "Done"

###### Post Requirement
- User gets "Not so fast. You still have some cards to swipe." notification
- User can go back to the "Swiping Stack" page and swipe the remaining cards

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 3. Swiping Stack page - User takes divers as preferred ones: </summary>

###### Pre Requirement
- User has selected divers as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the divers gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the divers gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 4. Swiping Stack page - User takes women as preferred ones: </summary>

###### Pre Requirement
- User has selected women as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the women gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the women gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 5. Swiping Stack page - User takes men as preferred ones: </summary>

###### Pre Requirement
- User has selected men as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the men gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the men gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 6. Swiping Stack page - User takes men and divers as preferred ones: </summary>

###### Pre Requirement
- User has selected men and divers as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the men or divers gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the men or divers gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 7. Swiping Stack page - User takes divers and women as preferred ones: </summary>

###### Pre Requirement
- User has selected women and divers as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the women or divers gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the women or divers gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 8. Swiping Stack page - User takes men and women as preferred ones: </summary>

###### Pre Requirement
- User has selected men and women as gender preferences and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of the men or women gender

###### Post Requirement
- User can swipe
- User is only suggested test users of the men or women gender 

</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 9. Swiping Stack page - User takes all genders as preferred ones: </summary>

###### Pre Requirement
- User has selected all genders preferred ones and finished succesfully the registration

###### Test
- User sees "Welcome to CustomLove" page
- User clicks on next arrow
- User sees "What is CustomLove?" page
- User clicks on next arrow
- User sees "Its not About Looks!" page
- User clicks on next arrow
- User sees "Personalized Matches Await!"
- User clicks on next arrow
- User is on "Swiping Stack" page
- User sees a swipe card with a test user of all genders

###### Post Requirement
- User can swipe
- User is suggested test users of all genders 

</details>

---
<!-- End Test Case section -->


#### Profile

<!-- This is one Test Case section -->
<details>
<summary> 1. Changes on Profile page are stored: </summary>

###### Pre Requirement
- User is logged in
- User navigates to the Profile page

###### Test
- User modifies his bio
- User clicks on "Confirm changes" 
- User clicks on "Logout"
- User logs in
- User navigates to Profile page

###### Post Requirement
- User sees his modified bio
 
</details>

---
<!-- End Test Case section -->


#### Chat

<!-- This is one Test Case section -->
<details>
<summary> 1. Chat Initiation: </summary>

###### Pre Requirement
- User clicks on "Chat"
- User sees his Matches
- User clicks on a Match

###### Test
- User clicks on text box and types a message
- User sends message

###### Post Requirement
- User sees message appearing in chat
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 2. Send Text Message: </summary>

###### Pre Requirement
- User clicks on "Chat"
- User sees his Matches
- User clicks on a Match

###### Test
- User clicks on text box and types a message
- User sends message

###### Post Requirement
- User sees message appearing in chat
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 3. Image Attachment in Chat: </summary>

###### Pre Requirement
- User clicks on "Chat"
- User sees his Matches
- User clicks on a Match

###### Test
- User clicks on "image" icon to send a picture
- User chooses an image
- User sends image

###### Post Requirement
- User sees image appearing in chat
</details>

---
<!-- End Test Case section -->


<!-- This is one Test Case section -->
<details>
<summary> 4. Preview of the latest message: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone

###### Test
- Under the name of each recipient, there should be a message (or part of a message) shown

###### Post Requirement
- The message displayed is really the latest message in that conversation
- If the message is longer than 40 characters, it is abbreviated with *...*
- If there are no messages in the conversation, *no messages* is displayed

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 5. Preview of the latest message gets automatically updated: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)

###### Test
- Under the name of each recipient, there should be a message (or part of a message) shown
- Person x sends the user a message

###### Post Requirement
- The message preview should be automatically updated

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 6. The images in the chat are properly displayed: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)
- User previews a conversation with person x
- Person X sends a picture

###### Test
- Wait for the image to be received by the end device

###### Post Requirement
- The picture is displayed with no overflow and it does not cripple any chat functionalities (like scrolling)

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 7. Image gallery: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)
- User previews a conversation with person x
- Person X sends a picture

###### Test
- Wait for the image to be received by the end device
- Click on the image

###### Post Requirement
- The picture is displayed in a gallery view, so that the user can see the whole image

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 8. Send a new image from the camera: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)
- User previews a conversation with person x

###### Test
- Send a picture newly taken from the camera

###### Post Requirement
- The picture is delivered to both users

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 9. Send a new image from the gallery: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)
- User previews a conversation with person x

###### Test
- Send a picture from the gallery

###### Post Requirement
- The picture is delivered to both users

</details>

---
<!-- End Test Case section -->

#### Notification system

<!-- This is one Test Case section -->
<details>
<summary> 1. Log into the 11th device </summary>

###### Pre Requirement
- User is logged in, in 10 sessions

###### Test
- User logs in, in the 11th session

###### Post Requirement
- Oldest session of the User gets closed

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 2. User gets logged out when the webSocket connection is broken </summary>

###### Pre Requirement
- User is logged in
- Somehow the backend is no more reachable

###### Test
- Wait approximately 10s.

###### Post Requirement
- The user is automatically logged out

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 3. Automatically receive new conversations: </summary>

###### Pre Requirement
- User is logged in, has a match with someone (person x)

###### Test
- Person x starts a conversation with the user

###### Post Requirement
- User sees the newly open conversation without manually refreshing the app

</details>

---
<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 4. *You've got a match* notification: </summary>

###### Pre Requirement
- User is logged in, has already liked someone (person x)

###### Test
- Person x likes the user

###### Post Requirement
- User sees a notification about the new match

</details>

---
<!-- End Test Case section -->


<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 5. *You've got a match* notification: </summary>

###### Pre Requirement
- User sees a notification about the new match

###### Test
- Click "Say Hi"

###### Post Requirement
- Chat page is shown 
- Created conversation with the new match

</details>

---
<!-- End Test Case section -->

<!-- End Test Case section -->

<!-- This is one Test Case section -->
<details>
<summary> 6. *You've got a match* notification: </summary>

###### Pre Requirement
- User sees a notification about the new match

###### Test
- Click "Dismiss"

###### Post Requirement
- Swipe page is shown 
- New match visible on chat page 

</details>

---
<!-- End Test Case section -->
<!-- This is one Test Case section -->
<details>
<summary> 7. Messages are being delivered automatically: </summary>

###### Pre Requirement
- User is logged in, has a conversation with someone (person x)

###### Test
- Person x sends the user a message

###### Post Requirement
- User sees receives the message without having to refresh the app

</details>

---
<!-- End Test Case section -->