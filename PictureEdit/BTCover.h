//
//  BTCover.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTCover;
@protocol BTCoverDelegate <NSObject>

@optional
-(void)coverDidClick:(BTCover *)cover;
@end

@interface BTCover : UIView

+(instancetype)show;
+ (void)hide;
/**<#属性名#> */
@property(nonatomic,weak) id <BTCoverDelegate>delegate;
@end
