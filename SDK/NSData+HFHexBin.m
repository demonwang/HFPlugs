//
//  NSData+HFHexStringConvertion.m
//  HFSdk
//
//  Created by IOS on 13-12-17.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import "NSData+HFHexBin.h"

@implementation NSData (HFHexBin)
#pragma mark - String Conversion
+ (NSString *)toHexString :(NSData*) data{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [[NSString stringWithString:hexString] uppercaseString];
}


+ (NSData *)toData :(NSString *)hexString{
    NSUInteger ll = [hexString length] /2;
    int j=0;
    Byte bytes[ll];
    ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        Byte int_ch;  /// 两位16进制数转化后的10进制数
        
        Byte hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        Byte int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        Byte hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        Byte int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
//        NSLog(@"%02X(%02X %02X %02X)", bytes[j], int_ch1, int_ch2, int_ch);
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:ll];
    
    return newData;
}


- (NSString *)hexString
{
	NSMutableString *tmpString = [NSMutableString string];
	
	const char *p = [self bytes];
	
	for (int i=0; i<[self length]; i++)
	{
		[tmpString appendFormat:@"%02x", (unsigned char)p[i]];
	}
	
	return [tmpString uppercaseString];
}

@end
