//
//  HFLocalManager.h
//  HFPlugsDemo
//
//  Created by wangmeng on 14-10-22.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdpDelegate.h"
#import "EventDelegate.h"
#import "GCDAsyncUdpSocket.h"


@interface HFLocalManager : NSObject<GCDAsyncUdpSocketDelegate>


+(HFLocalManager*)getInstance;
-(void)startBeat;
-(void)startEventRecv;
-(void)registerEvent:(id<EventDelegate>)del;
-(void)unregisterEvent:(id<EventDelegate>)del;
@end