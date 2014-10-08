Pod:: Spec.new do |s|
s.name         = 'OPHTableController'
  s.version      = '1.0.0'
  s.summary      = 'Lightweight controller for TableView to add pull to refresh and load more functionality'
  s.author = {
    'Ritesh Gupta' => 'ritesh@ophio.co.in'
  }
  s.source = {
    :git => 'https://github.com/ophio/OPHTableController.git',
    :branch => 'master'
  }
  s.source_files = 'Source/*.{h,m}'
end