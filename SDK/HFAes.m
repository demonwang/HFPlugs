//
//  HFAes.m
//  HFSdk
//
//  Created by IOS on 14-1-7.
//  Copyright (c) 2014年 Sean. All rights reserved.
//

#import "HFAes.h"
#import "NSData+HFAes.h"

NSString * const HF_AES_DEFAULT_KEY_128 = @"0123456789abcdefg";

@implementation HFAes

+ (NSData *) encrypt:(NSData *)data key:(NSString *)key
{
    NSUInteger length = [data length];
    NSUInteger remainder = length % 16;
    if(remainder == 0)
    {
        ;//return data;
    }
    else{
        NSUInteger paddingLength = 16 - remainder;
        NSMutableData *mData = [[NSMutableData alloc] initWithData:data];
        Byte paddingBytes[paddingLength];
        memset(paddingBytes, 0x00, 16);
        
        [mData appendBytes:paddingBytes length:paddingLength];
        data= mData;
        ;//return mData;
    }
    
    NSData *coded = [data AES128EncryptWithKey:key];
    return coded;
}

+ (NSData *) decrypt:(NSData *)data key:(NSString *)key
{
    NSData *plant = [data AES256DecryptWithKey:key];
    return plant;
}

@end
