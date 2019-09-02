//
//  BTBubbleMenuButton.h
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ExpansionDirection) {
    DirectionLeft = 0,
    DirectionRight,
    DirectionUp,
    DirectionDown
};

@class BTBubbleMenuButton;

@protocol BTBubbleMenuButtonDelegate <NSObject>

- (void)bubbleMenuButtonWillExpand:(BTBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidExpand:(BTBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonWillCollapse:(BTBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidCollapse:(BTBubbleMenuButton *)expandableView;

@end

@interface BTBubbleMenuButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak, readonly) NSArray *buttons;
@property (nonatomic, strong) UIView *homeButtonView;
@property (nonatomic, readonly) BOOL isCollapsed;
@property (nonatomic, weak) id <BTBubbleMenuButtonDelegate> delegate;


@property (nonatomic) enum ExpansionDirection direction;


@property (nonatomic) BOOL animatedHighlighting;


@property (nonatomic) BOOL collapseAfterSelection;


@property (nonatomic) float animationDuration;


@property (nonatomic) float standbyAlpha;


@property (nonatomic) float highlightAlpha;


@property (nonatomic) float buttonSpacing;

/**<#属性名#> */
@property(nonatomic) NSInteger type;

- (id)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction;


- (void)addButtons:(NSArray *)buttons;
- (void)addButton:(UIButton *)button;
- (void)showButtons;
- (void)dismissButtons;


@end
