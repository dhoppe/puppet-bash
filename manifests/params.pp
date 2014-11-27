# == Class: bash::params
#
class bash::params {
  $package_name = $::osfamily ? {
    default => 'bash',
  }

  $package_list = $::osfamily ? {
    default => ['bash-completion'],
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/skel',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/skel/.bashrc',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_require = $::osfamily ? {
    default => 'Package[bash]',
  }

  case $::osfamily {
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
