//
//  FeatCell.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/3/9.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "FeatCell.h"

@implementation FeatCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.backgroundColor = self.normalColor;
}
- (void)setHighlighted:(BOOL)highlighted {
	if(highlighted) {
		self.backgroundColor = self.highlightedColor;
	}else{
		self.backgroundColor = self.normalColor;
	}
}
@end
