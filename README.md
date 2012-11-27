# Egg &mdash; the Applicasa Sample App for iOS

This is a sample app provided to show developers what Applicasa looks like in action, and help them see a real example of integrating Applicasa into their applications.

## About Applicasa

Applicasa is a Mobile Game Management Platform that provides developers a series of frameworks and a custom SDK for iOS and Android platforms that provide extensive support for In-App Purchases, Promotions, Analytics, and a customizable backend datastore. You can find out more information at [the Applicasa website](http://applicasa.com).

## About Egg

Egg is an imagined game that shows common scenarios and code samples that developers can learn from and emulate in their own applications.

### What You Will Find in Egg:
1. Integrating the Applicasa SDK and frameworks for iOS
2. Implementing Applicasa's extensive In-App Purchasing support
  * Virtual Currency support &mdash; whereby users use IAP to purchase in-game currency
  * Virtual Goods support &mdash; whereby users use in-game currency to buy virtual items
  * User Inventory &mdash; whereby users can see the virtual items they've purchased
3. Implementing User handling via Applicasa's SDK and Facebook
  * Register new users
  * Login/Logout via Applicasa
  * Login/Logout via Facebook
4. Implementing Promotion handling via Applicasa's Promotion framework
  * Easy-to-use promotions that are triggered by events that happen inside your game

## Getting Started

### Clone the Repository

As usual, you get started by cloning the project to your local machine:

```
$ git clone git@github.com:Applicasa/egg.git
```

### Open and Run Project in Xcode

Now that you have cloned the repo, open the project up in Xcode. At this point, you *should* be able to build and run the project in the iOS Simulator. The project is configured to use the automatic iPhone Developer profile selection inside Xcode. If, for some reason, you experience problems running the app in the simulator, first try checking the **Build Settings** and selecting your local profile.

## iOS Version Targeting

Egg is currently built to take advantage of the latest iOS features. For that reason, the sample app targets iOS 6 only, primarily because it uses new ```UICollectionView``` features, such as auto layout.

**However**, the current Applicasa frameworks and SDK target **iOS 4+**, so don't be worried that you must immediately port your app to iOS 6 to use Applicasa's extensive features. You can still use Egg as a reference for how to implement Applicasa functionality in your game. At some point in the future, Applicasa will continue to move forward, and we'll always let our developers know when this requires moving up in iOS versions.

## Other Remarks

### A Word on Promotions

Promotions can be triggered by events inside your application.

Events that can be triggered inside Egg:
* First-time User
* First-time Virtual Currency Purchase
* First-time Virtual Good Purchase
* Low-balance Promotion

Three types of Promotions you can use in your game:
* Announcements (news updates, new app versions, etc.)
* Deals (special offers on in-app purchases & virtual goods, etc.)
* Rewards (special rewards for completing tasks in the game, etc.)

### Customizing Your Applicasa Application

All customization of IAP items, Promotions, Virtual Currencies, Virtual Goods, and custom data are handled via the Applicsa web console. [Sign up for a private beta account](http://applicasa.com/#Register) to experience more.

<img src="https://github.com/Applicasa/egg/stable/readme_imgs/web-console.png" height="675" width="1279"/>

### Making Test IAP Purchases

Because this is a sandboxed app, you must use a test account to make IAP purchases (for virtual currencies). We have created a test user that can be used with the app as-is. The credentials are:

* username: eggtest@applicasa.com
* password: EggTest1

### A Word on Branches

Egg is, like any Github project, a constant work-in-progress. This means that you will, if you look, notice there are other branches. We recommend that all developers who are new to Applicasa and just getting their feet wet with the SDK and frameworks stick to the ```stable``` branch only. The ```master``` branch is our main development branch, and all other branches are feature-specific branches that are currently under development and will be merged into ```stable``` when they are tested and ready. You may check out these branches at any time if you want to see other feature work and examples of how to implement those in your game (where applicable), but be aware that we don't support any branches other than ```stable``` at this time (for issues and whatnot).

### Having Trouble?

Please feel free to submit issues with any bugs or other unforseen issues you experience. We work diligently to ensure that the ```stable``` branch is always bug-free and easy to clone and run from Xcode. If you experience problems, open an issue describing the problem and how to reproduce it, and we'll be sure to take a look at it.
