//
//  NSData+HFAes.h
//  HFSdk
//
//  Created by IOS on 13-12-18.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HFAes)

- (NSData *)AES128EncryptWithKey:(NSString*)key;
+ (NSData *)addZeroPadding:(NSData*)data;
- (NSData *)AES256DecryptWithKey:(NSString*)key;

@end
