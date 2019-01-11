//
//  TuyaSmartSweeperHistoryModel.h
//  TuyaSmartSweeper
//
//  Created by 黄凯 on 2019/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 历史记录模型
@interface TuyaSmartSweeperHistoryModel : NSObject

/**
 时间戳
 */
@property (assign, nonatomic) long time;

/**
 文件拆分读取规则 (json字符串)
 */
@property (copy, nonatomic) NSString *extend;

/**
 文件存储的bucket
 */
@property (copy, nonatomic) NSString *bucket;

/**
 文件路径
 */
@property (copy, nonatomic) NSString *file;

@end

NS_ASSUME_NONNULL_END
