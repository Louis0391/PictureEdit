//
//  UIView+Frame.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+BTExtension.h"
@interface UIView (Frame)

+ (instancetype)viewFromXib;

// @property在分类里面只会自动生成get,set方法，并不会生成下划线的成员属性
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property(assign,nonatomic)CGFloat centerX;

@property(assign,nonatomic)CGFloat centerY;



@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;


#warning 必须先设置了frame设置颜色才有用
/**
 设置View的渐变背景颜色
 @param startColor 起始颜色
 @param endColor 终止颜色
 @param landscape 是否横向渐变
 
 示例:
 [self.titleLabel setChangeColorWithstartColor:[UIColor colorWithHexString:@"#b57ffb"] endColor:[UIColor colorWithHexString:@"#9860e7"] landscape:YES];
 */
-(void)setChangeColorWithstartColor:(UIColor *)startColor endColor:(UIColor *)endColor landscape:(BOOL)landscape;
@end
