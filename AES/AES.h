//
//  AES.h
//  BIS
//
//  Created by Harold Jinho Yi on 9/9/13.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface AES : NSObject {
    
}
- (NSString*) aesEncryptString:(NSString*)textString;

- (NSString*) aesDecryptString:(NSString*)textString;

- (NSData *)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data;

- (NSData *)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data;

-(NSString *)hexEncode:(NSData *)data;

- (NSData*) decodeHexString : (NSString *)hexString;
@end