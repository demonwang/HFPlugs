//
//  HttpPostDelegate.h
//  HFPlugs
//
//  Created by wangmeng on 14-10-23.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpPostDelegate <NSObject>
-(void)onrecv:(NSString*)data;
@end