class role::stacki {
    include ::libvirt
    create_resources(hiera('libvirt_networks', []), {})
}
