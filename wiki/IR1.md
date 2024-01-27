# The functionality delivered by IR1:
1. The code that has been deemed 'ready' for the `Internal Review 1` is frozen on the branch `release-ir1`
2. Ready Functionality:
  - jwt authorization
  - login page
  - [backend] chat functionality (without message encryption)


# How to test the application:
Please use those urls (behind the TU VPN):
- https://23ws-ase-pr-inso-06.apps.student.inso-w.at/release/backend [backend endpoints]
- https://23ws-ase-pr-inso-06.apps.student.inso-w.at/release/app [frontend]

## Login page
You are welcome to test our login page with those test credentials:
- alfa.alfonson@email.com
- pass1

## Chat
You can also test our webSockets live messaging functionality using a testing endpoint (which will be deleted when the frontend chat functionality is ready). There is a dummy conversation between users alfa.alfonson@email.com and bravo.bravonson@email.com. Using at least two browser windows visit those sites:
- https://23ws-ase-pr-inso-06.apps.student.inso-w.at/release/backend/messages/socket/test?username=alfa.alfonson@email.com&receiver_username=bravo.bravonson@email.com (alfa.alfonson's (user.id 1) perspective)
- https://23ws-ase-pr-inso-06.apps.student.inso-w.at/release/backend/messages/socket/test?username=bravo.bravonson@email.com&receiver_username=alfa.alfonson@email.com (bravo.bravonson's (user.id 2) perspective)


You can send messages between users 1 and 2 and see that they're being delivered live. You can also open multiple browser windows with one user's perspective (as if this user was logged in on multiple devices at once) and see that the messages are being delivered on all windows simultaneously. Please keep in mind that this demo does not fetch the old messages from the db, it only displays those which could be delivered live.
