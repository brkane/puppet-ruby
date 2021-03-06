# Class: ruby
#
# This class installs ruby compiling it from sources
#
# Paremeters:
#
#   $version - the version as denoted in source filename
#
#
class ruby (
  $version       = '2.2.0',
  $install_path  = '/opt/rubies',
  $with_gdbm     = true,
  $with_openssl  = true,
  $with_readline = true,
  $with_ripper   = true,
  $with_zlib     = true
  ) {

  $minor_version = inline_template('<%= @version.slice(/^\d+\.\d+/) -%>')

  class { 'ruby::prereqs':
    minor_version => $minor_version,
    with_gdbm     => $with_gdbm,
    with_openssl  => $with_openssl,
    with_readline => $with_readline,
    with_ripper   => $with_ripper,
    with_zlib     => $with_zlib,
  }

  exec { 'ruby::get':
    command => "curl ftp://ftp.ruby-lang.org/pub/ruby/${minor_version}/ruby-${version}.tar.gz | tar xz",
    cwd => "/tmp",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    onlyif  => 'test ! -d /tmp/ruby-${version}',
    require => [Package['curl']],
    unless  => "test -x ${install_path}/${version}/bin/ruby",
  }

  exec { 'ruby::configure':
    command => "/tmp/ruby-${version}/configure --prefix=${install_path}/${version} --disable-install-rdoc",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Package['make'], Exec['ruby::get']],
    unless  => "test -x ${install_path}/${version}/bin/ruby",
  }

  exec { 'ruby::make':
    command => "make",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::configure'], Class['ruby::prereqs']],
    unless  => "test -x ${install_path}/${version}/bin/ruby",
  }

  exec { 'ruby::install':
    command => "make install",
    cwd => "/tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::make']],
    unless  => "test -x ${install_path}/${version}/bin/ruby",
  }

  exec { 'ruby::clean':
    command => "rm -rf /tmp/ruby-${version}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => [Exec['ruby::install']],
    unless  => "test -d /tmp/ruby-${version}",
  }

}
