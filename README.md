# Vagrant Drupal Dev Env Automator

This was created to automate setting up a Drupal development environment working with a project structure as hosted by Acquia.  
Replace "PROJECT" with actual Acquia Drupal project name
Replace "DOMAIN" with actual Acquia domain as applicable
Replace "PATH" with actual Acquia path as applicable

To set up a Vagrant based Drupal dev env, you will need to do the following:

1. Install Virtual Box
1. Install Vagrant
1. Get an Acquia cloud account if you don't have one
1. Create an SSH key to use with Acquia and set up in Acquia cloud (if you haven't already)
1. Clone this repo and cd into resulting dir:  **vagrant-drupal-dev-vm**
1. Clone the PROJECT codebase from Acquia into /vagrant-drupal-dev-vm, result: /vagrant-drupal-dev-vm/**PROJECT**
    1. `git clone PROJECT@DOMAIN:PROJECT.git`
1. Get DB backup from Acquia
    1. ssh in to view backups `ssh PROJECT@PROJECT.DOMAIN` 
    1. and `ls -l PATH/backups`
    1. exit out noting backup file name and scp it down: 
       `scp PROJECT@PROJECT.DOMAIN:PATH/_enter-file-name-here_.gz .`
    1. unzip and rename so you have this exact file name: /vagrant-drupal-dev-vm/**prod-PROJECT.sql**
1. Get non git tracked web assets files dir from Acquia
    1. ssh in `ssh PROJECT@PROJECT.DOMAIN` 
       and cd to PATH `cd PATH`
    1. tar up the files `tar -zcvf files.tar.gz sites/default/files`
    1. exit out and scp the files archive down so you have: /vagrant-drupal-dev-vm/**files.tar.gz**
       `scp PROJECT@PROJECT.DOMAIN:PATH/files.tar.gz .`
1. Make settings.local.php (and tweak settings if needed) from the example copy, 
   result: /vagrant-drupal-dev-vm/xfiles/**settings.local.php**
1. From /vagrant-drupal-dev-vm run: `vagrant up`

When vagrant up completes you should have a Vagrant Ubuntu VM running Drupal and forwarding ports so your host browser should be able to hit the Drupal login page via localhost:

Then log in to drupal admin
https://localhost/user/login

Make code changes as needed in the PROJECT codebase by editing files via your host code editor and ssh'ing into the Vagrant VM to run composer updates (if needed).  Test changes against the Drupal instance running on the Vagrant test environment, then create a branch to push up to Acquia to test in Acquia hosted Drupal environments.

For those unfamiliar with Vagrant:

* To ssh into the guest VM:  `vagrant ssh`
* To stop the guest VM:  `vagrant halt`
* Check VM status (running or not): `vagrant status`
* Start VM: `vagrant up` (only does the provisioning stuff first time)
