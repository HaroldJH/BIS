//
//  AES.m
//  BIS
//
//  Created by Harold Jinho Yi on 9/9/13.
//
//

#import "AES.h"

@implementation AES

- (NSString*) aesEncryptString:(NSString*)textString{
    //NSString *text = [[NSString alloc] initWithString:@"ncdncd"];
    NSString *key = [NSString stringWithFormat:@"0987654321098765"];
    
    NSData *data = [[NSData alloc] initWithData:[textString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *ret = [self AES128EncryptWithKey:key theData:data];
    
    //NSLog(@"%@", [[AESExtention alloc] encodeHexString:ret]);
    return [self hexEncode:ret];
}

- (NSString*) aesDecryptString:(NSString*)textString{
    NSString *key = [NSString stringWithFormat:@"0987654321098765"];
    NSLog(@"hex = %@",textString);
    NSData *ret = [self decodeHexString:textString];
    
    NSData *ret2 = [self AES128DecryptWithKey:key theData:ret];
    
    NSString *st2 = [[NSString alloc] initWithData:ret2 encoding:NSUTF8StringEncoding] ;
    
    return st2;
}

- (NSData *)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data {
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode +kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128, // oorspronkelijk 256
                                          nil, /* initialization vector (optional) */
                                          [Data bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data
{
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [Data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode +kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [Data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

-(NSString *)hexEncode:(NSData *)data{
    NSMutableString *hex = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    char temp[3];
    NSUInteger i=0;
    
    for(i=0; i<[data length]; i++){
        temp[0] = temp[1] = temp[2] =0;
        (void)sprintf(temp, "%02x",bytes[i]);
        [hex appendString:[NSString stringWithUTF8String:temp]];
        
    }
    return hex;
}

- (NSData*) decodeHexString : (NSString *)hexString
{
    int tlen = [hexString length]/2;
    
    char tbuf[tlen];
    int i,k,h,l;
    bzero(tbuf, sizeof(tbuf));
    
    for(i=0,k=0;i<tlen;i++)
    {
        h=[hexString characterAtIndex:k++];
        l=[hexString characterAtIndex:k++];
        h=(h >= 'A') ? h-'A'+10 : h-'0';
        l=(l >= 'A') ? l-'A'+10 : l-'0';
        tbuf[i]= ((h<<4)&0xf0)| (l&0x0f);
    }
    
    return [NSData dataWithBytes:tbuf length:tlen];
}

@end
