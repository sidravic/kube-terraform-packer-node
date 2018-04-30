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

# data "template_file" "user_data" {
#   template = "${file("user-data.tpl")}"
# }
output "kube_master_ip" {
  value = "${digitalocean_droplet.kube-master.ipv4_address}"
}
