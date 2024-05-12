# Group name
datacenter = "{{ nomad_datacenter }}"

# Save the persistent data to 
data_dir = "/opt/nomad"

# Allow clients to connect from any interface
bind_addr = "0.0.0.0"

advertise {
  # We explicitely advertise the IP on the vxlan interface
  http = "{{ hostvars[inventory_hostname]['vxlan_interface_address'] }}"
  rpc = "{{ hostvars[inventory_hostname]['vxlan_interface_address'] }}"
  serf = "{{ hostvars[inventory_hostname]['vxlan_interface_address'] }}"
}

# This node is a server
server {
  enabled = true
  bootstrap_expect = {{ nomad_server_number }}
}

# This node can run jobs
client {
  enabled = true
  network_interface = "{{ interface_vxlan }}"
}

# Connect to the local Consul agent
consul {
  address = "127.0.0.1:8500"
}

# Show the UI and link to the Consul UI
ui {
  enabled = true

  consul {
    ui_url = "https://perle.consul.100do.se/ui"
  }
}
