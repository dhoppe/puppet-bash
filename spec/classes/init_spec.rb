require 'spec_helper'

describe 'bash', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_anchor('bash::begin') }
      it { is_expected.to contain_class('bash::params') }
      it { is_expected.to contain_class('bash::install') }
      it { is_expected.to contain_class('bash::config') }
      it { is_expected.to contain_anchor('bash::end') }

      describe 'bash::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('bash').with(
              'ensure' => 'present',
            )
            is_expected.to contain_package('bash-completion').with(
              'ensure' => 'present',
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest',
            }
          end

          it do
            is_expected.to contain_package('bash').with(
              'ensure' => 'latest',
            )
            is_expected.to contain_package('bash-completion').with(
              'ensure' => 'latest',
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent',
            }
          end

          it do
            is_expected.to contain_package('bash').with(
              'ensure' => 'absent',
            )
            is_expected.to contain_package('bash-completion').with(
              'ensure' => 'absent',
            )
          end
          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged',
            }
          end

          it do
            is_expected.to contain_package('bash').with(
              'ensure' => 'purged',
            )
            is_expected.to contain_package('bash-completion').with(
              'ensure' => 'purged',
            )
          end
          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'absent',
              'require' => 'Package[bash]',
            )
          end
        end
      end

      describe 'bash::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/bash/wheezy/etc/skel',
            }
          end

          it do
            is_expected.to contain_file('bash.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/bash/wheezy/etc/skel',
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/bash/wheezy/etc/skel',
            }
          end

          it do
            is_expected.to contain_file('bash.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/bash/wheezy/etc/skel',
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/bash/wheezy/etc/skel/bashrc',
            }
          end

          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/bash/wheezy/etc/skel/bashrc',
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when content string' do
          let(:params) do
            {
              config_file_string: '# THIS FILE IS MANAGED BY PUPPET',
            }
          end

          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when content template' do
          let(:params) do
            {
              config_file_template: 'bash/wheezy/etc/skel/bashrc.erb',
            }
          end

          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'require' => 'Package[bash]',
            )
          end
        end

        context 'when content template (custom)' do
          let(:params) do
            {
              config_file_template: 'bash/wheezy/etc/skel/bashrc.erb',
              config_file_options_hash: {
                'key' => 'value',
              },
            }
          end

          it do
            is_expected.to contain_file('bash.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'require' => 'Package[bash]',
            )
          end
        end
      end
    end
  end
end
