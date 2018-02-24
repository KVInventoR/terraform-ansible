cpu = "2"
ram = "1024"

Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.box_version = ">= 0"
    config.vm.box_check_update = true
    config.vm.box_download_checksum = true
    config.vm.box_download_checksum_type = "sha1"
    config.vm.box_download_insecure = true
    config.vm.communicator = "ssh"
    config.ssh.username = "vagrant"
    config.ssh.insert_key = false
    config.vm.graceful_halt_timeout = "120"

    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
        v.memory = ram
        v.cpus = cpu
    end

    config.vm.provider "parallels" do |v|
        v.memory = ram
        v.cpus = cpu
    end

    config.vm.provision "shell", path: "vagrant/install-updates.sh"
    config.vm.provision "shell", path: "vagrant/install-zsh.sh"
    config.vm.provision "shell", path: "vagrant/install-common-software.sh"
    config.vm.provision "shell", path: "vagrant/install-aws-cli.sh"
    config.vm.provision "shell", path: "vagrant/install-terraform.sh"
    config.vm.provision "shell", path: "vagrant/install-terraform-ansible-provider.sh"

end
