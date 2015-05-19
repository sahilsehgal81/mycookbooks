#New PHP Cookbook




default['php']['install_method'] = 'package'

  default['php']['conf_dir']      = '/etc'
  default['php']['ext_conf_dir']  = '/etc/php.d'
  default['php']['fpm_user']      = 'nobody'
  default['php']['fpm_group']     = 'nobody'
  default['php']['ext_dir']       = "/usr/#{lib_dir}/php/modules"

default['php']['url'] = 'http://us.php.net/distributions'
default['php']['version'] = '5.3.5'
default['php']['checksum'] = 'a25ddae6a59d7345bcbb69ef2517784f56c2069af663ae4611e580cbdec77e22'
default['php']['prefix_dir'] = '/usr/local'

default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                          --with-libdir=#{lib_dir}
                                          --with-config-file-path=#{php['conf_dir']}
                                          --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                          --with-pear
                                          --enable-fpm
                                          --with-fpm-user=#{php['fpm_user']}
                                          --with-fpm-group=#{php['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --with-gd
                                          --with-filter
                                          --enable-gd-native-ttf
                                          --with-gettext
                                          --with-gmp
                                          --with-pdo
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --with-json
                                          --enable-sockets
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-libevent-dir
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}

