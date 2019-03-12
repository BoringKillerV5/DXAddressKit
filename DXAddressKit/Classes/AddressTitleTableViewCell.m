//
//  AddressTitleTableViewCell.m
//  Housekeeping
//
//  Created by 张旭 on 2017/10/12.
//  Copyright © 2017年 张旭. All rights reserved.
//

#import "AddressTitleTableViewCell.h"

@implementation AddressTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabbel.font = [UIFont systemFontOfSize:16];
    self.addressLabbel.font = [UIFont systemFontOfSize:14];
    
    self.selectBtn = [[UIButton alloc] init];
    self.selectBtn.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
    self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(15, UIScreen.mainScreen.bounds.size.width-40, 20, 20);//设置边距
    [self.selectBtn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
}

- (void)selectPressed:(UIButton *)sender{
    self.isSelect = !self.isSelect;
    if (self.qhxSelectBlock) {
        self.qhxSelectBlock(self.isSelect,sender.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
