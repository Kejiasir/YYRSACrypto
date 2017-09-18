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
    
    //    __weak typeof(self) weakSelf = self;
    //    [YYRSACrypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
    //
    //        [weakSelf setKeyPair:keyPair];
    //
    //    } archiverFileName:nil];
    
    
    YYRSACrypto *crypto = [[YYRSACrypto alloc] init];
    [crypto rsa_generate_key:^(MIHKeyPair *keyPair, bool isExist) {
        {
            NSString *enStr = [YYRSACrypto publicEncrypt:keyPair encryptStr:@"arvin🇨🇳123"];
            NSString *deStr = [YYRSACrypto privateDecrypt:keyPair decryptStr:enStr];
            
            NSLog(@"11加密的字符串:\n%@", enStr);
            NSLog(@"11私钥解密的原文:\n%@", deStr);
            
            
        } {
            NSString *enStr = [YYRSACrypto privateEncrypt:keyPair encryptStr:@"123🇨🇳arvin"];
            NSString *deStr = [YYRSACrypto publicDecrypt:keyPair decryptStr:enStr];
            
            NSLog(@"22加密的字符串:\n%@", enStr);
            NSLog(@"22公钥解密的原文:\n%@", deStr);
            
        }
        
    } archiverFileName:nil];
    
}


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end











