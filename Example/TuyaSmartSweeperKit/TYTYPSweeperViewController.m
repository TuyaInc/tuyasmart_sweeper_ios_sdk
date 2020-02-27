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

@interface TYTYPSweeperViewController () <TuyaSmartSweeperDelegate>

@property (strong, nonatomic) TuyaSmartSweeper *sweeper;
@property (copy, nonatomic) NSString *bucket;

@end

@implementation TYTYPSweeperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_deviceModel) {
        self.title = _deviceModel.name;
        
        NSString *devId = [_deviceModel.devId copy];
        __weak __typeof(&*self) weakSelf = self;
        // TODO: initialize
        [self.sweeper initCloudConfigWithDevId:devId complete:^(NSString * _Nonnull bucket, NSError * _Nullable error) {
            if (error == nil) {
                weakSelf.bucket = bucket;
                
                // TODO: Get current map or path data's URL
                [weakSelf.sweeper getSweeperCurrentPathWithDevId:devId success:^(NSDictionary<TYSweeperCurrentPathKey,NSString *> * _Nonnull paths) {
                    __strong __typeof(&*weakSelf) strongSelf = weakSelf;
                    
                    // TODO: Get data from URL
                    [strongSelf.sweeper getSweeperDataWithBucket:bucket path:paths[TYSweeperCurrentMapPathKey] complete:^(NSData * _Nonnull data, NSError * _Nullable error) {
                        if (error == nil) {
                            NSLog(@"current map data: %@", data);
                            // TODO: draw map UI With data
                        }
                    }];
                    
                    [strongSelf.sweeper getSweeperDataWithBucket:bucket path:paths[TYSweeperCurrentRoutePathKey] complete:^(NSData * _Nonnull data, NSError * _Nullable error) {
                        if (error == nil) {
                            NSLog(@"route path data in current map: %@", data);
                            // TODO: draw route UI With data
                        }
                    }];
                    
                } failure:^(NSError * _Nullable error) {
                    
                }];
            }
        }];
    }
}


#pragma mark - TuyaSmartSweeperDelegate

// When the device running, recive data from mqtt
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId message:(NSDictionary *)message {
    
    NSLog(@"recive mqtt messge from device: %@", message);
    
    // message[@"mapType"]
    // message[@"mapType"] = 0: map data
    // message[@"mapType"] = 1: route data
    
    // download map or route data from URL By NSURLSession
    NSString *url = [sweeper getCloudFileUrlWithBucket:self.bucket path:message[@"mapPath"]];
    [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // TODO: draw map or route UI With data
    }];
    
    // download map or route data from URL By TuyaSmartSweeper
//    [sweeper getSweeperDataWithBucket:self.bucket path:message[@"mapPath"] complete:^(NSData * _Nonnull data, NSError * _Nullable error) {
//
//        // TODO: draw map or route UI With data
//    }];
}

// When the device running, recive data from mqtt
- (void)sweeper:(TuyaSmartSweeper *)sweeper didReciveDataWithDevId:(NSString *)devId mapType:(NSInteger)mapType mapData:(NSData *)mapData error:(NSError *)error {
    
    NSLog(@"recive data from device: %ld %@", (long)mapType, mapData);
    // mapType = 0: map data
    // mapType = 1: route data
    // TODO: draw map or route UI With data
}


#pragma mark - Getter

- (TuyaSmartSweeper *)sweeper {
    if (!_sweeper) {
        _sweeper = [[TuyaSmartSweeper alloc] init];
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
