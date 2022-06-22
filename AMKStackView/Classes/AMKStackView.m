//
//  AMKStackView.m
//  AMKStackView
//
//  Created by 孟昕欣 on 2022/6/22.
//

#import "AMKStackView.h"
#import <Masonry/Masonry.h>

static NSString *kArrangedSubviewsArrayKey = @"arrangedSubviews";
static void *kArrangedSubviewsKVOContext = &kArrangedSubviewsKVOContext;

@interface AMKStackView ()
@property (nonatomic, copy, readwrite, nullable) NSMutableArray<__kindof UIView *> *arrangedSubviews;
@end

@implementation AMKStackView

#pragma mark - Init Methods

- (void)dealloc {
    [self removeObserver:self forKeyPath:kArrangedSubviewsArrayKey context:kArrangedSubviewsKVOContext];
}

- (instancetype)initWithAxis:(UILayoutConstraintAxis)axis spacing:(CGFloat)spacing {
    if (self = [self initWithFrame:CGRectZero]) {
        self.axis = axis;
        self.spacing = spacing;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addObserver:self forKeyPath:kArrangedSubviewsArrayKey options:NSKeyValueObservingOptionNew context:kArrangedSubviewsKVOContext];
    }
    return self;
}

#pragma mark - Getters & Setters

- (NSMutableArray<__kindof UIView *> *)arrangedSubviews {
    if (!_arrangedSubviews) {
        _arrangedSubviews = @[].mutableCopy;
    }
    return _arrangedSubviews;
}

#pragma mark - Data & Networking

#pragma mark - Layout Subviews

- (void)addArrangedSubview:(UIView *)view {
    // 若视图不存在，则直接返回
    if (!view) return;
    
    // 若已加入管理，则直接返回
    if ([self.arrangedSubviews containsObject:view]) return;
    
    // 添加视图，并加入管理
    [self addSubview:view];
    [[self mutableArrayValueForKey:kArrangedSubviewsArrayKey] addObject:view];
}

- (void)removeArrangedSubview:(UIView *)view {
    // 若视图不存在，则直接返回
    if (!view) return;
    
    // 若不是子视图，则直接返回
    if (view.superview != self) return;
    
    // 移除视图，更新管理
    [view removeFromSuperview];
    [[self mutableArrayValueForKey:kArrangedSubviewsArrayKey] removeObject:view];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    // 若视图不存在，则直接返回
    if (!view) return;
    
    // 若不是子视图，则添加为子视图，并更新管理
    if (view.superview != self) {
        [self addSubview:view];
        [[self mutableArrayValueForKey:kArrangedSubviewsArrayKey] insertObject:view atIndex:MIN(self.arrangedSubviews.count, stackIndex)];
    }
    // 否则已是子视图，则调整位置，并更新管理
    else {
        // 若更新后位置不变，则直接返回
        NSUInteger fromIndex = [self.arrangedSubviews indexOfObject:view];
        NSUInteger toIndex = MIN(self.arrangedSubviews.count, stackIndex);
        if (fromIndex == toIndex) return;
        
        // 先用 NSNull.null 占位，再插入视图，再移除占位的 NSNull.null，最后更新管理
        [(NSMutableArray *)self.arrangedSubviews replaceObjectAtIndex:fromIndex withObject:NSNull.null];
        [(NSMutableArray *)self.arrangedSubviews insertObject:view atIndex:toIndex];
        [(NSMutableArray *)self.arrangedSubviews removeObjectAtIndex:fromIndex];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    NSArray<UIView *> *subviews = self.arrangedSubviews;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (idx == 0) {
                    make.left.mas_equalTo(self).insets(self.contentInset);
                } else {
                    make.left.mas_equalTo(subviews[idx-1].mas_right).offset(self.spacing);
                }
                make.width.mas_equalTo(subview.width);
                make.top.bottom.mas_equalTo(self).insets(self.contentInset);
            }];
        }];
    } else {
        [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (idx == 0) {
                    make.top.mas_equalTo(self).insets(self.contentInset);
                } else {
                    make.top.mas_equalTo(subviews[idx-1].mas_bottom).offset(self.spacing);
                }
                make.height.mas_equalTo(subview.height);
                make.left.right.mas_equalTo(self).insets(self.contentInset);
            }];
        }];
    }
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Notifications

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == kArrangedSubviewsKVOContext) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Protocol

#pragma mark - Overrides

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view==self ? nil : view;
}

#pragma mark - Helper Methods

@end


#pragma mark -


#if __has_include(<YYCategories/YYCategories.h>)

@implementation AMKStackView (AMKHelperMethods)

- (UIButton *)addArrangedButton:(NSString *)title controlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    return [self addArrangedButton:title size:40 controlEvents:controlEvents block:block];
}

- (UIButton *)addArrangedButton:(NSString *)title size:(CGFloat)size controlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        button.width = size;
    } else {
        button.height = size;
    }
    button.layer.borderWidth = 1;
    button.layer.borderColor = self.tintColor.CGColor;
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.tintColor forState:UIControlStateNormal];
    [button addBlockForControlEvents:controlEvents block:block];
    [self addArrangedSubview:button];
    return button;
}

- (UIView *)addArrangedSeparatorWithTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size {
    UILabel *label = [UILabel.alloc init];
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        label.width = size;
    } else {
        label.height = size;
    }
    label.font = [UIFont boldSystemFontOfSize:size*0.9];
    label.textColor = color ?: self.tintColor;
    label.text = title;
    
    UIView *bottomSeparator = [UIView.alloc init];
    bottomSeparator.backgroundColor = color ?: [self.tintColor colorWithAlphaComponent:.3];
    [label addSubview:bottomSeparator];
    [bottomSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            make.top.bottom.mas_equalTo(label);
            make.centerX.mas_equalTo(label.mas_right);
            make.width.mas_equalTo(1);
        } else {
            make.left.right.mas_equalTo(label);
            make.centerY.mas_equalTo(label.mas_bottom);
            make.height.mas_equalTo(1);
        }
    }];
    
    [self addArrangedSubview:label];
    return label;
}

@end

#endif
