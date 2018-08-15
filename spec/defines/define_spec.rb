require 'spec_helper'

describe 'bash::define', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:pre_condition) { 'include bash' }
      let(:title) { '.bashrc' }

      context 'when source file' do
        let(:params) do
          {
            config_file_path: '/etc/skel/.bashrc.2nd',
            config_file_source: 'puppet:///modules/bash/wheezy/etc/skel/bashrc',
          }
        end

        it do
          is_expected.to contain_file('define_.bashrc').with(
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/bash/wheezy/etc/skel/bashrc',
            'require' => 'Package[bash]',
          )
        end
      end

      context 'when content string' do
        let(:params) do
          {
            config_file_path: '/etc/skel/.bashrc.3rd',
            config_file_string: '# THIS FILE IS MANAGED BY PUPPET',
          }
        end

        it do
          is_expected.to contain_file('define_.bashrc').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'require' => 'Package[bash]',
          )
        end
      end

      context 'when content template' do
        let(:params) do
          {
            config_file_path: '/etc/skel/.bashrc.4th',
            config_file_template: 'bash/wheezy/etc/skel/bashrc.erb',
          }
        end

        it do
          is_expected.to contain_file('define_.bashrc').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'require' => 'Package[bash]',
          )
        end
      end

      context 'when content template (custom)' do
        let(:params) do
          {
            config_file_path: '/etc/skel/.bashrc.5th',
            config_file_template: 'bash/wheezy/etc/skel/bashrc.erb',
            config_file_options_hash: {
              'key' => 'value',
            },
          }
        end

        it do
          is_expected.to contain_file('define_.bashrc').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'require' => 'Package[bash]',
          )
        end
      end
    end
  end
end
