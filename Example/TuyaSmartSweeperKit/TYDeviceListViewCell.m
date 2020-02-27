//
//  TYDeviceListViewCell.m
//  TuyaSmart
//
//  Created by 冯晓 on 16/1/4.
//  Copyright © 2016年 Tuya. All rights reserved.
//

#import "TYDeviceListViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TuyaSmartDeviceKit/TuyaSmartGroupModel.h>

@interface TYDeviceListViewCell()


@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, strong) UILabel     *groupTipLabel;


@end

@implementation TYDeviceListViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.statusImageView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.rightArrowImageView];
        [self.contentView addSubview:self.groupTipLabel];
    }
    return self;
}

- (UILabel *)groupTipLabel {
    if (!_groupTipLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 37 - 80, 0, 80, 80)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkTextColor];
        _groupTipLabel = label;
        _groupTipLabel.text = NSLocalizedString(@"group_item_flag", nil);
        _groupTipLabel.textAlignment = NSTextAlignmentRight;
    }
    return _groupTipLabel;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 32, 12, 8)];
        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 40, 40)];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, [UIScreen mainScreen].bounds.size.width - 100 - 22 - 10 - 50, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkTextColor];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIImageView *)rightArrowImageView {
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_view_arrow"]];
        _rightArrowImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-22,
                                                (80 - _rightArrowImageView.frame.size.height)/2.f,
                                                _rightArrowImageView.frame.size.width,
                                                _rightArrowImageView.frame.size.height);
    }
    return _rightArrowImageView;
}

- (void)setItem:(id)item {
    _nameLabel.text = [item name];
  
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[item iconUrl]] placeholderImage:nil];
    
    if ([item isOnline]) {
        if ([item isShare]) {
            _statusImageView.image = [UIImage imageNamed:@"ty_devicelist_share_green.png"];
        } else {
            _statusImageView.image = [UIImage imageNamed:@"ty_devicelist_dot_green.png"];
        }
    } else {
        if ([item isShare]) {
            _statusImageView.image = [UIImage imageNamed:@"ty_devicelist_share_gray.png"];
        } else {
            _statusImageView.image = [UIImage imageNamed:@"ty_devicelist_dot_gray.png"];
        }
    }
    
    _groupTipLabel.hidden = ![item isKindOfClass:[TuyaSmartGroupModel class]];

    if (_groupTipLabel.hidden) {
        //不是群组
        _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                      _nameLabel.frame.origin.y,
                                      [UIScreen mainScreen].bounds.size.width - 100 - 22 - 10,
                                      _nameLabel.frame.size.height);
    } else {
        //群组
        _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                      _nameLabel.frame.origin.y,
                                      [UIScreen mainScreen].bounds.size.width - 100 - 22 - 10 - 50,
                                      _nameLabel.frame.size.height);
    }

}

@end
