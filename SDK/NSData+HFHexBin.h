//
//  NSData+HFHexBin.h
//  HFSdk
//
//  Created by IOS on 13-12-17.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HFHexBin)

#pragma mark - HexString and Byte Conversion for class
+ (NSString *)toHexString :(NSData *)data;
+ (NSData *)toData :(NSString *)hexString;

#pragma mark - HexString Conversion for Self
- (NSString *)hexString;

@end
