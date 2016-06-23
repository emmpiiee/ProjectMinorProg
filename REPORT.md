# ProjectMinorProg

## Summary app
This app is a new kind of social media. Celebrate your event with all your guests closeby. The app is a way to capture guest photos and keep your guests up to date. It directly creates a folder in your Dropbox so you don't need to go after all your guests for the pictures.

![alt text](https://github.com/emmpiiee/ProjectMinorProg/blob/master/doc/Schermafbeelding%202016-06-23%20om%2022.55.44.png "Logo Title Text 1")

## Technical design
A design of the model that is implemented:
![alt text](https://github.com/emmpiiee/ProjectMinorProg/blob/master/doc/Schermafbeelding%202016-06-23%20om%2023.23.40.png "Logo Title Text 1")
if a user first uses the app, it will create an eventId. Long eventIds won't be allowed and spaces in the eventId neither, this because it can lead to confusion. after a correct name (and unique name) for a folder is chosen, the app will create a folder and make it a  shared foder with the corresponding name. Also a welcome image will be made as a start of the wall.

Secondly the user is asked to fil in an eventId that is received. While someone fills in an event and presses log in with dropbox the  program will tell if the eventid is in the list of files of the packtagapp. if not it warns the user. if it is in the files it will make a folder in the user it's own dropbox. this may take a while, so a dealy is build in.

Further the user will be led to the feed.
