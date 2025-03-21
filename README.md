# UPAM DevOps Test Documentation

The following contains the documentation and the steps taken in order to complete the UPAM DevOps test case.


## File ecosystem

The repository contains the jenkinsfile that is responsible for the pipeline, as well as the ansible playbooks that provision and configure the different tasks. These are configured to run in a declarative pipeline at different stages.

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

- 2002, 222, 22: OPENSSH access to each VM
- 8081: GitLab HTTP instance
- 8080: Jenkins HTTP instance


### Package Installation

- Installed OPENSSH-server for SSH connectivity between VMs and host machine
- Installed Java (prerequisite for Jenkins)


## Jenkins Setup

### Installation and Configuration

- Downloaded and installed Jenkins as a service on devops-main-vm
- Added Jenkins service to systemctl configuration (enabled on startup)
- Jenkins accessible at http://localhost:8080
- Created admin user account:
    - Username: admin
    - Password: admin
- Installed recommended Jenkins packages

### SSH Key Configuration

- Added jenkins as user to both nodes as well as gave them root and no password required priviledges
- Generated SSH keys for devops-k8master-vm and devops-k8worker-vm
- Copied keys to respective VMs
- Set up credentials in Jenkins for SSH connection
- Manually created known_hosts file under /var/lib/jenkins/.ssh/known_hosts
- Scanned and copied generated SSH keys with main VM's IP address to known_hosts file
- Added further internal SSH configuration and port openings on 22 for the ansible instance communication

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

**1. Git repository pull**

Checks whether the newest repository version is inside the workspace. Pulls newest version and navigates into it for further tasks.

**2. Setup of used tools**

Installs neccessary tools for further tasks such as docker and ansible.

**3. Generation of new User**

Uses dedicated ansible file to generate new user for use in further tasks.

**4. OS update (Optional)**

Optional OS update on the node the pipeline runs on.

**5. Setup K8s**

Sets up K8 cluster with ansible.

**6. Setup portainer**

Sets up portainer instance with ansible.

**7. Setup ingress**

Sets up ingress instance with ansible.


## GitLab Setup

### Docker Installation & Configuration

- Added GPG key for Docker and Docker Compose
- Downloaded Docker and Docker Compose using the GPG key
- Added docker group to both users 
- Enabled Docker to run on startup


### GitLab Instance Creation

- Created docker-compose.yml file under ~/gitlab
- Generates basic GitLab instance at http://localhost:8081


## Notes and Challenges

- **Vagrant SSH Issue**: Unable to generate private and public key pair due to Vagrant overwriting it on each startup
- **VirtualBox Network Configuration**: Manually added enp0s8 network with DHCP4 enabled in ~/etc/netplan/50-cloud-init.yaml
- **Jenkins Docker Installation**: Attempted including Jenkins in docker-compose.yml, but faced user creation and SSH key connection issues
- **GitLab Limitations**: Free version doesn't support SSH key connection to repository, opted for GitHub instead for easier SSH key generation and file checkout
- **Linux OS**: Due to this being my first real Linux OS experience with only using the CLI, I faced challenges understanding commands and the way different user priviledges work

## Improvement Points

- **Gitlab automation**: Automate and timestamp running of pipeline into Gitlab repository. Due to me using the free version, no SSH token can be generated, hence the connection between jenkins, the VMs and Gitlab could not be made in the long run
- **Simplify Linux VM configuration**: Making the provisioning and configuring of the Linux OS based VMs would be a top priority, as creating and maintaining these environmnet is top priority
- **Configuration with ansible**: Provisioning and configuration step automation using ansible for more steps
- **Add error-handling and retry hooks**: Add proper error-handling and rerty hooks to each element inside the pipeline
- **Join two VMs to create K8 cluster**: Due to SSH issues I was not able to connect both VMs to the K8 cluster

### General improvements & final thoughts
Unfortunately, I could not complete all tasks to a 100% as it was instructed by the tasklist (See problems above). Most problems arose from conflicts within the Linux OS and user priviledge problems, which can be mitigated with enough practice and knowledge of the Linux ecosystem as well as the knwoledge and experience of each tool used within the test case.

