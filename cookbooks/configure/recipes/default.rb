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
  "chromium",
  "cryptsetup",
  "curl",
  "filezilla",
  "firefox",
  "flashplugin",
  "fontconfig",
  "fontsproto",
  "freetype2",
  "fuse",
  "git",
  "gnome-terminal",
  "gnu-netcat",
  "gnupg",
  "gnutls",
  "gzip",
  "jre7-openjdk",
  "jre7-openjdk-headless",
  "mcabber",
  "net-tools",
  "openbox",
  "openssh",
  "pcmanfm",
  "pyxdg",
  "rsync",
  "sudo",
  "tmux",
  "ttf-dejavu",
  "ttf-droid",
  "ttf-freefont",
  "ttf-inconsolata",
  "vim",
  "wget",
  "whois",
  "xfe",
  "xorg-server",
  "xorg-xinit",
  "xorg-xrandr",
  "xterm",
  "zip"
].each do |p|
  package p
  retries 5
  action :upgrade
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

bash "reboot" do
  code "( sleep 5; reboot -f ) &"
  only_if { ::File.exists?("/var/run/reboot-required") }
end
