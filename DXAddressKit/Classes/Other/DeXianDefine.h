//
//  BMViewDefine.h
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-4-28.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#ifndef BlueMobiProject_BMViewDefine_h
#define BlueMobiProject_BMViewDefine_h

//屏幕适配:宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAVHEIGHT self.navigationController.navigationBar.frame.size.height


#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPhone_X_NAVHeight(iphone) iphone==YES?84:64
//监听

#define ORDER_PAY_NOTIFICATION @"winxinPay"

//#define TwoCellHEIGHT [UIScreen mainScreen].bounds.size.height*0.39

//缩放比例
#define SCALE  [UIScreen mainScreen].scale
//红字颜色
//#define REDColor [UIColor colorWithRed:0.604 green:0.114 blue:0.082 alpha:1.000]
//背景颜色
#define BJColor whiteColor
//黑颜色
#define BlackColor [UIColor colorWithWhite:51.0f / 255.0f alpha:1.0f]
//白颜色
#define WhiteColor [UIColor colorWithWhite:255.0f / 255.0f alpha:1.0f]
//灰颜色
#define greyColor [UIColor colorWithWhite:153.0f / 255.0f alpha:1.0f]
//绿颜色
#define greenColor  [UIColor colorWithHexString:@"14CC5D"]
//主色调
#define mainColor  [UIColor colorWithHexString:@"FF830E"]
//黄色调
#define yellowOrderColor  [UIColor colorWithHexString:@"F5A623"]
//浅灰颜色
#define whiteTwoColor [UIColor colorWithWhite:235.0f / 255.0f alpha:1.0f]
//深灰颜色
#define threeColor [UIColor colorWithHexString:@"333333"]
#define shenGreyColor [UIColor colorWithHexString:@"666666"]
#define shenWenZiColor [UIColor colorWithHexString:@"999999"]
//红色
//#define redTextColor  [UIColor colorWithRed:255.0f / 255.0f green:73.0f / 255.0f blue:73.0f / 255.0f alpha:1.0f]
#define redTextColor     [UIColor colorWithHexString:@"#fa656e"]
//背景底颜色
#define whiteThreeColor [UIColor colorWithHexString:@"F3F3F3"]

#define whiteFourColor [UIColor colorWithWhite:215.0f / 255.0f alpha:1.0f]

#define whiteFiveColor [UIColor colorWithHexString:@"EFEFEF"]

#define timebackgroundColor [UIColor colorWithWhite:204.0f / 255.0f alpha:1.0f]





#define  warmGrey [UIColor colorWithWhite:153.0f / 255.0f alpha:1.0f]
#define RgbColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define MainScreenSize_W   [[UIScreen mainScreen] bounds].size.width
#define MainScreenSize_H   [UIScreen mainScreen].bounds.size.height




#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height-44

#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define Nav_Back_Font_M [UIFont systemFontOfSize:14]
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define Theme_Color_Red  RGB(231,56,55)
#define Theme_Color_Pink RGB(255,83,123)
#define Theme_Color_White [UIColor whiteColor]

#define Theme_Color_Orange RGB(255,178,148)
#define Theme_Color_Peach RGB(253,184,202)


#define Theme_NavColor   RGB(255,255,255)

#define Theme_TextColor RGB(55,65,75)  //

//导航栏颜色
#define kNavigationBarBg  RGB(206,8,2) //#ce0802

#define KUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define KUIScreenHeight [UIScreen mainScreen].bounds.size.height
// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define ViewController_BackGround [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]//视图控制器背景颜色

//占位图
#define PLACEHOLDER_IMG @"image_nil"
//用户头像
#define AVATER_PLACEHOLDER_IMG @"logo_out_avatar"
//定位后用户所在城市
#define CITY_NAME @"CityName"


//字体
#define FontSize(small,big)         [UIFont systemFontOfSize:WIDTH==320?small:big]

/**
 *  px转换成ios字体大小
 */
#define DEF_FONT_NAME(pt) [UIFont fontWithName:@"PingFangSC-Regular" size:pt]


/**
 *    永久存储对象
 *
 *    @param    object    需存储的对象
 *    @param    key    对应的key
 */
#define DEF_PERSISTENT_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];                                                                         \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})

/**
 *    取出永久存储的对象
 *
 *    @param    key    所需对象对应的key
 *    @return    key所对应的对象
 */
#define DEF_PERSISTENT_GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key] 

#endif
