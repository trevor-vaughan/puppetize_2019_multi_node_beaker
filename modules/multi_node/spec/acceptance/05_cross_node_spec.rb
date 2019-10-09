require 'spec_helper_acceptance'

test_name "Cross-Node Test"

describe 'smash a file across' do

  let(:manifest){ 'include multi_node' }

  let(:test_port){ 12345 }
  let(:test_output_file){ '/tmp/test_file' }
  let(:test_message){ 'A special test message' }
  let(:server_fqdn){ fact_on(only_host_with_role(hosts, 'server'), 'fqdn') }

  let(:server_hieradata){{
    'multi_node::is_server'           => true,
    'multi_node::server::port'        => test_port,
    'multi_node::server::output_file' => test_output_file
  }}

  let(:client_hieradata){{
    'multi_node::is_client'       => true,
    'multi_node::client::server'  => server_fqdn,
    'multi_node::client::port'    => test_port,
    'multi_node::client::message' => test_message
  }}

  # Make sure things run cleanly without configuration
  hosts.each do |host|
    context "on #{host}" do
      it 'should run puppet' do
        apply_manifest_on(host, manifest, catch_failures: true)
      end

      it 'should be idempotent' do
        apply_manifest_on(host, manifest, catch_changes: true)
      end
    end
  end

  hosts_with_role(hosts, 'server').each do |host|
    context "on server #{host}" do
      it 'should set the hieradata' do
        set_hieradata_on(host, server_hieradata)
      end

      it 'should run puppet' do
        apply_manifest_on(host, manifest, catch_failures: true)
      end

      it 'should be idempotent' do
        apply_manifest_on(host, manifest, catch_changes: true)
      end
    end
  end

  hosts_with_role(hosts, 'client').each do |host|
    context "on client #{host}" do
      it 'should set the hieradata' do
        set_hieradata_on(host, client_hieradata)
      end

      it 'should run puppet' do
        apply_manifest_on(host, manifest, catch_failures: true)
      end

      it 'should be idempotent' do
        apply_manifest_on(host, manifest, catch_changes: true)
      end
    end
  end

  hosts_with_role(hosts, 'server').each do |host|
    context "on server #{host}" do
      it 'should start the listener' do
        on(host, '/usr/local/bin/nc_listen &')
        sleep(2)
      end
    end
  end

  hosts_with_role(hosts, 'client').each do |host|
    context "on client #{host}" do
      it 'should send a message to the server' do
        on(host, '/usr/local/bin/nc_send')
      end
    end
  end

  hosts_with_role(hosts, 'server').each do |host|
    context "on server #{host}" do
      it 'should have received the test message' do
        content = file_contents_on(host, test_output_file)
        expect(content.strip).to eq(test_message)
      end
    end
  end
end
