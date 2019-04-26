[![Build Status](https://travis-ci.org/qubitrenegade/ssl_cacert_hack.svg?branch=master)](https://travis-ci.org/qubitrenegade/ssl_cacert_hack)

# ssl_cacert_hack

This cookbook updates CA Bundles that are included with other software.

There are better ways to add trusted certificates to your system CA store, such as the [trusted_certificate](https://supermarket.chef.io/cookbooks/trusted_certificate) cookbook.  You should probably be using one of those.  This cookbook is a sledge hammer approach.

You have been warned.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL 6+

### Chef

- Chef 13+

### Cookbooks

- none

## Usage

This cookbook provides both a recipe and resource.  You probably want the resource.

### Recipe

#### default

The `ssl_cacert_hack::default` recipe is really intended for testing purposes only.  The included `ca-bundle.crt` is the ca-cert from the centos-7 kitchen dokken image.

Nevertheless you may include the recipe:

```ruby
include_recipe 'ssl_cacert_hack::default'`
```

### Resource

By default the `ssl_cacert_hack` resource  should handle common locations on CentOS, Debian, and Ubuntu.

```ruby
ssl_cacert_hack 'something relevant' do
  action :create
end
```

(actually, since the `:create` action is default, it can be omitted as well)

By default, this expects your cookbook to have a `files/default/ca-bundle.crt` included.  This can be overridden with the `ca_source` attribute.

This would expect a `files/default/foo.pem` bundled with your cookbook.

```ruby
ssl_cacert_hack 'internal certs' do
  ca_source 'foo.pem'
  action :create
end
```

#### Resource Attributes

* `ca_source`: Name of the file bundled with your cookbook.
* `ca_bundle`: On CentOS systems, path to the "system" ca_bundle, this will be linked to the `root_cabundle`
* `root_cabundle`: Path to the actual cabundle on the system.
* `certs_glob`: Array passed to `Dir.glob` to search for files.  This works similar to SH expansion.

Default Values:

```
ssl_cacert_hack 'demo' do
  ca_source 'ca-bundle.crt'
  ca_bundle '/etc/pki/tls/certs/ca-bundle.crt'
  certs_glob ['/opt/**/cacert{,s}.pem', '/hab/**/cacert{,s}.pem']

  case node['platform']
  when 'ubuntu', 'debian'
    root_cabundle '/etc/ssl/certs/ca-certificates.crt'
  else
    root_cabundle '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'
  end

  action :create
end
```

## License & Authors

**Author:** QubitRenegade

**Copyright:** 2019, QubitRenegade

```
The MIT License (MIT)

Copyright (c) 2019 QubitRenegade

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
