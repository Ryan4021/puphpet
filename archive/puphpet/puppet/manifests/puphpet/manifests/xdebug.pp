class puphpet::xdebug (
  $xdebug = $puphpet::params::hiera['xdebug'],
  $php    = $puphpet::params::hiera['php'],
) {

  include puphpet::php::settings

  Class['Puphpet::Php::Settings']
  -> Class['Puphpet::Php::Xdebug']

  $version = $puphpet::php::settings::version
  $service = $puphpet::php::settings::service

  $compile = $version ? {
    '5.6'   => true,
    '56'    => true,
    '70'    => true,
    default => false,
  }

  class { 'puphpet::php::xdebug':
    webserver => $service,
    compile   => $compile,
  }

  each( $xdebug['settings'] ) |$key, $value| {
    puphpet::php::ini { $key:
      entry       => "XDEBUG/${key}",
      value       => $value,
      php_version => $version,
      webserver   => $service,
      notify      => Service[$service],
    }
  }

}
