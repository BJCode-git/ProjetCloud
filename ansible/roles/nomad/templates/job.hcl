job "web" {
	datacenters = ["perle"]
  
	   // Create a new group for the frontend
	  group "frontends"{
		  count = 1
  
		  network {
			  port "frontend"{
				  static = 3000
				  to = 3000
			  }
  
		  }
  
		  service {
			  name = "frontend"
			  port = "frontend"
			  tags = ["http"]
			  check {
				  type     = "http"
				  path     = "/"
				  interval = "10s"
				  timeout  = "2s"
			  }
		  }
  
  
		  task "frontend" {
			  driver = "docker"
			  config {
				  image = "{{ cloud_frontend_img }}"
					ports = ["frontend"]
			  }
  
		  }
	  }
	   
  
	group "app" {
	  count = 1
		  network {
			  port "backend"{
				  static = 8080
				  to = 8080
			  }
	  }
	  
	  service {
			  name = "backend"
			  port = "backend"
	  }
	  
	  task "backend" {
		driver = "docker"
		  image = "{{ cloud_backend_img }}"
		  ports = ["backend"]
		}
  
		//resources {
		//  cpu    = 900
		//  memory = 800
		//}
	  }
	}
	   
	// Create a new group for the haproxy
	  group "haproxys"{
		  count = 3
  
		  network {
			  port "haproxy"{
				  static = 80
				  to = 80
			  }
		  }
  
		  service {
			  name = "haproxy"
  
		  }
  
		  // Use the haproxy image from the Docker Hub
		  task "haproxy" {
			  driver = "docker"
			  config {
				  image = "docker.io/library/haproxy:2.7"
				  ports = ["haproxy"]
				  volumes = ["local/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg",]
			  }
  
			  // Configue haproxy
			  template {
				  data = <<EOF
				  global
					  daemon
					  maxconn 1024
  
				  defaults
					  mode http
					  balance roundrobin
					  timeout client 60s
					  timeout connect 60s
					  timeout server 60s
  
				  frontend http
					  bind *:8080
					  default_backend web
  
				  resolvers consul
					  nameserver consul 127.0.0.1:8500
					  accepted_payload_size 8192
  
				  backend web
					  balance roundrobin
					  mode http
					  server-template frontend 1 _frontend._tcp.service.consul resolvers consul init-addr none
				  EOF
				  destination = "local/haproxy.cfg"
			  }
  
		  }
	  }
	   
	   
  }