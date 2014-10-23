//
//  ModuleInfo.h
//  HFPlugsDemo
//
//  Created by wangmeng on 14-10-22.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleInfo : NSObject




-(BOOL)open;
-(BOOL)close;
-(NSInteger)ModuleNetStat;
-(BOOL)delete;
-(BOOL)setModule;

@end
