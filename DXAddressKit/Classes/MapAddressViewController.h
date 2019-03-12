//
//  MapAddressViewController.h
//  Housekeeping
//
//  Created by 张旭 on 2017/10/12.
//  Copyright © 2017年 张旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapAddressViewController : UIViewController
@property (nonatomic, copy) void(^definiteSelectBlock)(NSDictionary *library);
@end
