# Tuya Smart Sweeper iOS SDK

[中文版](README-zh.md) | [English](README.md)

## Features Overview

Tuya Smart Sweeper iOS SDK is based on the [Tuya Smart Home iOS SDK](https://github.com/TuyaInc/tuyasmart_home_ios_sdk)(The following introduction is: Home SDK), which expands the interface package for accessing the related functions of the sweeper device to speed up the development process. Mainly includes the following functions:

- Streaming media (for gyro or visual sweepers) universal data channel
- Data transmission channel of laser sweeper
- Laser sweeper real-time / historical sweep record
- Sweeper universal voice download service

> The laser sweeper data is divided into real-time data and historical record data. Both types of data include map data and path data, which are stored in the cloud in the form of files. Among them, the map and path of real-time data are stored in different files, and the map and path of historical data are stored in the same file. The map and path data are split and read according to the specified rules.
>



## Preparation work

Tuya Smart Sweeper iOS SDK relies on the Tuya Smart Home iOS SDK, and develop on this basis。Before starting to develop with the SDK, you need to register a developer account, create a product, etc. on the Tuya Smart Development Platform, and obtain a key to activate the SDK, please refer to [Tuya Smart Home iOS SDK Preparation work](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/en/resource/Preparation.html).




## Fast Integration

### Using CocoaPods

Add the following content in file `Podfile`:

```ruby
platform :ios, '9.0'

target 'your_target_name' do

   pod 'TuyaSmartSweeperKit'
   
end
```

Execute command `pod update` in the project's root directory to begin integration.

For the instructions of CocoaPods, please refer to: [CocoaPods Guides](https://guides.cocoapods.org/) 



## Initializing SDK

1. Open project setting, `Target => General`, edit `Bundle Identifier` to the value from Tuya develop center.

2. Import security image to the project and rename as `t_s.bmp` from [Preparation Work](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/en/resource/Preparation.html), then add it into `Project Setting => Target => Build Phases => Copy Bundle Resources`.

3. Add the following to the project file `PrefixHeader.pch`：

```objective-c
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
```

Swift project add the following to the `xxx_Bridging-Header.h` file:

```
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
```

4. Open file `AppDelegate.m`，and use the `App Key` and `App Secret` obtained from the development platform in the `[AppDelegate application:didFinishLaunchingWithOptions:]`method to initialize SDK:

Objc:

```objc
[[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
```

Swift:

```swift
 TuyaSmartSDK.sharedInstance()?.start(withAppKey: <#your_app_key#>, secretKey: <#your_secret_key#>)
```

Now all the prepare work has been completed. You can use the sdk to develop your application now.



## Doc

Refer to details：[Tuya Smart Sweeper SDK - iOS](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/en/resource/Sweeper.html)



## ChangeLog

[ChangeLog.md](./ChangeLog.md) 

