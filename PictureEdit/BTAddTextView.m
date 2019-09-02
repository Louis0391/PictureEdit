//
//  BTAddTextView.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "BTAddTextView.h"
#import "BTCover.h"
#import "UIColor+BTExtension.h"
#import "UIView+Frame.h"
#import "BTLineView.h"

@interface BTAddTextView ()

@end
@implementation BTAddTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self creatCancelBtn];
        [self creatSureBtn];
        [self creatTxteView];
    }
    return self;
}

- (void)creatCancelBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 5, 60, 30);
    [btn setTitleColor:[UIColor colorWithHexString:@"#50C1E9"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:btn];
}

- (void)creatSureBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.width-65, 5, 60, 30);
    [btn setTitleColor:[UIColor colorWithHexString:@"#50C1E9"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:btn];
    
    BTLineView *lineView = [[BTLineView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(btn.frame), self.width, 0.5);
    [self addSubview:lineView];
}
- (void)creatTxteView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 40,self.width , self.height- 40)];
    textView.tag = 600;
    textView.font = [UIFont systemFontOfSize:16];
    //textView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:textView];
    self.textView = textView;
    
}
- (void)cancelBtnClick
{
    [BTCover hide];
    [self removeFromSuperview];
}
- (void)sureBtnClick
{
    UITextView *textView = (UITextView *)[self viewWithTag:600];
    if ([self.delegate respondsToSelector:@selector(addTextViewSureBtnDidClick:textView:)]) {
        [self.delegate addTextViewSureBtnDidClick:self textView:textView];
    }
     [BTCover hide];
    [self removeFromSuperview];
}

@end

