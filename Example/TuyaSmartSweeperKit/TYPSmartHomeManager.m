//
//  TYPSmartHomeManager.m
//  TuyaSmartHomeKit_Example
//
//  Created by luobei on 2019/9/26.
//  Copyright © 2019 xuchengcheng. All rights reserved.
//

#import "TYPSmartHomeManager.h"

@implementation TYPSmartHomeManager

+ (instancetype)sharedInstance {
    
    static TYPSmartHomeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [TYPSmartHomeManager new];
        }
    });
    return sharedInstance;
}

- (TuyaSmartHomeManager *)homeManager {
    if (!_homeManager) {
        _homeManager = [TuyaSmartHomeManager new];
    }
    return _homeManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentHome = [TuyaSmartHome homeWithHomeId:self.homeManager.homes.firstObject.homeId];
    }
    return self;
}

@end
