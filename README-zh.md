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



## 流数据清扫记录接口

### 1. 最新一次清扫记录

**接口：** tuya.m.device.media.latest

**版本：** 2.0

**入参说明**

| 字段名 | 类型    | 描述 |
| --- | --- | --- |
| devId  | String  | 设备 Id |
| start | String | 开始位置 (第一次传空，之后取下一页时填上一页返回值里的startRow值) |
| size  | Integer | 查询数据的大小 (固定参数为 500) |

**响应参数**

| 字段名 | 类型 | 描述 |
| --- | --- | --- |
| devId | String | 设备 Id |
| startRow | String | 分页查询索引 |
| dataList | Array | 流数据 |
| subRecordId | String | 清扫记录 Id |
| hasNext | BOOL | 是否有下一页数据 |

**响应示例**

```json
{
    "devId":"6ccdd506b7186ee85avntm",
    "startRow":"mtnva58ee6817b605ddcc6_35_1535629239586",
    "dataList":[
        "373702373700",
        "383702383802373901383901383800",
        "373802373901373800",
        "373802363901363801373800",
        "373702373602373600",
        "373502373500",
        "373502373402373301363301373400",
        "363502363500",
        "363502363500"
    ],
    "subRecordId":35,
    "hasNext":true,
    "startTime":1535629049,
    "endTime":1535629244,
    "status":2
}
```



### 2.历史清扫记录列表

**接口：** m.smart.scale.history.get.list

**版本：** 1.0

**入参说明**

| 字段名 | 类型    | 描述 |
| --- | --- | --- |
| devId  | String  | 设备 Id |
| offset | Integer | 分页偏移量 |
| limit  | Integer | 分页大小 |
| dpIds  | String  | 在涂鸦平台配置的清扫记录的dpId |

**响应参数**

| 字段名 | 类型 | 描述 |
| --- | --- | --- |
| uuid | String | 删除记录时的入参 |
| dps | Array |  |
| 15 | String | 在涂鸦平台配置的清扫记录的dpId |
| 201906171721009007 | String | 设备在对应 dpId 上报的值，解析为“2019年06月17号，17点21分，清扫时间009，清扫面积007”，具体数据与设备端对齐 |
| totalCount | int | 总条数 |
| hasNext | BOOL | 是否有下一页数据 |

**响应示例**

```json
{
    "datas":[
        {
            "devId":"xxxx",
            "dps":[
                {
                    "15":"201906171721009007"
                }
            ],
            "avatar":"https://airtake-public-data.oss-cn-hangzhou.aliyuncs.com/smart/user_res/avatar/scale/no_body_icon.png",
            "userName":"xx",
            "gmtCreate":1560763848501,
            "uuid":"15607600058B81A6C4A0273FDD61091D0B02403848501",
            "userId":"0",
            "tags":0,
            "status":1
        }
    ],
    "hasNext":false,
    "totalCount":2
}
```



### 3.清扫记录详情

**接口：** tuya.m.device.media.detail

**版本：** 2.0

**入参说明**

| 字段名 | 类型    | 描述 |
| --- | --- | --- |
| devId  | String  | 设备 Id |
| subRecordId | String  | 清扫记录 Id |
| start | String | 开始位置 (第一次传空，之后取下一页时填上一页返回值里的startRow值) |
| size  | Integer | 查询数据的大小 (固定参数为 500) |

**响应参数**

| 字段名 | 类型 | 描述 |
| --- | --- | --- |
| devId | String | 设备 Id |
| startRow | String | 分页查询索引 |
| dataList | Array | 流数据 |
| subRecordId | String | 清扫记录 Id |
| hasNext | BOOL | 是否有下一页数据 |

**响应示例**

```json
{
    "devId":"6ccdd506b7186ee85avntm",
    "startRow":"mtnva58ee6817b605ddcc6_31_1535622776561",
    "dataList":[
        "3e3f02403e013e3f00",
        "3f3f024040013f3f00",
        "3f3f02403f014040013f3f00",
        "3f40024140014040013f3f024041013f41013f3f00",
        "3f3f024040014041013f41013f3f00"
    ],
    "subRecordId":31,
    "hasNext":true,
    "startTime":1535621566,
    "endTime":1535623017,
    "status":2
}
```



### 4.删除清扫记录

**接口：** m.smart.sweep.record.clear

**版本：** 1.0

**入参说明**

| 字段名 | 类型    | 描述 |
| --- | --- | --- |
| devId  | String  | 设备 Id |
| uuid | String  | 清扫记录 uuid，传 uuid 表示清除特定记录 |

**响应示例**

```json
{
    "result":true,
    "t":1530589344923,
    "success":true,
    "status":"ok"
}
```



### 5.清空历史清扫记录

**接口：** m.smart.scale.history.delete

**版本：** 1.0

**入参说明**

| 字段名 | 类型    | 描述 |
| --- | --- | --- |
| devId  | String  | 设备 Id |
| uuid | Integer | 清扫记录 Id |

**响应示例**

```json
{
    "result":true,
    "success":true,
    "status":"ok",
    "t":1557740732829
}
```



## 陀螺仪型或视觉型功能接口

### 数据流程

![MediaCleanRecord](./imgs/zh-hans/MediaCleanRecord.png)

### 功能简介

涂鸦陀螺仪型或视觉型的扫地机是使用流通道来传输地图数据，实现 `TuyaSmartSweeperDeviceDelegate` 代理协议接收用来接收地图流数据回调。

| 类名                 | 说明                   |
| -------------------- | ---------------------- |
| TuyaSmartSweepDevice | 涂鸦扫地机设备相关的类 |



### 订阅地图流数据

**接口说明**

订阅设备的地图流数据

```objective-c
- (void)subscribeDeviceDataTransfer;
```

**示例代码**

```objective-c
- (void)subscribeDevice {
    
    [self.sweeperDevice subscribeDeviceDataTransfer];
}
```

### 取消订阅地图流数据

**接口说明**

取消订阅设备的地图流数据

```objective-c
- (void)unsubscribeDeviceDataTransfer;
```

**示例代码**

```objective-c
- (void)unsubscribeDevice {
    
    [self.sweeperDevice unsubscribeDeviceDataTransfer];
}
```

### 流数据回调

**接口说明**

设备上报的流数据实时回调

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data;
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` 实例对象 |
| data          | 流数据（ `NSData` 类型）          |

**示例代码**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data {
  
}
```



## 激光型功能接口

### 数据流程

![MediaCleanRecord](./imgs/zh-hans/CleanRecord.png)

### 功能简介

激光型扫地机是借助 mqtt 和 云存储来进行数据的传输，将地图或清扫路径以文件的形式保存在云端，其中涉及到获取云存储配置信息，接收文件上传完成的实时消息和文件下载功能。所有功能对应 `TuyaSmartSweepDevice` 类，需要使用设备 Id 进行初始化。错误的设备 Id 可能会导致初始化失败，返回 nil。

| 类名 | 说明 |
| --- | --- |
| TuyaSmartSweepDevice | 涂鸦扫地机设备相关的类 |

### 获取云存储配置

**接口说明**

从云端获取云存储配置信息

```objective-c
- (void)initCloudConfigWithSuccess:(void (^)(NSString *bucket))success
                           failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 类名 | 说明 |
| --- | --- |
| success | 成功回调（bucket：文件存储空间） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice initCloudConfigWithSuccess:^(NSString * _Nonnull bucket) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 获取数据内容

**接口说明**

根据文件（地图、清扫路径）在云端 (OSS/S3) 中存储的相对路径，下载文件数据

```objective-c
- (void)getSweeperDataWithBucket:(NSString *)bucket
                            path:(NSString *)path
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数    | 说明     |
| --- | --- |
| bucket | 文件存储空间 |
| path | 文件（地图、清扫路径）存储相对路径 |
| success | 成功回调 （data：文件具体内容） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getSweeperDataWithBucket:<#bucket#> path:<#path#> success:^(NSData * _Nonnull data) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 获取当前清扫中的数据内容

**接口说明**

获取当前清扫中的文件（地图、清扫路径）在云端 (OSS/S3) 中存储的相对路径

```objective-c
- (void)getSweeperCurrentPathWithSuccess:(void (^)(NSString *bucket, NSDictionary<TuyaSmartSweeperCurrentPathKey, NSString *> *paths))success
                                 failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| TuyaSmartSweeperCurrentPathKey    | 说明                             |
| --------------------------------- | -------------------------------- |
| TuyaSmartSweepCurrentMapPathKey   | 当前地图的相对路径对应的 key     |
| TuyaSmartSweepCurrentRoutePathKey | 当前清扫路径的相对路径对应的 key |

| 参数    | 说明     |
| --- | --- |
| success | 成功回调（bucket：文件存储空间，paths：地图和清扫路径存储的相对路径） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getSweeperCurrentPathWithSuccess:^(NSString * _Nonnull bucket, NSDictionary<TuyaSmartSweeperCurrentPathKey,NSString *> * _Nonnull paths) {
  
        NSString *mapPath = paths[TuyaSmartSweepCurrentMapPathKey];
        NSString *routePath = paths[TuyaSmartSweepCurrentRoutePathKey];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 获取历史清扫记录

**接口说明**

从云端获取激光型扫地机的历史清扫记录

```objective-c
- (void)getSweeperHistoryDataWithLimit:(NSUInteger)limit
                                offset:(NSUInteger)offset
                             startTime:(long)startTime
                               endTime:(long)endTime
                               success:(void (^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount))success
                               failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 类名                         | 说明         |
| ---------------------------- | ------------ |
| TuyaSmartSweeperHistoryModel | 历史清扫记录 |

| 属性   | 类型     | 说明                       |
| ------ | -------- | -------------------------- |
| fileId | NSString | 清扫记录文件 id            |
| time   | long     | 清扫记录文件时间戳         |
| extend | NSString | 清扫记录拆分读取规则       |
| bucket | NSString | 清扫记录文件的存储空间     |
| file   | NSString | 清扫记录文件存储的相对路径 |

| 参数 | 说明 |
| --- | --- |
| limit | 一次获取数据的数量(建议最大不要超过100) |
| offset | 获取数据的偏移量(用于分页) |
| startTime | 起始时间戳（默认不传） |
| endTime | 结束时间戳（默认不传） |
| success | 成功回调（datas：清扫记录数组，totalCount：历史清扫记录总数） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getSweeperHistoryDataWithLimit:50 offset:0 startTime:-1 endTime:-1 success:^(NSArray<TuyaSmartSweeperHistoryModel *> * _Nonnull datas, NSUInteger totalCount) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 删除历史清扫记录

**接口说明**

删除当前激光型扫地机设备指定的历史清扫记录

```objective-c
- (void)removeSweeperHistoryDataWithFileIds:(NSArray<NSString *> *)fileIds
                                    success:(void (^)(void))success
                                    failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| fileIds | 清扫记录文件 id 的字符串数组 |
| success | 成功回调 |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice removeSweeperHistoryDataWithFileIds:<#fileIds#> success:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 清空历史清扫记录

**接口说明**

清空当前激光型扫地机设备的所有历史清扫记录

```objective-c
- (void)removeAllHistoryDataWithSuccess:(void (^)(void))success
                                failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数    | 说明     |
| ------- | -------- |
| success | 成功回调 |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice removeAllHistoryDataWithSuccess:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 获取历史清扫记录（多地图）

**接口说明**

针对激光型扫地机一次清扫记录有多个地图的情况，提供从云端获取多地图的历史清扫记录。

```objective-c
- (void)getSweeperMultiHistoryDataWithLimit:(NSUInteger)limit
                                     offset:(NSUInteger)offset
                                  startTime:(long)startTime
                                    endTime:(long)endTime
                                    success:(void(^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount))success
                                    failure:(void(^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数 | 说明 |
| --- | --- |
| limit | 一次获取数据的数量(建议最大不要超过100) |
| offset | 获取数据的偏移量(用于分页) |
| startTime | 起始时间戳（默认不传） |
| endTime | 结束时间戳（默认不传） |
| success | 成功回调（datas：清扫记录数组，totalCount：历史清扫记录总数） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getSweeperMultiHistoryDataWithLimit:50 offset:0 startTime:-1 endTime:-1 success:^(NSArray<TuyaSmartSweeperHistoryModel *> * _Nonnull datas, NSUInteger totalCount) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 清空历史清扫记录（多地图）

**接口说明**

针对激光型扫地机一次清扫记录有多个地图的情况，提供清空所有多地图的历史清扫记录

```objective-c
- (void)removeAllMultiHistoryDataWithSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数    | 说明     |
| ------- | -------- |
| success | 成功回调 |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice removeAllMultiHistoryDataWithSuccess:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### 清扫文件上传完成的消息实时回调

激光型扫地机在工作中，实时地图或清扫路径数据上传到 OSS/S3 完成的消息回调。通过设置 `TuyaSmartSweeperDeviceDelegate` 代理协议，监听实时消息回调。

**MQTT 通知消息数据模型**

| 类名                        | 说明                               |
| --------------------------- | ---------------------------------- |
| TuyaSmartSweeperMQTTMessage | 设备上传完文件发送的 mqtt 通知消息 |

| 属性 | 类型 | 说明 |
| ---- | ---- | ---- |
| mapId | NSString | 文件（地图、清扫路径）id |
| mapType | TuyaSmartSweeperMQTTMessageType | 文件类型。0：地图；1：路径 |
| mapPath | NSString | 文件（地图、清扫路径）存储的相对路径 |

**接口说明**

设备上传完文件之后的消息回调

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message;
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| sweeperDevice | 扫地机设备实例 |
| message       | 设备上传完成后，推送的 mqtt 消息 |

**示例代码**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message {
  
}
```

### 清扫数据实时回调 

**接口说明**

设备上传完文件之后的消息回调，设置 `shouldAutoDownloadData` 为 `YES` 后，触发该回调下载文件内容。

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message downloadData:(nullable NSData *)data downloadError:(nullable NSError *)error;
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| sweeperDevice | 扫地机设备实例 |
| message       | 设备上传完成后，推送的 mqtt 消息 |
| data       | 文件下载后 `NSData` 类型的具体内容 |
| error       | 文件下载出错的错误信息 |

**示例代码**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message downloadData:(nullable NSData *)data downloadError:(nullable NSError *)error {
  
}
```



## 语音下载

### 数据流程

![MediaCleanRecord](./imgs/zh-hans/FileDownload.png)

### 功能简介

扫地机 SDK 提供了语音下载功能，实现 `TuyaSmartSweeperDeviceDelegate` 代理协议接收语音下载过程中的状态变化回调以及下载进度回调。

| 类名                 | 说明                   |
| -------------------- | ---------------------- |
| TuyaSmartSweepDevice | 涂鸦扫地机设备相关的类 |




### 获取语音文件列表

**接口说明**

拉取当前扫地机设备可用的语音文件列表

```objective-c
- (void)getFileDownloadInfoWithSuccess:(void (^)(NSArray<TuyaSmartFileDownloadModel *> *upgradeFileList))success failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 类名                       | 说明           |
| -------------------------- | -------------- |
| TuyaSmartFileDownloadModel | 语音文件数据类 |

| 属性        | 类型                | 说明                 |
| ----------- | ------------------- | -------------------- |
| fileId      | NSString            | 语音文件 Id          |
| productId   | NSString            | 产品 Id              |
| name        | NSString            | 语音文件名称         |
| desc        | NSString            | 语音文件描述         |
| auditionUrl | NSString            | 语音试听文件下载链接 |
| officialUrl | NSString            | 语音正式文件下载链接 |
| imgUrl      | NSString            | 语音文件图标下载链接 |
| region      | NSArray<NSString *> | 区域码               |

| 参数    | 说明 |
| ---- | ---- |
| success | 成功回调（upgradeFileList：可用语音文件列表） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getFileDownloadInfoWithSuccess:^(NSArray<TuyaSmartFileDownloadModel *> * _Nonnull upgradeFileList) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### 确认下载语音文件

**接口说明**

调用接口确认下载指定语音文件

```objective-c
- (void)downloadFileWithFileId:(NSString *)fileId
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 参数    | 说明 |
| ---- | ---- |
| fileId | 确认下载的语音文件 id |
| success | 成功回调 |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice downloadFileWithFileId:<#fileId#> success:^(id  _Nonnull result) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### 获取语音文件下载进度

**接口说明**

语音文件下载进度数据模型

```objective-c
- (void)getFileDownloadRateWithSuccess:(void (^)(TuyaSmartFileDownloadRateModel *rateModel))success failure:(void (^)(NSError * _Nullable error))failure;
```

**参数说明**

| 类名 | 说明 |
| ---- | ---- |
| TuyaSmartFileDownloadRateModel | 文件的下载进度信息 |

| 属性     | 类型      | 说明        |
| -------- | --------- | ----------- |
| fileId   | NSString  | 语音文件 id |
| deviceId | NSString  | 设备 id     |
| status   | NSInteger | 下载状态    |
| rate     | int       | 下载进度    |

| 参数    | 说明 |
| ---- | ---- |
| success | 成功回调（rateModel：语音文件下载进度信息） |
| failure | 失败回调 |

**示例代码**

```objective-c
[self.sweeperDevice getFileDownloadRateWithSuccess:^(TuyaSmartFileDownloadRateModel * _Nonnull rateModel) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### 语音下载回调

#### 下载状态实时回调

**接口说明**

语音下载状态实时回调

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadStatus:(TuyaSmartSweeperFileDownloadStatus)status;
```

**参数说明**

| TuyaSmartSweeperFileDownloadStatus    | 说明         |
| ------------------------------------- | ------------ |
| TuyaSmartSweeperFileDownloadUpgrading | 文件下载中   |
| TuyaSmartSweeperFileDownloadFinish    | 文件下载完成 |
| TuyaSmartSweeperFileDownloadFailure   | 文件下载失败 |

| 参数 | 说明 |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` 实例对象 |
| type | 文件类型 |
| status | 下载状态（`TuyaSmartSweeperFileDownloadStatus`） |

**示例代码**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadStatus:(TuyaSmartSweeperFileDownloadStatus)status {
  
}
```

#### 下载进度实时回调

**接口说明**

语音下载进度实时回调

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadProgress:(int)progress;
```

**参数说明**

| 参数          | 说明                              |
| ------------- | --------------------------------- |
| sweeperDevice | `TuyaSmartSweeperDevice` 实例对象 |
| type          | 文件类型                          |
| progress      | 文件下载进度                      |

**示例代码**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

// 实现代理方法
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadProgress:(int)progress {
  
}
```



## [更新日志](./ChangeLog-zh.md) 
