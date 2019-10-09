class multi_node (
  Boolean $is_server = false,
  Boolean $is_client = false
) {
  if $is_server { include multi_node::server }
  if $is_client { include multi_node::client }

  package { 'nc': ensure => 'installed' }
}
