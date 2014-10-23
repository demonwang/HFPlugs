//
//  NSString+HFJson.m
//  HFSdk
//
//  Created by IOS on 13-12-18.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import "NSString+HFJson.h"

@implementation NSString (HFJson)

#pragma mark - JSON Conversion
-(id)toJsonValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
