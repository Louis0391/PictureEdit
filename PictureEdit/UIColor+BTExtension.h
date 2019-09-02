//
//  UIColor+BTExtension.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BTExtension)
//十六进制转颜色
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
