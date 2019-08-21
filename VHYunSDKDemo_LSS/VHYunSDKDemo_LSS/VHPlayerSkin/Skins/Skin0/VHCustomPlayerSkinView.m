//
//  VHCustomPlayerSkinView.m
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCustomPlayerSkinView.h"
#import "VHPlayerSkinTool.h"
#import "UIView+Fade.h"
#import "VHSkinCoverView.h"

@interface VHCustomPlayerSkinView ()<VHCstomResolutionViewDelegate,VHCstomMoreViewDelegate>

@end


@implementation VHCustomPlayerSkinView

#pragma mark - creat

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.topImageView addSubview:self.moreBtn];
    }
    return self;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/more"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/more_pressed"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (UIButton *)danmakuBtn {
    if (!_danmakuBtn) {
        _danmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danmakuBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/danmuSet"] forState:UIControlStateNormal];
        [_danmakuBtn addTarget:self action:@selector(danmakuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmakuBtn;
}
- (VHCstomResolutionView *)resolutionView {
    if (!_resolutionView) {
        _resolutionView = [[VHCstomResolutionView alloc] initWithFrame:CGRectZero];
        _resolutionView.delegate = self;
        [self insertSubview:_resolutionView aboveSubview:self.bottomImageView];
    }
    return _resolutionView;
}
- (VHCstomMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[VHCstomMoreView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame))];
        _moreView.delegate = self;
        [self insertSubview:_moreView aboveSubview:self.bottomImageView];
    }
    return _moreView;
}
- (UIView *)rateView {
    if (!_rateView) {
        _rateView = [[VHSkinCoverView alloc] initWithFrame:CGRectMake(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)-375, 0, 375, MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))];
        [self insertSubview:_rateView aboveSubview:self.bottomImageView];
        NSArray *titles = @[@"0.5",@"0.75",@"1.0",@"1.5",@"1.75",@"2.0"];
        CGFloat originY = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)*0.5-titles.count*56*0.5;
        for (int i = 0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[titles[i] stringByAppendingString:@"x"] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(0, originY+i*56, CGRectGetWidth(_rateView.frame), 56)];
            [btn setTag:1000*[titles[i] integerValue]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateDisabled];
            [btn addTarget:self action:@selector(selectedRate:) forControlEvents:UIControlEventTouchUpInside];
            [_rateView addSubview:btn];
            if (i == 2) {
                btn.enabled = NO;
            }
        }
    }
    return _rateView;
}


#pragma mark - layout
- (void)setOrientationPortraitConstraint {
    [super setOrientationPortraitConstraint];
    
    self.moreBtn.hidden = YES;
    _rateView.hidden = YES;
    
    self.resolutionView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, 375, CGRectGetHeight(self.frame));
    self.resolutionView.hidden = YES;
    self.moreView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, 375, CGRectGetHeight(self.frame));
    self.moreView.hidden = YES;
}
- (void)setOrientationLandscapeConstraint {
    [super setOrientationLandscapeConstraint];
    
    self.moreBtn.hidden = NO;
    self.moreBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-20-40, 0, 40, 49);
    self.moreView.frame = CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame));
    self.resolutionView.frame = CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame));
    _rateView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, 375, CGRectGetHeight(self.frame));
    
    //直播
    if (self.isLive) {
        _rateView.hidden = YES;
    }
}


- (void)setHidden:(BOOL)hidden {
    if (!self.resolutionView.isHidden) {
        self.resolutionView.hidden = hidden;
    }
    if (!self.moreView.isHidden) {
        self.moreView.hidden = hidden;
    }
    if (!self.rateView.isHidden) {
        self.rateView.hidden = hidden;
    }
    
    [super setHidden:hidden];
    
    self.topImageView.hidden = hidden;
    self.bottomImageView.hidden = hidden;
}


#pragma mark - public

- (void)setIsLive:(BOOL)isLive {
    [super setIsLive:isLive];
    
}

- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition {
    //更新分辨率列表
    [self.resolutionView resolutionArray:definitions curDefinition:definition];
    //更新当前分辨率显示
    [self.resolutionBtn setTitle:[VHPlayerSkinTool defination:definition] forState:UIControlStateNormal];
}

- (void)playerStatus:(int)state {
    [super playerStatus:state];
    
}

#pragma mark - action
- (void)resolutionBtnClick:(UIButton *)sender {
    [self cancelFadeOut];
    
    self.topImageView.hidden = YES;
    self.bottomImageView.hidden = YES;
    self.moreView.hidden = YES;
    self.resolutionView.hidden = NO;
    self.resolutionView.frame = CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame));
}
//倍速
- (void)rateBtnBtnClick:(UIButton *)sender {
    [self cancelFadeOut];
    self.topImageView.hidden = YES;
    self.bottomImageView.hidden = YES;
    self.rateView.hidden = NO;
    self.rateView.frame = CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame));
}

- (void)moreBtnClick:(UIButton *)sender {
    [self cancelFadeOut];
    
    self.topImageView.hidden = YES;
    self.bottomImageView.hidden = YES;
    self.resolutionView.hidden = YES;
    self.moreView.hidden = NO;
    self.moreView.frame = CGRectMake(CGRectGetWidth(self.frame)-375, 0, 375, CGRectGetHeight(self.frame));
}
- (void)danmakuBtnClick:(UIButton *)sender {
    
}

- (void)selectedRate:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(skinView:willChnagedPlayRate:)]) {
        CGFloat rate = sender.tag / 1000;
        [self.delegate skinView:self willChnagedPlayRate:rate];
        for (UIView *view in self.rateView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.enabled = (btn != sender);
            }
        }
    }
}

#pragma mark - VHCstomResolutionViewDelegate
- (void)resolutionBtnAction:(UIButton *)sender resolution:(NSInteger)definition title:(NSString *)title {
    if ([self.delegate respondsToSelector:@selector(skinView:willChnagedResolution:)]) {
        [self.delegate skinView:self willChnagedResolution:definition];
        self.resolutionView.hidden = YES;
    }
}
#pragma mark - VHCstomMoreViewDelegate
- (void)cyclePlaySwitchOn:(BOOL)isOn {
//    if ([self.delegate respondsToSelector:@selector(skinView:cyclePlaySwitchOn:)]) {
//        [self.delegate skinView:self cyclePlaySwitchOn:isOn];
//    }
//    [self setCyclePlay:isOn];
}

@end
