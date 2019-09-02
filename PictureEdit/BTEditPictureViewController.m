//
//  BTEditPictureViewController.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "BTEditPictureViewController.h"

#import "BTPictureDrawView.h"

#import "BTBubbleMenuButton.h"

#import "BTAddTextView.h"
#import "UIView+Frame.h"
#import "BTCover.h"

@interface BTEditPictureViewController ()<UIActionSheetDelegate,BTAddTextViewDelegate,BTPictureDrawViewDelegate>

@property (nonatomic, strong) BTPictureDrawView *drawView;

@property (nonatomic, strong) NSArray *toolArray;

@property (nonatomic, strong) NSArray *colorArray;

@property (nonatomic, strong) NSArray *toolSelArray;

@property (nonatomic, strong) NSArray *colorSelArray;

@property (nonatomic, strong) UIButton *selectedButton;
/**<#属性名#> */
@property(nonatomic,weak) BTBubbleMenuButton *colorMenuView;
/**<#属性名#> */
@property(nonatomic,weak) BTBubbleMenuButton *toolMenuView;
/** <#注释#> */
@property(nonatomic, weak) UIButton *preBtn;
/** <#注释#> */
@property(nonatomic, weak) UIButton *nextBtn;
/** <#注释#> */
@property(nonatomic, strong) NSString *text;
/** <#注释#> */
@property(nonatomic, weak) UIButton *cancelBtn;
/** <#注释#> */
@property(nonatomic, weak) UIButton *sureBtn;
/**<#属性名#> */
@property(nonatomic,strong) UIImageView *toolImageView;
/**<#属性名#> */
@property(nonatomic,strong) UIImageView *colorImageView;
/**<#属性名#> */
@property(nonatomic,weak) BTAddTextView *textView;
/**<#属性名#> */
@property(nonatomic,assign) NSInteger type;

/**<#属性名#> */
@property(nonatomic,strong) UIImage *selectImage;

/**<#属性名#> */
@property(nonatomic,weak) UIImageView *imageView;


@end

@implementation BTEditPictureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.toolArray = @[@"picture_tool_arrow_default",@"picture_tool_text_default",@"picture_tool_rect_default",@"picture_tool_brush_default"];
    //self.toolSelArray = @[@"picture_tool_arrow_selected",@"picture_tool_text_selected",@"picture_tool_rect_selected",@"picture_tool_brush_selected"];
    
     self.toolArray = @[@"picture_tool_arrow_default",@"picture_tool_rect_default",@"picture_tool_brush_default"];
    
    self.toolSelArray = @[@"picture_tool_arrow_selected",@"picture_tool_rect_selected",@"picture_tool_brush_selected"];
    
    self.colorArray = @[@"picture_red_default",@"picture_blue_default",@"picture_green_default",@"picture_black_default"];
    
    self.colorSelArray = @[@"picture_red_selected",@"picture_blue_selected",@"picture_green_selected",@"picture_black_selected"];
    [self setUpViews];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
  
}

- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)setUpViews

{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (self.editImage == nil) {
        self.editImage = [UIImage imageNamed:@"homviewbg"];
    }
   
    
    imageView.image = self.editImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
  
    imageView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150);
    //imageView.backgroundColor = [UIColor redColor];

    
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    BTPictureDrawView *drawView = [[BTPictureDrawView alloc] init];
//    drawView.backgroundColor = [UIColor redColor];
    drawView.delegate = self;
    drawView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150);
    self.drawView = drawView;
    [self.view addSubview:drawView];
    
    UIImageView *toolImageView = [self createHomeToolView];
    UIImageView *colorImageView = [self createHomeColorView];
    self.toolImageView = toolImageView;
    self.colorImageView = colorImageView;
    
    BTBubbleMenuButton *colorMenuView = [[BTBubbleMenuButton alloc] initWithFrame:CGRectMake(20.f,self.view.height - toolImageView.height - 20.f,toolImageView.width,toolImageView.height) expansionDirection:DirectionUp];
    
    colorMenuView.type = 100;
    
    colorMenuView.homeButtonView = colorImageView;

    [colorMenuView addButtons:[self createDemoButtonArrayWith:self.colorArray memnuView:colorMenuView]];
    [self.view addSubview:colorMenuView];
    BTBubbleMenuButton *toolMenuView = [[BTBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.width - toolImageView.width - 20.f,self.view.height - toolImageView.height - 20.f,toolImageView.width,toolImageView.height) expansionDirection:DirectionUp];
    
    toolMenuView.type = 200;
    
    toolMenuView.homeButtonView = toolImageView;
    
    [toolMenuView addButtons:[self createDemoButtonArrayWith:self.toolArray memnuView:toolMenuView]];
    [self.view addSubview:toolMenuView];
    self.toolMenuView = toolMenuView;
    self.colorMenuView = colorMenuView;
    UIButton *preBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width * 0.5 - 20 - 40, colorMenuView.y, 40, 40)];
    [preBtn setBackgroundImage:[UIImage imageNamed:@"picture_tool_pre_disabled"] forState:UIControlStateNormal];
    [preBtn setBackgroundImage:[UIImage imageNamed:@"picture_tool_pre_disabled"] forState:UIControlStateDisabled];
    [preBtn addTarget:self action:@selector(preBtnDidClick:) forControlEvents:UIControlEventTouchDown];
    self.preBtn = preBtn;
    [self.view addSubview:preBtn];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width * 0.5 + 20, toolMenuView.y, 40, 40)];
    
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"picture_tool_next_disabled"] forState:UIControlStateNormal];
    
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"picture_tool_next_disabled"] forState:UIControlStateDisabled];
    
    [nextBtn addTarget:self action:@selector(nextBtnDidClick:) forControlEvents:UIControlEventTouchDown];
    
    self.nextBtn = nextBtn;
    [self.view addSubview:nextBtn];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 40, 20)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn = cancelBtn;
    [self.view addSubview:cancelBtn];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 30, 40, 20)];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#32b4ff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
      [cancelBtn addTarget:self action:@selector(cancelBtnDidClick) forControlEvents:UIControlEventTouchDown];
    
    [sureBtn addTarget:self action:@selector(sureBtnDidClick) forControlEvents:UIControlEventTouchDown];
    
}
-(void)cancelBtnDidClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sureBtnDidClick{
    
  
}

-(void)preBtnDidClick:(UIButton *)prebtn{
    if (self.drawView.drawInfos.count >= 1) {
        [self.drawView back];
        [self.drawView resetSize];
       
    }
}

-(void)nextBtnDidClick:(UIButton *)nextbtn{
    if (self.drawView.drawInfos.count < self.drawView.drawInfosBak.count) {
        [self.drawView next];
        [self.drawView resetSize];
    }
}

-(void)pictureDrawViewTextLabelClick:(NSString *)text{
    self.text = text;
    [self setUpTextView];
}
- (NSArray *)createDemoButtonArrayWith:(NSArray *)array memnuView:(BTBubbleMenuButton *)memnuView{
    
    self.type = memnuView.type;
     NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
     NSInteger count =array.count;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 34, 34);
        
        button.tag = i;
        
        if (memnuView.type == 100) {            [button addTarget:self action:@selector(colorButtonDidClick:) forControlEvents:UIControlEventTouchDown];        }else if (memnuView.type == 200){            [button addTarget:self action:@selector(toolButtonDidClick:) forControlEvents:UIControlEventTouchDown];
        }
        [buttonsMutable addObject:button];
    }
    return [buttonsMutable copy];
}

- (void)colorButtonDidClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            self.drawView.currentColor = [UIColor redColor];
            break;
        case 1:
            self.drawView.currentColor = [UIColor colorWithHexString:@"#007aff"];
            break;
        case 2:
            self.drawView.currentColor = [UIColor colorWithHexString:@"#4bd754"];
            break;
        case 3:
            self.drawView.currentColor = [UIColor colorWithHexString:@"#323232"];
            break;
        default:
            break;
    }
    NSString *colorString = self.colorSelArray[sender.tag];
    self.colorImageView.image =[UIImage imageNamed:colorString];
}
- (void)toolButtonDidClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            self.drawView.currentType = kDrawShapeArrow;
            break;
        case 1:
            {
            self.drawView.currentType = kDrawShapeText;
            [self setUpTextView];
            }
            break;
          case 2:
             self.drawView.currentType = kDrawShapeRect;
            break;
          case 3:
            self.drawView.currentType = kDrawShapeDoodle;
            break;
        default:
            break;
    }
    NSString *toolString = self.toolSelArray[sender.tag];
    self.toolImageView.image =[UIImage imageNamed:toolString];
}
-(void)setUpTextView{
    [BTCover show];
    
    BTAddTextView  *textView = [[BTAddTextView alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width - 80, 150)];
    textView.centerX = self.view.centerX;
    textView.textView.text = self.text;
    textView.delegate = self;
    [UIView animateWithDuration:0.35 animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:textView];
        //[self.view addSubview:textView];
    }];
    self.text = @"";
    [self.toolMenuView dismissButtons];
}
-(void)addTextViewSureBtnDidClick:(BTAddTextView *)addtextView textView:(UITextView *)textView{
    
    self.text = textView.text;
    
    [self.drawView addTextWithText:self.text];
    
}

- (UIImageView *)createHomeColorView {
    UIImageView *colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 34, 34)];
    colorImageView.image = [UIImage imageNamed:@"picture_colour_pop"];
    return colorImageView;
}

- (UIImageView *)createHomeToolView {
    UIImageView *toolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 34, 34)];
    toolImageView.image = [UIImage imageNamed:@"picture_tool_open"];
    return toolImageView;
}






-(void)addSavaToAlbumClick{
  
 }

@end

