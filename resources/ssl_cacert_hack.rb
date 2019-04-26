resource_name :ssl_cacert_hack

# property :the_name, String, name_property: true

property :ca_source, String, default: 'ca-bundle.crt'
property :ca_bundle, String, default: '/etc/pki/tls/certs/ca-bundle.crt'

property :certs_glob, [String, Array], default: ['/opt/**/cacert{,s}.pem', '/hab/**/cacert{,s}.pem']

property :root_cabundle, String, default: lazy {
  if platform_family? 'rhel'
    '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'
  else
    '/etc/ssl/certs/ca-certificates.crt'
  end
}

action :create do
  cookbook_file new_resource.root_cabundle do
    source new_resource.ca_source
    cookbook cookbook_name
    sensitive true
    owner 'root'
    group 'root'
    mode '0444'
    action :create
  end

  link new_resource.ca_bundle do
    to new_resource.root_cabundle
    link_type :symbolic
    action :create
    not_if { platform_family? 'debian' }
  end

  Dir.glob(new_resource.certs_glob).each do |cert|
    link cert do
      case node['platform']
      when 'ubuntu', 'debian'
        to new_resource.root_cabundle
      else
        to new_resource.ca_bundle
      end
      link_type :symbolic
      action :create
    end
  end
end
