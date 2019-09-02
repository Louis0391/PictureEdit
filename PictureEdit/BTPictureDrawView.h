//
//  BTPictureDrawView.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  涂鸦类型
 */
typedef NS_OPTIONS(NSUInteger, JRDrawShapeType) {
    /**
     *  涂鸦
     */
    kDrawShapeDoodle = 0,
    /**
     *  橡皮擦
     */
    kDrawShapeEraser = 1,
    /**
     *  矩形
     */
    kDrawShapeRect = 1 << 1,
    /**
     *  圆
     */
    kDrawShapeRound = 1 << 2,
    /**
     *  直线
     */
    kDrawShapeLine = 1 << 3,
    /**
     *  箭头
     */
    kDrawShapeArrow = 1 << 4,
    
    /**
     *  文字
     */
    kDrawShapeText = 1 << 5
};

/**
 *  涂鸦宽度
 */
typedef NS_OPTIONS(NSUInteger, JRDrawLineWidthType) {
    /**
     *  宽度2
     */
    kDrawLineWidthThin = 2,
    /**
     *  宽度4
     */
    kDrawLineWidthMiddle = 2 << 1,
    /**
     *  宽度8
     */
    kDrawLineWidthBigger = 2 << 2,
    /**
     *  宽度16
     */
    kDrawLineWidthBiggest = 2 << 3
};


@interface BTDrawInfo : NSObject

@property (nonatomic, strong) NSMutableArray *linePoints;
@property (nonatomic, strong) UIColor        *lineColor;
@property (nonatomic, assign) CGFloat         lineWidth;

@property (nonatomic, assign) NSInteger       drawType;
@property (nonatomic, assign) CGSize          drawSize;

@property (nonatomic, assign) CGPoint         startPoint;
@property (nonatomic, assign) CGPoint         lastPoint;

- (id)initWithColor:(UIColor *)color andWidth:(CGFloat)width;

- (CGFloat)getLogicLineWidth;

@end



@protocol BTPictureDrawViewDelegate <NSObject>

@optional
-(void)pictureDrawViewTextLabelClick:(NSString *)text;
@end

@interface BTPictureDrawView : UIView

@property (nonatomic, strong) NSMutableArray *drawInfos;
@property (nonatomic, strong) NSMutableArray *drawInfosBak;
@property (nonatomic, strong) UIColor        *currentColor;
@property (nonatomic, assign) CGFloat         currentWidth;

@property (nonatomic, assign) JRDrawShapeType currentType;

/**<#属性名#> */
@property(nonatomic,strong) NSString *text;


/** 代理 */
@property(nonatomic, weak) id<BTPictureDrawViewDelegate> delegate;



/**
 画布大小有变动，需要重置数据
 */
- (void)resetSize;

/**
 后退
 */
- (void)back;

/**
 前进
 */
- (void)next;

/**
 清空
 */
- (void)clear;


- (void)addTextWithText:(NSString *)text;

@end
