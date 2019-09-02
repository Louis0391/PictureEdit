//
//  BTCover.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "BTCover.h"

@implementation BTCover

+(instancetype)show{
    //创建一个遮盖.
    BTCover *cover = [[self alloc] init];
    //设置cover的尺寸大小.
    cover.frame = [UIScreen mainScreen].bounds;
    //设置遮盖的颜色
    cover.backgroundColor = [UIColor blackColor];
    //设置遮盖的透明度
    cover.alpha = 0.5;
    //把遮盖添加到主窗口上.
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
   
    return cover;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self hide];
    if ([self.delegate respondsToSelector:@selector(coverDidClick:)]) {
        [self.delegate coverDidClick:self];
    }
}
//
+ (void)hide{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        
        if([view isKindOfClass:[BTCover class]]){
            
            [view removeFromSuperview];
        }
    }
}

@end
