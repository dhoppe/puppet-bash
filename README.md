# bash

[![Build Status](https://travis-ci.org/dhoppe/puppet-bash.png?branch=master)](https://travis-ci.org/dhoppe/puppet-bash)
[![Puppet Forge](https://img.shields.io/puppetforge/v/dhoppe/bash.svg)](https://forge.puppetlabs.com/dhoppe/bash)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/dhoppe/bash.svg)](https://forge.puppetlabs.com/dhoppe/bash)
[![Puppet Forge](https://img.shields.io/puppetforge/mc/dhoppe.svg)](https://forge.puppetlabs.com/dhoppe)
[![Puppet Forge](https://img.shields.io/puppetforge/rc/dhoppe.svg)](https://forge.puppetlabs.com/dhoppe)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bash](#setup)
    * [What bash affects](#what-bash-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with bash](#beginning-with-bash)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This module installs and configures the Bash package.

## Module Description

This module handles installing and configuring Bash across a range of operating systems and distributions.

## Setup

### What bash affects

* bash package.
* bash configuration file.

### Setup Requirements

* Puppet >= 2.7
* Facter >= 1.6
* [Stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with bash

Install bash with the default parameters ***(No configuration files will be changed)***.

```puppet
    class { 'bash': }
```

Install bash with the recommended parameters.

```puppet
    class { 'bash':
      config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
      config_file_hash     => {
        '.bash_aliases_skel' => {
          config_file_path   => '/etc/skel/.bash_aliases',
          config_file_source => 'puppet:///modules/bash/common/etc/skel/bash_aliases',
        },
        '.bash_aliases_root' => {
          config_file_path   => '/root/.bash_aliases',
          config_file_source => 'puppet:///modules/bash/common/etc/skel/bash_aliases',
        },
        '.bashrc'            => {
          config_file_path     => '/root/.bashrc',
          config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
        },
      },
    }
```

## Usage

Update the bash package.

```puppet
    class { 'bash':
      package_ensure => 'latest',
    }
```

Remove the bash package.

```puppet
    class { 'bash':
      package_ensure => 'absent',
    }
```

Purge the bash package ***(All configuration files will be removed)***.

```puppet
    class { 'bash':
      package_ensure => 'purged',
    }
```

Deploy the configuration files from source directory.

```puppet
    class { 'bash':
      config_dir_source => "puppet:///modules/bash/${::lsbdistcodename}/etc/skel",
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration files will be removed)***.

```puppet
    class { 'bash':
      config_dir_purge  => true,
      config_dir_source => "puppet:///modules/bash/${::lsbdistcodename}/etc/skel",
    }
```

Deploy the configuration file from source.

```puppet
    class { 'bash':
      config_file_source => "puppet:///modules/bash/${::lsbdistcodename}/etc/skel/bashrc",
    }
```

Deploy the configuration file from string.

```puppet
    class { 'bash':
      config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
    }
```

Deploy the configuration file from template.

```puppet
    class { 'bash':
      config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
    }
```

Deploy the configuration file from custom template ***(Additional parameters can be defined)***.

```puppet
    class { 'bash':
      config_file_template     => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
      config_file_options_hash => {
        'key' => 'value',
      },
    }
```

Deploy additional configuration files from source, string or template.

```puppet
    class { 'bash':
      config_file_hash => {
        'bashrc.2nd.conf' => {
          config_file_path   => '/etc/skel/bashrc.2nd.conf',
          config_file_source => "puppet:///modules/bash/${::lsbdistcodename}/etc/skel/bashrc.2nd.conf",
        },
        'bashrc.3rd.conf' => {
          config_file_path   => '/etc/skel/bashrc.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'bashrc.4th.conf' => {
          config_file_path     => '/etc/skel/bashrc.4th.conf',
          config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.4th.conf.erb",
        },
      },
    }
```

## Reference

### Classes

#### Public Classes

* bash: Main class, includes all other classes.

#### Private Classes

* bash::install: Handles the packages.
* bash::config: Handles the configuration file.

### Parameters

#### `package_ensure`

Determines if the package should be installed. Valid values are 'present', 'latest', 'absent' and 'purged'. Defaults to 'present'.

#### `package_name`

Determines the name of package to manage. Defaults to 'bash'.

#### `package_list`

Determines if additional packages should be managed. Defaults to '['bash-completion']'.

#### `config_dir_ensure`

Determines if the configuration directory should be present. Valid values are 'absent' and 'directory'. Defaults to 'directory'.

#### `config_dir_path`

Determines if the configuration directory should be managed. Defaults to '/etc/skel'

#### `config_dir_purge`

Determines if unmanaged configuration files should be removed. Valid values are 'true' and 'false'. Defaults to 'false'.

#### `config_dir_recurse`

Determines if the configuration directory should be recursively managed. Valid values are 'true' and 'false'. Defaults to 'true'.

#### `config_dir_source`

Determines the source of a configuration directory. Defaults to 'undef'.

#### `config_file_ensure`

Determines if the configuration file should be present. Valid values are 'absent' and 'present'. Defaults to 'present'.

#### `config_file_path`

Determines if the configuration file should be managed. Defaults to '/etc/skel/.bashrc'

#### `config_file_owner`

Determines which user should own the configuration file. Defaults to 'root'.

#### `config_file_group`

Determines which group should own the configuration file. Defaults to 'root'.

#### `config_file_mode`

Determines the desired permissions mode of the configuration file. Defaults to '0644'.

#### `config_file_source`

Determines the source of a configuration file. Defaults to 'undef'.

#### `config_file_string`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_template`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_require`

Determines which package a configuration file depends on. Defaults to 'Package[bash]'.

#### `config_file_hash`

Determines which configuration files should be managed via `bash::define`. Defaults to '{}'.

#### `config_file_options_hash`

Determines which parameters should be passed to an ERB template. Defaults to '{}'.

#### `color_prompt`

Determines which color (prompt) should be used. Defaults to '\[\033[01;32m\]'.

* '\[\033[01;30m\]' # grey
* '\[\033[01;31m\]' # red
* '\[\033[01;32m\]' # green
* '\[\033[01;33m\]' # yellow
* '\[\033[01;34m\]' # blue
* '\[\033[01;35m\]' # magenta
* '\[\033[01;36m\]' # cyan
* '\[\033[01;37m\]' # white

#### `hostname_prompt`

Determines which hostname (prompt) should be used. Defaults to '\h'.

## Limitations

This module has been tested on:

* Debian 6/7/8
* Ubuntu 12.04/14.04

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a pull request.

### Contributors

The list of contributors can be found at: [https://github.com/dhoppe/puppet-bash/graphs/contributors](https://github.com/dhoppe/puppet-bash/graphs/contributors)
