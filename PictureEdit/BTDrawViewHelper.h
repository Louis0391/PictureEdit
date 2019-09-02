//
//  BTDrawViewHelper.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTDrawViewHelper : NSObject

/**
 获取两点间距离
 
 @param fromPoint 开始点
 @param toPoint 结束点
 @return double
 */
+ (double)distanceFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

/**
 *  获取文本size
 *
 *  @param str    内容文本
 *  @param font   字体
 *  @param width  宽度（无限大：0）
 *  @param height 高度（无限大：0）
 *
 *  @return CGSize
 */
+ (CGSize)getSizeWithString:(NSString *)str andFont:(UIFont *)font contentWidth:(CGFloat)width contentHeight:(CGFloat)height;


@end
