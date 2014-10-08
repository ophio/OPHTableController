Pod:: Spec.new do |spec|
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
    :branch => 'master'
  }
  spec.source_files = 'Source/*.{h,m}'
  spec.requires_arc     = true
end