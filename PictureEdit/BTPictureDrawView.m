//
//  BTPictureDrawView.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "BTPictureDrawView.h"
#import "BTDrawViewHelper.h"
#import "BTBubbleMenuButton.h"

@implementation BTDrawInfo
- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

- (id)initWithColor:(UIColor *)color andWidth:(CGFloat)width
{
    self = [self init];
    if(self)
    {
        self.lineColor = color;
        self.lineWidth = width;
        
    }
    
    return self;
}

- (NSMutableArray *)linePoints
{
    if(!_linePoints)
    {
        _linePoints = [NSMutableArray new];
    }
    
    return _linePoints;
}

- (CGFloat)getLogicLineWidth
{
    if(self.drawType == kDrawShapeEraser)
    {
        return kDrawLineWidthMiddle * 10. / 1000.0 * self.drawSize.width;
    }
    else
    {
        return self.lineWidth / 1000.0 * self.drawSize.width;
    }
}

- (void)setDrawSize:(CGSize)drawSize
{
    if(CGSizeEqualToSize(drawSize, CGSizeZero)) return;
    
    if(!CGSizeEqualToSize(_drawSize, drawSize))
    {
        for(int i = 0; i < self.linePoints.count; i++)
        {
            CGPoint nowPoint = [[self.linePoints objectAtIndex:i] CGPointValue];
            CGPoint logicPoint = [self getLogicPoint:nowPoint andSize:_drawSize];
            nowPoint = [self getLocalPoint:logicPoint andSize:drawSize];
            [self.linePoints replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:nowPoint]];
        }
        
        self.startPoint = [self getLogicPoint:self.startPoint andSize:_drawSize];
        self.startPoint = [self getLocalPoint:self.startPoint andSize:drawSize];
        
        self.lastPoint = [self getLogicPoint:self.lastPoint andSize:_drawSize];
        self.lastPoint = [self getLocalPoint:self.lastPoint andSize:drawSize];
        
        _drawSize = drawSize;
    }
}

/**
 获取逻辑坐标
 
 @param point 实际坐标
 @param size 实际size
 @return 逻辑坐标
 */
- (CGPoint)getLogicPoint:(CGPoint)point andSize:(CGSize)size
{
    CGPoint logicPoint;
    CGFloat XL = point.x/size.width - 0.5;
    CGFloat YL = point.y/size.height - 0.5;
    logicPoint = CGPointMake(XL, YL);
    return logicPoint;
}

/**
 获取实际坐标
 
 @param point 逻辑坐标
 @param size 逻辑size
 @return 实际坐标
 */
- (CGPoint)getLocalPoint:(CGPoint)point andSize:(CGSize)size
{
    CGPoint localPoint;
    CGFloat X = (point.x + 0.5) * size.width;
    CGFloat Y = (point.y + 0.5) * size.height;
    localPoint = CGPointMake(X, Y);
    return localPoint;
}

@end


@interface BTPictureDrawView ()

/** <#注释#> */
@property(nonatomic, strong) UILabel *textlabel;

/**撤销 */
@property(nonatomic,weak) UIButton *preBtn;

/**<#属性名#> */
@property(nonatomic,assign) BOOL isTouchMove;

@end

@implementation BTPictureDrawView

- (id)init
{
    self = [super init];
    if(self)
    {
        //设置默认参数
        self.backgroundColor = [UIColor clearColor];
        self.currentType  = kDrawShapeArrow;
        self.currentWidth = kDrawLineWidthBigger;
        self.currentColor = [UIColor redColor];
    }
    
    return self;
}

#pragma mark - getter setter
- (NSMutableArray *)drawInfos
{
    if(!_drawInfos)
    {
        _drawInfos = [NSMutableArray new];
    }
    
    return _drawInfos;
}

- (void)drawRect:(CGRect)rect
{
    [self drawWithRect:rect];
}

BOOL flag = NO;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouchMove = NO;
    //当是文字的时候,就要关闭移动画图
    if (self.currentType == kDrawShapeText) return;
    //两个手指及以上操作
    if(event.allTouches.count > 1) return;
    
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [self drawWithBeganPoint:startPoint];
}


//滑动手指才会来到这个方法
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouchMove =YES;
    if (self.currentType == kDrawShapeText) return;
    
    NSArray *pointArray = [touches allObjects];
    CGPoint movePoint = [[pointArray objectAtIndex:0] locationInView:self];
    [self drawWithMovedPoint:movePoint];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentType == kDrawShapeText) return;
    
    if (self.isTouchMove) {
        
        //存的是已经完成绘画,用于回退和下一步
        self.drawInfosBak = [self.drawInfos mutableCopy];//深拷贝
    }
    else
    {
        //点击时间,就会到上一步,清除单击引起的绘画,防止单击后引起的绘画失效
        [self back];
        
    }
    
    
}


/**
 局部刷新时重新draw一次
 
 @param rect 刷新区域
 */
- (void)drawWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    for(BTDrawInfo *drawInfo in self.drawInfos)
    {
        if(drawInfo.linePoints.count <= 0) return;
        
        CGContextMoveToPoint(context, drawInfo.startPoint.x, drawInfo.startPoint.y);
        CGContextSetLineWidth(context, [drawInfo getLogicLineWidth]);
        CGContextSetStrokeColorWithColor(context, drawInfo.lineColor.CGColor);
        
        switch (drawInfo.drawType) {
            case kDrawShapeDoodle:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                if(drawInfo.linePoints.count > 0)
                {
                    for(int i = 0; i < drawInfo.linePoints.count; i++)
                    {
                        CGPoint movePoint = [[drawInfo.linePoints objectAtIndex:i] CGPointValue];
                        CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                    }
                }
            }
                break;
                
            case kDrawShapeEraser:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeClear);
                if(drawInfo.linePoints.count > 0)
                {
                    for(int i = 0; i < drawInfo.linePoints.count; i++)
                    {
                        CGPoint movePoint = [[drawInfo.linePoints objectAtIndex:i] CGPointValue];
                        CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                    }
                }
                
            }
                break;
            case kDrawShapeRect:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGRect rect = [self getRectFromPoint:drawInfo.startPoint toPoint:[[drawInfo.linePoints firstObject] CGPointValue]];
                CGContextAddRect(context, rect);
            }
                break;
            case kDrawShapeRound:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGRect rect = [self getRectFromPoint:drawInfo.startPoint toPoint:[[drawInfo.linePoints firstObject] CGPointValue]];
                CGContextAddEllipseInRect(context, rect);
            }
                break;
            case kDrawShapeLine:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGPoint movePoint = [[drawInfo.linePoints firstObject] CGPointValue];
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
            }
                break;
            case kDrawShapeArrow:
            {
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGPoint movePoint = [[drawInfo.linePoints firstObject] CGPointValue];
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                double slopy, cosy, siny;
                //箭头尺寸
                double length = drawInfo.lineWidth * 5;
                double width = drawInfo.lineWidth * 5;
                
                double distance = [BTDrawViewHelper distanceFromPoint:drawInfo.startPoint toPoint:movePoint];
                if(width >= distance * 0.5)
                {
                    length = width = distance * 0.5;
                }
                
                slopy = atan2((drawInfo.startPoint.y - movePoint.y), (drawInfo.startPoint.x - movePoint.x));
                cosy = cos(slopy);
                siny = sin(slopy);
                
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, movePoint.x, movePoint.y);
                CGContextAddLineToPoint(context,
                                        movePoint.x + (length * cosy - (width / 2.0 * siny)),
                                        movePoint.y + (length * siny + (width / 2.0 * cosy)));
                CGContextMoveToPoint(context, movePoint.x, movePoint.y);
                CGContextAddLineToPoint(context,
                                        movePoint.x + (length * cosy + width / 2.0 * siny),
                                        movePoint.y - (width / 2.0 * cosy - length * siny));
            }
                break;
            default:
                break;
        }
        
        CGContextStrokePath(context);
    }
}

- (void)resetSize
{
    for(BTDrawInfo *drawInfo in self.drawInfos)
    {
        drawInfo.drawSize = self.bounds.size;
    }
    
    for(BTDrawInfo *drawInfo in self.drawInfosBak)
    {
        drawInfo.drawSize = self.bounds.size;
    }
}

//回到上一步
- (void)back
{
    if(self.drawInfos.count > 0){
        [self.drawInfos removeLastObject];
        [self setNeedsDisplay];
    }else{//清除Label
            NSArray *viewArray =  (id)[self subviews];
            if (viewArray.count > 0)
            {
                if ([viewArray.lastObject isKindOfClass:[UILabel class]]) {
                    [viewArray.lastObject removeFromSuperview];
                }
            }
    }
}

//回到下一步
- (void)next
{
    if(self.drawInfos.count >= self.drawInfosBak.count) return;
    [self.drawInfos addObject:self.drawInfosBak[self.drawInfos.count]];
    [self setNeedsDisplay];
}

//一键清除所有
- (void)clear
{
    [self.drawInfos removeAllObjects];
    [self setNeedsDisplay];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
}


- (void)drawWithBeganPoint:(CGPoint)point
{
    BTDrawInfo *drawInfo = [BTDrawInfo new];
    drawInfo.lineColor = self.currentColor;
    drawInfo.lineWidth = self.currentWidth;
    drawInfo.drawType  = self.currentType;
    drawInfo.drawSize = self.bounds.size;
    drawInfo.startPoint = drawInfo.lastPoint = point;
    [self.drawInfos addObject:drawInfo];
    
    CGRect needsDisplayRect = [self getRectFromPoint:point toPoint:point lineWidth:drawInfo.lineWidth];
    [self setNeedsDisplayInRect:needsDisplayRect];
}

- (void)drawWithMovedPoint:(CGPoint)point
{
    BTDrawInfo *lastDrawInfo = [self.drawInfos lastObject];
    if(lastDrawInfo.linePoints.count == 0 || lastDrawInfo.drawType == kDrawShapeDoodle || lastDrawInfo.drawType == kDrawShapeEraser)
    {
        [lastDrawInfo.linePoints addObject:[NSValue valueWithCGPoint:point]];
    }
    else
    {
        [lastDrawInfo.linePoints replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:point]];
    }
    
    switch (lastDrawInfo.drawType) {
        case kDrawShapeDoodle:
        case kDrawShapeEraser:
        {
            CGRect needsDisplayRect = [self getRectFromPoint:lastDrawInfo.lastPoint toPoint:point lineWidth:lastDrawInfo.lineWidth];
            [self setNeedsDisplayInRect:needsDisplayRect];
            lastDrawInfo.lastPoint = point;
        }
            break;
        default:
        {
            CGRect needsDisplayRect = [self getRectFromPoint:lastDrawInfo.startPoint toPoint:lastDrawInfo.lastPoint lineWidth:lastDrawInfo.lineWidth];
            [self setNeedsDisplayInRect:needsDisplayRect];
            
            if(!CGRectContainsPoint(needsDisplayRect, point))
            {
                needsDisplayRect = [self getRectFromPoint:lastDrawInfo.startPoint toPoint:point lineWidth:lastDrawInfo.lineWidth];
                [self setNeedsDisplayInRect:needsDisplayRect];
            }
            
            lastDrawInfo.lastPoint = point;
        }
            break;
    }
}

/**
 *  根据移动的前后两个点计算足够的画板刷新区域
 *
 *  @param fromPoint  前一个点
 *  @param toPoint 后一个点
 *
 *  @return drawRect方法的刷新区域
 */
- (CGRect)getRectFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint lineWidth:(CGFloat)lineWidth
{
    CGFloat brushWidth = lineWidth * 10;
    CGRect drawRect = CGRectMake(MIN(fromPoint.x, toPoint.x) - brushWidth, MIN(fromPoint.y, toPoint.y) - brushWidth, ABS(fromPoint.x- toPoint.x) + brushWidth + lineWidth, ABS(fromPoint.y - toPoint.y) + brushWidth + lineWidth);
    drawRect.size.width *= 1.2;
    drawRect.size.height *= 1.2;
    return drawRect;
}

- (CGRect)getRectFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGRect drawRect = CGRectMake(fromPoint.x, fromPoint.y, toPoint.x - fromPoint.x , toPoint.y - fromPoint.y);
    return drawRect;
}


#pragma mark 增加文字代理方法
- (void)addTextWithText:(NSString *)text
{
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 100)];
    textlabel.font = [UIFont systemFontOfSize:25];
    textlabel.numberOfLines = 0;
    textlabel.textColor = self.currentColor;
    textlabel.tag = 900;
    textlabel.lineBreakMode = 0;
    textlabel.text = text;
    [textlabel sizeToFit];
    textlabel.center =self.center;
    textlabel.userInteractionEnabled = YES;
    [self addSubview:textlabel];
    self.textlabel = textlabel;
    
    //点击
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
    [textlabel addGestureRecognizer:tapLabel];
    //拖拽
    UIPanGestureRecognizer *panLabel = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panLabel:)];
    [textlabel addGestureRecognizer:panLabel];
    //旋转
    UIRotationGestureRecognizer *rota = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [textlabel addGestureRecognizer:rota];
    //缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [textlabel addGestureRecognizer:pinch];
}

-(void)tapLabel:(UITapGestureRecognizer *)tap{
    if (self.currentType != kDrawShapeText) return;
    UILabel *label = (UILabel *)tap.view;
    //    self.textlabel.text = @"999999999";
    if ([self.delegate respondsToSelector:@selector(pictureDrawViewTextLabelClick:)]) {
        [self.delegate pictureDrawViewTextLabelClick:label.text];
    }
    [label removeFromSuperview];
    [self setNeedsDisplay];
}

//放大
-(void)pinch:(UIPinchGestureRecognizer *)pin{
    if (self.currentType != kDrawShapeText) return;
    pin.view.transform = CGAffineTransformScale(pin.view.transform, pin.scale, pin.scale);
    //重置缩放系数
    pin.scale = 1.0;
    [self setNeedsDisplay];
}
//旋转
-(void)rotation:(UIRotationGestureRecognizer *)rota{
    //rota.rotation 旋转的角度
    if (self.currentType != kDrawShapeText) return;
    rota.view.transform = CGAffineTransformRotate(rota.view.transform, rota.rotation);
    //重置角度
    rota.rotation = 0;
    [self setNeedsDisplay];
}
//拖拽
- (void)panLabel:(UIPanGestureRecognizer *)panLabel
{
    //if (self.currentType != kDrawShapeText) return;
    UILabel *textlabel = (UILabel *)[self viewWithTag:900];
    CGPoint point =  [panLabel  translationInView:textlabel];
    // NSLog(@"%f %f",point.x ,point.y);
    //改变中心点坐标（原来的中心点+偏移量=当前的中心点）
    panLabel.view.center = CGPointMake(panLabel.view. center.x+point.x, panLabel.view.center.y+point.y);
    //每次调用完之后，需要重置手势的偏移量，否则平移手势会自动累加偏移量
    //CGPointMake(0, 0)<==>CGPointZero
    [panLabel setTranslation:CGPointZero inView:textlabel];
    
    [self setNeedsDisplay];
}


@end
