class multi_node::server (
  Simplib::Port        $port,
  Stdlib::Absolutepath $output_file
){

  service { 'firewalld': ensure => stopped, enable => false }
  service { 'iptables': ensure => stopped, enable => false }

  file { '/usr/local/bin/nc_listen':
    mode    => '0755',
    content => "#!/bin/bash\n\n nc -l ${port} > ${output_file} &\n"
  }
}
