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
                image = "docker.io/jbunistra/cloud-frontend:v1"
              	ports = ["frontend"]
            }

        }
    }
     

  group "app" {
    count = 1
		network {
            port "worker"{
                static = 8080
                to = 8080
            }
    }
    
    service {
            name = "worker"
            port = "worker"
    }
    
    task "worker" {
      driver = "docker"
      config {
        image = "docker.io/jbunistra/cloud-worker:v1"
        ports = ["worker"]
      }

      resources {
        cpu    = 900
        memory = 800
      }
    }
  }
}