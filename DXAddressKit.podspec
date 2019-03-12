Pod::Spec.new do |s|
    s.name         = "DXAddressKit" # 项目名称
    s.version      = "0.0.5"        # 版本号 与 你仓库的 标签号 对应
    s.license      = "MIT"          # 开源证书
    s.summary      = "得贤高德地图" # 项目简介
    s.swift_version = '4.2'
    s.homepage     = "https://github.com/dongcantl/DXAddressCocoapods.git" # 仓库的主页
    s.source       = { :git => "https://github.com/dongcantl/DXAddressCocoapods.git", :tag => "#{s.version}" }#你的仓库地址，不能用SSH地址
    s.source_files = 'DXAddressKit/Classes/**/*.{h,m}','DXAddressKit/*.{h,m}'
    s.public_header_files = 'DXAddressKit/**/*.h'

    # s.resources = 'DXAddressKit/Assets/*.{png, xib}'
    s.resources = ["DXAddressKit/Assets/*.png", "DXAddressKit/Assets/Xib/*.xib"]
    # s.prefix_header_file = "DXAddressKit/Classes/Other/PrefixHeader.pch"

    # 你代码的位置， BYPhoneNumTF/*.{h,m} 表示 BYPhoneNumTF 文件夹下所有的.h和.m文件
    s.platform     = :ios, "9.0" #平台及支持的最低版本
    s.frameworks = 'CoreGraphics', 'CoreLocation', 'CoreTelephony', 'GLKit', 'Security', 'SystemConfiguration'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES'}

    s.dependency 'AMap3DMap-NO-IDFA'
    s.dependency 'AMapSearch-NO-IDFA'
    s.dependency 'AMapLocation-NO-IDFA'
    s.dependency 'AMapNavi-NO-IDFA'

    # User
    s.author             = { "董飞天" => "872783079@qq.com" } # 作者信息

end
