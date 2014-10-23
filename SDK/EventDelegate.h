//
//  EventDelegate.h
//  HFPlugs
//
//  Created by wangmeng on 14-10-23.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleInfo.h"

@protocol EventDelegate <NSObject>
-(void)onEventOff:(NSString*)mac;
-(void)onEventON:(NSString *)mac;
-(void)onNewDevFind:(ModuleInfo*)mi;
@end
