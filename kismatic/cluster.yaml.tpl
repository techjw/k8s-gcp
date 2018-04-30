cluster:
  name: gcpk8s
  version: v1.9.6
  disable_package_installation: false
  disconnected_installation: false

  networking:
    pod_cidr_block: 172.16.0.0/16
    service_cidr_block: 172.20.0.0/16
    update_hosts_files: true
    http_proxy: ""
    https_proxy: ""
    no_proxy: ""

  certificates:
    expiry: 17520h
    ca_expiry: 17520h

  ssh:
    user: %gce_user%
    ssh_key: %ssh_key%
    ssh_port: 22

  kube_apiserver:
    option_overrides: {}
  kube_controller_manager:
    option_overrides: {}
  kube_scheduler:
    option_overrides: {}
  kube_proxy:
    option_overrides: {}
  kubelet:
    option_overrides:
      max-pods: 50
      kube-reserved: "cpu=500m,memory=500Mi"
      system-reserved: "cpu=500m,memory=500Mi"


  cloud_provider:

    # Options: aws|azure|cloudstack|fake|gce|mesos|openstack|ovirt|photon|rackspace|vsphere
    # Leave config empty if provider does not require a path to a config file.
    provider: ""
    config: ""
    # provider: "gce"
    # config: "gce-cloud-provider.conf"

docker:
  disable: false
  logs:
    driver: json-file
    opts:
      max-file: "1"
      max-size: 50m
  storage:
    driver: ""
    opts: {}
    direct_lvm_block_device:
      path: ""
      thinpool_percent: "95"
      thinpool_metapercent: "1"
      thinpool_autoextend_threshold: "80"
      thinpool_autoextend_percent: "20"

docker_registry:
  server: ""
  CA: ""
  username: ""
  password: ""

additional_files: []

add_ons:
  cni:
    disable: false
    # Options: calico|weave|contiv|custom
    provider: calico
    options:
      calico:
        mode: overlay
        log_level: info
        workload_mtu: 1500
        felix_input_mtu: 1440
        ip_autodetection_method: first-found

  dns:
    disable: false
    provider: kubedns
    options:
      replicas: 2

  heapster:
    disable: true
    options:
      heapster:
        replicas: 2
        service_type: ClusterIP
        sink: influxdb:http://heapster-influxdb.kube-system.svc:8086
      influxdb:
        pvc_name: ""

  metrics_server:
    disable: true

  dashboard:
    disable: false

  package_manager:
    disable: false
    provider: helm
    options:
      helm:
        namespace: kube-system

  rescheduler:
    disable: true

etcd:
  expected_count: 1
  nodes:
  - host: "%deploy_name%-master-1"
    ip: "%master1_pubip%"
    internalip: "%master1_ip%"

master:
  expected_count: 1
  load_balanced_fqdn: "%masterlb_ip%"
  load_balanced_short_name: "%masterlb_ip%"
  nodes:
  - host: "%deploy_name%-master-1"
    ip: "%master1_pubip%"
    internalip: "%master1_ip%"
    labels:
      component: "master"

worker:
  expected_count: 2
  nodes:
  - host: "%deploy_name%-worker-1"
    ip: "%worker1_pubip%"
    internalip: "%worker1_ip%"
    labels:
      component: "worker"
  - host: "%deploy_name%-worker-2"
    ip: "%worker2_pubip%"
    internalip: "%worker2_ip%"
    labels:
      component: "worker"

ingress:
  expected_count: 1
  nodes:
  - host: "%deploy_name%-ingress-1"
    ip: "%ingress1_pubip%"
    internalip: "%ingress1_ip%"
    labels:
      component: "ingress"

storage:
  expected_count: 0
  nodes: []

nfs:
  nfs_volume: []
