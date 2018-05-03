provider "digitalocean" {
  token = "${var.do_token}"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "kube-master" {
  image       = "33914855"
  name        = "kube-master"
  region      = "${var.do_region}"
  size        = "4gb"
  ssh_keys    = ["20097580"]
  resize_disk = true

  provisioner "local-exec" {
    command = "./generate-ssh-key.py"
  }

  /*
                                                              Copy the ssh file created on the local machine upto the master node
                                                              The master node will contain both the id_rsa and id_rsa.pub files.

                                                              The worker node will add the id_rsa.pub file to the node
                                                            */
  provisioner "file" {
    source      = "/tmp/ssh/id_rsa.pub"
    destination = "/tmp/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  # provisioner "file" {
  #   source      = "/tmp/ssh/id_rsa"
  #   destination = "/root/.ssh/id_rsa"


  #   connection {
  #     type        = "ssh"
  #     user        = "root"
  #     agent       = true
  #     private_key = "${file("${var.private_key_path}")}"
  #   }
  # }

  provisioner "file" {
    source      = "user-data.sh"
    destination = "/root/user-data.sh"

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "cd /root",
      "chmod +x /root/user-data.sh",
      "./user-data.sh",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }
}

resource "digitalocean_droplet" "kube-worker" {
  count       = 2
  image       = "33914855"
  name        = "${format("kube-worker-%d", count.index)}"
  region      = "${var.do_region}"
  size        = "4gb"
  ssh_keys    = ["20097580"]
  resize_disk = true

  provisioner "file" {
    source      = "/tmp/ssh/id_rsa.pub"
    destination = "/root/.ssh/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "/tmp/ssh/id_rsa"
    destination = "/root/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "kube-worker-init.sh"
    destination = "/root/kube-worker-init.sh"

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /root",
      "chmod +x /root/kube-worker-init.sh",
      "export MASTER_IP=${digitalocean_droplet.kube-master.ipv4_address} && ./kube-worker-init.sh",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = true
      private_key = "${file("${var.private_key_path}")}"
    }
  }
}

# data "template_file" "kube-worker-init" {
#   template = "${file("kube-worker-init.tpl")}"

#   vars {
#     kube_master_ip = "${digitalocean_droplet.kube-master.ipv4_address}"
#   }
# }

output "kube_master_ip" {
  value = "${digitalocean_droplet.kube-master.ipv4_address}"
}

output "kube_worker_ips" {
  value = "${digitalocean_droplet.kube-worker.*.ipv4_address}"
}
