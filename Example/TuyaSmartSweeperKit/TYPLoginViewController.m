//
//  TYPLoginViewController.m
//  TuyaSmartHomeKit_Example
//
//  Created by luobei on 2019/9/26.
//  Copyright © 2019 xuchengcheng. All rights reserved.
//

#import "TYPLoginViewController.h"
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>
#import "TYPSmartHomeManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const TYPLoginDidSusscess = @"TYPLoginDidSusscess";

@interface TYPLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTfd;
@property (weak, nonatomic) IBOutlet UITextField *accountTfd;
@property (weak, nonatomic) IBOutlet UITextField *passwordTfd;

@end

@implementation TYPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Login";
}

- (void)showTips:(NSString *)tips {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:tips
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:email];
}

- (void)loadHomeDataWithCompleteBlock:(void(^)(void))completeBlock {
    if (![TuyaSmartUser sharedInstance].isLogin) {
        completeBlock();
        return;
    }
    
    TuyaSmartHomeManager *homeManager = [TYPSmartHomeManager sharedInstance].homeManager;
    [homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        if (homes.count > 0) {
            // If homes are already exist, choose the first one as current home.
            TuyaSmartHomeModel *model = [homes firstObject];
            TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:model.homeId];
            [TYPSmartHomeManager sharedInstance].currentHome = home;
            completeBlock();
        } else {
            // Or else, add a default home named "hangzhou's home" and choose it as current home.
            [homeManager addHomeWithName:@"hangzhou's home" geoName:@"hangzhou" rooms:@[@"bedroom"] latitude:0 longitude:0 success:^(long long homeId) {
                TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeId];
                [TYPSmartHomeManager sharedInstance].currentHome = home;
                completeBlock();
            } failure:^(NSError *error) {
                completeBlock();
            }];
        }
    } failure:^(NSError *error) {
        completeBlock();
    }];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.accountTfd.text.length) {
        [self showTips:@"account field can't be nil."];
        return;
    }
    
    if (!self.countryCodeTfd.text.length) {
        [self showTips:@"Country code is essential."];
        return;
    }
    
    if (self.passwordTfd.text.length < 6) {
        [self showTips:@"Invalid password formmat."];
        return;
    }
    
    if ([self isValidateEmail:self.accountTfd.text]) {
        [self loginWithEmailAndPassword];
    } else {
        [self loginWithPhoneNumberAndPassword];
    }
}

- (void)loginWithEmailAndPassword {
    NSString *countryCode   = self.countryCodeTfd.text;
    NSString *email         = self.accountTfd.text;
    NSString *password      = self.passwordTfd.text;
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [[TuyaSmartUser sharedInstance] loginByEmail:countryCode email:email password:password success:^{
        __strong typeof(weakSelf) self = weakSelf;
        [self loadHomeDataWithCompleteBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:TYPLoginDidSusscess
                                                                object:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) self = weakSelf;
        [self showTips:error.localizedDescription];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

- (void)loginWithPhoneNumberAndPassword {
    NSString *countryCode   = self.countryCodeTfd.text;
    NSString *phoneNumber   = self.accountTfd.text;
    NSString *password      = self.passwordTfd.text;
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [[TuyaSmartUser sharedInstance] loginByPhone:countryCode phoneNumber:phoneNumber password:password success:^{
        __strong typeof(weakSelf) self = weakSelf;
        [self loadHomeDataWithCompleteBlock:^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:TYPLoginDidSusscess
                                                                object:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) self = weakSelf;
        [self showTips:error.localizedDescription];
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

@end
