//
//  TuyaSmartSweeper.h
//  TuyaSmartSweeperSDK
//
//  Created by 黄凯 on 2019/1/10.
//

#import <Foundation/Foundation.h>
#import "TuyaSmartSweeperHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TuyaSmartSweeper;
@protocol TuyaSmartSweeperDelegate <NSObject>

/**
 扫地机数据通道的文件信息回调
 
 @param sweeper sweeper
 @param devId 对应数据所属设备 Id
 @param mapType (0表示路径，1表示地图)
 @param mapPath 文件路径
 */
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId mapType:(NSInteger)mapType mapPath:(NSString *)mapPath;

/**
 扫地机数据通道的地图数据回调

 需要提前设置 `shouldAutoDownloadData` = YES, 会自动根据返回的地图 url 请求下载数据
 
 @param sweeper 扫地机
 @param devId 对应数据所属设备 Id
 @param mapType (0表示路径，1表示地图)
 @param mapData 地图数据
 @param error error
 */
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId mapType:(NSInteger)mapType mapData:(NSData *)mapData error:(NSError *)error;


@end


@interface TuyaSmartSweeper : NSObject


/**
 是否自动下载地图文件数据
 */
@property (nonatomic, assign) BOOL shouldAutoDownloadData;

@property (nonatomic, weak) id<TuyaSmartSweeperDelegate> delegate;

/**
 初始化云配置
 
 @param devId 设备id
 @param complete 成功返回文件存储的bucket信息(用来获取文件的存储url)
 */
- (void)initCloudConfigWithDevId:(NSString *)devId
                        complete:(void(^)(NSString *bucket, NSError * _Nullable error))complete;


/**
 更新云配置
 
 @param devId 设备id
 @param complete 成功返回文件存储的bucket信息
 */
- (void)updateCloudConfigWithDevId:(NSString *)devId
                          complete:(void(^)(NSString *bucket, NSError * _Nullable error))complete;


/**
 获取数据文件地址
 
 @param bucket 文件存储的bucket
 @param path 文件路径
 */
- (nullable NSString *)getCloudFileUrlWithBucket:(NSString *)bucket
                                            path:(NSString *)path;


/**
 获取扫地机历史记录
 
 @param devId 设备id
 @param limit 一次获取数据的数量(建议最大不要超过100)
 @param offset 获取数据的偏移量(用于分页)
 @param complete 结果回调
 */
- (void)getSweeperHistoryDataWithDevId:(NSString *)devId
                                 limit:(NSUInteger)limit
                                offset:(NSUInteger)offset
                              complete:(void(^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount, NSError * _Nullable error))complete;


/**
 获取扫地机历史记录
 
 @param devId 设备id
 @param limit 一次获取数据的数量(建议最大不要超过100)
 @param offset 获取数据的偏移量(用于分页)
 @param startTime 起始时间戳
 @param endTime 结束时间戳
 @param complete 结果回调
 */
- (void)getSweeperHistoryDataWithDevId:(NSString *)devId
                                 limit:(NSUInteger)limit
                                offset:(NSUInteger)offset
                             startTime:(long)startTime
                               endTime:(long)endTime
                              complete:(void(^)(NSArray<TuyaSmartSweeperHistoryModel *> *datas, NSUInteger totalCount, NSError * _Nullable error))complete;

@end

NS_ASSUME_NONNULL_END
