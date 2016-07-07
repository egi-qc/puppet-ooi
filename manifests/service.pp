class ooi::service {
    include ooi::config
    if ! defined(Service["nova-api"]) {
        service {
            "nova-api":
                ensure    => running,
                subscribe => File["/etc/nova/nova-ooi.conf", "/etc/nova/api-paste.ini"]
        }
    }
}
