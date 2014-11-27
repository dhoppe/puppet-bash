# == Class: bash::install
#
class bash::install {
  if $::bash::package_name {
    package { 'bash':
      ensure => $::bash::package_ensure,
      name   => $::bash::package_name,
    }
  }

  if $::bash::package_list {
    ensure_resource('package', $::bash::package_list, { 'ensure' => $::bash::package_ensure })
  }
}
