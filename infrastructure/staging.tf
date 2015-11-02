/*Configure the AWS Provider*/
provider "aws" {
  region = "us-east-1"
}

/*Add a keypair*/
resource "aws_key_pair" "staging" {
  key_name = "staging"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ0kf8OoQlmWLr1k0xnphz9+UszypsHQUG1G7tJ1bklsOJhdz3EsKs9HvSLyIfrbM0PoP5n0houe8f/LHZYmCifQLygb+22MfVUycvVjW92sY+ihHHiyvxAs4o+kd5SqtiSY5GJyX1RBsUFSMKugq/OiKy7Z/zlgVGGyFT543wIS2e/lCfscUMoVwsc4FMNXseYG+xVdo5mbEHB4hWg1iZquwPkI2vQhtMqSE+oYca43kRb8HwTgXf6iytH38SEAv1zHalaMgLgDxjjxX4MnGLPhoGQwrx3O16e3zeaCg6ArfzwTJNqk3+3M8voksfcD33SYO+0DoAxlME0jFF0SzX funkymonkeymonk@MegaManEXE.local"
}

/*Create a blog server*/
/*TODO: create multiple servers*/
resource "aws_instance" "blog" {
  ami = "ami-05783d60"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.staging.key_name}"
  tags {
    Name = "DevOps Blog Staging"
  }
  provisioner "remote-exec" {
    connection {
      user = "core"
    }
    inline = [
      "docker pull buildingbananas/devops_blog",
      "docker run -d -p 80:80 -h devops_blog buildingbananas/devops_blog"
    ]
  }
}

/*Create a new load balancer*/
resource "aws_elb" "devops-blog-elb" {
  name = "devops-blog-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  instances = ["${aws_instance.blog.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "devops-blog-elb"
  }
}

output "elb_ip" {
  value = "${aws_elb.devops-blog-elb.dns_name}"
}

output "app_ip" {
  value = "${aws_instance.blog.public_ip}"
}
