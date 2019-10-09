require 'spec_helper_acceptance'

test_name "Multi-Node Test"

describe 'gathering puppet facts' do
  hosts.each do |host|
    context "on #{host}" do
      it do
        result = on(host, 'facter -p').output.strip.lines

        expect(result.grep(/Error/).grep(/Facter/)).to be_empty
      end
    end
  end
end
