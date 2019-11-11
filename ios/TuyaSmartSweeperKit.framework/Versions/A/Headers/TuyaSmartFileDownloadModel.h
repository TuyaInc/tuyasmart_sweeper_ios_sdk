//
//  TuyaSmartFileDownloadModel.h
//  TuyaSmartSweeperKit
//
//  Created by Misaka on 2019/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartFileDownloadModel : NSObject

/**
 文件 id
 */
@property (copy, nonatomic) NSString *fileId;
/**
 产品 id
 */
@property (copy, nonatomic) NSString *productId;
/**
 文件名称
 */
@property (copy, nonatomic) NSString *name;
/**
 文件描述
 */
@property (copy, nonatomic) NSString *desc;
/**
 文件url
 */
@property (copy, nonatomic) NSString *auditionUrl;
/**
 正式文件url
 */
@property (copy, nonatomic) NSString *officialUrl;
/**
 文件图标url
 */
@property (copy, nonatomic) NSString *imgUrl;
/**
 区域码
 */
@property (strong, nonatomic) NSArray<NSString *> *region;

@end

NS_ASSUME_NONNULL_END
