//
//  YYRSACrypto.h
//  cryptoDemo
//
//  Created by Arvin on 17/9/16.
//  Copyright © 2017年 Arvin. All rights reserved.
//

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
 @param name 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
+ (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)name;

/**
 * 生成RSA密钥对, 或者使用 '-rsa_generate_key:keySize:archiverFileName:'
 
 @param block   回调生成的密钥对模型
 @param keySize 枚举, 可指定生成的秘钥大小
 @param name    归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
+ (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)name;


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
 @param name 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
- (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)name;

/**
 * 生成RSA密钥对, 或者使用 '+rsa_generate_key:keySize:archiverFileName:'
 
 @param block   回调生成的密钥对模型
 @param keySize 枚举, 可指定生成的秘钥大小
 @param name    归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
- (void)rsa_generate_key:(KeyPairExist)block keySize:(MIHRSAKeySize)keySize archiverFileName:(NSString *)name;


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

@end


