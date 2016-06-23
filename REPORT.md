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

## Challenges

## Week 1
Onderwerp gekozen. App maken voor events, instagram met alle genodigden. Tekeningen gemaakt en gekozen voor de dropbox API. Gekozen dat je enkel kan inloggen en je naam geven als MVP. Niet erg veilig, als option nog facebook login bijvoegen. 

Tijdens de groepssessie hebben we gebrainstormd over een naam --> Packtag. Ook hebben we gesproken over de privacy van de gebruikers, omdat de functie misschien redelijk anoniem is. Het opslaan van de foto's is bij deze app ook een probleem dus we hebben het hier ook weer over gehad. Vervolgens ben ik begonnen met de UML maken in creately. 

Bedacht dat camera ook een API is, dus readme aangepast. 
Bezig met de opdracht van vandaag. UML loop tegen classes aan, welke zijn nou echt nodig. Vervolgens ook nog de installatie van Dropbox ging niet goed. Hebben we opgelost, door middel van tekst bestand toe te voegen aan xcode map. nu dropbox API goed geinstalleerd, problemen met de openen van de verkeerde workspace, moet andere workspace openen. 
Ook MVP aangepast, dus de readme oook aangepast. 

Besloten om in plaats van Dropbox toch de API firebase te gebruiken. Waren problemen met of gebruik eigen account (voordeel : veel opslag, nadeel : risico eigen bestanden openbaar, mischien per ongeluk dingen wissen) of gebruik nieuw account (voordeel : kan niks mis gaan is niet erg als dingen gewist worden tijdens het project, nadeel : weinig opslag ) Firebase maakt gewoon nieuwe databse aan --> handiger.  Readme aangepast. Vervolgens schermen geimplementeerd met handmatige knoppen onderaan scherm. veel heen en weer navigatie tussen schermen, kijken of dit makkelijker kan 

Code review gehad. Verteld dat dropbox niet meer nodig was, veel ingelezen over firebase. wordt nog wel lastig te implementeren waarschijnlijk. Bedacht dat de structuur van mijn schermen makkelijk zou moeten kunnen

## Week 2
Gelezen dat tapbar controller handiger mooier en handiger is dan zelf ingesteld plaatjes. gehele storyboard vervangen, nu veel overzichtelijker. nog een probleem met verschillende devices. Ik zoek eigenlijk een soort view die schaalt per device terwijl de verhoudingen hetzelfde blijven tussen items. Nu maakt het programma bij profile op iphone 6 een goed beeld maar iphone 4 valt alles weg. met julian besproken moet misschien stackviews gebruiken, echter eerst verder aan code werken later pas layout. 

beginnen met coderen opzetten van post and profile models en views. Classes aangemaakt om dingen op te slaan van users en van posts. ook een functie gemaakt om nieuwe users aan te maken. UITable view cell aangemaakt om de feeds te laten zien. profile controller begonnen op te zetten. dat was redelijk te doen, echter de feeds controller stuk lastiger. 

veel gezeur gehad met nog een header table view cell erbij te maken. dit omdat xcode steeds dacht dat ze dezelfde identifier hadden terwijl dit niet het geval was. xcode moeten afsluiten en weer opstarten om fout weg te krijgen. maken van de feeds controller leverde veel gezeur op. je wilt dat de feeds in omgekeerde volgorde getoont worden, dan ze worden geupload. uiteindelijk denk ik juiste formule alleen kan het niet checken. heb wel een hardcode in de delegate gezet om  te checken of de table view werkt. die werkt wel. ben in twijfel of ik nt als echte instagram een pop-up screen wilt als je op camera klikt of dat dat niet nodig is. 
probeer eerst zonder.

Goede dag gehad. Camera werkende en geeft alles door aan volgende view. posts worden ook opgeslagen met de juiste caption en de juitse gebruiker en de juiste foto. layout veranderd wel als je op kruisje drukt na het kiezen vane een foto --> probleem voor laatste week. de wall werkt nu helemaal behalve dat je niet kan liken en commenten --> zit niet in mvp dus zorg voor later

presentatie, besproken of ik met weddingid moet werken of het prive te maken. eerst mvp dus met weddingid. bedacht dat er nu wel echt schot achter de zaak moet gaan komen. 

## Week 3
Firebase proberen te implementeren. Veel verschillende documentatie want is net vernieuwd. weer terug gegaan naar dropbpox, want in hour of code veel mensen gehoord die niet uit firebase kwamen en er al dagen mee bezig waren. dropbox heeft een relatief simpele API. Proberen te implementeren. kan nu 1 foto laten zien uit dropbox echter als ik ze alemaal probeer te laten zien kan hij een optional niet uitpakken.

optional kan nu wel worden uitgepakt. opletten als er bestanden in staan met een ander type dan jpg of een verkeerde naam crasht de app nog. dit mag niet het geval zijn.. week 4 fiksen. er is nu nog een probleem met dingen uploaden. kan nu enkel textbestanden uploaden terwijl ik een foto moet uploaden --> misschien hour of code vragen of andere ook dit probleem hebben

in hour of code gevraagd of mensen misscien mij konden helpen. goed geholpen goede documentatie gevonden.
kan nu per ingelogde user in verschillende mappen foto;s laten zien en uploaden. heel lang met jaap aan een syntax probleem van dropbox gezeten uiteindelijk opgelost. probeer nu verschillende evenementen aan te maken maar ben het nog niet helemaal eens met de structuur.

Nu verschillende evenementen proberen te implementeren maar structuur is lastig . gevraagd aan de hour of code en overwegingen user te hardcoden biedt een oplossing. 
Loop tegen groot probleem aan. 2 users moeten worden ingelogd want ik wil via het packtag account met de user een gedeelde map maken zodat er ook direct een dropbox map op je computer staat zodat je geen foto's van het gehele event nog moet navragen aan iedereen. er moet dus 1 user (de pactagapp user) worden gehardcoded in het programma. De addMember van Dropbox is depreciated en ze geven geen alternatief dus het linken van de 2 users lukt niet. durf niet te committen want bang dat ik werkende code verlies. 

eerst functionaliteit regelen --> bugs komt later. 

## week 4
Eerst verder gegaan met rest van de app. profile users aangemaakt als goed wordt opgeslagen laadt nu de juiste profielfoto, echter nog niet direct als je hem hebt veranderd. zit ook lange vertraging in weet niet hoe ik dat sneller kan maken. nog gezeur gehad met als je je eigen profiel aan tikt mag je wel je photo edditten en als je ander mans profiel foto aanklikt mag dat niet. verder als er dus al een bestand met die naam bestaaan verwijder je eerst de ouder profielfoto en vervolgens de nieuwe.

gewerkt aan dat mensen hun naam kunnen aantikken en dat ze dan in de goede profielfoto komne. lukte niet om de indextabel nummer te krijgen dus manier eromheen gewerkt. er staat nu een onzichtbare label naast de naam van de user met het profielid. deze kan hij namelijk als de naam van de user wordt aangetikt wel ophalen zodoende hebben we de profielid en kunnen er in het systeem mensen met dezelfde naam bestaan. 

geprobeerd op te lossen dat de 2 users naast elkaar bestaan. Dit is uiteindelijk gelukt. ik krijg nu een user in het bestand en er wordt meteen een shared folder aangemaakt. deze moest je eerst in je mail accepteren en dan pas zou het werken, nu ook ingeprogrameerd dat er meteen wordt geaccepteerd dat je dit bestand in je dropbox wilt. dus er wordt nu met inloggen meteen gelinkt aan je folder en deze folder wordt direct in je dropbox gezet. er wordt gecheckt of het eventid bestaat en er wordt gecheckt of bij het aanmaken van een event het eventid niet al bestaat.

## Defend Descissions
After all it was good to use the dropbox API. With Firebase you wont be able to get a cursor in order to only refresh the feed. You need to refresh the entire feed, which will cost alot of data and storage. Though this method has also some disadvantages. Everybody is able to view and edit the folder on their computer, so people can delete the entire folder if they want to do harm. Also the security check with only an unique eventId is not good enough. You'll need to create a list of people who can view certain events. this list need to be made by the creator. Also the feeds aren't showed in the correct order, this will be handy if a database get's larger, so you don't have tp show all.


