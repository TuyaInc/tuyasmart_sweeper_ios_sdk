## Integration SDK

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