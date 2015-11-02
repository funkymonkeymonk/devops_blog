Goal
We are deploying a company blog! So far we have a simple Flask placeholder site. The source code is in a public github repository: https://github.com/vitalco/devops_blog

We want to have a single command to deploy this to AWS.

Deployment specs
Ubuntu (version of your choice)
Server: uwsgi (or any python app server of your choice)/nginx
Python: 2.7

Deliverables
A GitHub repo containing your scripts (but NOT any .PEMs or AWS keys)
A script that will
Launch an EC2 server using aws cli utilities or the aws api and a scripting language of our choice
Run configuration management scripts (Ansible/Chef/Puppet/salt/your choice!) that bootstrap the server and deploy the latest code to it

Remember to use security groups to restrict port access.

I should be able to perform the following commands and then interact with a functioning app in my browser. (you can assume we have the AWS Unified CLI).

ec2.sh <app> <environment> <num_servers> <server_size>

This should return the IP address of the launched server, after which, I can open a browser to http://12.23.34.56 and see the Flask blog app come up!

example


> ec2.sh devops_blog dev 1 t1.micro
Launching EC2 instance….
Deploying blog…
Your blog is deployed at http://12.23.34.56
> curl http://12.23.34.56
<html>...
