//
//  TYPDeviceListViewController.m
//  TuyaSmartHomeKit_Example
//
//  Created by luobei on 2019/9/26.
//  Copyright © 2019 xuchengcheng. All rights reserved.
//

#import "TYPDeviceListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>
#import "TYPSmartHomeManager.h"
#import "TYDeviceListViewCell.h"
#import "TYPLoginViewController.h"
#import "TYAppDelegate.h"
#import "TYTYPSweeperViewController.h"

@interface TYPDeviceListViewController () <TuyaSmartHomeDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation TYPDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = [TYPSmartHomeManager sharedInstance].currentHome.homeModel.name;
    [TYPSmartHomeManager sharedInstance].currentHome.delegate = self;
    
    // add home switch button to nav
    UIBarButtonItem *homeSwitchBtn = [[UIBarButtonItem alloc] initWithTitle:@"Switch Home"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(switchHomeAction:)];
    self.navigationItem.leftBarButtonItem = homeSwitchBtn;
    
    // add logout button to nav
    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(logoutAction:)];
    self.navigationItem.rightBarButtonItem = logoutBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:TYPLoginDidSusscess
                                               object:nil];
    

}


#pragma mark - TuyaSmartHomeDelegate

// 家庭的信息更新，例如name
- (void)homeDidUpdateInfo:(TuyaSmartHome *)home {
    [self.tableView reloadData];
}

// 家庭和房间关系变化
- (void)homeDidUpdateRoomInfo:(TuyaSmartHome *)home {
    [self.tableView reloadData];
}

// 我收到的共享设备列表变化
- (void)homeDidUpdateSharedInfo:(TuyaSmartHome *)home {
    [self.tableView reloadData];
}

// 房间信息变更，例如name
- (void)home:(TuyaSmartHome *)home roomInfoUpdate:(TuyaSmartRoomModel *)room {
    [self.tableView reloadData];
}

// 房间与设备，群组的关系变化
- (void)home:(TuyaSmartHome *)home roomRelationUpdate:(TuyaSmartRoomModel *)room {
    [self.tableView reloadData];
}

// 添加设备
- (void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

// 删除设备
- (void)home:(TuyaSmartHome *)home didRemoveDeivice:(NSString *)devId {
    [self.tableView reloadData];
}

// 设备信息更新，例如name
- (void)home:(TuyaSmartHome *)home deviceInfoUpdate:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

// 设备dp数据更新
- (void)home:(TuyaSmartHome *)home device:(TuyaSmartDeviceModel *)device dpsUpdate:(NSDictionary *)dps {
    [self.tableView reloadData];
}

// 添加群组
- (void)home:(TuyaSmartHome *)home didAddGroup:(TuyaSmartGroupModel *)group {
    [self.tableView reloadData];
}

// 群组dp数据更新
- (void)home:(TuyaSmartHome *)home group:(TuyaSmartGroupModel *)group dpsUpdate:(NSDictionary *)dps {
    [self.tableView reloadData];
}

// 删除群组
- (void)home:(TuyaSmartHome *)home didRemoveGroup:(NSString *)groupId {
    [self.tableView reloadData];
}

// 群组信息更新，例如name
- (void)home:(TuyaSmartHome *)home groupInfoUpdate:(TuyaSmartGroupModel *)group {
    [self.tableView reloadData];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info; {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([TYPSmartHomeManager sharedInstance].currentHome.deviceList.count == 0) {
        [self switchToHome:[TYPSmartHomeManager sharedInstance].currentHome.homeModel];
    }
}


#pragma mark - Actions

- (void)loginSuccess:(NSNotification *)notice {
    self.title = [TYPSmartHomeManager sharedInstance].currentHome.homeModel.name;
    [self.tableView reloadData];
}

- (void)switchHomeAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[TYPSmartHomeManager sharedInstance].homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        __strong typeof(weakSelf) self = weakSelf;
        if (homes.count > 0) {
            // If homes are already exist, choose the first one as current home.
            [self showHomeList:homes];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        } else {
            // Or else, add a default home named "hangzhou's home" and choose it as current home.
            [[TYPSmartHomeManager sharedInstance].homeManager addHomeWithName:@"hangzhou's home" geoName:@"hangzhou" rooms:@[@"bedroom"] latitude:0 longitude:0 success:^(long long homeId) {
                TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:homeId];
                [self showHomeList:@[home.homeModel]];
                [TYPSmartHomeManager sharedInstance].currentHome = home;
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            } failure:^(NSError *error) {
                //Do fail action.
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            }];
        }
    } failure:^(NSError *error) {
        //Do fail action.
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

- (void)logoutAction:(id)sender {
    [[TuyaSmartUser sharedInstance] loginOut:nil failure:nil];
    [(TYAppDelegate *)[UIApplication sharedApplication].delegate showLoginVc];
}

- (void)showHomeList:(NSArray<TuyaSmartHomeModel*> *)homes {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Select Home"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [homes enumerateObjectsUsingBlock:^(TuyaSmartHomeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj.name
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self switchToHome:obj];
                                                       }];
        [sheet addAction:action];
    }];
    [sheet addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:sheet animated:YES completion:nil];
}

- (void)switchToHome:(TuyaSmartHomeModel *)homeModel {
    [TYPSmartHomeManager sharedInstance].currentHome = [TuyaSmartHome homeWithHomeId:homeModel.homeId];
    [TYPSmartHomeManager sharedInstance].currentHome.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[TYPSmartHomeManager sharedInstance].currentHome getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        self.title = homeModel.name;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray <TuyaSmartDeviceModel *> *deviceList = [TYPSmartHomeManager sharedInstance].currentHome.deviceList;
    return deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYDeviceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TYDeviceListViewCell class])];
    if (!cell) {
        cell = [[TYDeviceListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([TYDeviceListViewCell class])];
    }
    
    TuyaSmartDeviceModel *deviceModel = [[TYPSmartHomeManager sharedInstance].currentHome.deviceList objectAtIndex:indexPath.row];
    [cell setItem:deviceModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    TuyaSmartDeviceModel *deviceModel = [[TYPSmartHomeManager sharedInstance].currentHome.deviceList objectAtIndex:indexPath.row];
    
    TYTYPSweeperViewController *sweeperVc = [[TYTYPSweeperViewController alloc] init];
    sweeperVc.deviceModel = deviceModel;
    [self.navigationController pushViewController:sweeperVc animated:true];
}

@end
