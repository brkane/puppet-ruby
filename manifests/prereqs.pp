
class ruby::prereqs (
  $minor_version = '2.2',
  $with_gdbm     = true,
  $with_openssl  = true,
  $with_readline = true,
  $with_ripper   = true,
  $with_zlib     = true
  ) {

  if defined(Package['curl']) == false {
    package { 'curl': ensure => present }
  }

  if defined(Package['make']) == false {
    package { 'make': ensure => present }
  }

  if defined(Package['gcc']) == false {
    package { 'gcc': ensure => present }
  }

  if $with_gdbm and defined(Package['gdbm-devel']) == false {
    package { 'gdbm-devel': ensure => present }
  }

  if $with_openssl and defined(Package['openssl-devel']) == false {
    package { 'openssl-devel': ensure => present }
  }

  if $with_readline and defined(Package['readline-devel']) == false {
    package { 'readline-devel': ensure => present }
  }

  if $with_ripper and defined(Package['bison']) == false {
    package { 'bison': ensure => present }
  }

  if $with_zlib and defined(Package['zlib-devel']) == false {
    package { 'zlib-devel': ensure => present }
  }

  if $minor_version == '2.2' and defined(Package['libffi-devel']) == false {
    package { 'libffi-devel': ensure => present }
  }
}
