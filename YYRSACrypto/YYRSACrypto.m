//
// YYRSACrypto.m
//
// Copyright (c) 2017 Arvin.Yang (https://github.com/Kejiasir/YYRSACrypto)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "YYRSACrypto.h"
#import "MIHRSAPrivateKey.h"
#import "MIHRSAPublicKey.h"
#import "MIHInternal.h"
#import <openssl/pem.h>
#import <openssl/rsa.h>
#import <GTMBase64.h>

#ifndef __OPTIMIZE__
#define FILE_NAME [[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent] UTF8String]
#define NSLog(fmt, ...) fprintf(stderr,"%s %s => %d 行: %s\n", FILE_NAME, __FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

/**
 * pem key callback block
 
 @param cString c string
 */
typedef void (^cStrBlock)(const char *cString);

static NSString *const KeyPair = @"KeyPair_key";

static NSString *const BEGIN_PUBLIC_KEY  = @"-----BEGIN PUBLIC KEY-----\n";
static NSString *const END_PUBLIC_KEY    = @"\n-----END PUBLIC KEY-----";
static NSString *const BEGIN_PRIVATE_KEY = @"-----BEGIN RSA PRIVATE KEY-----\n";
static NSString *const END_PRIVATE_KEY   = @"\n-----END RSA PRIVATE KEY-----";

@interface YYRSACrypto () {
    RSA *publicKey, *privateKey;
}

@end


@implementation YYRSACrypto

#pragma mark -
+ (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)fileName {
    [self rsa_generate_key:block keySize:MIHRSAKey1024 archiverFileName:fileName];
}


+ (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)fileName {
    MIHRSAKeyFactory *keyFactory = [[MIHRSAKeyFactory alloc] init];
    [keyFactory setPreferedKeySize:keySize];
    bool isExist = isExistFileWithName(fileName);
    !block ?: block(isExist ? nil : [keyFactory generateKeyPair], isExist);
}


#pragma mark -
+ (NSString *)privateEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr {
    NSError *encryptError = nil;
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [keyPair.private encrypt:data error:&encryptError];
    !encryptError ?: ({ NSLog(@"private encrypt error: %@",encryptError); });
    return !encryptError ? dataToStr([GTMBase64 encodeData:encryptData]) : nil;
}


+ (NSString *)publicDecrypt:(MIHKeyPair *)keyPair decryptStr:(NSString *)dataStr {
    NSError *decryptError = nil;
    NSData *data = [GTMBase64 decodeData:strToData(dataStr)];
    NSData *decryptData = [keyPair.public decrypt:data error:&decryptError];
    !decryptError ?: ({ NSLog(@"public decrypt error: %@",decryptError); });
    return !decryptError ? dataToStr(decryptData) : nil;
}


#pragma mark -
+ (NSString *)publicEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr {
    NSError *encryptError = nil;
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [keyPair.public encrypt:data error:&encryptError];
    !encryptError ?: ({ NSLog(@"public encrypt error: %@",encryptError); });
    return !encryptError ? dataToStr([GTMBase64 encodeData:encryptData]) : nil;
}


+ (NSString *)privateDecrypt:(MIHKeyPair *)keyPair decryptStr:(NSString *)dataStr {
    NSError *decryptError = nil;
    NSData *data = [GTMBase64 decodeData:strToData(dataStr)];
    NSData *decryptData = [keyPair.private decrypt:data error:&decryptError];
    !decryptError ?: ({ NSLog(@"private decrypt error: %@",decryptError); });
    return !decryptError ? dataToStr(decryptData) : nil;
}


#pragma mark -
+ (BOOL)archiverKeyPair:(MIHKeyPair *)keyPair withFileName:(NSString *)fileName {
    NSAssert(fileName, @"fileName can not be empty...");
    NSString *filePath = [documentsDir() stringByAppendingPathComponent:fileName];
    return [NSKeyedArchiver archiveRootObject:keyPair toFile:filePath];
}


+ (void)unarchiverKeyPair:(KeyPairBlock)block withFileName:(NSString *)fileName {
    NSAssert(fileName, @"fileName can not be empty...");
    NSString *filePath = [documentsDir() stringByAppendingPathComponent:fileName];
    !block ?: block((MIHKeyPair *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]);
}


+ (void)archiverKeyPair:(MIHKeyPair *)keyPair {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keyPair];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KeyPair];
}


+ (void)unarchiverKeyPair:(KeyPairBlock)block {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPair];
    !block ?: block((MIHKeyPair *)[NSKeyedUnarchiver unarchiveObjectWithData:data]);
}


#pragma mark -
+ (BOOL)isExistFileWithUserDefaults {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KeyPair] ? YES : NO;
}


+ (BOOL)removeFileFromUserDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyPair];
    return ![[self class] isExistFileWithUserDefaults];
}


+ (BOOL)removeFileFromDocumentsDir:(NSString *)fileName {
    NSString *filePath = [documentsDir() stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


#pragma mark -
+ (NSString *)getPublicKey:(MIHKeyPair *)keyPair {
    return dataToStr([GTMBase64 encodeData:[keyPair.public dataValue]]);
}


+ (NSString *)getPrivateKey:(MIHKeyPair *)keyPair {
    NSData *data = [keyPair.private dataValue];
    NSData *encodeData = [GTMBase64 encodeData:data];
    NSData *decodeData = [GTMBase64 decodeData:encodeData];
    return base64EncodedFromPEMStr(dataToStr(decodeData));
}


#pragma mark -
+ (NSString *)getFormatterPublicKey:(MIHKeyPair *)keyPair {
    return formatterPublicKey([self getPublicKey:keyPair]);
}


+ (NSString *)getFormatterPrivateKey:(MIHKeyPair *)keyPair {
    return formatterPrivateKey([self getPrivateKey:keyPair]);
}


#pragma mark -
- (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)fileName {
    [self rsa_generate_key:block keySize:MIHRSAKey1024 archiverFileName:fileName];
}


- (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)fileName {
    bool isExist = isExistFileWithName(fileName);
    if (isExist) {
        !block ?: block(nil, isExist);
        return;
    }
    if (rsa_generate_key(&publicKey, &privateKey, keySize)) {
        
        __block MIHRSAPrivateKey *rsaPrivateKey;
        __block MIHRSAPublicKey *rsaPublicKey;
        
        /// get rsa private pem Key
        get_pem_key(^(const char *cString) {
            NSData *privateKeyData = strToData(charToStr(cString));
            rsaPrivateKey = [[MIHRSAPrivateKey alloc] initWithData:privateKeyData];
        }, privateKey, false, false);
        
        /// get rsa public pem Key
        get_pem_key(^(const char *cString) {
            NSString *publicKeyStr = base64EncodedFromPEMStr(charToStr(cString));
            NSData *publicKeyData = [GTMBase64 decodeData:strToData(publicKeyStr)];
            rsaPublicKey = [[MIHRSAPublicKey alloc] initWithData:publicKeyData];
        }, publicKey, true, true);
        
        MIHKeyPair *keyPair = [[MIHKeyPair alloc] init];
        [keyPair setPrivate:rsaPrivateKey];
        [keyPair setPublic:rsaPublicKey];
        
        !block ?: block(keyPair, isExist);
    }
}


#pragma mark -
+ (MIHKeyPair *)setPublicKey:(NSString *)aPublicKey privateKey:(NSString *)aPrivateKey {
    if (!aPublicKey && !aPrivateKey) {
        return nil;
    }
    MIHKeyPair *keyPair = [[MIHKeyPair alloc] init];
    if (aPrivateKey && aPrivateKey.length) {
        if (![aPrivateKey hasPrefix:@"-----BEGIN RSA PRIVATE KEY-----"]) {
            aPrivateKey = formatterPrivateKey(aPrivateKey);
        }
        NSData *privateKeyData = strToData(aPrivateKey);
        [keyPair setPrivate:[[MIHRSAPrivateKey alloc] initWithData:privateKeyData]];
    }
    if (aPublicKey && aPublicKey.length) {
        if ([aPublicKey hasPrefix:@"-----BEGIN PUBLIC KEY-----"]) {
            aPublicKey = base64EncodedFromPEMStr(aPublicKey);
        }
        NSData *publicKeyData = [GTMBase64 decodeData:strToData(aPublicKey)];
        [keyPair setPublic:[[MIHRSAPublicKey alloc] initWithData:publicKeyData]];
    }
    return keyPair;
}


+ (void)keyPair:(KeyPairBlock)block publicKey:(NSString *)aPublicKey privateKey:(NSString *)aPrivateKey {
    !block ?: block([self setPublicKey:aPublicKey privateKey:aPrivateKey]);
}


#pragma mark -
+ (NSString *)SHA128_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message {
    NSError *signError = nil;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signData = [keyPair.private signWithSHA128:data error:&signError];
    !signError ?: ({ NSLog(@"SHA128 sign error: %@",signError); });
    return !signError ? dataToStr([GTMBase64 encodeData:signData]) : nil;
}


+ (NSString *)SHA256_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message {
    NSError *signError = nil;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signData = [keyPair.private signWithSHA256:data error:&signError];
    !signError ?: ({ NSLog(@"SHA256 sign error: %@",signError); });
    return !signError ? dataToStr([GTMBase64 encodeData:signData]) : nil;
}


+ (NSString *)MD5_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message {
    NSError *signError = nil;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signData = [keyPair.private signWithMD5:data error:&signError];
    !signError ?: ({ NSLog(@"MD5 sign error: %@",signError); });
    return !signError ? dataToStr([GTMBase64 encodeData:signData]) : nil;
}


#pragma mark -
+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair SHA128:(NSString *)signStr message:(NSString *)message {
    NSData *data = [GTMBase64 decodeData:strToData(signStr)];
    return [keyPair.public verifySignatureWithSHA128:data message:strToData(message)];
}


+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair SHA256:(NSString *)signStr message:(NSString *)message {
    NSData *data = [GTMBase64 decodeData:strToData(signStr)];
    return [keyPair.public verifySignatureWithSHA256:data message:strToData(message)];
}


+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair MD5:(NSString *)signStr message:(NSString *)message {
    NSData *data = [GTMBase64 decodeData:strToData(signStr)];
    return [keyPair.public verifySignatureWithMD5:data message:strToData(message)];
}


#pragma mark - Private method
/** Filter secret key string header, newline, etc */
static inline NSString *base64EncodedFromPEMStr(NSString *PEMStr) {
    return [[[[[[PEMStr componentsSeparatedByString:@"-----"] objectAtIndex:2]
               stringByReplacingOccurrencesOfString:@"\r" withString:@""]
              stringByReplacingOccurrencesOfString:@"\n" withString:@""]
             stringByReplacingOccurrencesOfString:@"\t" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}


/** Format the public key string, splicing the header and footer */
static inline NSString *formatterPublicKey(NSString *aPublicKey) {
    NSMutableString *mutableStr = [NSMutableString string];
    [mutableStr appendString:BEGIN_PUBLIC_KEY];
    int count = 0;
    for (int i = 0; i < [aPublicKey length]; ++i) {
        unichar c = [aPublicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [mutableStr appendFormat:@"%c", c];
        if (++count == 64) {
            [mutableStr appendString:@"\n"];
            count = 0;
        }
    }
    [mutableStr appendString:END_PUBLIC_KEY];
    return mutableStr.copy;
}


/** Format the private key string, splicing the header and footer */
static inline NSString *formatterPrivateKey(NSString *aPrivateKey) {
    NSMutableString *mutableStr = [NSMutableString string];
    [mutableStr appendString:BEGIN_PRIVATE_KEY];
    int index = 0, count = 0;
    while (index < [aPrivateKey length]) {
        char cStr = [aPrivateKey UTF8String][index];
        if (cStr == '\r' || cStr == '\n') {
            ++index;
            continue;
        }
        [mutableStr appendFormat:@"%c", cStr];
        if (++count == 64) {
            [mutableStr appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [mutableStr appendString:END_PRIVATE_KEY];
    return mutableStr.copy;
}


/** Determine if a file exists in a sandbox directory */
static inline bool isExistFileWithName(NSString *fileName) {
    if (!fileName || !fileName.length) return false;
    NSString *filePath = [documentsDir() stringByAppendingPathComponent:fileName];
    return (bool)[[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


/** Generating rsa key */
static inline bool rsa_generate_key(RSA **public_key, RSA **private_key, MIHRSAKeySize keySize) {
    BIGNUM *a = BN_new();
    BN_set_word(a, 65537);
    @try {
        RSA *rsa = RSA_new();
        /// use new version. ==> RSA_generate_key() is deprecated. <==
        /// generates a key pair and stores it in the RSA structure provided in rsa.
        /// returns 1 on success or 0 on error.
        int result = RSA_generate_key_ex(rsa, keySize * 8, a, NULL);
        if (result != 1) {
            @throw [NSException openSSLException];
        }
        /// extract public key and private key
        *public_key  = RSAPublicKey_dup(rsa);
        *private_key = RSAPrivateKey_dup(rsa);
        
        RSA_free(rsa);
        return (bool)result;
    }
    @finally {
        /// freed
        BN_free(a);
    }
}


/** Read the pem key */
static inline void get_pem_key(cStrBlock block, RSA *rsa, bool isPublicKey, bool isPkcs8) {
    if (!rsa) return;
    BIO *bp = BIO_new(BIO_s_mem());
    int keylen; char *pem_key;
    @try {
        if (!isPublicKey) {
            EVP_PKEY *key = EVP_PKEY_new();
            EVP_PKEY_assign_RSA(key, rsa);
            if (!isPkcs8)   /// PKCS#1
                PEM_write_bio_RSAPrivateKey(bp, rsa, NULL, NULL, 0, NULL, NULL);
            else    /// PKCS#8
                PEM_write_bio_PrivateKey(bp, key, NULL, NULL, 0, NULL, NULL);
        } else {    /// PKCS#8
            PEM_write_bio_RSA_PUBKEY(bp, rsa);
        }
        
        keylen = BIO_pending(bp);
        pem_key = calloc(keylen + 1, 1);
        BIO_read(bp, pem_key, keylen);
        
        !block ?: block(pem_key);
    }
    @finally {
        BIO_free_all(bp);
        RSA_free(rsa);
        free(pem_key);
    }
}


/** String conversion binary */
static inline NSData *strToData(NSString *string) {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}


/** Binary conversion string */
static inline NSString *dataToStr(NSData *data) {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


/** C string conversion oc string */
static inline NSString *charToStr(const char *cString) {
    return [[NSString alloc] initWithCString:cString encoding:NSUTF8StringEncoding];
}


/** Sandbox documents path */
static inline NSString *documentsDir() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end


