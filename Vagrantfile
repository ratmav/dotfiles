Vagrant.configure("2") do |config|
  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/contrib-buster64"

    debian.vm.provider "virtualbox" do |v|
      v.name = "dotfiles-debian"
      v.cpus = 2
      v.memory = 4096
    end

    debian.vm.synced_folder "./", "/home/vagrant/dotfiles"
  end

  # user: vagrant; pass: vagrant
  config.vm.define "elementary" do |elementary|
    elementary.vm.box = "evanplaice/elementaryos-5.1-hera"

    elementary.vm.provider "virtualbox" do |v|
      v.name = "dotfiles-elementary"
      v.cpus = 2
      v.memory = 4096
    end

    elementary.vm.synced_folder "./", "/home/vagrant/dotfiles"
  end

  # TODO: macos?
end
