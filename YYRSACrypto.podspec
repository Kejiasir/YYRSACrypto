
Pod::Spec.new do |s|

  s.name         = "YYRSACrypto"
  s.version      = "0.1.1"
  s.summary      = "RSA encryption and decryption based on MIHCrypto encapsulation, signature verification tool class."
  s.description  = <<-DESC
                   RSA encryption and decryption based on MIHCrypto encapsulation, signature verification tool class.
                   DESC

  s.homepage     = "https://github.com/Kejiasir/YYRSACrypto"

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "Arvin.Yang" => "arvinSir.86@gmail.com" }

  # Or just: s.author    = "Arvin.Yang"
  # s.authors            = { "Arvin.Yang" => "arvinSir.86@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Arvin"

  # s.platform     = :ios
  s.platform     = :ios, "6.0"

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
