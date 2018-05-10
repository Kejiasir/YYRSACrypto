//
//  ViewController.m
//  cryptoDemo
//
//  Created by Arvin on 17/9/16.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ViewController.h"
#import "YYRSACrypto.h"

static NSString *const archiver = @"keyPair.archiver";

@interface ViewController ()

@property (nonatomic, strong) MIHKeyPair *keyPair;
@property (nonatomic, strong) NSString *encryptStr;
@property (nonatomic, copy) NSString *sha128,*sha256,*md5;

@end

@implementation ViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark -
/// 生成秘钥对
- (IBAction)generateKeyPair:(UIButton *)sender {
    [self testFunc1];
}


/// 生成秘钥并归档到沙盒
- (IBAction)generateKey_archiver:(UIButton *)sender {
    [self testFunc2];
}


/// 从沙盒解档密钥对并加解密
- (IBAction)unarchiver_crypto:(UIButton *)sender {
    [self testFunc4];
}


/// 根据服务器返回的秘钥进行加解密
- (IBAction)setServerKeyPair:(UIButton *)sender {
    [self testFunc3];
}


#pragma mark -
- (void)testFunc1 {
    
    /// 生成秘钥对方式 一:
    
    __weak typeof(self) weakSelf = self;
    
    [YYRSACrypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        
        [weakSelf setKeyPair:keyPair];
        
        if (![YYRSACrypto isExistFileWithUserDefaults]) {
            /// 归档到偏好设置
            [YYRSACrypto archiverKeyPair:keyPair];
        }
        
        /// 从偏好设置解档
        [YYRSACrypto unarchiverKeyPair:^(MIHKeyPair *keyPair) {
            NSLog(@"%@",keyPair);
        }];
        
        /// 从偏好设置删除数据, 正常来说没必要做删除操作, 重新保存就会覆盖掉原来的数据
        // [YYRSACrypto removeFileFromUserDefaults];
        
    } archiverFileName:nil];
}


- (void)testFunc2 {
    
    /// 生成秘钥对方式 二:
    
    YYRSACrypto *crypto = [[YYRSACrypto alloc] init];
    
    /// 如果文件已成功归档到沙盒, 再次点击不会生成秘钥对, keyPair 为 nil
    /// 如果想要生成新的密钥对, 可以先将沙盒的归档文件删除
    
    // BOOL flag = [YYRSACrypto removeFileFromDocumentsDir:archiver];
    // NSLog(@"%@", flag ? @"删除成功" : @"删除失败");
    
    [crypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        
        NSLog(@"%@", isExist ? @"文件已归档" : @"文件未归档");
        
        if (!isExist) {
            
            NSLog(@"%@", keyPair);
            
            /// 归档到沙盒
            [YYRSACrypto archiverKeyPair:keyPair withFileName:archiver];
        }
        
    } archiverFileName:archiver];
}


- (void)testFunc3 {
    
    /// 根据服务器给的秘钥字符串进行加密或者解密
    /// 可以单独设置公钥或者私钥 (其实服务器只会返回一个秘钥, 公钥或者私钥)
    /// 可根据需求, 比如: 返回公钥来客户端解密, 或者私钥来加密; 当然反之亦可
    
    __weak typeof(self) weakSelf = self;
    
    [YYRSACrypto keyPair:^(MIHKeyPair *keyPair) {
        
        [weakSelf encryptAndDecrypt:keyPair];
        
    } publicKey:TestPublicKey privateKey:TestPrivateKey];
}


- (void)testFunc4 {
    
    /// 从沙盒目录中解档出秘钥对
    
    [YYRSACrypto unarchiverKeyPair:^(MIHKeyPair *keyPair) {
        
        [self encryptAndDecrypt:keyPair];
        
    } withFileName:archiver];
}


#pragma mark -
/// 公钥加密
- (IBAction)publicEncrypt:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSString *originStr = @"😂😇🚠♏️📡⛸⛳️🕷(ಥ_ಥ)ε(┬┬﹏┬┬)3";
    self.encryptStr = [YYRSACrypto publicEncrypt:self.keyPair encryptStr:originStr];
    NSLog(@"公钥加密后的字符串:\n%@", self.encryptStr);
}


/// 私钥解密
- (IBAction)privateDecrypt:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSString *decryptStr = [YYRSACrypto privateDecrypt:self.keyPair decryptStr:self.encryptStr];
    NSLog(@"私钥解密后的原文: %@", decryptStr);
}


/// 私钥加密
- (IBAction)privateEncrypt:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSString *originStr = @"(╥╯^╰╥)乂(ﾟДﾟ三ﾟДﾟ)乂 🙄💏🎿🙈🌺⚔";
    self.encryptStr = [YYRSACrypto privateEncrypt:self.keyPair encryptStr:originStr];
    NSLog(@"私钥加密后的字符串:\n%@", self.encryptStr);
}


/// 公钥解密
- (IBAction)publicDecrypt:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSString *decryptStr = [YYRSACrypto publicDecrypt:self.keyPair decryptStr:self.encryptStr];
    NSLog(@"公钥解密后的原文: %@", decryptStr);
}


/// 私钥签名
- (IBAction)sign:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSLog(@"SHA128: %@", self.sha128 = [YYRSACrypto SHA128_signKeyPair:self.keyPair message:@"111"]);
    NSLog(@"SHA256: %@", self.sha256 = [YYRSACrypto SHA256_signKeyPair:self.keyPair message:@"222"]);
    NSLog(@"MD5: %@", self.md5 = [YYRSACrypto MD5_signKeyPair:self.keyPair message:@"333"]);
}


/// 公钥验签
- (IBAction)verSign:(UIButton *)sender {
    if (!self.keyPair) {
        NSLog(@"请先生成秘钥对");
        return;
    }
    NSLog(@"SHA128: %@", [YYRSACrypto verSignKeyPair:self.keyPair SHA128:self.sha128 message:@"111"] ? @"签名有效" : @"签名无效");
    NSLog(@"SHA256: %@", [YYRSACrypto verSignKeyPair:self.keyPair SHA256:self.sha256 message:@"222"] ? @"签名有效" : @"签名无效");
    NSLog(@"MD5: %@", [YYRSACrypto verSignKeyPair:self.keyPair MD5:self.md5 message:@"333"] ? @"签名有效" : @"签名无效");
    
    NSLog(@"错误1: %@", [YYRSACrypto verSignKeyPair:self.keyPair MD5:self.md5 message:@"444"/* 验证的消息与签名的消息不一样 */] ? @"签名有效" : @"签名无效");
    NSLog(@"错误2: %@", [YYRSACrypto verSignKeyPair:self.keyPair MD5:self.sha128/* 验证的签名字符串与签名后的不一样 */ message:@"333"] ? @"签名有效" : @"签名无效");
}


#pragma mark -
- (void)encryptAndDecrypt:(MIHKeyPair *)keyPair {
    {
        NSString *enStr = [YYRSACrypto publicEncrypt:keyPair encryptStr:@"arvin🇨🇳123"];
        NSString *deStr = [YYRSACrypto privateDecrypt:keyPair decryptStr:enStr];
        
        NSLog(@"公钥加密后的字符串:\n%@", enStr);
        NSLog(@"私钥解密后的原文: %@", deStr);
    }
    NSLog(@"==============================================================================================================");
    {
        NSString *enStr = [YYRSACrypto privateEncrypt:keyPair encryptStr:@"123🇨🇳arvin"];
        NSString *deStr = [YYRSACrypto publicDecrypt:keyPair decryptStr:enStr];
        
        NSLog(@"私钥加密后的字符串:\n%@", enStr);
        NSLog(@"公钥解密后的原文: %@", deStr);
    }
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



