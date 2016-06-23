# ProjectMinorProg

## Summary app
This app is a new kind of social media. Celebrate your event with all your guests closeby. The app is a way to capture guest photos and keep your guests up to date. It directly creates a folder in your Dropbox so you don't need to go after all your guests for the pictures.

![alt text](https://github.com/emmpiiee/ProjectMinorProg/blob/master/doc/Schermafbeelding%202016-06-23%20om%2022.55.44.png "Logo Title Text 1")

## Technical design
A design of the model that is implemented:
![alt text](https://github.com/emmpiiee/ProjectMinorProg/blob/master/doc/Schermafbeelding%202016-06-23%20om%2023.23.40.png "Logo Title Text 1")
if a user first uses the app, it will create an eventId. Long eventIds won't be allowed and spaces in the eventId neither, this because it can lead to confusion. after a correct name (and unique name) for a folder is chosen, the app will create a folder and make it a  shared foder with the corresponding name. Also a welcome image will be made as a start of the wall.

Secondly the user is asked to fil in an eventId that is received. While someone fills in an event and presses log in with dropbox the  program will tell if the eventid is in the list of files of the packtagapp. if not it warns the user. if it is in the files it will make a folder in the user it's own dropbox. this may take a while, so a dealy is build in.

Further the user will be led to the feed. it may take a while untill all feeds will be downloaded, but the app can already be used while  it will be busy downloading. it will download a list of images in the current eventId and if the character ' is 5 times in the name, it will make the picture a part of the wall. The string before the first ' will correspond to the user uploader it's name, the string after that to the caption and the string after that to the uploaders userId

If the users clicks on the photoICon, a user has the choice to select a photo or make a photo. Both options have a photoPicker  which makes sure the user is able to choose a photo from his library or make a photo directly in the app, and return to the photoController . if a picture is chosen a button appears to go to the caption controller.

In the caption controller a user can edit a caption to his photo, consisting of mostly 35 characters. any string which is longer will be cut off. it will upload the photo with the same name building as we download the photo. 

in the profile the controller searches for names with 2 ' inside. when it is found it will check if profile id corresponds to one, if so it will show it as profile picture if not it will remain empty. if the profile you'd like to see is your own profile you'll be able to edit your profile picture, if you do so a similiar view as in the cameracontroller will open, and you'll be able to change your profilePhoto.

##

