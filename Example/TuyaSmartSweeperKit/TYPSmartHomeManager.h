//
//  TYPSmartHomeManager.h
//  TuyaSmartHomeKit_Example
//
//  Created by luobei on 2019/9/26.
//  Copyright © 2019 xuchengcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPSmartHomeManager : NSObject

@property (nonatomic, strong) TuyaSmartHome *currentHome;
@property (nonatomic, strong) TuyaSmartHomeManager *homeManager;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
