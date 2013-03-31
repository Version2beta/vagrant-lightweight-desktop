# Cookbook Name:: config
# Recipe:: default
#
# Copyright 2013 M Robert Martin / @version2beta
#
#

# execute 'DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

execute "set locale" do
  command <<-EOC
    export LANGUAGE="en_US.UTF-8"
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    locale-gen en_US.UTF-8
    dpkg-reconfigure locales
    update-locale LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
  EOC
  not_if { `locale | grep UTF-8` } 
end

gem_package "ruby-shadow" do
    action :install
end

include_recipe "openssl"
user "vagrant" do
  password `openssl passwd -1 "password"`.strip
  action :modify
end

[
  "build-essential",
  "python"
].each do |r|
  include_recipe r
end

[
  "apg",
  "aspell",
  "binutils",
  "bzip2",
  "chromium-browser",
  "cryptsetup",
  "curl",
  "dkms",
  "filezilla",
  "firefox",
  "fontconfig",
  "fuse",
  "git",
  "gnome-terminal",
  "gnupg",
  "gzip",
  "mcabber",
  "openbox",
  "openjdk-7-jdk",
  "openjdk-7-jre-headless",
  "pcmanfm",
  "python-xdg",
  "rsync",
  "sudo",
  "tmux",
  "traceroute",
  "ttf-dejavu",
  "ttf-droid",
  "ttf-inconsolata",
  "ubuntu-restricted-extras",
  "gvim",
  "virtualbox-guest-additions",
  "wget",
  "whois",
  "xorg",
  "xterm",
  "zip"
].each do |p|
  package p do
    retries 5
    action :upgrade
  end
end

[
  "BeautifulSoup",
  "dingus",
  "expecter",
  "Fabric",
  "ipython",
  "nose",
  "requests",
  "sh"
].each do |p|
  python_pip p do
    action :upgrade
  end
end

cookbook_file "/home/vagrant/dotfiles.tgz" do
  user "vagrant"
  group "vagrant"
  source "dotfiles.tgz"
end
execute "untar dotfiles into ~vagrant" do
  cwd "/home/vagrant"
  user "vagrant"
  group "vagrant"
  command "tar xzf dotfiles.tgz"
end

bash "reboot" do
  code "( sleep 5; reboot -f ) &"
  only_if { ::File.exists?("/var/run/reboot-required") }
end
