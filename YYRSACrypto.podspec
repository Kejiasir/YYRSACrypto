
Pod::Spec.new do |s|

  s.name         = "YYRSACrypto"
  s.version      = "0.0.1"
  s.license      = "MIT"
  s.summary      = "基于MIHCrypto封装的 RSA 加密解密的工具类, 一行代码加密解密!" 

  s.authors      =  {'Arvin' => 'yasir86@126.com'}
  s.homepage     = "https://github.com/Kejiasir/YYRSACrypto"
  s.source       = { :git => "https://github.com/Kejiasir/YYRSACrypto.git", :tag => "#{s.version}" }
  
  s.platform     = :ios, "8.0" 

  s.source_files  = "YYRSACrypto", "YYRSACrypto/*.{h,m}" 
  
  s.requires_arc = true
  
  s.dependency 'MIHCrypto', "~> 0.4.1"
  s.dependency 'GTMBase64', '~> 1.0.0'
  
end
