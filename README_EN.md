# Tuya Smart Sweeper iOS SDK

## Features Overview

Tuya Smart Sweeper App SDK

Tuya Smart iOS Laser Sweeper SDK is based on [ Tuya Smart iOS SDK] (https://github.com/TuyaInc/tuyasmart_home_ios_sdk) (introduced below: Home SDK), which provides access to the laser sweeper function interface package to speed up development process. It mainly includes the following functions:

- Get cloud configuration of sweeping machine data file.
- obtain real-time sweep records of sweeping machine.
- acquisition of sweeping historical record sweeping machine.
- voice download service of sweeping machine.



> Laser sweeper data is divided into real-time data and historical record data. Both types of data contain map data and path data and are stored in the oss/s3.
>
> The map and path of real-time data are stored in different files. And the map and path of historical data are stored in the same file. The map and path data are split and read according to the specified rules.



## Rapid Integration

### Using CocoaPods integration (version 8.0 or above is supported)

Add the following content in file `Podfile`:

```ruby
platform :ios, '8.0'

target 'your_target_name' do

   pod 'TuyaSmartSweeperKit'
   
end
```

Execute command pod update in the project's root directory to begin integration.

For the instructions of CocoaPods, please refer to: [CocoaPods Guides](https://guides.cocoapods.org)



### Initializing SDK

Add the following to the project file `PrefixHeader.pch`：

```objective-c
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
```



## Function Overview

The main class is `TuyaSmartSweeper` , which implements` TuyaSmartSweeperDelegate` to accept callbacks for file information changes

**Code:**

```objective-c
@property (strong, nonatomic) TuyaSmartSweeper *sweeper;

- (TuyaSmartSweeper *)sweeper {
    if (!_sweeper) {
        _sweeper = [[TuyaSmartSweeper alloc] init];
        _sweeper.delegate = self;
        _sweeper.shouldAutoDownloadData = YES;
    }
    
    return _sweeper;
}


#pragma mark - TuyaSmartSweeperDelegate

/**
 * File information callback of sweeper data channel
 *
 * @param sweeper sweeper
 * @param devId corresponding data relevant to the device Id
 * @param mapType (0 for map, 1 for path )
 * @param mapData map data
 * @param error error
*/
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId mapType:(NSInteger)mapType mapData:(NSData *)mapData error:(NSError *)error {
    NSLog(@"data %@  ---  error: %@", mapData, error);
}
```



### Data flow diagram

![image](./imgs/img1.png)



### Init config of oss/s3

```objective-c
/**
 * Initialize cloud configuration
 *
 * @param devId device id
 * @param complete returns the bucket information of the file storage ( used to get the storage URL of the file )
 */
- (void)initCloudConfigWithDevId:(NSString *)devId
                        complete:(void(^)(NSString *bucket, NSError * _Nullable error))complete;
```



### Update config of oss/s3

Due to the time validity of the obtained file address, when the file URL was invalid, the following interface needs to be called to update the cloud configuration

```objective-c
/**
 * Update cloud configuration
 *
 * @param devId device id
 * @param complete returns bucket information for file storage successfully
 */
- (void)updateCloudConfigWithDevId:(NSString *)devId
                          complete:(void(^)(NSString *bucket, NSError * _Nullable error))complete;
```



### Get map or route data file URL

After obtaining the URL of the file storage , read the data of the file for display

Note: Current and historical data stored in different `bucket`

```objective-c
/**
 Get file download URL
 
 @param bucket bucket
 @param path file path
 */
- (nullable NSString *)getCloudFileUrlWithBucket:(NSString *)bucket
                                            path:(NSString *)path;
```



### Get the sweeper history record

```objective-c
/**
 * Get sweeper history record
 *
 * @param devId device id
 * @param limit the number of data obtained at one time (the maximum recommended is not more than 100)
 * @param offset Get the offset of the data ( for pagination )
 * @param startTime start timestamp
 * @param endTime end timestamp
 * @param complete result callback
 */
- (void)getSweeperHistoryDataWithDevId:(NSString *)devId
                                 limit:(NSUInteger)limit
                                offset:(NSUInteger)offset
                             startTime:(long)startTime
                               endTime:(long)endTime
                              complete:(void(^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount, NSError * _Nullable error))complete;

// -----------------------------------------------
// History Model
@interface TuyaSmartSweeperHistoryModel : NSObject

/**
 * File id
 */
@property (copy, nonatomic) NSString *fileId;
/**
 * Timestamp
 */
@property (assign, nonatomic) long time;

/**
 * File split read rules (json string)
 */
@property (copy, nonatomic) NSString *extend;

/**
 * bucket
 */
@property (copy, nonatomic) NSString *bucket;

/**
 * File path
 */
@property (copy, nonatomic) NSString *file;

@end
```



### Get data content

Note：oss error：https://help.aliyun.com/document_detail/32005.html?spm=a2c4g.11186623.6.1328.609b28126VcNPW

```objective-c
/**
 * Get data content
 *
 * @param bucket file storage bucket
 * @param path file path
 * @param complete data callback
 */
- (void)getSweeperDataWithBucket:(NSString *)bucket
                            path:(NSString *)path
                        complete:(void(^)(NSData *data, NSError * _Nullable error))complete;
```



### Get real-time map storage path and path storage path

Query the real-time map / path file address of the current device according to `devId` , and the obtained path can download the complete data through the` [-(void) getSweeperDataWithBucket:] ` method.

```objective-c
/**
 * Get real-time map storage path and path storage path
 *
 * @param devId device id
 * @param complete result callback
 */
- (void)getSweeperCurrentPathWithDevId:(NSString *)devId
                              complete:(void(^)(NSString *mapPath, NSString *routePath, NSError * _Nullable error))complete;
```



### Delete sweeper history

```objective-c
/**
 * Delete sweeper history
 *
 * @param devId device id
 * @param fileIds array of file ids
 * @param complete result callback
 */
- (void)removeSweeperHistoryDataWithDevId:(NSString *)devId
                                  fileIds:(NSArray<NSString *> *)fileIds
                                 complete:(void (^)(NSError * _Nullable error))complete;
```



### Delete all history

```objective-c
/**
 * Delete all history of the current device
 *
 * @param devId device id
 * @param complete result callback
 */
- (void)removeAllHistoryDataWithDevId:(NSString *)devId
                             complete:(void (^)(NSError * _Nullable error))complete;
```



## Voice download service

### Function Description

![image3](./imgs/img3.png)

The main function class is `TuyaSmartFileDownload` , which implements` TuyaSmartFileDownloadDelegate` to receive state change callbacks and download progress callbacks during the voice download process.

```objective-c
- (TuyaSmartFileDownload *)fileDownloader {
    if (!_fileDownloader) {
        _fileDownloader = [TuyaSmartFileDownload fileDownloadWithDeviceId:@"<#devId#>"];
        _fileDownloader.delegate = self;
    }
    return _fileDownloader;
}


#pragma mark - TuyaSmartFileDownloadDelegate
/**
 * File download status
 *
 * @param fileDownload instance
 * @param type file type
 * @param status status
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type status:(TuyaSmartFileDownloadStatus)status {
    NSLog(@"[LOG] %s: %@ status:%@", __PRETTY_FUNCTION__, type, @(status));
}

/**
 * File download progress
 *
 * @param fileDownload instance
 * @param type file type
 * @param progress download progress
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type progress:(int)progress {
    NSLog(@"[LOG] %s: %@ status:%@", __PRETTY_FUNCTION__, type, @(progress));
}
```


### Download flow

![image2](./imgs/img2.png)

### Get Download Information

```objective-c
/**
 Get file information
 
 @param success callback
 @param failure callback
 */
- (void)getFileDownloadInfoWithSuccess:(nullable void (^)(NSArray<TuyaSmartFileDownloadModel *> *upgradeFileList))success
                               failure:(nullable TYFailureError)failure;
```



### Request file download instruction, the device starts downloading files

```objective-c
/**
 * The download file command is issued, and the device starts downloading the file . The success or failure of the upgrade will be returned through TuyaSmartFileDownloadDelegate
 *
 * @param fileId fileId of `TuyaSmartFileDownloadModel`
 * @param success callback (status 0 : Not downloaded 1 : Downloading )
 * @param failure failure callback
 */
- (void)downloadFileWithFileId:(NSString *)fileId
                       success:(nullable TYSuccessID)success
                       failure:(nullable TYFailureError)failure;
```



### Get file download progress

```objective-c
/**
 Get file download progress
 
 @param success callback
 @param failure callback
 */
- (void)getFileDownloadRateWithSuccess:(nullable void (^)(TuyaSmartFileDownloadRateModel *rateModel))success
                               failure:(nullable TYFailureError)failure;
```



### Download information callback

After issuing the download instruction, the device starts downloading, and will report the real-time information back through mqtt . The following proxy method can accept the real-time status callback of the device download：

```objective-c
/**
 File download status

 @param fileDownload instance
 @param type file type
 @param status download status
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type status:(TuyaSmartFileDownloadStatus)status;

```

According to the above method agents `(TuyaSmartFileDownloadStatus) status` to determine if ` status` value `TuyaSmartFileDownloadStatusUpgrading`, the proxy method is triggered, the download progress obtain.

```objective-c
/**
 File download progress

 @param fileDownload instance
 @param type file type
 @param progress download progress
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type progress:(int)progress;
```


### Download file data model

```objective-c
@interface TuyaSmartFileDownloadModel : NSObject

/**
 file id
 */
@property (copy, nonatomic) NSString *fileId;
/**
 pid
 */
@property (copy, nonatomic) NSString *productId;
/**
 file name
 */
@property (copy, nonatomic) NSString *name;
/**
 file desc
 */
@property (copy, nonatomic) NSString *desc;
/**
 audition file url
 */
@property (copy, nonatomic) NSString *auditionUrl;
/**
 official file url
 */
@property (copy, nonatomic) NSString *officialUrl;
/**
 file icon url
 */
@property (copy, nonatomic) NSString *imgUrl;
/**
 area code
 */
@property (strong, nonatomic) NSArray<NSString *> *region;

@end
```


### Download progress data model

```objective-c
@interface TuyaSmartFileDownloadRateModel : NSObject

/**
 file id
 */
@property (copy, nonatomic) NSString *fileId;
/**
 device id
 */
@property (copy, nonatomic) NSString *deviceId;
/**
 download status 0：Not downloaded  1：Downloading
 */
@property (assign, nonatomic) NSInteger status;
/**
 Download progress
 */
@property (assign, nonatomic) int rate;

@end
```



### ChangeLog

**0.1.3 -> 0.1.4**

- [x] [fix] : The TuyaSmartSweeperDelegate proxy method only returns the MQTT messages received by the device corresponding to the devId passed in during the current initialization.
- [x] [feature] : - (void)getSweeperDataWithBucket: According bucket and path to download files, Complete callback downloads
- [x] [feature] : - (void)getSweeperDataWithBucket: Parse OSS error message and return NSError
- [x] [feature] : - (void)getSweeperCurrentPathWithDevId: 
- [x] [feature] : - (void)removeSweeperHistoryDataWithDevId: 

**0.1.4 -> 0.1.5**

- [x] [fix] : Get history interface adjustment, it will be differentiated according to the latitude

**0.1.5 -> 0.1.6**

- [x] [feature] : Share device supports viewing history

**0.1.6 -> 0.1.7**

Dependency `pod 'TuyaSmartDeviceKit', '~> 2.8.43'`

- [x] [fix] : Support bitcode
- [x] [fix] : `- (void)getSweeperCurrentPathWithDevId:` logic to update cloud configuration
- [x] [feature] : `- (void)removeAllHistoryDataWithDevId:` Remove the current sweeper history from cloud

**0.1.7 -> 0.2.0**

Dependency `pod 'TuyaSmartDeviceKit', '~> 2.10.96'`

- [x] [deprecated] : `-[TuyaSmartSweeperDelegate sweeper:didReciveDataWithDevId:mapType:mapPath:]` Receive laser data channel message
- [x] [feature] : `-[TuyaSmartSweeperDelegate sweeper:didReciveDataWithDevId:mapData:]` Receive laser data channel message

**0.2.0 -> 1.0.4**

Depends on the latest version of `TuyaSmartDeviceKit`

- [x] [bugfix] : Remove delegate when Sweeper object is destroyed

**1.0.4 -> 1.0.5**

Depends on the latest version of `TuyaSmartDeviceKit`

- [x] [bugfix] : fix occasional crash

**1.0.5 -> 1.0.6**

Depends on the latest version of `TuyaSmartDeviceKit`

- [x] [bugfix] : remove log 

**1.0.6 -> 1.0.7** 

- [x] [feature] : Voice download service `TuyaSmartFileDownload` 
- [x] [bugfix] : `-[TuyaSmartSweeper sweeper:didReciveDataWithDevId:]` Fix callback data of the current device