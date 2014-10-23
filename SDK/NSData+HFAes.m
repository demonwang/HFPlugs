//
//  NSData+HFAes.m
//  HFSdk
//
//  Created by IOS on 13-12-18.
//  Copyright (c) 2013年 Sean. All rights reserved.
//

#import "NSData+HFAes.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (HFAes)

- (NSData *)AES128EncryptWithKey:(NSString*)key
{
    Byte iv[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    
	char keyPtr[kCCKeySizeAES128 + 1];
	bzero(keyPtr, sizeof(keyPtr));
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	size_t bufferSize           = dataLength + kCCBlockSizeAES128;
	void* buffer                = malloc(bufferSize);
	
	size_t numBytesEncrypted    = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,       // Operation
                                          kCCAlgorithmAES128,   // Algorithm
                                          0,                // Padding (Option)
                                          keyPtr,           // key
                                          kCCKeySizeAES128,  // key length
                                          iv /* initialization vector (optional) */,
                                          [self bytes],     // plain text
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);

	
	if (cryptStatus == kCCSuccess)
	{
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
	
	free(buffer);
	return nil;
}

+ (NSData *)addZeroPadding:(NSData*)data;
{
    NSUInteger length = [data length];
    NSUInteger remainder = length % 16;
    if(remainder == 0)
    {
        return data;
    }
    else{
        NSUInteger paddingLength = 16 - remainder;
        NSMutableData *mData = [[NSMutableData alloc] initWithData:data];
        Byte paddingBytes[paddingLength];
        memset(paddingBytes, 0x00, 16);
        
        [mData appendBytes:paddingBytes length:paddingLength];
        
        return mData;
    }

}

- (NSData*)AES256DecryptWithKey:(NSString*)key
{
    Byte iv[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          iv /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

#if 0
// encrypt
{
    // the key is 32 bytes （256 bits）.
    Byte iv[] = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,        // Operation
                                          kCCAlgorithmAES128, // Algorithm
                                          kCCOptionPKCS7Padding, // Option
                                          keyPtr,                // key
                                          kCCKeySizeAES256,      // key length
                                          iv, /* initialization vector (optional) */
                                          [self bytes],    // plain text
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted); //dataOutMove
    if (cryptStatus == kCCSuccess) {
        NSData *encryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString *encryptedString = [encryptedData base64Encoding];
    }
}

// Decrypted
{
    byte[] _key1 = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF, 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
    public static string AESDecrypt(string encryptedString, string key)
    {
        AesCryptoServiceProvider aes = new AesCryptoServiceProvider();
        aes.BlockSize = 128;
        aes.KeySize = 256;
        aes.IV = _key1;
        aes.Key = Encoding.UTF8.GetBytes(key);
        aes.Mode = CipherMode.CBC;
        aes.Padding = PaddingMode.PKCS7;
        
        // Convert Base64 strings to byte array
        byte[] src = System.Convert.FromBase64String(encryptedString);
        
        // decryption
        using (ICryptoTransform decrypt = aes.CreateDecryptor())
        {
            byte[] dest = decrypt.TransformFinalBlock(src, 0, src.Length);
            return Encoding.UTF8.GetString(dest);
        }
    }
}
#endif

@end
