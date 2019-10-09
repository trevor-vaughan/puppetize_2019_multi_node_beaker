require 'simp/beaker_helpers'
include Simp::BeakerHelpers

# Install puppet on our hosts
hosts.each { |host| install_puppet } unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # simp-beaker-helpers magic to fix some common Linux issues
  fix_errata_on(hosts)

  # Ensure that our test output is human readable (nobody likes dots)
  c.formatter = :documentation

  c.before :suite do
    begin
      # Install modules and dependencies from spec/fixtures/modules
      copy_fixture_modules_to( hosts )
    rescue StandardError, ScriptError => e
      if ENV['PRY']
        require 'pry'; binding.pry
      else
        raise e
      end
    end
  end
end
