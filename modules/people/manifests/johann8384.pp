#Borrowed https://github.com/mroth/my-boxen/blob/master/modules/people/manifests/mroth.pp
class people::johann8384 {
  include chrome

  include redis
  include zeromq
  include go
  go::version { '1.1.2': }
  #TODO: set `goenv global 1.1.2`?

  include mysql  
  include phpstorm
  include php
  include iterm2::stable

  include webstorm
  include hipchat
  include macvim
  include python
  include pycharm

  #text editors i hate the least
  include macvim
  include sublime_text_2

  #virtual machines
  include virtualbox
  include vagrant

  #non-dev stuff for general productivity
  include github_for_mac
  include caffeine
  include sizeup
  include vlc
  include flux
  include transmission
  include evernote
  include cloudapp

  #non-dev stuff for general unproductivity
  include steam
  include spotify

  include league_of_legends
  include skype

  #lolcommits is gunna want the below
  include xquartz
  # include imagemagick #fuck boxen's custom bottle, use homebrew

  #
  # define convenience variables for later
  #
  $home = "/Users/${::boxen_user}"

  #
  # configure git
  #
  git::config::global {
    'user.name':
      value => 'Jonathan Creasy';
    'user.email':
      value => 'jonathan@ghostlab.net';
    'github.user':
      value => 'johann8384';
    'color.ui':
      value => 'true';
    'core.quotepath':
      value => 'false';
    'diff.tool':
      value => 'opendiff';
    'merge.tool':
      value => 'opendiff';
    'push.default':
      value => 'simple';
    'alias.amend':
      value => 'commit --amend -C HEAD';
  }


  #
  # install ST2 configuration and package control stuff
  # TODO: make this override existing non git directories
  # TODO: install ST2 license file?
  #
  repository { 'my-sublime-config':
    source => 'https://github.com/mroth/my-sublime-config.git',
    path   => "${home}/Library/Application Support/Sublime Text 2/Packages/User"
  }
  repository { 'package-control':
    source => 'wbond/sublime_package_control',
    path   => "${home}/Library/Application Support/Sublime Text 2/Packages/Package Control"
  }

## TODO: Check this out
  #
  # install and use homeshick for managing dotfiles
  #
#  repository { 'homeshick':
#    source => 'andsens/homeshick',
#    path   => "${home}/.homesick/repos/homeshick"
#  }
#  -> file { "${home}/.homeshick":
#    ensure => 'link',
#    target => "${home}/.homesick/repos/homeshick/home/.homeshick"
#  }
#  -> repository { 'mroth-dotfiles':
#    source => 'https://github.com/mroth/dotfiles.git',
#    path   => "${home}/.homesick/repos/dotfiles"
#  }
#  ~> exec { "${home}/.homeshick link dotfiles --force":
#    refreshonly => true
#  }

  #
  # install scm_breeze to make CLI git less annoying
  #
#  repository { 'scmbreeze':
#    source => 'ndbroadbent/scm_breeze',
#    path   => "${home}/.scm_breeze"
#  }

  # some sensible OSX defaults
  boxen::osx_defaults {
    "Disable 'natural scrolling'":
      ensure => present,
      key    => 'com.apple.swipescrolldirection',
      domain => 'NSGlobalDomain',
      user   => $::boxen_user,
      value  => 'false',
      type   => 'bool';
    "Set aqua color variant to graphite":
      ensure => present,
      key    => 'AppleAquaColorVariant',
      domain => 'NSGlobalDomain',
      user   => $::boxen_user,
      type   => 'int',
      value  => 6;
    "disables Dashboard":
      user   => $::boxen_user,
      domain => 'com.apple.dashboard',
      key    => 'mcx-disabled',
      value  => true;
  }
  ~> exec { 'killall Finder':
    refreshonly => true
  }
  # some more settings from puppet-osx
  include osx::global::enable_keyboard_control_access
  include osx::no_network_dsstores
  include osx::dock::dim_hidden_apps
  class { 'osx::dock::icon_size':
    size => 42
  }
  # automatically run software-update
  include osx::software_update
  # in case of emergency
  osx::recovery_message { 'If found, please call +1 3145808909': }

  #TODO: install solarized in various places
  # apple color picker

  # more homebrew packages I personally want
  package {
    [
      'imagesnap', #webcams are meant to be CLI tools
      'pianobar',  #music is meant to be listened to from CLI
      'imagemagick'
    ]:
    ensure => present,
  }
}
