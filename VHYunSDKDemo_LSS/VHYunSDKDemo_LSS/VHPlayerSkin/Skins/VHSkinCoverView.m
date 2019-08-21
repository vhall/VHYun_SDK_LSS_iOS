//
//  VHSkinCoverView.m
//  VHLSS
//
//  Created by vhall on 2019/8/3.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSkinCoverView.h"

@implementation VHSkinCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.hidden = YES;
    }
    return self;
}


@end
