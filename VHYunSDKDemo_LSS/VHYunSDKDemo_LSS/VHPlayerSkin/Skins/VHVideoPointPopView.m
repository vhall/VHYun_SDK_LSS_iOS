//
//  VHVideoPointPopView.m
//  VHYunSDKDemo_LSS
//
//  Created by xiongchao on 2020/11/2.
//  Copyright © 2020 vhall. All rights reserved.
//

#import "VHVideoPointPopView.h"
#import <VHLSS/VHPlayerCommonModel.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface VHVideoPointPopView ()
/** alertView */
@property (nonatomic, strong) UIView *alertView;
/** 图片 */
@property (nonatomic, strong) UIImageView *alertImgView;
/** 标题 */
@property (nonatomic, strong) UILabel *alertTitle;
/** 数据模型 */
@property (nonatomic, strong) VHVidoePointModel *model;
@end

@implementation VHVideoPointPopView

+ (instancetype)showPointViewWithModel:(VHVidoePointModel *)model {
    VHVideoPointPopView *popView = [[VHVideoPointPopView alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
    popView.model = model;
    [popView showAlert];
    return popView;
}

- (void)setModel:(VHVidoePointModel *)model {
    _model = model;
    self.alertTitle.text = model.msg;
    [self.alertImgView sd_setImageWithURL:[NSURL URLWithString:model.picurl]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.alpha = 0;
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        [mainWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(mainWindow);
        }];
        [self configSubview];
    }
    return self;
}

- (void)configSubview {
    [self addSubview:self.alertView];
    [self.alertView addSubview:self.alertTitle];
    [self.alertView addSubview:self.alertImgView];
    
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(self.alertView.mas_width).multipliedBy(15/20.0);
        make.center.equalTo(self);
    }];
    
    [self.alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.alertView);
        make.height.equalTo(@(40));
    }];
    
    [self.alertImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alertView);
        make.top.equalTo(self.alertTitle.mas_bottom);
    }];
}

- (void)showAlert {
    self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    } completion:nil];
}

//点击弹窗外移除
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if(!CGRectContainsPoint(self.alertView.frame, touchPoint)) {
        // 判断点击的区域如果不是alertView, 则关闭弹窗
        [self removeFromSuperview];
    }
}


- (UIView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[UIView alloc] init];
        _alertView.layer.cornerRadius = 10;
        _alertView.clipsToBounds = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

- (UILabel *)alertTitle
{
    if (!_alertTitle)
    {
        _alertTitle = [[UILabel alloc] init];
        _alertTitle.font = [UIFont systemFontOfSize:15];
        _alertTitle.textColor = [UIColor blackColor];
        _alertTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _alertTitle;
}

- (UIImageView *)alertImgView
{
    if (!_alertImgView)
    {
        _alertImgView = [[UIImageView alloc] init];
        _alertImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _alertImgView;
}
@end
