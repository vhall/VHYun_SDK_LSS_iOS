//
//  OptionRowCell.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2021/12/10.
//  Copyright © 2021 vhall. All rights reserved.
//

#import "OptionRowCell.h"
@interface OptionRowCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttoner;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation OptionRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.slider addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.switcher addTarget:self action:@selector(didchangeSwitchValue:) forControlEvents:UIControlEventValueChanged];
    [self.buttoner addTarget:self action:@selector(onClickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(OptionItem *)item {
    super.item = item;
    self.titleLabel.text = item.title;
    self.buttoner.hidden = YES;
    self.switcher.hidden = YES;
    self.slider.hidden = YES;
    switch (item.style) {
        case OptionStyleSlider:
            self.slider.hidden = NO;
            self.slider.minimumValue = item.minValue;
            self.slider.maximumValue = item.maxValue;
            self.slider.value = [item.currentValue floatValue];
            break;
        case OptionStyleSwitch:
            self.switcher.hidden = NO;
            [self.switcher setOn:[item.currentValue boolValue]];
            break;
        case OptionStyleButton:
            self.buttoner.hidden = NO;
            [self.buttoner setTitle:item.currentValue forState:UIControlStateNormal];;
            break;
        case OptionStyleNone:
            break;
    }
}

- (void)didchangeSwitchValue:(UISwitch *)switcher {
    self.item.currentValue = [NSNumber numberWithBool:switcher.isOn];
    super.handleOnChangeValue ? super.handleOnChangeValue(self.item) : nil;
}

- (void)onClickChooseButton:(UIButton *)button {
    super.handleOnChangeValue ? super.handleOnChangeValue(self.item) : nil;
}

- (void)didChangeValue:(UISlider *)slider {
    self.item.currentValue = [NSNumber numberWithFloat:slider.value];
    super.handleOnChangeValue ? super.handleOnChangeValue(self.item) : nil;
}
@end
