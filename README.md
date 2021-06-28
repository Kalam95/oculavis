# oculavis
Test Assignment 
 **This repo contains 2 sub branches**

## 1. pokemon_assignment:
* It contains an assinment(Get Data from API and show list) using **MVVM**. 
* Since its a small project some of network layer files are not used but created to showcase that how would i do those things if requried for example: SessionManager, SSLHandler.
* Comments are made on all required places, in general the properties and functions names are self descriptive.
* I made the project testable easily via mocks using protocols, but the test tasget was not included in the given projject so, i then ignored to write test cases and also the its was a simple assignemnt which in general do not require any testing[unit and UI testing]

## 2. debugging_test_websocket: 
* Its was an already created project but having number of bugs.
* I have resolved, crashes, duplicay, retain cycles within the code, UI issues, other memory leaks. I used profiling(alloocations and leacks from instruments), Memory graph from Xcode and UISnapshot or ViewHirarchy via XCode tools.
* UI issues in image view for earth image(gfetting added again and again with wrong constraints)-> moved image to niv and removed contentview 
* ButtonConnect Action was not connect to nib in the code --> crash resolved
* UI Update of background thread resolved - creash resolved
* Added auto returna and dismisskeyboard when send is tapped or return/done on keyboard is tapped
* Updated visibility flag for websocket and QuestionAnswers [isHidden] -> condition was whrong in one call all were hiddeden now resolved
* Listner for message was called twice
* Delete was a strong refrence for websockect - made it weak and now the retain cycle is resolved
* while disconnecting websocket was being holded by contoller as it was global so not getting released --> memory leaks resolved
* Question and answers both were holding each other and making memoy cycles --> resolved by making them as Struct and removed question linking from answers as it was not required
* ViewDidLoad was callong ViewLoaded, which was not allowed and app was crashing -> crash resloved

### imporvements
* code indentations

### Skipped Things(can be imporved)
* Code restructing, right now everything is in same call
* Proper layering of network and locics and data models
