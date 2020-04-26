//
//  TYTYPSweeperViewController.m
//  TuyaSmartSweeperKit_Example
//
//  Created by Misaka on 2020/2/27.
//  Copyright © 2020 misakatao. All rights reserved.
//

#import "TYTYPSweeperViewController.h"
#import <TuyaSmartSweeperKit/TuyaSmartSweeperKit.h>
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>

@interface TYTYPSweeperViewController () <TuyaSmartSweeperDeviceDelegate>

@property (strong, nonatomic) TuyaSmartSweeperDevice *sweeper;
@property (copy, nonatomic) NSString *bucket;

@end

@implementation TYTYPSweeperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Transfer

- (void)testDataTransfer {
    [self.sweeper subscribeDeviceDataTransfer];
}



#pragma mark - Laser Sweeper

- (void)testLaserSweeper {
    
    __block NSString *sweeperBucket = nil;
    // 1. download data from TuyaSmartSweeperDevice
    self.sweeper.shouldAutoDownloadData = true;
    
    // 2.download data from NSURLSession
//    self.sweeper.shouldAutoDownloadData = false;
    
    // init config
    __weak __typeof(&*self) weakSelf = self;
    [self.sweeper initCloudConfigWithSuccess:^(NSString * _Nonnull bucket) {
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;
        
        sweeperBucket = bucket;
        
        [strongSelf.sweeper getSweeperCurrentPathWithSuccess:^(NSString * _Nonnull bucket, NSDictionary<TuyaSmartSweeperCurrentPathKey,NSString *> * _Nonnull paths) {
            
            NSString *mapPath = paths[TuyaSmartSweepCurrentMapPathKey];
            NSString *routePath = paths[TuyaSmartSweepCurrentRoutePathKey];
            
            [strongSelf downloadDataWithBucket:sweeperBucket path:mapPath complete:^(NSData *data) {
                NSLog(@"[LOG] laser device current sweeping data: %@", data);
            }];
        } failure:^(NSError * _Nullable error) {
            
        }];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    // history sweep data
    [self.sweeper getSweeperHistoryDataWithLimit:50 offset:0 success:^(NSArray<TuyaSmartSweeperHistoryModel *> * _Nonnull datas, NSUInteger totalCount) {
        __strong __typeof(&*weakSelf) strongSelf = weakSelf;

        NSString *filePath = datas[0].file;
        [strongSelf downloadDataWithBucket:sweeperBucket path:filePath complete:^(NSData *data) {
            NSLog(@"[LOG] laser device current sweeping data: %@", data);
        }];
        
    } failure:^(NSError * _Nullable error) {
        
        
    }];
    
}

- (void)downloadDataWithBucket:(NSString *)bucket path:(NSString *)path complete:(void(^)(NSData *))complete {
    // 1. download data from TuyaSmartSweeperDevice
    if (self.sweeper.shouldAutoDownloadData) {
        
        [self.sweeper getSweeperDataWithBucket:bucket path:path success:^(NSData * _Nonnull data) {
            if (complete) {
                complete(data);
            }
        } failure:^(NSError * _Nullable error) {
            
        }];
    } else {
        // 2.download data from NSURLSession
        NSString *URLString = [self.sweeper getCloudFileDownloadURLWithBucket:bucket path:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 200) {
                if (complete) {
                    complete(data);
                }
            }
        }];
        [task resume];
    }
}



#pragma mark - TuyaSmartSweeperDeviceDelegate

/**
 * When received device stream data, the delegate will execute.
 * 扫地机数据通道的流数据回调
 *
 * @param sweeperDevice instance
 * @param data Received Data
 */
- (void)sweeperDevice:(TuyaSmartSweeperDevice *)sweeperDevice didReceiveStreamData:(NSData *)data {
    NSLog(@"recive data transfer from device: %@", data);
}


#pragma mark - Getter

- (TuyaSmartSweeperDevice *)sweeper {
    if (!_sweeper) {
        _sweeper = [[TuyaSmartSweeperDevice alloc] initWithDeviceId:self.deviceModel.devId];
        _sweeper.delegate = self;
    }
    return _sweeper;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
