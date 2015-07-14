
#-------------------------------------------------------------------------------
#
# Copyright 2015 Cumulus Networks, inc  all rights reserved
#
#-------------------------------------------------------------------------------

require 'spec_helper'

puts "-" * 80
puts
puts "    Running serverspec on " + property[:host]
puts
puts "-" * 80

brPorts=[]

if property[:role] != "dcSw"
    describe bond('uplink') do
        it { should exist }
        it { should have_interface 'swp1' }
        it { should have_interface 'swp2' }
    end

    describe interface('uplink') do
        it { should be_up }
    end
    brPorts += ["uplink"]
end

describe bond('peerlink') do
    it { should exist }
    it { should have_interface 'swp3' }
    it { should have_interface 'swp4' }
end

describe interface('peerlink') do
    it { should be_up }
end
brPorts += ["peerlink"]

describe interface('peerlink.4094') do
    it { should exist }
    it { should be_up }
    it { should have_ipv4_address("169.254.0.%s/30" % property[:swNum]) }
end

describe host('169.254.0.%d' % (3 - property[:swNum].to_i)) do
    it { should be_reachable }
end

if property[:role] == "torSw"
    1.upto(property[:hostsPerRack]) do |host|
        describe bond('host' + host.to_s) do
            it { should exist }
            it { should have_interface 'swp' + (host+4).to_s }
        end

        describe interface('host' + host.to_s) do
            it { should be_up }
        end
        brPorts += ["host" + host.to_s]
    end
end

describe bridge('br0') do
    it { should exist }
    brPorts.each do |brPort|
        it { should have_interface brPort }
    end
end

describe interface('br0') do
    it { should be_up }
end

describe service('clagd') do
  it { should be_enabled }
  it { should be_running }
end

describe command('clagctl') do
  its(:stdout) { should contain("The peer is alive") }
  its(:stdout) { should contain("System MAC: 44:38:39:ff:ff:%02x" % property[:pairId]) }
end


