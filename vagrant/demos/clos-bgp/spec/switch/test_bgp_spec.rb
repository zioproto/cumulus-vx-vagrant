require 'spec_helper'
require 'yaml'

properties = YAML.load_file('properties.yml')

describe "BGP and Zebra MUST be enabled" do
  describe file('/etc/quagga/daemons') do
    its(:content) { should contain 'bgpd=yes' }
    its(:content) { should contain 'zebra=yes' }
  end
end

describe service('quagga') do
  it { should be_enabled }
  it { should be_running }
end

describe 'All BGP Sessions are Established' do
  hostname = ENV['TARGET_HOST']

  if hostname.start_with?('s')
    # Handle spines
    1.upto(properties[:numLeaves]) do |link|
      iface = 'swp' + link.to_s

      describe interface(iface) do
        it { should be_up }
      end

      describe command('sudo cl-bgp neighbor show ' + iface) do
        its(:stdout) { should contain "BGP state = Established" }
      end
    end
  elsif hostname.start_with?('l')
    # Handle leaves
    1.upto(properties[:numSpines]) do |link|
      iface = 'swp' + link.to_s

      describe interface(iface) do
        it { should be_up }
      end
      describe command('sudo cl-bgp neighbor show ' + iface) do
        its(:stdout) { should contain "BGP state = Established" }
      end
    end
  end
end


