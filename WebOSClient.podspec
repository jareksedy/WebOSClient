# WebOSClient.podspec

Pod::Spec.new do |s|
  s.name             = 'WebOSClient'
  s.version          = '1.0.9'
  s.summary          = 'A framework for communicating with LG Smart TV.'
  s.description      = 'WebOSClient is a lightweight Swift framework that allows you to communicate with an LG Smart TV running WebOS.'
  s.homepage         = 'https://github.com/jareksedy/WebOSClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yaroslav Sedyshev' => 'jareksedy@icloud.com' }
  s.platforms        = { :ios => '13.0', :watchos => '6.0', :tvos => '13.0' }
  s.source           = { :git => 'https://github.com/jareksedy/WebOSClient.git', :tag => s.version.to_s }
  s.swift_version    = '5.9'
  s.source_files     = 'Sources/**/*.swift'
  s.frameworks       = 'Foundation'
end
