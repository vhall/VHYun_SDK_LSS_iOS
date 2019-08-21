//
//  VHSwitch.m
//  VHPlayerSkin
//
//  Created by vhall on 2019/7/30.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSwitch.h"

@implementation VHSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSwitchTarget];
        [self switchDefaultSet];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self addSwitchTarget];
        [self switchDefaultSet];
    }
    return self;
}

- (void)addSwitchTarget {
    [self addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}
- (void)switchDefaultSet {
    [self setOnTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
    [self setTintColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0]];
}

- (void)switchAction:(VHSwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(switchOn:isOn:)]) {
        [self.delegate switchOn:sender isOn:sender.isOn];
    }
}

@end
