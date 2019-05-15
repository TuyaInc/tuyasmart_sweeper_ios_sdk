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
@optional
/**
 扫地机数据通道的文件信息回调
 
 @param sweeper sweeper
 @param devId 对应数据所属设备 Id
 @param mapType (0表示地图，1表示路径)
 @param mapPath 文件路径
 */
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId mapType:(NSInteger)mapType mapPath:(NSString *)mapPath __deprecated_msg("This method is deprecated, Use -[TuyaSmartSweeperDelegate sweeper:didReciveDataWithDevId:message:] instead");

/**
 扫地机数据通道的文件信息回调
 
 @param sweeper sweeper
 @param devId 对应数据所属设备 Id
 @param message MQTT消息体
 */
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId message:(NSDictionary *)message;

/**
 扫地机数据通道的地图数据回调

 需要提前设置 `shouldAutoDownloadData` = YES, 会自动根据返回的地图 url 请求下载数据
 
 @param sweeper 扫地机
 @param devId 对应数据所属设备 Id
 @param mapType (0表示地图，1表示路径)
 @param mapData 地图数据
 @param error OSS 错误码查询: https://help.aliyun.com/document_detail/32005.html?spm=a2c4g.11186623.6.1328.609b28126VcNPW
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
 获取数据内容
 OSS 错误码查询: https://help.aliyun.com/document_detail/32005.html?spm=a2c4g.11186623.6.1328.609b28126VcNPW

 @param bucket 文件存储的bucket
 @param path 文件路径
 @param complete 数据回调
 */
- (void)getSweeperDataWithBucket:(NSString *)bucket
                            path:(NSString *)path
                        complete:(void(^)(NSData *data, NSError * _Nullable error))complete;



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

/**
 获取实时的地图存储路径和路径存储路径

 @param devId 设备 id
 @param complete 结果回调
 */
- (void)getSweeperCurrentPathWithDevId:(NSString *)devId
                              complete:(void(^)(NSString *mapPath, NSString *routePath, NSError * _Nullable error))complete;

/**
 删除扫地机历史记录

 @param devId 设备 id
 @param fileIds 文件 id 数组
 @param complete 结果回调
 */
- (void)removeSweeperHistoryDataWithDevId:(NSString *)devId
                                  fileIds:(NSArray<NSString *> *)fileIds
                                 complete:(void (^)(NSError * _Nullable error))complete;

/**
 删除当前扫地机所有历史记录

 @param devId 设备 id
 @param complete 结果回调
 */
- (void)removeAllHistoryDataWithDevId:(NSString *)devId
                             complete:(void (^)(NSError * _Nullable error))complete;


@end

NS_ASSUME_NONNULL_END
