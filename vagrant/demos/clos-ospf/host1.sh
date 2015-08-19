sudo ip addr add 10.1.1.10/32 dev lo
sudo ip addr add 10.1.1.10/32 dev eth1
sudo ip link set up dev eth1
sudo cp /vagrant/quaggaconfig/* /etc/quagga/
sudo /etc/init.d/quagga restart
