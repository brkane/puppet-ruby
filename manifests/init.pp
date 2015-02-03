# Class: ruby
#
# This class installs ruby compiling it from sources
#
# Paremeters:
#
#   $version - the version as denoted in source filename
#
#
class ruby ($version = '2.2.0') {

  if defined(Package['curl']) == false {
    package { 'curl': ensure => present }
  }

  if defined(Package['make']) == false {
    package { 'make': ensure => present }
  }

  exec { 'ruby::get':
    command => "curl ftp://ftp.ruby-lang.org/pub/ruby/2.2/ruby-${version}.tar.gz | tar xz",
    cwd => "/tmp",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    onlyif  => 'test ! -d /tmp/ruby-${version}',
    require => [Package['curl']]
  }

  exec { 'ruby::configure':
    command => "/tmp/ruby-${version}/configure --disable-install-rdoc",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Package['make'], Exec['ruby::get']]
  }

  exec { 'ruby::make':
    command => "make",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::configure']]
  }

  exec { 'ruby::install':
    command => "make install",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::make']]
  }

  exec { 'ruby::clean':
    command => "rm -rf /tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::install']]
  }

}
