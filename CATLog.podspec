Pod::Spec.new do |s|
  s.name         = "CATLog"
  s.version      = "1.1.0"
  s.license      = 'MIT'
  s.homepage     = "http://catchzeng.com"
  s.summary      = "CATLog is a log system that supports remote output."
  s.author		 = { "CatchZeng" => "891793848@qq.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/CatchZeng/CATLog.git", :tag => "1.1.0" }
  s.source_files  = "CATLog/CATLog/*.{h,m}"
  s.resources = "CATLog/CATLog/*.xib"
  s.requires_arc = true
end