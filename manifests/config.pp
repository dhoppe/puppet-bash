# == Class: bash::config
#
class bash::config {
  if $::bash::config_dir_source {
    file { 'bash.dir':
      ensure  => $::bash::config_dir_ensure,
      path    => $::bash::config_dir_path,
      force   => $::bash::config_dir_purge,
      purge   => $::bash::config_dir_purge,
      recurse => $::bash::config_dir_recurse,
      source  => $::bash::config_dir_source,
      require => $::bash::config_file_require,
    }
  }

  if $::bash::config_file_path {
    file { 'bash.conf':
      ensure  => $::bash::config_file_ensure,
      path    => $::bash::config_file_path,
      owner   => $::bash::config_file_owner,
      group   => $::bash::config_file_group,
      mode    => $::bash::config_file_mode,
      source  => $::bash::config_file_source,
      content => $::bash::config_file_content,
      require => $::bash::config_file_require,
    }
  }
}
