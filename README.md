# YYRSACrypto
基于 MIHCrypto 封装的 RSA 加密解密工具类

暂时不支持 CocoaPods 安装, 可将 Demo 中的 **YYRSACrypto** 文件夹 拷贝到你的工程, 使用前需导入 [MIHCrypto](https://github.com/hohl/MIHCrypto) 和 [GTMBase64](https://github.com/MxABC/GTMBase64) 这两个依赖库, 建议使用 CocoaPods 导入, 因为 **MIHCrypto** 是在 [openssl](https://github.com/openssl/openssl) 之上封装的, 使用 CocoaPods 导入会自动安装 **openssl**, 否则还需要手动导入 **openssl** .


### 头文件方法

``` objc
#pragma mark - 生成RSA密钥对
/**
 * 生成RSA密钥对
 
 @param block 回调生成的密钥对模型, 秘钥大小为 1024 字节
 @param name 归档到沙盒中的文件名, 如果没有归档, 可以为 nil
 */
+ (void)rsa_generate_key:(KeyPairExist)block archiverFileName:(NSString *)name;

/**
 * 生成RSA密钥对
 
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
 
 @return 返回加密的二进制结果
 */
+ (NSData *)privateEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr;

/**
 * 公钥解密
 
 @param keyPair 密钥对模型
 @param data    需解密的二进制数据
 
 @return 返回解密的原文字符串
 */
+ (NSString *)publicDecrypt:(MIHKeyPair *)keyPair decryptData:(NSData *)data;


#pragma mark - 公钥加密, 私钥解密
/**
 * 公钥加密
 
 @param keyPair 密钥对模型
 @param dataStr 需加密的字符串
 
 @return 返回加密的二进制结果
 */
+ (NSData *)publicEncrypt:(MIHKeyPair *)keyPair encryptStr:(NSString *)dataStr;

/**
 * 私钥解密
 
 @param keyPair 密钥对模型
 @param data    需解密的二进制数据
 
 @return 返回解密的原文字符串
 */
+ (NSString *)privateDecrypt:(MIHKeyPair *)keyPair decryptData:(NSData *)data;


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
 * 生成RSA密钥对, 或者使用 '+rsa_generate_key:archiverFileName:'
 
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


```
