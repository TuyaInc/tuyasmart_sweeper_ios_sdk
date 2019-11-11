//
//  TuyaSmartFileDownload.h
//  TuyaSmartSweeperKit
//
//  Created by Misaka on 2019/10/18.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartUtil/TuyaSmartUtil.h>

@class TuyaSmartFileDownloadModel;
@class TuyaSmartFileDownloadRateModel;
@class TuyaSmartFileDownload;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TuyaSmartFileDownloadStatus) {
    TuyaSmartFileDownloadStatusUpgrading = 1,   // 下载中
    TuyaSmartFileDownloadStatusFinish,          // 下载完成
    TuyaSmartFileDownloadStatusFailure,         // 下载失败
};

@protocol TuyaSmartFileDownloadDelegate <NSObject>

/**
 文件下载状态

 @param fileDownload instance
 @param type 文件类型
 @param status 状态
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type status:(TuyaSmartFileDownloadStatus)status;

/**
 文件下载进度

 @param fileDownload instance
 @param type 文件类型
 @param progress 下载进度
 */
- (void)fileDownloadUpgrade:(TuyaSmartFileDownload *)fileDownload type:(NSString *)type progress:(int)progress;

@end

@interface TuyaSmartFileDownload : NSObject

@property (weak, nonatomic) id <TuyaSmartFileDownloadDelegate> delegate;

+ (instancetype)fileDownloadWithDeviceId:(NSString *)devId;
- (instancetype)initWithDeviceId:(NSString *)devId NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 获取文件信息
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getFileDownloadInfoWithSuccess:(nullable void (^)(NSArray<TuyaSmartFileDownloadModel *> *upgradeFileList))success
                               failure:(nullable TYFailureError)failure;

/**
 下发下载文件指令，设备开始下载文件, 升级成功或失败会通过 TuyaSmartFileDownloadDelegate 返回
 
 @param fileId  fileId of `TuyaSmartFileDownloadModel`
 @param success 成功回调 (status 0：未下载  1：下载中)
 @param failure 失败回调
 */
- (void)downloadFileWithFileId:(NSString *)fileId
                       success:(nullable TYSuccessID)success
                       failure:(nullable TYFailureError)failure;

/**
 获取文件下载进度
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)getFileDownloadRateWithSuccess:(nullable void (^)(TuyaSmartFileDownloadRateModel *rateModel))success
                               failure:(nullable TYFailureError)failure;

@end

NS_ASSUME_NONNULL_END
