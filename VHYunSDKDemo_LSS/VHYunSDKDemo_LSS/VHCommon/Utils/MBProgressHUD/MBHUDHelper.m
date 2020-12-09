//
//  MBHUDHelper.m
//  iplaza
//
//  Created by Rush.D.Xzj on 4/27/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "MBHUDHelper.h"
#import "MBProgressHUD.h"

@implementation MBHUDHelper

+ (void)showWarningWithText:(NSString *)text
{
    [MBHUDHelper showWarningWithText:text delegate:nil];
}

+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.delegate = delegate;
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:2.0];
}
@end
