Vagrant.configure("2") do |config|
  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/contrib-buster64"

    config.vm.provider "virtualbox" do |v|
      v.name = "dotfiles-debian"
      v.cpus = 2
      v.memory = 4096
    end

    config.vm.synced_folder "./", "/home/vagrant/dotfiles"
  end

  # TODO: config block for macos...and windows?
end
