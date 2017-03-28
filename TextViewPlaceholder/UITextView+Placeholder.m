//
//  UITextView+Placeholder.m
//  FenxiaoMS
//
//  Created by Locke on 2017/3/24.
//  Copyright © 2017年 lainkai. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>

@interface VerticalAlignLabel : UILabel

@property (nonatomic, assign) NSTextVerticalAlignment textVerticalAlignment;

@end

@implementation VerticalAlignLabel

-  (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_textVerticalAlignment) {
        case NSTextVerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case NSTextVerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case NSTextVerticalAlignmentCenter:
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect {
    CGRect finalRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:finalRect];
}

@end


@implementation NSObject (Swizzling)

- (void)swizzlingInstanceMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

static const void *PlaceholderKey = (void *)@"PlaceholderKey";
static const void *PlaceholderColorKey = (void *)@"PlaceholderColorKey";
static const void *PlaceholderAlignmentKey = (void *)@"PlaceholderAlignmentKey";
@implementation UITextView (Placeholder)
@dynamic placeholderAlignment;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("UITextView") swizzlingInstanceMethod:@selector(initWithFrame:) swizzledSelector:@selector(swizzling_initWithFrame:)];
        [objc_getClass("UITextView") swizzlingInstanceMethod:@selector(layoutSubviews) swizzledSelector:@selector(swizzling_layoutSubviews)];
        [objc_getClass("UITextView") swizzlingInstanceMethod:@selector(setFont:) swizzledSelector:@selector(swizzling_setFont:)];
    });
}


- (NSString *)placeholder {
    return objc_getAssociatedObject(self, PlaceholderKey);
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, PlaceholderKey, placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (placeholderLabel) {
        placeholderLabel.text = placeholder;
        if (!self.text.length && placeholderLabel.isHidden) {
            placeholderLabel.hidden = NO;
        }
    }
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, PlaceholderColorKey);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, PlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (placeholderLabel) {
        placeholderLabel.textColor = placeholderColor;
    }
}

- (NSTextVerticalAlignment)placeholderAlignment {
    return [objc_getAssociatedObject(self, PlaceholderAlignmentKey) integerValue];
}

- (void)setPlaceholderAlignment:(NSTextVerticalAlignment)placeholderAlignment {
    NSNumber *alignment = [NSNumber numberWithInteger:placeholderAlignment];
    objc_setAssociatedObject(self, PlaceholderAlignmentKey, alignment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (placeholderLabel) {
        placeholderLabel.textVerticalAlignment = placeholderAlignment;
    }
}

- (instancetype)swizzling_initWithFrame:(CGRect)frame {
    UITextView *textView = [self swizzling_initWithFrame:frame];
    if (textView) {
        VerticalAlignLabel *placeholderLabel = [[VerticalAlignLabel alloc] init];
        placeholderLabel.tag = 666;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        placeholderLabel.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:0.70];
        placeholderLabel.hidden = YES;
        [textView addSubview:placeholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return textView;
}

- (void)swizzling_layoutSubviews {
    [self swizzling_layoutSubviews];
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (placeholderLabel) {
        placeholderLabel.frame = CGRectMake(3, 7, self.frame.size.width - 6, self.frame.size.height - 14);
    }
}

- (void)swizzling_setFont:(UIFont *)font {
    [self swizzling_setFont:font];
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (placeholderLabel) {
        placeholderLabel.font = font;
    }
}

- (void)textViewTextDidChange {
    VerticalAlignLabel *placeholderLabel = (VerticalAlignLabel *)[self viewWithTag:666];
    if (!self.text.length && placeholderLabel && placeholderLabel.isHidden) {
        placeholderLabel.hidden = NO;
    } else if(self.text.length && !placeholderLabel.isHidden) {
        placeholderLabel.hidden = YES;
    }
}

@end
