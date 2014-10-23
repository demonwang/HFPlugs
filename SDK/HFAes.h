//
//  HFAes.h
//  HFSdk
//
//  Created by IOS on 14-1-7.
//  Copyright (c) 2014年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const HF_AES_DEFAULT_KEY_128;

@interface HFAes : NSObject


+ (NSData *) encrypt:(NSData *)data key:(NSString *)key;
+ (NSData *) decrypt:(NSData *)data key:(NSString *)key;

@end
