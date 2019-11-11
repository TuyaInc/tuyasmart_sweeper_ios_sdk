//
//  TuyaSmartFileDownloadRateModel.h
//  TuyaSmartSweeperKit
//
//  Created by Misaka on 2019/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartFileDownloadRateModel : NSObject

/**
 下载文件 id
 */
@property (copy, nonatomic) NSString *fileId;
/**
 设备 id
 */
@property (copy, nonatomic) NSString *deviceId;
/**
 下载状态 0：未下载  1：下载中
 */
@property (assign, nonatomic) NSInteger status;
/**
 下载进度
 */
@property (assign, nonatomic) int rate;

@end

NS_ASSUME_NONNULL_END
