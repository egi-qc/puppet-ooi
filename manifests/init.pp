class ooi ($openstack_version,
           $ooi_listen = "0.0.0.0",
           $ooi_listen_port = 8787,
           $ooi_workers = undef,
           $manage_service = true) {

    if ! ($openstack_version in ["liberty", "mitaka"]) {
        fail("Unsupported OpenStack version, choose between 'liberty' or 'mitaka'.")
    }

    class { "ooi::repos": }

    class { "ooi::install": require => Class["ooi::repos"]}

    class { "ooi::config": require => Class["ooi::install"]}

    if $manage_service {
        class { "ooi::service": require => Class["ooi::config"]}
    }
}
