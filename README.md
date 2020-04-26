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



## Data Transfer Record Interface

### 1. The Latest Cleaning Record

**API：** tuya.m.device.media.latest

**Version：** 2.0

**Request Parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId  | String  | Device Id |
| start | String | Start position (the first pass is empty, then fill the startRow value in the return value of the previous page when taking the next page) |
| size  | Integer | Query data size (fixed parameter is 500) |

**Response parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId | String | Device Id |
| startRow | String | Paging query index |
| dataList | Array | Streaming data |
| subRecordId | String | Record Id |
| hasNext | BOOL | Is there data on the next page |

**Response Example**

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



### 2.List of Historical Records

**API：** m.smart.scale.history.get.list

**Version：** 1.0

**Request Parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId  | String  | Device Id |
| offset | Integer | Paging offset |
| limit  | Integer | Paging Size |
| dpIds  | String  | The dpId of the cleaning record configured on the Tuya Iot |

**Response parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| uuid | String | Input parameters when deleting records |
| dps | Array | The list of dpIds |
| 15 | String | The dpId of the cleaning record configured on the Tuya Iot |
| 201906171721009007 | String | The value reported by the device at the corresponding dpId is parsed as "June 17, 2019, 17:21, cleaning time 009, cleaning area 007", the specific data is aligned with the device end |
| totalCount | int | Total Count |
| hasNext | BOOL | Is there data on the next page |

**Response Example**

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



### 3.Cleaning Record Getails

**API：** tuya.m.device.media.detail

**Version：** 2.0

**Request parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId  | String  | Device Id |
| subRecordId | String  | Record Id |
| start | String | Start position (the first pass is empty, then fill the startRow value in the return value of the previous page when taking the next page) |
| size  | Integer | Query data size (fixed parameter is 500) |

**Response parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId | String | Device Id |
| startRow | String | Paging query index |
| dataList | Array | Streaming data |
| subRecordId | String | Record Id |
| hasNext | BOOL | Is there data on the next page |

**Response Example**

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



### 4.Delete Cleaning Records

**API：** m.smart.sweep.record.clear

**Version：** 1.0

**Request parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId  | String  | Device Id |
| uuid | String  | Clean the record uuid, pass uuid to clear the specific record |

**Response Example**

```json
{
    "result":true,
    "t":1530589344923,
    "success":true,
    "status":"ok"
}
```



### 5.Clear History Records

**API：** m.smart.scale.history.delete

**Version：** 1.0

**Request parameters**

| Parameter | Type | Description |
| --- | --- | --- |
| devId  | String  | Device Id |
| uuid | Integer | Clean the record uuid, pass uuid to clear the specific record |

**Response Example**

```json
{
    "result":true,
    "success":true,
    "status":"ok",
    "t":1557740732829
}
```



## Data Transfer Subscribe

### Data flow

![MediaCleanRecord](./imgs/en/MediaCleanRecord.png)

### Function introduction

The graffiti gyroscope or visual sweeper uses a stream channel to transmit map data and implements the `TuyaSmartSweeperDeviceDelegate` proxy protocol to receive callbacks for receiving map stream data.

| Class | Description |
| --- | --- |
| TuyaSmartSweepDevice | Tuya sweeper device management class |



### Subscribe to Map Streaming Data

**Declaration**

Subscribe to the device's map streaming data

```objective-c
- (void)subscribeDeviceDataTransfer;
```

**Example**

```objective-c
- (void)subscribeDevice {
    
    [self.sweeperDevice subscribeDeviceDataTransfer];
}
```

### Unsubscribe to Map Streaming Data

**Declaration**

Unsubscribe map stream data from device

```objective-c
- (void)unsubscribeDeviceDataTransfer;
```

**Example**

```objective-c
- (void)unsubscribeDevice {
    
    [self.sweeperDevice unsubscribeDeviceDataTransfer];
}
```

### Streaming Data Callback

**Declaration**

Real-time callback of streaming data reported by the device

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| sweeperDevice | `TuyaSmartSweeperDevice` Instance object |
| data          | Streaming data（ `NSData`）          |

**Example**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data {
  
}
```



## Laser Sweeper Record

### Data flow

![MediaCleanRecord](./imgs/en/CleanRecord.png)

### Function introduction

The laser sweeper uses mqtt and cloud storage to transfer data, save the map or sweeping path in the form of a file in the cloud, which involves obtaining cloud storage configuration information, receiving real-time messages and file download functions after file upload is completed. All functions correspond to the `TuyaSmartSweepDevice` class and need to be initialized using the device Id. The wrong device ID may cause initialization failure and return nil.

| Class | Description |
| --- | --- |
| TuyaSmartSweepDevice | Tuya sweeper device management class |

### Get Cloud Storage Configuration

**Declaration**

Get cloud storage configuration information from the cloud

```objective-c
- (void)initCloudConfigWithSuccess:(void (^)(NSString *bucket))success
                           failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| success | success callback（bucket：File storage space） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice initCloudConfigWithSuccess:^(NSString * _Nonnull bucket) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Get Data Content

**Declaration**

Download file data according to the relative path of the file (map, sweep path) stored in the cloud (OSS / S3)

```objective-c
- (void)getSweeperDataWithBucket:(NSString *)bucket
                            path:(NSString *)path
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| bucket | File storage space |
| path | File (map, sweeping path) storage relative path |
| success | success callback |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getSweeperDataWithBucket:<#bucket#> path:<#path#> success:^(NSData * _Nonnull data) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Get the Data Content of Current Cleaning

**Declaration**

Get the relative path of the files (map, cleaning path) currently being cleaned in the cloud (OSS / S3)

```objective-c
- (void)getSweeperCurrentPathWithSuccess:(void (^)(NSString *bucket, NSDictionary<TuyaSmartSweeperCurrentPathKey, NSString *> *paths))success
                                 failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameter**

| TuyaSmartSweeperCurrentPathKey    | Description |
| --- | --- |
| TuyaSmartSweepCurrentMapPathKey   | The key corresponding to the relative path of the current map     |
| TuyaSmartSweepCurrentRoutePathKey | The key corresponding to the relative path of the current cleaning path |

| Parameter | Description |
| --- | --- |
| success | success callback（bucket：File storage space，paths：Map and sweep path storage relative path） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getSweeperCurrentPathWithSuccess:^(NSString * _Nonnull bucket, NSDictionary<TuyaSmartSweeperCurrentPathKey,NSString *> * _Nonnull paths) {
  
        NSString *mapPath = paths[TuyaSmartSweepCurrentMapPathKey];
        NSString *routePath = paths[TuyaSmartSweepCurrentRoutePathKey];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Get Historical Sweep Records

**Declaration**

Get the historical cleaning records of the laser sweeper from the cloud

```objective-c
- (void)getSweeperHistoryDataWithLimit:(NSUInteger)limit
                                offset:(NSUInteger)offset
                             startTime:(long)startTime
                               endTime:(long)endTime
                               success:(void (^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount))success
                               failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Class | Description |
| --- | --- |
| TuyaSmartSweeperHistoryModel | Historical sweep |

| Property | Type | Description |
| --- | --- | --- |
| fileId | NSString | Cleaning record file id |
| time   | long     | Time stamp of cleaning record file |
| extend | NSString | Cleaning record split reading rules |
| bucket | NSString | Sweep the storage space of log files |
| file   | NSString | Relative path for storage of cleaning record files |

| Parameter | Description |
| --- | --- |
| limit | The number of data obtained at a time (it is recommended not to exceed 100) |
| offset | Get data offset (for paging) |
| startTime | Start time stamp (none by default) |
| endTime | End timestamp (none by default) |
| success | success callback（datas：Sweep record array，totalCount：Total number of historical sweep records） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getSweeperHistoryDataWithLimit:50 offset:0 startTime:-1 endTime:-1 success:^(NSArray<TuyaSmartSweeperHistoryModel *> * _Nonnull datas, NSUInteger totalCount) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Delete History Sweep Records

**Declaration**

Delete the historical cleaning records specified by the current laser sweeper equipment

```objective-c
- (void)removeSweeperHistoryDataWithFileIds:(NSArray<NSString *> *)fileIds
                                    success:(void (^)(void))success
                                    failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| ---- | ---- |
| fileIds | String array of cleaning record file id |
| success | success callback |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice removeSweeperHistoryDataWithFileIds:<#fileIds#> success:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Clear Hstory Sweep Rcords

**Declaration**

Clear all the historical cleaning records of the current laser sweeper equipment

```objective-c
- (void)removeAllHistoryDataWithSuccess:(void (^)(void))success
                                failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| success | success callback |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice removeAllHistoryDataWithSuccess:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Get Hstorical Sweep Rcords (multi-map)

**Declaration**

For the case where the laser sweeper sweeps and records multiple maps at one time, it provides historical sweeping records that obtain multiple maps from the cloud.

```objective-c
- (void)getSweeperMultiHistoryDataWithLimit:(NSUInteger)limit
                                     offset:(NSUInteger)offset
                                  startTime:(long)startTime
                                    endTime:(long)endTime
                                    success:(void(^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount))success
                                    failure:(void(^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| limit | The number of data obtained at a time (it is recommended not to exceed 100) |
| offset | Get data offset (for paging) |
| startTime | Start time stamp (none by default) |
| endTime | End timestamp (none  by default) |
| success | success callback（datas：Sweep record array，totalCount：Total count of historical sweep records） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getSweeperMultiHistoryDataWithLimit:50 offset:0 startTime:-1 endTime:-1 success:^(NSArray<TuyaSmartSweeperHistoryModel *> * _Nonnull datas, NSUInteger totalCount) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Clear History Sweep Records (multiple maps)

**Declaration**

For the case where the laser sweeper sweeps multiple maps in one sweep, it provides the historical sweeping record of clearing all multiple maps

```objective-c
- (void)removeAllMultiHistoryDataWithSuccess:(void (^)(void))success
                                     failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| --- | --- |
| success | success callback |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice removeAllMultiHistoryDataWithSuccess:^{
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```

### Real-time callback of the message that the cleaning file upload is completed

When the laser sweeper is working, the real-time map or sweep path data is uploaded to OSS / S3 to complete the message callback. By setting the `TuyaSmartSweeperDeviceDelegate` proxy protocol, you can monitor real-time message callbacks.

**MQTT notification message data model**

| Class | Description |
| --- | --- |
| TuyaSmartSweeperMQTTMessage | Mqtt notification message sent after the device has uploaded the file |

| Property | Type | Description |
| ---- | ---- | ---- |
| mapId | NSString | File (map, sweeping path) id |
| mapType | TuyaSmartSweeperMQTTMessageType | File type. 0: map; 1: path |
| mapPath | NSString | The relative path of the file (map, cleaning path) storage |

**Declaration**

Message callback after the device uploads files

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message;
```

**Parameters**

| Parameter | Description |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` instance |
| message | After the device upload is complete, the pushed mqtt message |

**Example**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message {
  
}
```

### Cleaning data real-time callback

**Declaration**

Message callback after the device uploads the file, set `shouldAutoDownloadData` to` YES`, trigger this callback to download the file content.

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message downloadData:(nullable NSData *)data downloadError:(nullable NSError *)error;
```

**Parameters**

| Parameter | Description |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` instance |
| message | After the device upload is complete, the pushed mqtt message |
| data | The specific content of the `NSData` type after the file is downloaded |
| error | File download error message |

**Example**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveMessage:(TuyaSmartSweeperMQTTMessage *)message downloadData:(nullable NSData *)data downloadError:(nullable NSError *)error {
  
}
```



## Voice Download

### Data flow

![MediaCleanRecord](./imgs/en/FileDownload.png)

### Function introduction

The sweeper SDK provides a voice download function, which implements the `TuyaSmartSweeperDeviceDelegate` proxy protocol to receive the status change callback and download progress callback during the voice download process.

| Class | Description |
| --- | --- |
| TuyaSmartSweepDevice | Tuya sweeper device management class |




### Get a list of voice files

**Declaration**

Request the list of voice files available for the current sweeper device

```objective-c
- (void)getFileDownloadInfoWithSuccess:(void (^)(NSArray<TuyaSmartFileDownloadModel *> *upgradeFileList))success failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Class | Description |
| ---- | ---- |
| TuyaSmartFileDownloadModel | The class of voice file data |

| Property | Type | Description |
| --- | --- | --- |
| fileId      | NSString            | Voice file Id          |
| productId   | NSString            | Product Id              |
| name        | NSString            | Voice file name         |
| desc        | NSString            | Voice file description         |
| auditionUrl | NSString            | Download link for audio audition file |
| officialUrl | NSString            | Download link for official voice files |
| imgUrl      | NSString            | Voice file icon download link |
| region      | NSArray<NSString *> | Area code               |

| Parameter | Description |
| ---- | ---- |
| success | success callback（upgradeFileList：List of available voice files） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getFileDownloadInfoWithSuccess:^(NSArray<TuyaSmartFileDownloadModel *> * _Nonnull upgradeFileList) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### Confirm to download voice file

**Declaration**

Confirm the download of the specified voice file

```objective-c
- (void)downloadFileWithFileId:(NSString *)fileId
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Parameter | Description |
| ---- | ---- |
| fileId | Confirm downloaded voice file id |
| success | success callback |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice downloadFileWithFileId:<#fileId#> success:^(id  _Nonnull result) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### Get voice file download progress

**Declaration**

Voice file download progress data model

```objective-c
- (void)getFileDownloadRateWithSuccess:(void (^)(TuyaSmartFileDownloadRateModel *rateModel))success failure:(void (^)(NSError * _Nullable error))failure;
```

**Parameters**

| Class | Description |
| ---- | ---- |
| TuyaSmartFileDownloadRateModel | File download progress information |

| Property | Type | Description |
| -------- | --------- | ----------- |
| fileId   | NSString  | Voice file id |
| deviceId | NSString  | Device id     |
| status   | NSInteger | Download status    |
| rate     | int       | Download progress    |

| Parameter | Description |
| ---- | ---- |
| success | success callback（rateModel：Voice file download progress information） |
| failure | failure callback |

**Example**

```objective-c
[self.sweeperDevice getFileDownloadRateWithSuccess:^(TuyaSmartFileDownloadRateModel * _Nonnull rateModel) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
```



### Voice download callback

#### Download status real-time callback

**Declaration**

Real-time callback of voice download status

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadStatus:(TuyaSmartSweeperFileDownloadStatus)status;
```

**Parameters**

| TuyaSmartSweeperFileDownloadStatus    | Description |
| ---- | ---- |
| TuyaSmartSweeperFileDownloadUpgrading | File downloading  |
| TuyaSmartSweeperFileDownloadFinish    | File download completed |
| TuyaSmartSweeperFileDownloadFailure   | File download failed |

| Parameter | Description |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` instance |
| type | File type |
| status | Downlaod status（`TuyaSmartSweeperFileDownloadStatus`） |

**Example**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadStatus:(TuyaSmartSweeperFileDownloadStatus)status {
  
}
```

#### Real-time callback of download progress

**Declaration**

Real-time callback of voice download progress

```objective-c
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadProgress:(int)progress;
```

**Parameters**

| Parameter | Description |
| ---- | ---- |
| sweeperDevice | `TuyaSmartSweeperDevice` instance |
| type          | File type |
| progress      | File download progress |

**Example**

```objective-c
self.sweeperDevice = [TuyaSmartSweeperDevice deviceWithDeviceId:<#devId#>];
self.sweeperDevice.delegate = self;

- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice type:(NSString *)type downloadProgress:(int)progress {
  
}
```



## [Change Log](./ChangeLog.md) 


