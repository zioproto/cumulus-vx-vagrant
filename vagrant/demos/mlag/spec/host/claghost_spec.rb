
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

describe bond('bond0') do
    it { should exist }
    it { should have_interface 'eth1' }
    it { should have_interface 'eth2' }
end

describe interface('bond0') do
    it { should be_up }
    it { should have_ipv4_address("10.99.%d.%d" % [property[:pairId].to_i / 256, property[:pairId].to_i % 256]) }
end

describe file('/proc/net/bonding/bond0') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /Number of ports: 2/ }
end

# Ping all other hosts
1.upto(property[:podsPerDC]) do |podNum|
    1.upto(property[:racksPerPod]) do |rackNum|
        1.upto(property[:hostsPerRack]) do |hostNum|
        host = (podNum-1)*(property[:racksPerPod]*(property[:hostsPerRack]+2)+2) + 
               (rackNum-1)*(property[:hostsPerRack]+2) + hostNum
            describe host('10.99.%d.%d' % [host / 256, host % 256]) do
                it { should be_reachable }
            end
        end
    end
end
