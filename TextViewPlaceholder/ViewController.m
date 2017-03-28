//
//  ViewController.m
//  TextViewPlaceholder
//
//  Created by Locke on 2017/3/24.
//  Copyright © 2017年 lainkai. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+Placeholder.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
    textView.backgroundColor = [UIColor yellowColor];
    textView.placeholder = @"在日常开发中";
    textView.placeholderColor = [UIColor redColor];
    textView.placeholderAlignment = NSTextVerticalAlignmentTop;
    textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
