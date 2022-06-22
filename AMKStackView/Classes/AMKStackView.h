//
//  AMKStackView.h
//  AMKStackView
//
//  Created by 孟昕欣 on 2022/6/22.
//

#import <UIKit/UIKit.h>

/// 类似 UIStackView
@interface AMKStackView : UIView

/// 布局被管理的子视图的主轴
@property (nonatomic, assign, readwrite) UILayoutConstraintAxis axis;

/// 布局被管理的子视图的间距
@property (nonatomic, assign, readwrite) CGFloat spacing;

/// 布局被管理的子视图的内边距，默认 UIEdgeInsetsZero
@property (nonatomic, assign, readwrite) UIEdgeInsets contentInset;

/// 所有被管理的子视图
@property (nonatomic, copy, readonly, nullable) NSArray<__kindof UIView *> *arrangedSubviews;

/// 初始化
- (instancetype)initWithAxis:(UILayoutConstraintAxis)axis spacing:(CGFloat)spacing;

/// 添加子视图
- (void)addArrangedSubview:(UIView *)view;

/// 移除子视图
- (void)removeArrangedSubview:(UIView *)view;

/// 插入子视图
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;

@end


#pragma mark -


#if __has_include(<YYCategories/YYCategories.h>)
#import <YYCategories/YYCategories.h>

@interface AMKStackView (AMKHelperMethods)

/// 添加按钮（默认主轴方向的大小）
- (UIButton *)addArrangedButton:(NSString *)title controlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/// 添加按钮（指定主轴方向的大小）
- (UIButton *)addArrangedButton:(NSString *)title size:(CGFloat)size controlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/// 供 Debug 使用：添加分割线，并可指定标题
- (UIView *)addArrangedSeparatorWithTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size;

@end

#endif
