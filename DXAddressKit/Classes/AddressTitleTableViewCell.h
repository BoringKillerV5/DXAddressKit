//
//  AddressTitleTableViewCell.h
//  Housekeeping
//
//  Created by 张旭 on 2017/10/12.
//  Copyright © 2017年 张旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabbel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabbel;
//@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) UIButton *selectBtn;


@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);

@end
