//
//  BTAddTextView.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTAddTextView;

@protocol BTAddTextViewDelegate <NSObject>


@optional

-(void)addTextViewCloseBtnDidClick:(BTAddTextView *)addtextView;
-(void)addTextViewSureBtnDidClick:(BTAddTextView *)addtextView textView:(UITextView *)textView;

@end

@interface BTAddTextView : UIView
/**<#属性名#> */
@property(nonatomic,weak) id <BTAddTextViewDelegate>delegate;

/** <#注释#> */
@property(nonatomic, weak) UITextView *textView;

@end
