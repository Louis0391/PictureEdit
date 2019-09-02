//
//  BTLineView.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "BTLineView.h"

#import "UIColor+BTExtension.h"

@implementation BTLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor colorWithHexString:@"#e4eaf6"]];
//        self.alpha = 0.10;
//        self.alpha = 0.6;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
