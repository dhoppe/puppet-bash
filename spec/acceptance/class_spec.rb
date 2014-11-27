require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  package_name     = 'bash'
  config_dir_path  = '/etc/skel'
  config_file_path = '/etc/skel/.bashrc'
end

describe 'bash', :if => SUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'is_expected.to work with no errors' do
    pp = <<-EOS
      class { 'bash': }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe 'bash::install' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash': }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    context 'when package latest' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash':
            package_ensure => 'latest',
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

#    context 'when package absent' do
#      it 'is_expected.to work with no errors' do
#        pp = <<-EOS
#          class { 'bash':
#            package_ensure => 'absent',
#          }
#        EOS
#
#        apply_manifest(pp, :catch_failures => true)
#      end
#
#      describe package(package_name) do
#        it { is_expected.not_to be_installed }
#      end
#      describe file(config_file_path) do
#        it { is_expected.to be_file }
#      end
#    end
#
#    context 'when package purged' do
#      it 'is_expected.to work with no errors' do
#        pp = <<-EOS
#          class { 'bash':
#            package_ensure => 'purged',
#          }
#        EOS
#
#        apply_manifest(pp, :catch_failures => true)
#      end
#
#      describe package(package_name) do
#        it { is_expected.not_to be_installed }
#      end
#      describe file(config_file_path) do
#        it { is_expected.not_to be_file }
#      end
#    end
  end

  describe 'bash::config' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash': }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
      end
    end

    context 'when content string' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash':
            config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
    end

    context 'when content template' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash':
            config_file_template => "bash/#{fact('lsbdistcodename')}/#{config_dir_path}/bashrc.erb",
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
    end

    context 'when hash of files' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'bash':
            config_file_hash => {
              '.bash_aliases_skel' => {
                config_file_path   => '/#{config_dir_path}/.bash_aliases',
                config_file_source => "puppet:///modules/bash/common/#{config_dir_path}/bash_aliases",
              },
              '.bash_aliases_root' => {
                config_file_path   => '/root/.bash_aliases',
                config_file_source => "puppet:///modules/bash/common/#{config_dir_path}/bash_aliases",
              },
              '.bashrc'            => {
                config_file_path     => '/root/.bashrc',
                config_file_template => "bash/#{fact('lsbdistcodename')}/#{config_dir_path}/bashrc.erb",
              },
            },
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file('/etc/skel/.bash_aliases') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
      describe file('/root/.bash_aliases') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
      describe file('/root/.bashrc') do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
    end
  end
end
