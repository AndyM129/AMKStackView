//
//  AMKViewController.m
//  AMKStackView
//
//  Created by mengxinxin on 06/22/2022.
//  Copyright (c) 2022 mengxinxin. All rights reserved.
//

#import "AMKViewController.h"
#import <AMKStackView/AMKStackView.h>
#import <Masonry/Masonry.h>

@interface AMKViewController ()
@property (nonatomic, strong, readwrite, nullable) AMKStackView *stackView1;
@property (nonatomic, strong, readwrite, nullable) AMKStackView *stackView2;
@property (nonatomic, strong, readwrite, nullable) AMKStackView *stackView3;
@end

@implementation AMKViewController

#pragma mark - Dealloc

- (void)dealloc {
    
}

#pragma mark - Init Methods

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AMKStackView Example";
    self.view.backgroundColor = self.view.backgroundColor?:[UIColor whiteColor];
    
    // 竖向布局
    [self.stackView1 addArrangedButton:@"Button 1.1" controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView1 addArrangedButton:@"Button 1.2" controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView1 addArrangedButton:@"Button 1.3" controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stackView1.arrangedSubviews.lastObject).offset(self.stackView1.contentInset.bottom);
    }];
    
    // 横向布局
    [self.stackView2 addArrangedButton:@"Button 2.1" size:100 controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView2 addArrangedButton:@"Button 2.2" size:100 controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView2 addArrangedButton:@"Button 2.3" size:100 controlEvents:UIControlEventTouchUpInside block:^(id sender) { }];
    [self.stackView2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.stackView2.arrangedSubviews.lastObject).offset(self.stackView2.contentInset.right);
    }];
    
    // 混合布局
    [self.stackView3 addArrangedSubview:[self viewWithSize:CGSizeMake(40, 40) backgroundColor:[self.view.tintColor colorWithAlphaComponent:0.4]]];
    [self.stackView3 addArrangedSubview:[self viewWithSize:CGSizeMake(40, 40) backgroundColor:[self.view.tintColor colorWithAlphaComponent:0.6]]];
    [self.stackView3 addArrangedSubview:[self viewWithSize:CGSizeMake(40, 40) backgroundColor:[self.view.tintColor colorWithAlphaComponent:0.8]]];
    [self.stackView3 addArrangedSubview:[self stackViewWithAxis:UILayoutConstraintAxisHorizontal backgroundColor:self.view.tintColor]];
    [self.stackView3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.stackView3.arrangedSubviews.lastObject).offset(self.stackView3.contentInset.bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Getters & Setters

- (AMKStackView *)stackView1 {
    if (!_stackView1) {
        _stackView1 = [AMKStackView.alloc initWithAxis:UILayoutConstraintAxisVertical spacing:20];
        _stackView1.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _stackView1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self.view addSubview:_stackView1];
        [_stackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(UIApplication.sharedApplication.statusBarFrame.size.height + 44 + 20);
            make.left.right.mas_equalTo(self.view).inset(20);
        }];
    }
    return _stackView1;
}

- (AMKStackView *)stackView2 {
    if (!_stackView2) {
        _stackView2 = [AMKStackView.alloc initWithAxis:UILayoutConstraintAxisHorizontal spacing:10];
        _stackView2.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _stackView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self.view addSubview:_stackView2];
        [_stackView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stackView1.mas_bottom).offset(20);
            make.left.mas_equalTo(self.view).inset(20);
            make.right.mas_lessThanOrEqualTo(self.view).inset(20);
            make.height.mas_equalTo(40 + _stackView2.contentInset.top + _stackView2.contentInset.bottom);
        }];
    }
    return _stackView2;
}

- (AMKStackView *)stackView3 {
    if (!_stackView3) {
        _stackView3 = [AMKStackView.alloc initWithAxis:UILayoutConstraintAxisVertical spacing:10];
        _stackView3.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _stackView3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self.view addSubview:_stackView3];
        [_stackView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stackView2.mas_bottom).offset(20);
            make.left.right.mas_equalTo(self.view).inset(20);
        }];
    }
    return _stackView3;
}

#pragma mark - Data & Networking

#pragma mark - Layout Subviews

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Notifications

#pragma mark - KVO

#pragma mark - Protocol

#pragma mark - Overrides

#pragma mark - Helper Methods

- (UIView *)viewWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor {
    UIView *view = [UIView.alloc init];
    view.size = size;
    view.backgroundColor = backgroundColor;
    return view;
}

- (AMKStackView *)stackViewWithAxis:(UILayoutConstraintAxis)axis backgroundColor:(UIColor *)backgroundColor {
    AMKStackView *stackView = [AMKStackView.alloc initWithAxis:axis spacing:10];
    stackView.height = 40;
    stackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];

    [stackView addArrangedSubview:[self viewWithSize:CGSizeMake(100, 0) backgroundColor:backgroundColor]];
    [stackView addArrangedSubview:[self viewWithSize:CGSizeMake(100, 0) backgroundColor:backgroundColor]];
    [stackView addArrangedSubview:[self viewWithSize:CGSizeMake(100, 0) backgroundColor:backgroundColor]];
    return stackView;
}

@end
