#!/usr/bin/env bash

## Update machine
DEBIAN_FRONTEND=noninteractive apt -qqy update
DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install unzip curl git jq 

cat >/etc/netplan/99-custom-dns.yaml <<EOL
network:
    version: 2
    ethernets:
        ens3:
            nameservers:
                addresses: [ "161.26.0.7", "161.26.0.8" ]
            dhcp4-overrides:
                use-dns: false
EOL

netplan apply
echo "supersede domain-name-servers 161.26.0.7, 161.26.0.8;" | tee -a /etc/dhcp/dhclient.conf
dhclient -v -r; dhclient -v
systemd-resolve --flush-caches

## Download and install Consul
curl --silent --remote-name https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul_${consul_version}_linux_amd64.zip
chown root:root consul
mv consul /usr/local/bin/
consul -autocomplete-install

## Create directories and add consul system user
mkdir --parents /opt/consul
mkdir --parents /etc/consul.d
useradd --system --home /etc/consul.d --shell /bin/false consul

## Create systemd service file 
cat >/etc/systemd/system/consul.service <<EOL
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
ExecStop=/usr/local/bin/consul leave
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOL

## Create client and server configuration files
cat >/etc/consul.d/consul.hcl <<EOL
datacenter = "${zone}"
data_dir = "/opt/consul"
encrypt = "${encrypt_key}"
bind_addr = `hostname -I`
retry_join = ["consul-server1.us-east.cde", "consul-server2.us-east.cde", "consul-server3.us-east.cde"]
acl = {
    enabled = true,
    default_policy = "allow",
    enable_token_persistence = true
    tokens = {
      "master" =  "${acl_token}"
    }
  }
EOL

cat >/etc/consul.d/server.hcl <<EOL
server = true
bootstrap_expect = 3
ui = true
EOL


## Set default file and directory permissions and ownership
chown --recursive consul:consul /opt/consul
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/consul.hcl
chmod 640 /etc/consul.d/server.hcl

systemctl enable consul.service
systemctl start consul.service

## Install LogDNA for easier troubleshooting
echo "deb https://repo.logdna.com stable main" | tee /etc/apt/sources.list.d/logdna.list

wget -O- https://repo.logdna.com/logdna.gpg | apt-key add -
DEBIAN_FRONTEND=noninteractive apt -qqy update
DEBIAN_FRONTEND=noninteractive apt -qqy install logdna-agent < "/dev/null"
logdna-agent -k 613b640c3c290be2cf232c489c966a1d
logdna-agent -s LOGDNA_APIHOST=api.us-south.logging.cloud.ibm.com
logdna-agent -s LOGDNA_LOGHOST=logs.us-south.logging.cloud.ibm.com
logdna-agent -t ${vpc_name},${zone}
update-rc.d logdna-agent defaults
/etc/init.d/logdna-agent start