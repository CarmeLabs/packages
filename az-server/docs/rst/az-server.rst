
Manage a Server on Azure
========================

This notebook can be used to launch a server using Azure CLI. It is
designed to be run via the included Docker container, but it can be run
locally if the appropriate tools are installed.

This script assumes you have already installed the az-server package and
logged in using the ``az login`` command.

To install the package use: ``carme package install az-server``

To log into the Azure CLI: ``carme cmd az-server login``

Remove the comment below.
=========================

.. code:: ipython3

    #!carme cmd az-server login

Do you want to run the commands or just see them?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below we have set the carme option dryrun so that commands are printed
and not executed.

.. code:: ipython3

    #To run for real, just set dryrun=''
    #dryrun= ''
    dryrun='--dryrun'

Print Available Commands
~~~~~~~~~~~~~~~~~~~~~~~~

Optionally you can print the configuration and common commands for your
desired cluster. You can use this as a reference and copy and paste into
the terminal.

.. code:: ipython3

    !carme cmd az-server list



.. parsed-literal::

    carme: [INFO] These commands are currently installed:
    login: "az login"
    login_sa: "echo 'Service account login not yet available for Azure'"
    create_resource_group: "az group create --name {resource_group} --location {location}"
    delete_resource_group: "az group delete --name {resource_group} --location {location}"
    create: "az vm create --name {server_name} --resource-group {resource_group} --image\
      \ {server_image} --size {server_size} --admin-username {server_admin} --generate-ssh-keys"
    stop: "az vm deallocate --name {server_name} --resource-group {resource_group}"
    start: "az vm start --name {server_name} --resource-group {resource_group}"
    delete: "az vm delete --name {server_name} --resource-group {resource_group} --yes"
    show: "az vm show --name {server_name} --resource-group {resource_group}"
    ssh: "ssh {server_admin}@{server_ip}"
    open_port_80: "az vm open-port --port 80 --resource-group {resource_group} --name\
      \ {server_name}"
    open_port_8888: "az vm open-port --port 8888 --resource-group {resource_group} --name\
      \ {server_name}"
    open_ports_all: "az vm open-port --port * --resource-group {resource_group} --name\
      \ {server_name}"
    show_sizes: "az vm list-sizes --location {location}"
    create_storage: "az storage account create --resource-group={resource_group} --location={location}\
      \ --sku=Standard_LRS --name={storage_account} --kind=Storage"
    get_storage_key: "az storage account keys list --account-name={storage_account} --resource-group={resource_group}\
      \ --output=json | jq .[0].value -r"
    create_keyvault: "az keyvault create --name={resource_group} --resource-group={resource_group}\
      \ --location={location} --enabled-for-template-deployment true"
    backup_private_key: "az keyvault secret set --vault-name={vault_name} --name=id-rsa-{server_name}\
      \ --file=~/.ssh/id_rsa_{server_name}"
    backup_public_key: "az keyvault secret set --vault-name={vault_name} --name=id-rsa{server_name}-pub\
      \ --file=~/.ssh/id_rsa_{server_name}.pub"
    get_private_key: "az keyvault secret show --vault-name={vault_name} --name=id-rsa-{server_name}"
    get_public_key: "az keyvault secret show --vault-name={vault_name} --name=id-rsa{server_name}-pub"


Create Resource Groups
~~~~~~~~~~~~~~~~~~~~~~

Google calls them projects. Azure calles them resource groups. Either
way you need one. This useful to track spending and also ensure you
delete all resources at the end.

Review the Package Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You should always review your configuration prior to executing any
commands.

.. code:: ipython3

    !cat ../../config/az-server.yaml


.. parsed-literal::

    azure_image: carmelabs/azurecli
    email: 'jason@analyticsdojo.com'    #Email Associated with the account.
    #Start of Azure Configuration
    resource_group: carme     #Resource groups are used to separate projects.
    server_name: carmeserver
    server_image: UbuntuLTS         #Bionic 18.04 (LTS)Artful 17.10 Xenial 16.04 (LTS)
    server_admin: carmeuser
    server_auth: '--generate-ssh-keys'
    server_size: 'Standard_DS1_v2'    #See all available at `carme cmd az-server show_sizes` or https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
    storage_account: twitter          #For use with Pachyderm
    container_name: twitter           #For use with Pachyderm
    storage_name: pach2-disk.vhd   #For use with Pachyderm
    storage_size: 1                #For use with Pachyderm Storage account size in GB.
    location: eastus2                 #Selection from `az account list-locations`.
    server_ip: 104.210.8.14


.. code:: ipython3

    !carme cmd az-server create_resource_group $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: create_resource_group
    carme: [INFO] Template: az group create --name {resource_group} --location {location}
    carme: [INFO] Values: az group create --name carme --location eastus2


Create the Server
~~~~~~~~~~~~~~~~~

This will create the server with an SSH key. This is the easiest way to
manage it.

.. code:: ipython3

    !carme cmd az-server create $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: create
    carme: [INFO] Template: az vm create --name {server_name} --resource-group {resource_group} --image {server_image} --size {server_size} --admin-username {server_admin} --generate-ssh-keys
    carme: [INFO] Values: az vm create --name carmeserver --resource-group carme --image UbuntuLTS --size Standard_DS1_v2 --admin-username carmeuser --generate-ssh-keys


WAIT FOR A WHILE
~~~~~~~~~~~~~~~~

This can take a few minutes.

Open Ports on the Target Machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There is a need to open ports on the target machine.

.. code:: ipython3

    #gcloud container clusters get-credentials carme
    !carme cmd az-server open_port_8888 $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: open_port_8888
    carme: [INFO] Template: az vm open-port --port 8888 --resource-group {resource_group} --name {server_name}
    carme: [INFO] Values: az vm open-port --port 8888 --resource-group carme --name carmeserver


Using and Enhancing Your Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``carme cmd az-server ssh --dryrun``

.. code:: ipython3

    !carme cmd az-server ssh --dryrun


.. parsed-literal::

    carme: [INFO] Running the command: ssh
    carme: [INFO] Template: ssh {server_admin}@{server_ip}
    carme: [INFO] Values: ssh carmeuser@104.210.8.14


Stop the Server
~~~~~~~~~~~~~~~

The stop command by default deallocates so you won't be charged untill
you start it up again.

.. code:: ipython3

    #Scale the cluster 
    !carme cmd az-server stop $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: stop
    carme: [INFO] Template: az vm deallocate --name {server_name} --resource-group {resource_group}
    carme: [INFO] Values: az vm deallocate --name carmeserver --resource-group carme


Start the Server
~~~~~~~~~~~~~~~~

.. code:: ipython3

    #Stop the cluster, effectively setting the size to 0.
    !carme cmd az-server start $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: start
    carme: [INFO] Template: az vm start --name {server_name} --resource-group {resource_group}
    carme: [INFO] Values: az vm start --name carmeserver --resource-group carme


Show the Server
~~~~~~~~~~~~~~~

.. code:: ipython3

    #Set the cluster to the normal size.
    !carme cmd az-server show $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: show
    carme: [INFO] Template: az vm show --name {server_name} --resource-group {resource_group}
    carme: [INFO] Values: az vm show --name carmeserver --resource-group carme


Deleting the Server
~~~~~~~~~~~~~~~~~~~

This will delete the Kubernetes cluster by deleting the entire project.
This will prefent any future charges.

.. code:: ipython3

    #Always delete the namespace first. 
    !carme cmd az-server delete $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: delete
    carme: [INFO] Template: az vm delete --name {server_name} --resource-group {resource_group} --yes
    carme: [INFO] Values: az vm delete --name carmeserver --resource-group carme --yes


Delete the Resource Group
~~~~~~~~~~~~~~~~~~~~~~~~~

To fully clean up everything, go ahead and delete the resource group.

.. code:: ipython3

    !carme cmd az-server delete_resource_group $dryrun


.. parsed-literal::

    carme: [INFO] Running the command: delete_resource_group
    carme: [INFO] Template: az group delete --name {resource_group} --location {location}
    carme: [INFO] Values: az group delete --name carme --location eastus2

