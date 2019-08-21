//
//  VHCstomResolutionView.m
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHCstomResolutionView.h"

@interface VHCstomResolutionView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end


@implementation VHCstomResolutionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        

        self.buttonArray = [NSMutableArray array];
        
        //0 音频  1 原画  2 360p  3 480p  4 720p
        NSArray *titles = @[@"720p",@"480p",@"360p",@"原画",@"音频"];
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateDisabled];
            btn.enabled = YES;
            btn.hidden = YES;
            [self addSubview:btn];
            [self.buttonArray addObject:btn];
            switch (i) {
                case 0:
                    btn.tag = 10010+1;
                    break;
                case 1:
                    btn.tag = 10010+2;
                    break;
                case 2:
                    btn.tag = 10010+3;
                    break;
                case 3:
                    btn.tag = 10010+0;
                    break;
                case 4:
                    btn.tag = 10010+4;
                    break;
                default:
                    break;
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(resolutionBtnAction:resolution:title:)]) {
        [self.delegate resolutionBtnAction:sender resolution:sender.tag-10010 title:sender.titleLabel.text];
    }
}


- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition {
    //hidden所有按钮
    for (UIButton *btn in self.subviews) {
        btn.hidden = YES;
    }
    for (NSNumber *num in definitions) {
        NSInteger tag = [num intValue] + 10010;
        UIButton *button = [self viewWithTag:tag];
        button.hidden = NO;
        button.enabled = YES;
        if ([num intValue] == definition) {
            button.enabled = NO;
        }
    }
    NSInteger index = 0;
    CGFloat firstOriginY = MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)*0.5-definitions.count*44*0.5;
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        if (!btn.isHidden) {
            btn.frame = CGRectMake(0, firstOriginY+index*44, CGRectGetWidth(self.frame), 44);
            index++;
        }
        else {
            btn.frame = CGRectZero;
        }
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    NSLog(@"****** %ld",(long)self.supportCount);
//
//    NSInteger index = 0;
//    CGFloat firstOriginY = CGRectGetHeight(self.frame)*0.5-self.supportCount*44*0.5;
//    for (int i = 0; i < self.buttonArray.count; i++) {
//        UIButton *btn = self.buttonArray[i];
//        if (!btn.isHidden) {
//            btn.frame = CGRectMake(0, firstOriginY+index*44, CGRectGetWidth(self.frame), 44);
//            index++;
//        }
//        else {
//            btn.frame = CGRectZero;
//        }
//    }
//}



//    VHDefinitionOrigin             = 0,    //原画
//    VHDefinitionUHD                = 1,    //超高清    720p
//    VHDefinitionHD                 = 2,    //高清      480p
//    VHDefinitionSD                 = 3,    //标清      360p
//    VHDefinitionAudio              = 4,    //音频


@end
