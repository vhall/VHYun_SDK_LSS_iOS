//
//  CONSTS.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#ifndef CONSTS_h
#define CONSTS_h

#import "VHSystemSettings.h"
#import <objc/message.h>

#import <YYModel/YYModel.h>
#import <GLEnvs/GLEnvs.h>
#import <GLExtensions/UIViewController+GLExtension.h>
#import <GLExtensions/NSObject+GLExtension.h>

#define GETTER(_TYPE_, _VAR_, _VALUE_)      -(_TYPE_)_VAR_{if(!_##_VAR_) {_##_VAR_ = _VALUE_;}return _##_VAR_;}

#endif /* CONSTS_h */
