# TextViewPlaceholder
给UITextView添加了placeholder属性，并且可以修改placeholder的颜色和垂直位置
```
// 垂直对齐枚举
typedef NS_ENUM(NSUInteger, NSTextVerticalAlignment) {
    NSTextVerticalAlignmentCenter,
    NSTextVerticalAlignmentTop,
    NSTextVerticalAlignmentBottom
};

@interface UITextView (Placeholder)

@property (nullable, nonatomic, copy) NSString *placeholder;// 占位符
@property (nullable, nonatomic, strong) UIColor *placeholderColor;// 颜色
@property (nonatomic) NSTextVerticalAlignment placeholderAlignment;// 垂直对齐方式

@end
```

