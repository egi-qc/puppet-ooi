class ooi::repos {
    if $::osfamily == "redhat" {
        if $::operatingsystemmajrelease == 7 {
            include ooi::repos::redhat
        }
        else {
            fail("This Puppet module unly supports RedHat/CentOS 7.")
        }
    }
    elsif $::osfamily == "debian" {
        if $::operatingsystemmajrelease in ["14.04", "16.04", "8"] {
            include ooi::repos::apt
        }
        else {
            fail("This Puppet module unly supports Ubuntu 14.04, Ubuntu 16.04 or Debian 8.")
        }
    }
    else {
        fail("This Puppet module only supports RedHat/CentOS and Debian/Ubuntu.")
    }
}

class ooi::repos::apt {

    $distro = downcase($::operatingsystem)

    apt::source {
        "ooi":
            location => "http://repository.egi.eu/community/software/ooi/occi-1.1/releases/${distro}",
            release  => $::lsbdistcodename,
            repos    => "main",
            key      => {
                id     => "47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30",
                source => "http://repository.egi.eu/community/keys/APPDBCOMM-DEB-PGP-KEY.asc"
            },
            notify   => Exec['apt_update'],
    }

    Exec['apt_update'] -> Package<||>
}

class ooi::repos::redhat {
    yumrepo {
        "ooi-sl-7-x86_64":
            descr    => "Repository for ooi (o/s: sl7 arch: x86_64)",
            baseurl  => "http://repository.egi.eu/community/software/ooi/occi-1.1/releases/sl/7/x86_64/RPMS/",
            enabled  => 1,
            gpgcheck => 0,
    }
}
