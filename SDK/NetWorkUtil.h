//
//  NetWorkUtil.h
//  HFPlugs
//
//  Created by wangmeng on 14-10-23.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdpDelegate.h"
#import "HttpPostDelegate.h"

@interface NetWorkUtil : NSObject

+(void)udpsendAsyc:(NSString*)data delegate:(id<UdpDelegate>)del;
+(void)httpsendAsyc:(NSString *)data delegate:(id<HttpPostDelegate>)del;

+(NSString*)udpsendSync:(NSString*)data;
+(NSString *)httpsendSyc:(NSString *)data;

@end
