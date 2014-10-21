# Class: ruby
#
# This class installs ruby compiling it from sources
#
# Paremeters:
#
#   $version - the version as denoted in source filename
#
# Dependencies:
#    autoconf bison build-essential libssl-dev
#    libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev
#
class ruby ($version = '2.1.2') {

  if defined(Package['autoconf']) == false {
    package { 'autoconf': ensure => present }
  }

  if defined(Package['bison']) == false {
    package { 'bison': ensure => present }
  }

  if defined(Package['build-essential']) == false {
    package { 'build-essential': ensure => present }
  }

  if defined(Package['libssl-dev']) == false {
    package { 'libssl-dev': ensure => present }
  }

  if defined(Package['libyaml-dev']) == false {
    package { 'libyaml-dev': ensure => present }
  }

  if defined(Package['libreadline6-dev']) == false {
    package { 'libreadline6-dev': ensure => present }
  }

  if defined(Package['zlib1g-dev']) == false {
    package { 'zlib1g-dev': ensure => present }
  }

  if defined(Package['libncurses5-dev']) == false {
    package { 'libncurses5-dev': ensure => present }
  }

  if defined(Package['curl']) == false {
    package { 'curl': ensure => present }
  }

  if defined(Package['make']) == false {
    package { 'make': ensure => present }
  }

  exec { 'ruby::get':
    command => "curl ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-${version}.tar.gz | tar xz",
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

