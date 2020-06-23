# 涂鸦智能扫地机 iOS SDK 接入指南

[中文版](README-zh.md) | [English](README.md)

## 功能概述

涂鸦智能扫地机 iOS SDK 是在[涂鸦智能 iOS SDK](https://github.com/TuyaInc/tuyasmart_home_ios_sdk) （下文简介为: Home SDK）的基础上扩展了接入扫地机设备相关功能的接口封装，加速开发过程。主要包括了以下功能：

- 流媒体（用于陀螺仪型或视觉型扫地机）通用数据通道
- 激光型扫地机数据传输通道
- 激光型扫地机实时/历史清扫记录
- 扫地机通用语音下载服务 



## 准备工作

该 SDK 依赖于涂鸦全屋智能 SDK，基于此基础上进行拓展开发。在开始使用 SDK 开发前，需要在涂鸦智能开发平台上注册开发者账号、创建产品等，并获取到激活 SDK 的密钥，具体的操作流程请参考[涂鸦全屋智能 SDK 集成准备章节](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/zh-hans/resource/Preparation.html)。 



## 快速集成

### 使用 CocoaPods 集成

在 `Podfile` 文件中添加以下内容：

```ruby
platform :ios, '9.0'

target 'your_target_name' do

   pod 'TuyaSmartSweeperKit'
   
end
```

然后在项目根目录下执行 `pod update` 命令，集成第三方库。

CocoaPods 的使用请参考：[CocoaPods Guides](https://guides.cocoapods.org/) 

## 初始化 SDK

1. 打开项目设置，Target => General，修改`Bundle Identifier`为涂鸦开发者平台对应的iOS包名

2. 导入安全图片到工程根目录，重命名为`t_s.bmp`，并加入「项目设置 => Target => Build Phases => Copy Bundle Resources」中。

3. 在项目的`PrefixHeader.pch`文件添加以下内容：

```objective-c
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
```

Swift 项目可以添加在 `xxx_Bridging-Header.h` 桥接文件中添加以下内容

```
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
```

4. 打开`AppDelegate.m`文件，在`[AppDelegate application:didFinishLaunchingWithOptions:]`方法中初始化SDK：

Objc:

```objc
[[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
```

Swift:

```swift
 TuyaSmartSDK.sharedInstance()?.start(withAppKey: <#your_app_key#>, secretKey: <#your_secret_key#>)
```

至此，准备工作已经全部完毕，可以开始App开发啦。



## 开发文档

更多请参考：[涂鸦智能扫地机 iOS SDK 开发文档](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/zh-hans/resource/Sweeper.html)



## 版本更新记录

[ChangeLog.md](./ChangeLog.md) 

