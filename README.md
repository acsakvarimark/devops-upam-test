# UPAM DevOps Test Documentation

The following contains the documentation and the steps taken in order to complete the UPAM DevOps test case.

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

1. Added jenkins as user to both nodes as well as gave them root and no password required priviledges
2. Generated SSH keys for devops-k8master-vm and devops-k8worker-vm
3. Copied keys to respective VMs
4. Set up credentials in Jenkins for SSH connection
5. Manually created known_hosts file under /var/lib/jenkins/.ssh/known_hosts
6. Scanned and copied generated SSH keys with main VM's IP address to known_hosts file

### Workspace Configuration

- Added /home/jenkins folders (specified as default workspace)
- Granted sufficient permissions to these directories


### Node Configuration

- Added nodes for each VM and connected them using SSH keys
- Created Jenkins job named "upam-test-pipeline"
- Added two environmental variables for optional OS update and secondary user's username

### Pipeline Configuration

- Created pipeline and linked repository and Jenkinsfile
- Added parameters to choose which node the job runs on, what the generated username will be and if the user want the operating system to update

#### Stages

1. Git repository pull 
2. Setup of used tools 
3. Generation of new User
4. OS update (Optional)
5. Setup K8s
6. Setup portainer
7. Setup ingress


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

