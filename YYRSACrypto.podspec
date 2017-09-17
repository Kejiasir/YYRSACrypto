
Pod::Spec.new do |s|

  s.name         = "YYRSACrypto"
  s.version      = "0.0.1"
  s.summary      = "基于 MIHCrypto 封装的 RSA 加密解密工具类."
  s.description  = <<-DESC
                  基于 MIHCrypto 封装的 RSA 加密解密工具类, 加密解密, 只需要一句代码就能实现.
                   DESC

  s.homepage     = "https://github.com/Kejiasir/YYRSACrypto"

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Arvin" => "yasir86@126.com" }

  # Or just: s.author    = "Arvin"
  # s.authors            = { "Arvin" => "yasir86@126.com" }
  # s.social_media_url   = "http://twitter.com/Arvin"

  # s.platform     = :ios
  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Kejiasir/YYRSACrypto.git", :tag => "#{s.version}" }

  s.source_files  = "YYRSACrypto", "YYRSACrypto/YYRSACrypto/*.{h,m}"

  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency "MIHCrypto", "~> 0.4.1"
  s.dependency "GTMBase64", "~> 1.0.0"

end
