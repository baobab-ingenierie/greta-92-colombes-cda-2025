Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.hostname = "bookworm"
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.11.11"
  config.vm.synced_folder "./scripts", "/home/share"
  config.vm.provision "shell", inline: <<-SHELL
	apt-get update
	apt-get upgrade -y
	apt-get install apache2 -y
	apt-get install php -y
	# apt-get install phpmyadmin -y
	apt-get install git -y
  SHELL
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
    vb.cpus = 1
	vb.name = "Debian-MariaDB"
  end
end