//
//  VHPlaySlider.m
//  VHPlayerSkin
//
//  Created by vhall on 2019/7/29.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHPlaySlider.h"

@implementation VHPlaySlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addInitUI];
        [self addSliderTarget];
        [self sliderDefaultSet];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self addInitUI];
        [self addSliderTarget];
        [self sliderDefaultSet];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _progressView.frame = CGRectMake(0.5, CGRectGetHeight(self.frame)*0.5-1, CGRectGetWidth(self.frame)-1, 2);
}

//设置进度条高度为2
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect suBounds = [super trackRectForBounds:bounds];
    return CGRectMake(suBounds.origin.x, suBounds.origin.y, suBounds.size.width, 2);
}
////设置滑块可触摸范围大小
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    CGRect suBounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    return CGRectMake(suBounds.origin.x, suBounds.origin.y, 20, 20);
//}

- (void)addInitUI {
    _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    _progressView.trackTintColor    = [UIColor clearColor];
    _progressView.layer.masksToBounds = YES;
    _progressView.layer.cornerRadius  = 1;
    _progressView.progress = 0;
    [self addSubview:_progressView];
    [self sendSubviewToBack:_progressView];
}

- (void)addSliderTarget {
    // slider开始滑动事件
    [self addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}
- (void)sliderDefaultSet {
    [self setMinimumTrackTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
    [self setMaximumTrackTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
    [self setThumbImage:[UIImage imageNamed:@"VHSKinBundle.bundle/seekbar"] forState:UIControlStateNormal];
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:)]) {
        [self.delegate sliderTouchBegan:self];
    }
}
- (void)progressSliderValueChanged:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:self];
    }
}
- (void)progressSliderTouchEnded:(UISlider *)sender {
    self.isDragging = NO;
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self];
    }
}


@end
