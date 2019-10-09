class multi_node::client (
  Simplib::Host $server,
  Simplib::Port $port,
  String[1]     $message = 'This is a test'
) {
  file { '/usr/local/bin/nc_send':
    mode    => '0755',
    content => "#!/bin/bash\n\n echo '${message}' | nc ${server} ${port} -w 5\n"
  }
}
