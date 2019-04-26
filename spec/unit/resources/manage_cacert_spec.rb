require 'spec_helper'

describe 'ssl_cacert_hack' do
  step_into :ssl_cacert_hack

  context 'ssl_cacert_hack resource' do
    before do
      allow(Dir).to receive(:glob)
        .with(['/opt/**/cacert{,s}.pem', '/hab/**/cacert{,s}.pem'])
        .and_return(['/opt/chef/embedded/ssl/certs/cacert.pem'])
    end

    recipe do
      ssl_cacert_hack 'test'
    end

    context 'On CentOS with default attributes' do
      platform 'centos'

      it { is_expected.to create_cookbook_file '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem' }
      it { is_expected.to create_link '/etc/pki/tls/certs/ca-bundle.crt' }
      it { is_expected.to create_link '/opt/chef/embedded/ssl/certs/cacert.pem' }
    end

    context 'On Ubuntu with default attributes' do
      platform 'ubuntu'
      it { is_expected.to create_cookbook_file '/etc/ssl/certs/ca-certificates.crt' }
      it { is_expected.to_not create_link '/etc/pki/tls/certs/ca-bundle.crt' }
      it { is_expected.to create_link '/opt/chef/embedded/ssl/certs/cacert.pem' }
    end
  end
end
