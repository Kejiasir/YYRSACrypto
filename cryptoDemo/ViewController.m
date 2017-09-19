//
//  ViewController.m
//  cryptoDemo
//
//  Created by Arvin on 17/9/16.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ViewController.h"
#import "YYRSACrypto.h"

@interface ViewController ()

@property (nonatomic, strong) MIHKeyPair *keyPair;
@property (nonatomic, strong) NSString *encryptData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.v
    
}


/// 生成秘钥对
- (IBAction)generateKeyPair:(UIButton *)sender {
    // [self testFunc1];
    // [self testFunc2];
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
        
        /// 从偏好设置删除数据, 正常来说没必要做删除操作, 重新保存的话就会覆盖原来的数据
        // [YYRSACrypto removeFileFromUserDefaults];
        
    } archiverFileName:nil];
}


- (void)testFunc2 {
    /// 生成秘钥对方式 二:
    __weak typeof(self) weakSelf = self;
    YYRSACrypto *crypto = [[YYRSACrypto alloc] init];
    [crypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        [weakSelf encryptAndDecrypt:keyPair];
    } archiverFileName:nil];
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


#pragma mark -
/// 公钥加密
- (IBAction)publicEncrypt:(UIButton *)sender {
    NSString *encryptStr = @"123456789";
    self.encryptData = [YYRSACrypto publicEncrypt:self.keyPair encryptStr:encryptStr];
    NSLog(@"111111----\n%@", self.encryptData);
}


/// 私钥解密
- (IBAction)privateDecrypt:(UIButton *)sender {
    NSString *decryptStr = [YYRSACrypto privateDecrypt:self.keyPair decryptStr:self.encryptData];
    NSLog(@"私钥解密: %@", decryptStr);
}


/// 私钥加密
- (IBAction)privateEncrypt:(UIButton *)sender {
    NSString *encryptStr = @"987654321";
    self.encryptData = [YYRSACrypto privateEncrypt:self.keyPair encryptStr:encryptStr];
    NSLog(@"222222---\n%@", self.encryptData);
}


/// 公钥解密
- (IBAction)publicDecrypt:(UIButton *)sender {
    NSString *decryptStr = [YYRSACrypto publicDecrypt:self.keyPair decryptStr:self.encryptData];
    NSLog(@"公钥解密: %@", decryptStr);
}


#pragma mark -
- (void)encryptAndDecrypt:(MIHKeyPair *)keyPair {
    {
        NSString *enStr = [YYRSACrypto publicEncrypt:keyPair encryptStr:@"arvin🇨🇳123"];
        NSString *deStr = [YYRSACrypto privateDecrypt:keyPair decryptStr:enStr];
        
        NSLog(@"公钥加密的字符串:\n%@", enStr);
        NSLog(@"私钥解密的原文:\n%@", deStr);
        
    } {
        NSString *enStr = [YYRSACrypto privateEncrypt:keyPair encryptStr:@"123🇨🇳arvin"];
        NSString *deStr = [YYRSACrypto publicDecrypt:keyPair decryptStr:enStr];
        
        NSLog(@"私钥加密的字符串:\n%@", enStr);
        NSLog(@"公钥解密的原文:\n%@", deStr);
    }
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



