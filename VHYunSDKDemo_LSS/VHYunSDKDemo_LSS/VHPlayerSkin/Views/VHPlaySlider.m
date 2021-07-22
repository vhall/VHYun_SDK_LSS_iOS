//
//  VHPlaySlider.m
//  VHPlayerSkin
//
//  Created by vhall on 2019/7/29.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHPlaySlider.h"

@interface VHPlaySlider ()

@property (nonatomic, strong) UITapGestureRecognizer *sliderTap;

@end


@implementation VHPlaySlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSliderTarget];
        [self sliderDefaultSet];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self addSliderTarget];
        [self sliderDefaultSet];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addProgressVeiw];
}

//设置进度条高度为2
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect suBounds = [super trackRectForBounds:bounds];
    return CGRectMake(suBounds.origin.x, suBounds.origin.y, suBounds.size.width, 2);
}
//设置滑块可触摸范围大小
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect suBounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
    return CGRectMake(suBounds.origin.x-15, suBounds.origin.y-15, suBounds.size.width+30, suBounds.size.height+30);
}

- (void)addProgressVeiw {

    if(_progressView) {
        [_progressView removeFromSuperview];
    }
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    _progressView.trackTintColor    = [UIColor clearColor];
    _progressView.layer.masksToBounds = YES;
    _progressView.layer.cornerRadius  = 1;
    _progressView.progress = 0;
//    _progressView.backgroundColor = [UIColor redColor];
    //    self.backgroundColor = [UIColor blueColor];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0) {
        _progressView.frame = CGRectMake(20, CGRectGetHeight(self.frame)*0.5-3, CGRectGetWidth(self.frame)-20, 5);
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 0.5f);
    }else {
        _progressView.frame = CGRectMake(20, CGRectGetHeight(self.frame)*0.5-1, CGRectGetWidth(self.frame)-20, 5);
    }
    
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
    // slider点击事件
    self.sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapAction:)];
    [self addGestureRecognizer:self.sliderTap];
}
- (void)sliderDefaultSet {
    [self setMinimumTrackTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
    [self setMaximumTrackTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]];
    [self setThumbImage:[UIImage imageNamed:@"VHSKinBundle.bundle/seekbar"] forState:UIControlStateNormal];
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.sliderTap.enabled = NO;
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
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:)]) {
        [self.delegate sliderTouchEnded:self];
    }
    self.sliderTap.enabled = YES;
    self.isDragging = NO;
}

- (void)sliderTapAction:(UITapGestureRecognizer *)tap
{
    self.isDragging = YES;
    
    CGPoint point = [tap locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (point.x / self.frame.size.width );
    [self setValue:value animated:YES];


    if ([self.delegate respondsToSelector:@selector(sliderSignleTouch:)]) {
        [self.delegate sliderSignleTouch:self];
    }
    
    self.isDragging = NO;
}

@end
