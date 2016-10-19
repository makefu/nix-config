{ config, lib, ... }:

{
  krebs.urlwatch = {
    enable = true;
    mailto = config.krebs.users.makefu.mail;
    onCalendar = "*-*-* 05:00:00";
    urls = [
      ## nixpkgs maintenance
      https://api.github.com/repos/ovh/python-ovh/tags
      https://api.github.com/repos/embray/d2to1/tags
      http://git.sysphere.org/vicious/log/?qt=grep&q=Next+release
      https://pypi.python.org/simple/bepasty/
      https://pypi.python.org/simple/xstatic/
      http://guest:derpi@cvs2svn.tigris.org/svn/cvs2svn/tags/
      http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/
      https://github.com/amadvance/snapraid/releases.atom
      https://erdgeist.org/gitweb/opentracker/commit/
    ];
  };
}

