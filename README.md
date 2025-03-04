- VirtualBox Vm configuration
Used Windows 11 Operating system, with VirtualBox version 7.1.6. VMs using Ubuntu 24.04. (downloaded its server .iso file from here: https://ubuntu.com/download/server) as it is pretty new and still has securitiy and feature patches, as well as it supports all software and tools in the requirement and tasks list.
- Created VMs:
devops-main-vm -> Runs jenkins and gitlab instances (192.168.56.3)
devops-k8master-vm -> Runs jenkinsfile as master node (192.168.56.4)
devops-k8worker-vm -> Runs jenkinsfile as worker node (192.168.56.5)

All VMs were running under localhost (127.0.0.1), the IP address provided in the list are configured with a Host-only adapter option and is used for internal communication.
Used generated user acsakvari with password "changeme" throughout the installation process with root/sudo priviledges. Root user can also be used with the same password.

- Downloaded and installed Os updates
Generally required due to potential security and feature patches.
- Configured networks
Created both NAT and Host-only adapter networks, for outside and inside connectivity types. This way, each VM can communite with the internet (needed due to package updates and etc...), as well as communicate with each other on their respective IP address (needed due to ssh connectivity for nodes in jenkins).

Configured firewall and ports
Enabled and added ports to VMs firewall. Also opened certain ports for outside and inside network access within VirtualBox.
Ports:
- 2222, 222, 22 -> Used for OPENSSH acccess to each VM (devops-main-vm, devops-k8master-vm, devops-k8worker-vm)
- 8081 -> Gitlab HTTP instance
- 8080 -> Jenkins HTTP instance

Installed packages
Installed used packages, such as OPENSSH-server package for ssh connectivity inbetween each VM and the host machine itself. Installed Java, as it is a prerequisite for jenkins.

Jenkins instance

- Downloaded and installed Jenkins as service onto devops-main-vm. Added jenkins service to systemctl configuration as always enabled upon startup. Jenkins could now be opened at http://localhost:8080. Created admin user account under name admin, with password admin. Downloaded and installed packages that were recommended by jenkins.
- Generated ssh keys for the other two VM (devops-k8master-vm, devops-k8worker-vm) and copied them to each VM. Set up credential inside credentials section in jenkins, for ssh connection.
- Jenkins does not generate known_hosts file by default, which is required by the worker nodes, so each had to be made by hand under /var/lib/jenkins/.ssh/known_hosts. Now after scanning for generated ssh keys with the main VMs IP address and copying them into this created file will ensure the connectivity of the nodes.
- Also added /home/jenkins folders, as this is what I specified for the default workspace folder for each VM. Added sufficient permissions to these directories for further work.
- Added nodes for each VM named respectively and connected them using the aforementioned ssh key step.
- Created jenkinsjob named upam-test-pipeline. Created two environmental variables for the optional OS update as well as the option to decide upon the generated secondary user's username.

Gitlab instance

- Added gpg key for both docker and docker compose, then used this key to download them both.
- Created docker-compose.yml file under ~/gitlab that generates the bare bones gitlab instance at http://localhost:8081
- Added docker group to both users and enabled docker to run upon startup.

Notes and challenges faced:

- Configured VM setup using vagrant and vagrantfile, however due to a known and not fixed ssh issue, could not generate private and public key pair, due to vagrant overwriting it upon each startup. For further explanation visit: https://github.com/hashicorp/vagrant/issues/13565
- VirtualBox Host-only adapter network was created, however DHCP was not enabled on neither VM. Manual addition of the enp0s8 network had to be done, where DHCP4 had to be enabled.
This included navigating to ~/etc/netplan/50-cloud-init.yaml and adding enp0s8 under ethernets as seen with local network enp0s3
- Tried including Jenkins installation inside docker-compose.yml file as service, however since no jenkins.service file was created, the user wasn't created. This meant that jenkins could not figure out who to connect the user interface and ssh keys, which resulted in the the VMs not connecting to the jenkins server VM (generated ssh keys could not link vm to user).
- Gitlab instance was created but could not be reached outside VMs network. Gitlab free version does not support SSH key connection to the repository, hence files uploaded to it cannot be checked out by jenkins. Decided using GitHub instead, since SSH key generation is free and easy.


## Virtual Machine Setup

### VirtualBox Configuration

- **Operating System**: Windows 11
- **VirtualBox Version**: 7.1.6
- **VM OS**: Ubuntu 24.04 (Server .iso downloaded from ubuntu.com/download/server)
- **Reason**: New version with security and feature patches, supports all required software and tools


### Created VMs

1. **devops-main-vm** (192.168.56.3)
    - Runs Jenkins and GitLab instances
2. **devops-k8master-vm** (192.168.56.4)
    - Runs Jenkinsfile as master node
3. **devops-k8worker-vm** (192.168.56.5)
    - Runs Jenkinsfile as worker node

**Note**: All VMs run under localhost (127.0.0.1). IP addresses are configured with Host-only adapter for internal communication.

### User Configuration

- Generated user: acsakvari
- Password: "changeme"
- Root/sudo privileges granted
- Root user accessible with the same password


## System Configuration

### OS Updates

- Downloaded and installed OS updates for security and feature patches


### Network Configuration

- Created NAT and Host-only adapter networks
    - NAT: For outside connectivity (internet access)
    - Host-only: For internal VM communication (SSH connectivity for Jenkins nodes)


### Firewall and Port Configuration

- Enabled and added ports to VM firewall
- Opened specific ports in VirtualBox for outside and inside network access

**Ports**:

- 2222, 222, 22: OPENSSH access to each VM
- 8081: GitLab HTTP instance
- 8080: Jenkins HTTP instance


### Package Installation

- Installed OPENSSH-server for SSH connectivity between VMs and host machine
- Installed Java (prerequisite for Jenkins)


## Jenkins Setup

### Installation and Configuration

1. Downloaded and installed Jenkins as a service on devops-main-vm
2. Added Jenkins service to systemctl configuration (enabled on startup)
3. Jenkins accessible at http://localhost:8080
4. Created admin user account:
    - Username: admin
    - Password: admin
5. Installed recommended Jenkins packages

### SSH Key Configuration

1. Generated SSH keys for devops-k8master-vm and devops-k8worker-vm
2. Copied keys to respective VMs
3. Set up credentials in Jenkins for SSH connection
4. Manually created known_hosts file under /var/lib/jenkins/.ssh/known_hosts
5. Scanned and copied generated SSH keys with main VM's IP address to known_hosts file

### Workspace Configuration

- Added /home/jenkins folders (specified as default workspace)
- Granted sufficient permissions to these directories


### Node Configuration

- Added nodes for each VM and connected them using SSH keys
- Created Jenkins job named "upam-test-pipeline"
- Added two environmental variables for optional OS update and secondary user's username


## GitLab Setup

### Docker Installation

1. Added GPG key for Docker and Docker Compose
2. Downloaded Docker and Docker Compose using the GPG key

### GitLab Instance Creation

- Created docker-compose.yml file under ~/gitlab
- Generates basic GitLab instance at http://localhost:8081


### Docker Configuration

- Added docker group to both users
- Enabled Docker to run on startup


## Notes and Challenges

1. **Vagrant SSH Issue**: Unable to generate private and public key pair due to Vagrant overwriting it on each startup
2. **VirtualBox Network Configuration**: Manually added enp0s8 network with DHCP4 enabled in ~/etc/netplan/50-cloud-init.yaml
3. **Jenkins Docker Installation**: Attempted including Jenkins in docker-compose.yml, but faced user creation and SSH key connection issues
4. **GitLab Limitations**: Free version doesn't support SSH key connection to repository, opted for GitHub instead for easier SSH key generation and file checkout

<div style="text-align: center">⁂</div>

[^1]: https://ubuntu.com/download/serve

