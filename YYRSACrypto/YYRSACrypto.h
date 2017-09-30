//
// YYRSACrypto.h
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

#import <Foundation/Foundation.h>
#import "MIHRSAKeyFactory.h"
#import "MIHKeyPair.h"

/**
 * 密钥对模型回调
 
 @param keyPair 密钥对模型
 @param isExist 是否已生成并归档到沙盒目录中
 */
typedef void(^KeyPairExist)(MIHKeyPair *keyPair, bool isExist);

/**
 * 密钥对模型回调
 
 @param keyPair 密钥对模型
 */
typedef void(^KeyPairBlock)(MIHKeyPair *keyPair);


@interface YYRSACrypto : NSObject

#pragma mark - 生成RSA密钥对
/**
 * 生成RSA密钥对, 或者使用 '-rsa_generate_key:archiverFileName:'
 
 @param block 回调生成的密钥对模型, 秘钥大小为 1024 字节
 @param fileName 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
+ (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)fileName;

/**
 * 生成RSA密钥对, 或者使用 '-rsa_generate_key:keySize:archiverFileName:'
 
 @param block   回调生成的密钥对模型
 @param keySize 枚举, 可指定生成的秘钥大小
 @param fileName 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
+ (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)fileName;


#pragma mark - 私钥加密, 公钥解密
/**
 * 私钥加密
 
 @param keyPair 密钥对模型
 @param dataStr 需加密的字符串
 
 @return 返回加密的密文字符串
 */
+ (NSString *)privateEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr;

/**
 * 公钥解密
 
 @param keyPair 密钥对模型
 @param dataStr 需解密的'加密后的字符串'
 
 @return 返回解密的原文字符串
 */
+ (NSString *)publicDecrypt:(MIHKeyPair *)keyPair decryptStr:(NSString *)dataStr;


#pragma mark - 公钥加密, 私钥解密
/**
 * 公钥加密
 
 @param keyPair 密钥对模型
 @param dataStr 需加密的字符串
 
 @return 返回加密的密文字符串
 */
+ (NSString *)publicEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr;

/**
 * 私钥解密
 
 @param keyPair 密钥对模型
 @param dataStr 需解密的'加密后的字符串'
 
 @return 返回解密的原文字符串
 */
+ (NSString *)privateDecrypt:(MIHKeyPair *)keyPair decryptStr:(NSString *)dataStr;


#pragma mark - 归档/解档 密钥对模型
/**
 * 归档 MIHKeyPair 对象
 
 @param keyPair  需要归档的密钥对模型
 @param fileName 归档到沙盒的文件名, 带后缀, 不能为 nil; 例如 @"keyPair.archiver"
 
 @return 返回归档结果, 成功返回 yes, 否则 no
 */
+ (BOOL)archiverKeyPair:(MIHKeyPair *)keyPair withFileName:(NSString *)fileName;

/**
 * 解档 MIHKeyPair 对象
 
 @param block    通过 block 回调解档出来的密钥对模型
 @param fileName 归档时的文件名, 根据文件名取出归档的对象, 不能为 nil
 */
+ (void)unarchiverKeyPair:(KeyPairBlock)block withFileName:(NSString *)fileName;

/**
 * 归档 MIHKeyPair 对象, 存储到偏好设置
 
 @param keyPair 需要归档的密钥对模型
 */
+ (void)archiverKeyPair:(MIHKeyPair *)keyPair;

/**
 * 解档 MIHKeyPair 对象, 从偏好设置中读取
 
 @param block 通过 block 回调解档出来的密钥对模型
 */
+ (void)unarchiverKeyPair:(KeyPairBlock)block;


#pragma mark - 文件操作
/**
 * 偏好设置中是否已存在 MIHKeyPair 数据
 
 @return 如果有返回 YES, 没有则返回 NO
 */
+ (BOOL)isExistFileWithUserDefaults;

/**
 * 从偏好设置中删除 MIHKeyPair 数据
 
 @return 删除成功返回 YES, 失败返回 NO
 */
+ (BOOL)removeFileFromUserDefaults;

/**
 * 从沙盒目录中删除文件 (MIHKeyPair 对象)
 
 @param fileName 归档到沙盒时的文件名
 
 @return 删除成功返回 YES, 失败返回 NO
 */
+ (BOOL)removeFileFromDocumentsDir:(NSString *)fileName;


#pragma mark - 获取密钥对字符串
/**
 * 获取Base64编码的公钥字符串
 
 @param keyPair 密钥对模型
 
 @return 返回公钥字符串
 */
+ (NSString *)getPublicKey:(MIHKeyPair *)keyPair;

/**
 * 获取Base64编码的私钥字符串
 
 @param keyPair 密钥对模型
 
 @return 返回私钥字符串
 */
+ (NSString *)getPrivateKey:(MIHKeyPair *)keyPair;


#pragma mark - 获取格式化后的密钥对字符串
/**
 * 获取格式化后的公钥
 * 即标准的 PKCS#8 格式公钥
 
 @param keyPair 密钥对模型
 
 @return 返回格式化后的公钥字符串
 */
+ (NSString *)getFormatterPublicKey:(MIHKeyPair *)keyPair;

/**
 * 获取格式化后的私钥
 * 即标准的 PKCS#1 格式私钥
 
 @param keyPair 密钥对模型
 
 @return 返回格式化后的私钥字符串
 */
+ (NSString *)getFormatterPrivateKey:(MIHKeyPair *)keyPair;


#pragma mark - 非通过 MIHRSAKeyFactory 生成密钥对
/**
 * 生成RSA密钥对, 或者使用 '+rsa_generate_key:archiverFileName:'
 
 @param block 回调生成的密钥对模型, 秘钥大小为 1024 字节
 @param fileName 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
- (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)fileName;

/**
 * 生成RSA密钥对, 或者使用 '+rsa_generate_key:keySize:archiverFileName:'
 
 @param block   回调生成的密钥对模型
 @param keySize 枚举, 可指定生成的秘钥大小
 @param fileName 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
- (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)fileName;


#pragma mark - 设置服务器返回的秘钥字符串
/**
 * 设置公钥和私钥, 当秘钥是服务器返回的时候, 可使用此方法来获得密钥对模型
 
 @param aPublicKey  公钥字符串, 须是去掉头尾和换行符等的纯公钥字符串
 @param aPrivateKey 私钥字符串, 须是去掉头尾和换行符等的纯私钥字符串
 
 @return 返回 MIHKeyPair 密钥对模型
 */
+ (MIHKeyPair *)setPublicKey:(NSString *)aPublicKey privateKey:(NSString *)aPrivateKey;

/**
 * 设置公钥和私钥, 当秘钥是服务器返回的时候, 可使用此方法来获得密钥对模型
 
 @param block       通过 block 回调 MIHKeyPair 密钥对模型
 @param aPublicKey  公钥字符串, 须是去掉头尾和换行符等的纯公钥字符串
 @param aPrivateKey 私钥字符串, 须是去掉头尾和换行符等的纯私钥字符串
 */
+ (void)keyPair:(KeyPairBlock)block publicKey:(NSString *)aPublicKey privateKey:(NSString *)aPrivateKey;


#pragma mark - 私钥签名
/**
 * RSA私钥签名，利用SHA128散列函数
 
 @param keyPair 密钥对模型
 @param message 需要签名的字符串
 
 @return 返回签名后的字符串
 */
+ (NSString *)SHA128_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message;

/**
 * RSA私钥签名，利用SHA256散列函数
 
 @param keyPair 密钥对模型
 @param message 需要签名的字符串
 
 @return 返回签名后的字符串
 */
+ (NSString *)SHA256_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message;

/**
 * RSA私钥签名，利用MD5散列函数
 
 @param keyPair 密钥对模型
 @param message 需要签名的字符串
 
 @return 返回签名后的字符串
 */
+ (NSString *)MD5_signKeyPair:(MIHKeyPair *)keyPair message:(NSString *)message;


#pragma mark - 公钥验签

/**
 * 验证已经签名后的消息，利用SHA128散列函数
 
 @param keyPair 密钥对模型
 @param signStr 需要验证的签名字符串
 @param message 需要验证的消息字符串
 
 @return 返回验证结果，签名有效返回 YES，无效返回 NO
 */
+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair SHA128:(NSString *)signStr message:(NSString *)message;

/**
 * 验证已经签名后的消息，利用SHA256散列函数
 
 @param keyPair 密钥对模型
 @param signStr 需要验证的签名字符串
 @param message 需要验证的消息字符串
 
 @return 返回验证结果，签名有效返回 YES，无效返回 NO
 */
+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair SHA256:(NSString *)signStr message:(NSString *)message;

/**
 * 验证已经签名后的消息，利用MD5散列函数
 
 @param keyPair 密钥对模型
 @param signStr 需要验证的签名字符串
 @param message 需要验证的消息字符串
 
 @return 返回验证结果，签名有效返回 YES，无效返回 NO
 */
+ (BOOL)verSignKeyPair:(MIHKeyPair *)keyPair MD5:(NSString *)signStr message:(NSString *)message;


@end


