class ooi ($openstack_version = hiera("ooi::openstack_version", undef),
           $ooi_listen = "0.0.0.0",
           $ooi_listen_port = 8787,
           $ooi_workers = undef,
           $manage_repos = true,
           $manage_service = true) {

    if ! ($openstack_version in ["liberty", "mitaka"]) {
        fail("Unsupported OpenStack version, choose between 'liberty' or 'mitaka'.")
    }

    if $manage_repos {
        class { "ooi::repos": }
        $requires = Class["ooi::repos"]
    }

    class { "ooi::install": require => $requires }

    class { "ooi::config": require => Class["ooi::install"]}

    if $manage_service {
        class { "ooi::service": require => Class["ooi::config"]}
    }
}
