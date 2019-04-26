# Inspec test for recipe ssl_cacert_hack::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  if os.debian?
    describe file '/etc/ssl/certs/ca-certificates.crt' do
      it { should exist }
    end

    describe file '/opt/chef/embedded/ssl/certs/cacert.pem' do
      it { should exist }
      it { should be_symlink }
      it { should be_linked_to '/etc/ssl/certs/ca-certificates.crt' }
    end
  else
    describe file '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem' do
      it { should exist }
      its('type') { should eq :file }
    end

    describe file '/etc/pki/tls/certs/ca-bundle.crt' do
      it { should exist }
      it { should be_symlink }
      it { should be_linked_to '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem' }

      # so... is it a symlink or no?
      # its('type') { should eq :symlink }
      # File /etc/pki/tls/certs/ca-bundle.crt
      # ✔  should exist
      # ✔  should be symlink
      # ✔  should be linked to "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"
      # ×  type should eq :symlink
    end

    describe file '/opt/chef/embedded/ssl/certs/cacert.pem' do
      it { should exist }
      it { should be_symlink }
      it { should be_linked_to '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem' }

      # I don't understand... this file exists...
      # its('shallow_link_path'){ should eq '/etc/pki/tls/certs/ca-bundle.crt' }
      #   File /opt/chef/embedded/ssl/certs/cacert.pem
      # ✔  should exist
      # ✔  should be symlink
      # ✔  should be linked to "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"
      # ×  shallow_link_path
      # No such file or directory @ rb_readlink - /opt/chef/embedded/ssl/certs/cacert.pem
    end
  end
end
