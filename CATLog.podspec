Pod::Spec.new do |s|
  s.name         = "CATLog"
  s.version      = "1.0.1"
  s.license      = 'MIT'
  s.homepage     = "http://catchzeng.com"
  s.summary      = "CATLog is an open source Log System for Objective-C."
  s.author		 = { "CatchZeng" => "891793848@qq.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/CatchZeng/CATLog.git", :tag => "1.0.1" }
  s.source_files  = "CATLog/CATLog/CATLog/CATLog.{h,m}"
  s.requires_arc = true
end