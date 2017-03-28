//
//  UITextView+Placeholder.h
//  FenxiaoMS
//
//  Created by Locke on 2017/3/24.
//  Copyright © 2017年 lainkai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NSTextVerticalAlignment) {
    NSTextVerticalAlignmentCenter,
    NSTextVerticalAlignmentTop,
    NSTextVerticalAlignmentBottom
};

@interface UITextView (Placeholder)

@property (nullable, nonatomic, copy) NSString *placeholder;
@property (nullable, nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) NSTextVerticalAlignment placeholderAlignment;

@end
