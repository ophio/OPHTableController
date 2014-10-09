Pod:: Spec.new do |spec|
  spec.platform     = 'ios', '7.0'
  spec.name         = 'OPHTableController'
  spec.version      = '1.0.0'
  spec.summary      = 'Lightweight controller for TableView to add pull to refresh and load more functionality'
  spec.author = {
    'Ritesh Gupta' => 'ritesh@ophio.co.in'
  }
  spec.license          = 'MIT' 
  spec.homepage         = 'https://github.com/ophio/OPHTableController'
  spec.source = {
    :git => 'https://github.com/ophio/OPHTableController.git',
    :tag => '1.0.0'
  }
  spec.ios.deployment_target = '7.0'
  spec.source_files = 'Source/*.{h,m}'
  spec.requires_arc     = true
end