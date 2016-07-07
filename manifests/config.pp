class ooi::config {
    file {
        "/etc/nova/nova-ooi.conf":
            ensure  => file,
            content => template('ooi/nova.conf.erb'),
            require => Package["python-ooi"],
    }

    if ! defined(File["/etc/nova/api-paste.ini"]) {
        $api_paste = "/etc/nova/api-paste.ini"
    }
    else {
        $api_paste = "/etc/nova/api-paste-ooi.ini"
        warning("There is some other Puppet module managing your api-paste.ini file.
                 NOTE: I will install ooi's file under ${api_paste}, thereforey
                 you need to ensure that your nova configuration is using ooi's
                 api-paste.ini file, as otherwise ooi won't be able to run.")
    }

    file {
        $api_paste:
            ensure => file,
            source => "puppet:///modules/ooi/api-paste-${ooi::openstack_version}.ini",
    }
}
