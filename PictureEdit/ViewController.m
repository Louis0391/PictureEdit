//
//  ViewController.m
//  PictureEdit
//
//  Created by hqc on 2019/9/2.
//  Copyright © 2019年 hqc. All rights reserved.
//

#import "ViewController.h"
#import "BTEditPictureViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)jumpToEditPicture:(UIButton *)sender {
    BTEditPictureViewController *editVC = [[BTEditPictureViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
