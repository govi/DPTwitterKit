Pod::Spec.new do |s|
    s.name          =   "DPTwitterKit"
    s.version       =   "0.0.1"
    s.summary       =   "Embeddable Twitter client"
    s.license       =   "MIT"
    s.author        =   { "Govi" => "govi@email.com"}
    s.source        =   { :git => 'https://github.com/govi/DPTwitterKit.git', :tag => '0.0.1' }
    s.platform      =   :ios, '5.0'
    s.source_files  =   'DPTwitterKit', 'DPTwitterKit/**/*.{h,m}'
    s.resources     =   '**/*.{png,xib}'
    s.frameworks    =   'Twitter', 'Accounts', 'ImageIO'
    s.requires_arc  =   true
    s.homepage      =   'https://github.com/govi/DPTwitterKit'
    s.dependency 'REComposeViewController', '~> 2.1.1'
    s.dependency 'SVProgressHUD', '~> 1.0'
    s.dependency 'TSMiniWebBrowser', '~> 1.0.1'
    s.dependency 'AFNetworking', '~> 2.2'
    #s.dependency 'STTwitter', :git => 'https://github.com/govi/STTwitter.git'
    #s.dependency 'STTweetLabel', :git => 'https://github.com/govi/STTweetLabel.git', :commit => '395c3ca5f8'
end