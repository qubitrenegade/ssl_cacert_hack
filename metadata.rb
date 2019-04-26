name              'ssl_cacert_hack'
maintainer        'QubitRenegade'
maintainer_email  'q at qubitrenegade period com'
license           'MIT'
description       'Installs/Configures ssl_cacert_hack'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'
chef_version      '>= 13.0'

issues_url 'https://github.com/qubitrenegade/ssl_cacert_hack/issues'
source_url 'https://github.com/qubitrenegade/ssl_cacert_hack'

%w(centos redhat ubuntu).each do |os|
  supports os
end
