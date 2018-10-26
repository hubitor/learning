# WSL Docker Setup

In order to run Docker command from inside WSL you need to have Docker installed to get access to the client binaries. This playbook will assist with this by installing Docker within the Ubuntu WSL environment but keep the services off.  It will also set the `DOCKER_HOST` environment variable globally so that you can access the Docker daemon running on the Windows host that was created via the `Vagrantfile` stored in the parent of this directory.

From within your WSL environment that already has Ansible installed while in this directory, run the following command to get setup.

```
ansible-galaxy install -r requirements.yml
ansible-playbook playbook.yml
```

You may have to close and reopen your Bash session so that the `DOCKER_HOST` variable gets loaded at which point you should be able to interact with Docker with all the normal Docker commands from within your WSL environment.