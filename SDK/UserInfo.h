//
//  UserInfo.h
//  HFPlugsDemo
//
//  Created by wangmeng on 14-10-22.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


-(NSInteger)setUser;
-(NSInteger)login;
-(NSInteger)logout;
-(NSInteger)register;
-(NSArray*)getAllModule;
-(BOOL)islogin;
-(NSInteger)changePswd;
+(NSInteger)retrievePswd:(NSString*)sms phone:(NSString*)phone;

@end
