
### Before you Begin. The '--dryrun' option and the '--yes' Option 
Do you want to run the commands or just see them?  
Below we have set the carme option `dryrun` so that commands are printed and not executed. 

If executing carme commands from the command line, by default the CMD command and will print the command and ask you to confirm before executing it. In Jupyter notebooks, this interactivity isn't possible. Instead, just add the --yes flag.   


```python
#To run for real, just set dryrun=''
#dryrun= '' to run or dryrun='--dryrun' to print. 
dryrun=''
yes = '--yes'
```

### View Available Commands


```python
!carme cmd az-cluster list

```

### View the Configuration


```python
!carme cmd az-cluster show_config $yes
```

### Create Kubernetes Cluster on Azure

This notebook can be used to launch a Kubernetes Cluster using Azure CLI.  It is designed to be run in an environment in whic the appropriate tools (Helm/Azure CLI) are installed.  

This script assumes you have already installed the az-server package and logged in using the `az login` command.  

To install the package use:
`carme package install az-cluster`

To log into the Azure CLI:
`carme cmd az-cluser login`

You may also have to set the correct subscription. 
`az account list --refresh --output table`

Set the appropriate subscription here. 
`az account set -s <YOUR-CHOSEN-SUBSCRIPTION-NAME>`
   


### Login to Azure


```python
!carme cmd az-cluster login $dryrun $yes
```

### List Available Subscription (Optional)
You can update the current subscription usine either the ID or the name.  

### Print Available Commands
Optionally you can print the configuration and common commands for your desired cluster. You can use this as a reference and copy and paste into the terminal.


```python
#This will list all subscrptions. 
!carme cmd az-cluster list_subscriptions $dryrun $yes
```

### Set the Appropriate Subscription (Optional)
You can skip this if you already have the appropriate subscription set. 


```python
!carme cmd az-cluster set_subscription $dryrun $yes
```

### Create the Resource Group 
Google calls them projects.  Azure calles them resource groups. Either way you need one. This useful to track spending and also ensure you delete all resources at the end. 



```python
!carme cmd az-cluster create_group $dryrun $yes
```

### Enable the Cloud API
The following commands enable various Azure tools that we’ll need in creating and managing the JupyterHub.


```python
!carme cmd az-cluster register $dryrun $yes
```

### Create the ssh key.  
This will create the ssh key and put it in the ./config/ssh/servername directory. 


```python
!carme cmd az-cluster create_key $dryrun $yes
```

### Create the Cluster
This will create your Kubernetes Cluster. You have to wait for about 5 minutes before this finishes creating.



```python
!carme cmd az-cluster create $dryrun $yes
```

### WAIT FOR A WHILE
This can take up to 10 minutes. 

If you get an error ".kube/config: No such file or directory" just wait, it is likely still booting up. 

### Get Credentials for Kubectl
We need to add the credentials for Kubectl to work. You need a bit of time for your Kubernetes to launch.


```python
#gcloud container clusters get-credentials carme
!carme cmd az-cluster get_credentials $dryrun $yes
```


```python
#Check to see if we have Kubectl working. 
!kubectl cluster-info

```


```python
#Check notes with Kubectl
!kubectl get node

```

### Helm Installation.  
We are going to be utilizing Helm for  installations of a variety of analytics tools.  This command will install Tiller on your cluster.  As they say, "Happy Helming!" 

A critical factor for Helm is that you have the same version running locally and via your machine.  If you run helm version and you have the right version, then you should be fine.

```
Client: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
```

To install the appropriate version: 

```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
RUN get_helm.sh --version v2.6.2

```



```python
#Setup Serviceaccount
!kubectl --namespace kube-system create serviceaccount tiller
```


```python
#Initialize Helm
!helm init --service-account tiller
```


```python
#This may need to be run more than once if you get a "cannot connect to server."
!helm version
```


```python
# Secure Helm
!kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
```

### Resize a Cluster



```python
#Scale the cluster 
!carme cmd az-cluster class_size $dryrun $yes
```


```python
#Stop the cluster, effectively setting the size to 0.
!carme cmd az-cluster stop $dryrun $yes
```


```python
#Set the cluster to the normal size.
!carme cluster normal_size
```

### Deleting a Kubernetes Cluster

This will delete the Kubernetes cluster by deleting the entire project. This will prefent any future charges. 


```python
#Always delete the namespace first. 
!carme cmd az-cluster delete $dryrun $yes
```

### Delete the Resource Group
To fully clean up everything, go ahead and delete the resource group.


```python
!carme cmd az-cluster delete_group $dryrun $yes
```
