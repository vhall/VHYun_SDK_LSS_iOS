//
//  VHCstomMoreView.m
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCstomMoreView.h"
#import "VHSwitch.h"
#import "VHPlaySlider.h"
#import "VHBaseSkinPlayerView.h"
#import "VHPlayerSkinTool.h"

@interface VHCstomMoreView ()<VHSwitchDelegate,VHPlaySliderDelegate>

@property (nonatomic) UIView *titleCell;
@property (nonatomic) UIView *playCell;
@property (nonatomic) UIView *pointCell;
@property (nonatomic) UIView *soundCell;
@property (nonatomic) UIView *ligthCell;
@property (nonatomic) UIView *subtitleCell;
/** 字幕选项标题 */
@property (nonatomic, strong) UIButton *subTtileButton;
@property BOOL isVolume;
@property NSDate *volumeEndTime;
/** 循环播放开关 */
@property (nonatomic, strong) VHSwitch *playSwitch;
/** 打点开关 */
@property (nonatomic, strong) VHSwitch *pointSwitch;
/** 字幕开关 */
@property (nonatomic, strong) VHSwitch *subtitleSwith;
/** 可选字幕列表 */
@property (nonatomic, strong) NSArray <VHVidoeSubtitleModel *> *subtitleArr;

@end


@implementation VHCstomMoreView

- (instancetype)initWithFrame:(CGRect)frame isLive:(BOOL)live {
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUIWithOption:live];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUIWithOption:NO];
    }
    return self;
}

- (void)setUpUIWithOption:(BOOL)isLive
{
    [self addSubview:[self titleCell]];
    [self addSubview:[self playCell]];
    [self addSubview:[self pointCell]];
    [self addSubview:[self soundCell]];
    [self addSubview:[self ligthCell]];
    
    if (isLive) {
        self.playCell.hidden = YES;
        self.pointCell.hidden = YES;
        _soundCell.frame = CGRectMake(0, 56, CGRectGetWidth(self.frame), 56);
        _ligthCell.frame = CGRectMake(0, 56*2, CGRectGetWidth(self.frame), 56);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)         name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)volumeChanged:(NSNotification *)notify
{
    if (!self.isVolume) {
        if (self.volumeEndTime != nil && -[self.volumeEndTime timeIntervalSinceNow] < 2.f)
            return;
        float volume = [[[notify userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        self.soundSlider.value = volume;
    }
}

- (UIView *)titleCell {
    if (!_titleCell) {
        _titleCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 56)];
        _titleCell.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, CGRectGetWidth(self.frame)-40, 21)];
        label.text = @"播放设置";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15.0];
        [_titleCell addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleCell.frame)-0.5, CGRectGetWidth(_titleCell.frame)-40, 1)];
        line.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        [_titleCell insertSubview:line aboveSubview:label];
    }
    return _titleCell;
}

- (UIView *)playCell {
    if (!_playCell) {
        _playCell = [[UIView alloc] initWithFrame:CGRectMake(0, 56, CGRectGetWidth(self.frame), 56)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 56*0.5-10, CGRectGetWidth(self.frame)*0.5, 20)];
        label.text = @"循环播放";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_playCell addSubview:label];
        
        VHSwitch *onSwitch = [[VHSwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-20-45, 56*0.5-11, 45, 22)];
        onSwitch.delegate = self;
        _playSwitch = onSwitch;
        [_playCell addSubview:onSwitch];
    }
    return _playCell;
}


- (UIView *)soundCell {
    if (!_soundCell) {
        _soundCell = [[UIView alloc] initWithFrame:CGRectMake(0, 56 * 2, CGRectGetWidth(self.frame), 56)];
        
        UIImageView *soundImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VHSKinBundle.bundle/sound_min"]];
        soundImage1.frame = CGRectMake(20, 56*0.5-9, 22, 18);
        [_soundCell addSubview:soundImage1];
        
        UIImageView *soundImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VHSKinBundle.bundle/sound_max"]];
        soundImage2.frame = CGRectMake(CGRectGetWidth(self.frame)-20-22, 56*0.5-9, 22, 18);
        [_soundCell addSubview:soundImage2];
        
        VHPlaySlider *slider = [[VHPlaySlider alloc] initWithFrame:CGRectMake(60, 56*0.5-CGRectGetHeight(_soundCell.frame)*0.5, CGRectGetWidth(self.frame)-120, CGRectGetHeight(_soundCell.frame))];
        slider.maximumValue          = 1;
        slider.minimumValue          = 0;
        slider.delegate = self;
        slider.tag = 100201;
        [_soundCell addSubview:slider];
        self.soundSlider = slider;
    }
    return _soundCell;
}

- (UIView *)ligthCell {
    if (!_ligthCell) {
        _ligthCell = [[UIView alloc] initWithFrame:CGRectMake(0, 56 * 3, CGRectGetWidth(self.frame), 56)];
        
        UIImageView *lightImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VHSKinBundle.bundle/light_min"]];
        lightImage1.frame = CGRectMake(20, 56*0.5-13, 27, 26);
        [_ligthCell addSubview:lightImage1];
        
        UIImageView *lightImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VHSKinBundle.bundle/light_max"]];
        lightImage2.frame = CGRectMake(CGRectGetWidth(self.frame)-20-27, 56*0.5-13, 27, 26);
        [_ligthCell addSubview:lightImage2];
        
        VHPlaySlider *slider = [[VHPlaySlider alloc] initWithFrame:CGRectMake(60, 56*0.5-CGRectGetHeight(_ligthCell.frame)*0.5, CGRectGetWidth(_ligthCell.frame)-120, CGRectGetHeight(_ligthCell.frame))];
        slider.maximumValue          = 1;
        slider.minimumValue          = 0;
        slider.delegate = self;
        slider.tag = 100202;
        slider.value = [UIScreen mainScreen].brightness;
        [_ligthCell addSubview:slider];
        self.lightSlider = slider;
    }
    return _ligthCell;
}

- (UIView *)pointCell {
    if (!_pointCell) {
        _pointCell = [[UIView alloc] initWithFrame:CGRectMake(0, 56 * 4, CGRectGetWidth(self.frame), 56)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 56 * 0.5-10, CGRectGetWidth(self.frame)*0.5, 20)];
        label.text = @"显示打点";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_pointCell addSubview:label];
        
        VHSwitch *onSwitch = [[VHSwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-20-45, 56*0.5-11, 45, 22)];
        onSwitch.delegate = self;
        _pointSwitch = onSwitch;
        [_pointCell addSubview:onSwitch];
    }
    return _pointCell;
}

- (UIView *)subtitleCell {
    if (!_subtitleCell) {
        _subtitleCell = [[UIView alloc] initWithFrame:CGRectMake(0, 56 * 5, CGRectGetWidth(self.frame), 56)];
        
        UIButton *subtitleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (56 - 40)/2.0, CGRectGetWidth(self.frame)*0.5, 40)];
        [subtitleBtn setTitle:@"开启字幕" forState:UIControlStateNormal];
        [subtitleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [subtitleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [subtitleBtn addTarget:self action:@selector(subtitleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_subtitleCell addSubview:subtitleBtn];
        _subTtileButton = subtitleBtn;
        
        VHSwitch *onSwitch = [[VHSwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-20-45, 56*0.5-11, 45, 22)];
        onSwitch.delegate = self;
        _subtitleSwith = onSwitch;
        [_subtitleCell addSubview:onSwitch];
    }
    return _subtitleCell;
}


//字幕选择
- (void)subtitleBtnClick {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for(int i = 0 ; i < self.subtitleArr.count ; i++) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:self.subtitleArr[i].lang style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.subTtileButton setTitle:[NSString stringWithFormat:@"开启字幕(%@)",self.subtitleArr[i].lang] forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(selelectSubtitle:)]) {
                [self.delegate selelectSubtitle:self.subtitleArr[i]];
            }
        }];
        [alertController addAction:alertAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [[VHPlayerSkinTool getCurrentActivityViewController] presentViewController:alertController animated:YES completion:nil];
}


- (void)update
{
    self.soundSlider.value = [VHBaseSkinPlayerView volumeViewSlider].value;
    self.lightSlider.value = [UIScreen mainScreen].brightness;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self update];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (!hidden) {
        [self update];
    }
}

//设置字幕列表
- (void)setSubtitleArr:(NSArray <VHVidoeSubtitleModel *> *)array {
    _subtitleArr = array;
    if(array.count > 0) {
        //添加字幕开关
        [self addSubview:[self subtitleCell]];
    }
}


#pragma mark - VHSwitchDelegate
- (void)switchOn:(VHSwitch *)sender isOn:(BOOL)on {
    if(sender == self.playSwitch) {
        if ([self.delegate respondsToSelector:@selector(cyclePlaySwitchOn:)]) {
            [self.delegate cyclePlaySwitchOn:on];
        }
    }else if (sender == self.pointSwitch) {
        if ([self.delegate respondsToSelector:@selector(showPointSwitchOn:)]) {
            [self.delegate showPointSwitchOn:on];
        }
    }else if (sender == self.subtitleSwith) {
        
        if(on) {
            if([self.delegate respondsToSelector:@selector(showSubtitle:completion:)]) {
                [self.delegate showSubtitle:YES completion:^(VHVidoeSubtitleModel * subtitle) {
                    if(subtitle) {
                        [self.subTtileButton setTitle:[NSString stringWithFormat:@"开启字幕(%@)",subtitle.showName] forState:UIControlStateNormal];
                    }else {
                        [self.subTtileButton setTitle:@"开启字幕(未选择)" forState:UIControlStateNormal];
                    }
                }];
            }
        }else {
            [self.subTtileButton setTitle:@"开启字幕" forState:UIControlStateNormal];
            if([self.delegate respondsToSelector:@selector(showSubtitle:completion:)]) {
                [self.delegate showSubtitle:NO completion:nil];
            }
        }
    }
}

#pragma mark - VHPlaySliderDelegate
- (void)sliderTouchBegan:(VHPlaySlider *)slider {
    if (slider.tag == 100201) {
        self.isVolume = YES;
    }
}
- (void)sliderValueChanged:(VHPlaySlider *)slider {
    if (slider.tag == 100201) { //音量
        if (self.isVolume) {
            [VHBaseSkinPlayerView volumeViewSlider].value = slider.value;
        }
    }
    else if (slider.tag == 100202) { //亮度
        [UIScreen mainScreen].brightness = slider.value;
    }
}
- (void)sliderTouchEnded:(VHPlaySlider *)slider {
    if (slider.tag == 100201) {
        self.isVolume = NO;
        self.volumeEndTime = [NSDate date];
    }
}
- (void)sliderSignleTouch:(VHPlaySlider *)slider {
    if (slider.tag == 100201) { //音量
        [VHBaseSkinPlayerView volumeViewSlider].value = slider.value;
    }
    else if (slider.tag == 100202) { //亮度
        [UIScreen mainScreen].brightness = slider.value;
    }
}


@end
