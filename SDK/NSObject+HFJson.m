//
//  NSObject+HFJson.m
//  HFSdk
//
//  Created by IOS on 13-12-18.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import "NSObject+HFJson.h"

@implementation NSObject (HFJson)
#pragma mark - JSON Conversion

-(NSString *)toJsonString;
{
//    NSError* error = nil;
//    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
//    if (error != nil) return nil;
//    
//    
//    NSString *str= [[NSString alloc] init];
//    str= [NSString stringWithUTF8String:[result bytes]];
//    return  str;
    NSError* error = nil;
    NSData *result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil)
        return nil;
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

@end
