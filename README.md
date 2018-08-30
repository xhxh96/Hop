# Hop

Hop is an iOS mobile app that assists users in looking for the cafés that they need. Users are able to search for cafés either using keyword or via location.

The key features of the app are posting of reviews for cafés and updating of café information such as address and amenities.


## Getting Started

The app is fully written in Swift 4.1, targeted to run on iOS 11.4, although the app should work for any iOS devices running iOS 9.0 and above.

The app is however not universal and is thus not officially supported on iPad. 

Backend system of this mobile app is running on MongoDB + NodeJS and managed by @elstonayx. For updates and development of the backend system, please access the GitHub repo [here](https://github.com/elstonayx/hopdbserver)


### Prerequisites
* iOS device running iOS 9.0 and above


## User Guide
The mobile app can be used with and without an account being created (guest mode)


### Creating an Account
Account can be created selecting Sign In, followed by Create an Account. 

Account details are stored in our backend server, with the password being hashed via bcrypt.


### User Profile
User Profile can only be accessed after user has logged in via the main page.

Under User Profile, user can edit the profile information and view all the reviews submitted. 

Review management are also done using the User Profile.


### Café Search
To begin café search, select the search bar in the main page. 

User will then be brought to the search result table. By default, the results will show cafés that are near the user. 

Selecting the café in the search result will bring user to the café page. 



## Deployment
Deployment of the backend system can be found in the backend server repo. 


## Built With
* XCode 9.4.1
* [Swift 4.1](https://github.com/apple/swift)
* [Carthage](https://github.com/Carthage/Carthage) - Dependency Management (Version 3.4 and prior)
* [Cocoapod](https://cocoapods.org/) - Dependency Management (Version 3.5 onwards)

Third-Party Dependencies:
* [HCSStarRatingView](https://github.com/hsousa/HCSStarRatingView)
* [ScalingCarousel](https://github.com/superpeteblaze/ScalingCarousel)


## Versioning
Git

## Authors
* **Cheng Xianhao** - *Front-End Developer* - [xhxh96](https://github.com/xhxh96)
* **Elston Aw** - *Back-End Developer* - [elstonayx](https://github.com/elstonayx)


## Acknowledgments
* [School of Computing, National University of Singapore](https://www.comp.nus.edu.sg)
