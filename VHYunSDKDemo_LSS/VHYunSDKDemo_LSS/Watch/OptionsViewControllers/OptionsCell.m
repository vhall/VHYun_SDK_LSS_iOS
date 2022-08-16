//
//  OptionsCell.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/5/10.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "OptionsCell.h"


@interface OptionsCell()
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) NSInteger index;
@end

@implementation OptionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setItem:(OptItem *)item {
    _item = item;
}

- (void)layoutSubviews {
    NSMutableString *titleStr = [self.item.title mutableCopy];
    if(self.item.available==YES) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        if(self.isSelected == YES) {
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            self.line.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            [titleStr insertString:@"✅" atIndex:0];
        }else{
            self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:.7];
            self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
            self.line.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
            [titleStr insertString:@"" atIndex:0];
        }
    }else{
        [titleStr insertString:@"🚫" atIndex:0];
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:.2];
        self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        self.line.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    }
    self.titleLabel.text = [titleStr copy];
    [self.titleLabel sizeToFit];
}
@end
