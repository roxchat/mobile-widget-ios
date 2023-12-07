# RoxChatMobileWidget

## What is it?
This library provide simple chat integration, that based on [RoxchatClientLibrary](https://github.com/roxchat/mobile-sdk-ios/).

## Installation

### CocoaPods
Currently not available.

### SPM
1. Select File > Swift Packages > Add Package Dependency. Enter `SOME URL (in progress)` in the "Choose Package Repository" dialog.
2. In the next page, specify the version resolving rule as "Up to Next Major" with the latest `roxchat-mobile-ui-ios` release.
3. After Xcode checking out the source and resolving the version, you can choose the "RoxchatClientLibrary" library and add it to your app target.

### Carthage
Add following line to your **Cartfile**:
```
SOME URL (in progress)
```


### Important info
If you want to use framework in extension, you must set Preprocessor Macros.
1) Click Build Settings
2) Find (or search) Preprocessor Macros under Apple LLVM 6.0 - Preprocessing
3) Add TARGET_IS_EXTENSION or any other name of your choice in both the debug and release sections.
Notice that some functions not allow when you use app extension.


## Usage

#### Add selected code to AppDelegate.swift ####
*This code prevent incorrect keyboard behaviour.*
```
    func applicationDidEnterBackground(_ application: UIApplication) {
        WidgetAppDelegate.shared.applicationDidEnterBackground()
    }
```

#### Set session configuration with associated `WMSessionConfig` object. ####
*You must call this method for correct behaviour of Widget*
```
WMWidgetBuilder.set(sessionConfig:)
```

#### Set configuration's for Widget viewControllers ####
*If you skip calling this methods Widget will be use default configurations for these viewControllers.*
```
WMWidgetBuilder.set(chatViewControllerConfig:)
WMWidgetBuilder.set(imageViewControllerConfig:)
WMWidgetBuilder.set(fileViewControllerConfig:)
``` 

#### Call `WMWidgetBuilder.build()` method for getting Widget that represents by UIViewController class. ####
*See example for more informtaion.*

## License

RoxchatWidget is available under the MIT license. See the LICENSE file for more info.
