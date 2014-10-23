//
//  HFLocalSave.h
//  HFPlugsDemo
//
//  Created by wangmeng on 14-10-22.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleInfo.h"

@interface HFLocalSave : NSObject



-(NSArray *)getAllModule;
-(BOOL)removeModuleFromLocal:(ModuleInfo*)mi;
-(BOOL)addModuleInLocal:(ModuleInfo*)mi;
-(BOOL)updateModuleLocal:(ModuleInfo *)mi;
-(ModuleInfo *)getModuleByMac:(NSString*)mac;
@end
