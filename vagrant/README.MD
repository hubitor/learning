# Vagrant
This folder contains files used to work with [Vagrant][1].

## Contents

**template:** Contains Vagrant template files used for creating new Vagrant environments for testing/learning. The idea of having a more generic Vagrantfile and using a YAML file with machine data in it to provision VM was inspired by [Scott Lowe's][2] [learning-tools repo][3].

**docker:** Contains Vagrant environment for running CentOS 7 VM locally with the Docker daemon exposed so that I can interact with it from Windows Subsystem for Linux.

**ansible-win_nssm-testing:** Contains Vagrant environment for testing pull request for win_nssm Ansible module on a Windows system.

[1]: https://www.vagrantup.com/
[2]: https://blog.scottlowe.org/
[3]: https://github.com/scottslowe/learning-tools
