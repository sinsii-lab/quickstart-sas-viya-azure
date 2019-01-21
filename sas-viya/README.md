## SAS Viya Quickstart Template for Azure


This SAS Viya Quickstart Template for Azure README is used to deploy the following SAS Viya products on the Azure cloud:

* SAS Visual Analytics 8.3 on Linux
* SAS Visual Statistics 8.3 on Linux
* SAS Visual Data Mining and Machine Learning 8.3 on Linux

This Quickstart is a reference architecture for users who want to deploy the SAS platform, using microservices and other cloud-friendly technologies. By deploying the SAS platform on Azure, you get SAS analytics, data visualization, and machine learning capabilities in an Azure-validated environment. 

## Costs and Licenses
You are responsible for the cost of the Azure services used while running this Quickstart reference deployment. There is no additional cost for using the Quickstart.
You will need a SAS license to launch this Quick Start. Your SAS account team and the SAS Enterprise Excellence Center can advise on the appropriate software licensing and sizing to meet workload and performance needs.
The SAS Viya Quickstart Template for Azure creates 3 instances, including 
* 1 compute virtual machine (VM), the Cloud Analytic Services (CAS) controller
* 1 VM for administration, the Ansible controller
* 1 VM for the SAS Viya services


## Prerequisites
Before deploying SAS Viya Quickstart Template for Azure, you must have the following:
* Azure user account with Contributor and Admin Roles
* Sufficient Quota of at least 28 Cores (assuming 4 licensed SAS cores)
* A SAS Software Order Confirmation e-mail that contains supported Quickstart products:

 		SAS Visual Analytics 8.3 on Linux
		SAS Visual Statistics 8.3 on Linux
        SAS Visual Data Mining and Machine Learning 8.3 on Linux
*  The license .zip file from your software order uploaded to a blob
*  Verification that your file uploads meet the limits of the Application Gateway.  For details on limits, see 
["Application Gateway limits."](https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits?toc=%2fazure%2fapplication-gateway%2ftoc.json#application-gateway-limits)
## (Optional) Create a Mirror Repository 
To use a mirror repository, you create a mirror repository as documented in ["Create a Mirror Repository"](https://go.documentation.sas.com/?docsetId=dplyml0phy0lax&docsetTarget=p1ilrw734naazfn119i2rqik91r0.htm&docsetVersion=3.4&locale=en) in the SAS Viya 3.4 for Linux: Deployment Guide.  

Note: To be considered as a directory mirror by the system, the URL must end in a "/" directly before the SAS key. 

You can then either:
* Use the default method which downloads the install files directly from SAS.

* Upload the entire mirror to Azure blob storage as follows:
1. Upload the mirror:
```
az storage blob upload-batch --account-name "$STORAGE_ACCOUNT" --account-key "$STORAGEKEY" --destination "$SHARE_NAME" --destination-path "$SUBDIRECTORY_NAME" --source "$(pwd)" 
```
2. Create a SAS key that has (at a minimum) list and read on the blob store.

3. During deployment, set the DeploymentMirror parameter to the URL of the folder in Azure blob that is qualified by that SAS key. 

Note: For the system to recognize the mirror directory, the URL must end in a "/" directly before the SAS key.
* Compress the folder and upload to Azure blob or another storage location that is secure as follows:
1. Zip up the entire folder as a compressed tar archive. For example, .tar.gz/.tgz. 
2. Upload the compressed tar archive to Azure blob storage or another storage location that is accessible from the Internet and can be secured. 
3. During deployment, set the DeploymentMirror parameter to the authenticated URL. In the case of blob storage, this would be the path URL to the blob that is qualified by a SAS key.

  
## Solution Summary
By default, Quickstart deployments enable Transport Layer Security (TLS) to help ensure that communication is secure.

This SAS Viya Quickstart Template for Azure will take a generic license for SAS Viya and deploy it into its own network. The deployment will create the network and other infrastructure.  After the deployment completes, you will have the outputs for the Web endpoints for a deployed SAS Viya on recommended VMs. 

Deploying this Quick Start with default parameters builds the following SAS Viya environment in the Microsoft Azure  Cloud, shown in 

XX NEED PIC XX

* 
For details, see the deployment guide.
## Upload the License .ZIP file to a Microsoft Azure Blob and Getting a SAS URI

When you run the deployment, you will need the blob Shared Access SIgnature (SAS) URL as a parameter. 

Before you run the deployment:
1. Upload the license file to the Azure block blob.  Follow the Microsoft Azure instructions to 
["Create a Container" and "Upload a Block Blob"](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-portal).

2. Create a Shared Access signature (SAS) token.  For details, see 
 ["Using Shared Access Signatures"](https://docs.microsoft.com/en-us/azure/storage/common/storage-dotnet-shared-access-signature-part-1).
 
 3. Create a Service SAS. Navigate to the license file blob and select **Generate SAS**, then click **Generate blob SAS token and URL.**

4. Make a note of the blob SAS URL for use during deployment. 

## Deployment Steps
You can click the "Deploy to Azure" button at the beginning of this document or follow the instructions for command line deployment using the scripts in the root of this repository.

The deployment takes about 90 to 180 minutes.

## Optional Post-Deployment 
### Create a Record for the DNS Name in Order to Associate a Certificate

By default, the Quick Start deployment will generate a highly unique DNS name for your deployment and a self-signed certificate for secure connections. 

The self-signed certificate is untrusted.  To secure your environment, add a new shorter DNS name and get a  proper Certificate Authority signed certificate. 

If you acquire a domain address, either:
* create  a CNAME DNS entry at the current unique DNS
* create a traditional A record at the application gateway IP 
 
If you have acquired a new domain or are using the existing domain, you can create a trusted certificate and upload it to the application gateway. For details, see [Renew Application Gateway certificates](https://docs.microsoft.com/en-us/azure/application-gateway/renew-certificates).
### Enable Access to Existing Data Sources
To access an existing data source from your SAS Viya deployment, add an inbound rule to each security group or firewall for the data source as follows:
* If your data source is accessed by transiting the public Internet, add a public IP to the the SAS Viya "services" VM and SAS Viya "controller" VM. Add an Allow rule for each of these IPs. For details, see: 
 ["Create, change, or delete a public IP address."](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-public-ip-address)

* If you have an Azure-managed database, add the service endpoint for the database to your SAS Viya network's private subnet. For details, see
 ["Use Virtual Network service endpoints and rules for Azure SQL."](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview)

* If you have peered the virtual network, add a rule to Allow the private subnet CIDR range for the SAS Viya network. (By default, 10.0.127.0/24). For details, see 
 ["Virtual network peering."](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)
 
### Validate the Server Certificate if Using ODBC
If you are using SAS/ACCESS with SSL/TLS, unvalidated SSL certificates are not supported. In this case, a valid trust store must be provided.

### Set Up ODBC and Microsoft SQL Server
1. Locate the following two odbc.ini files:
* CAS controller: /opt/sas/viya/home/lib64/accessclients/odbc.ini
* SAS Viya services: /opt/sas/spre/home/lib64/accessclients/odbc.ini

2. For each file, modify the parameters per the following examples.  For details about how to configure:
* For detailed information about configuring data access, see 
 ["Configure Data Access"](https://go.documentation.sas.com/?docsetId=dplyml0phy0lax&docsetTarget=p03m8khzllmphsn17iubdbx6fjpq.htm&docsetVersion=3.4&locale=en) in the SAS Viya Deployment Guide.
* For specific DataDirect information, see ["Configuration Through the System Information (odbc.ini) File"](https://documentation.progress.com/output/DataDirect/odbcsqlserverhelp/index.html#page/odbcsqlserver%2Fconfiguration-through-the-system-information-(od.html%23)).

3. For SQLServer, specify the appropriate driver location:
* For SAS Viya: /opt/sas/spre/home/lib64/accessclients/lib/S0sqls27.so 
* For CAS controller: /opt/sas/viya/home/lib64/accessclients/lib/S0sqls27.so 
 
```
[SQLServerTest] 
Driver=<driver location>
Description=SAS Institute, Inc 7.1 SQL Server Wire Protocol 
AlternateServers= 
AlwaysReportTriggerResults=0 
AnsiNPW=1 
ApplicationName= 
ApplicationUsingThreads=1 
AuthenticationMethod=1 
BulkBinaryThreshold=32 
BulkCharacterThreshold=-1 
BulkLoadBatchSize=1024 
BulkLoadFieldDelimiter= 
BulkLoadOptions=2 
BulkLoadRecordDelimiter= 
ConnectionReset=0 
ConnectionRetryCount=0 
ConnectionRetryDelay=3 
Database=sqlserver 
EnableBulkLoad=0 
EnableQuotedIdentifiers=0
```

4. To set the encryption method, set EncryptionMethod to 0 for no SSL or 1 for SSL. 

```
EncryptionMethod=1 
FailoverGranularity=0 
FailoverMode=0 
FailoverPreconnect=0 
FetchTSWTZasTimestamp=0 
FetchTWFSasTime=1 
GSSClient=native 
HostName= <host name of the SQL Server>
HostNameInCertificate= 
InitializationString= 
Language= 
LoadBalanceTimeout=0 
LoadBalancing=0 
LoginTimeout=15 
LogonID= 
MaxPoolSize=100 
MinPoolSize=0 
PacketSize=-1 
Password= 
Pooling=0 
PortNumber=1433 
QueryTimeout=0 
ReportCodePageConversionErrors=0 
SnapshotSerializable=0 
TrustStore= 
TrustStorePassword=
```

5. You must ensure ValidateServerCertificate is set to a value of 1. 

``` 
ValidateServerCertificate=1 
WorkStationID= 
XMLDescribeType=-10 
SSLLibName=/usr/lib64/libssl.so.1.0.2k 
CryptoLibName=/usr/lib64/libcrypto.so.1.0.2k
```

6. Save the odbc.ini files. 
### Set Up SAS Data Agent

1. Perform the pre-nstallation and installation steps in the ["SAS Data Agent for Linux Deployment Guide."](https://go.documentation.sas.com/?docsetId=dplydagent0phy0lax&docsetTarget=p06vsqpjpj2motn1qhi5t40u8xf4.htm&docsetVersion=2.3&locale=en) For the post-installation tasks, you can either:
* (Recommended) Use the post-install playbooks as specified in steps 6 and 7 below.
* Perform the manual steps in the SAS Data Agent Deployment Guide.

2. In the SAS Viya plus SAS Data Preparation environment, open the firewall to allow access on port 443 as follows:

      a. Obtain the public IP of the SAS Data agent firewall. The SAS Data Agent firewall address is either the public IP of the machine where the HTTPS service is running or the public IP of the NAT that routes outgoing traffic in the SAS Data Agent network.

      b. Modify the security group of the Application Gateway. By default, this is called "PrimaryViyaLoadbalancer_NetworkSecurityGroup" and will be under the resource group of your SAS Viya deployment. Add an inbound rule for port 443 for the public IP found in step a.
      
3. To verify that the connection works, on the machine assigned to the [httpproxy] host group in the Ansible inventory file in your SAS Data Agent environment, run the following:
``` 
    sudo yum install -y nc
    nc -v -z  <DNS of SAS Viya endpoint> 443
``` 
4. To allow access from your SAS Viya network, open the firewall of the SAS Data Agent Environment. You can either:
    * Add a public IP address to both the controller and services VMs and allow port 443 from the public IPs of your install. For details, see ["SAS Data Agent for Linux Deployment Guide."](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-public-ip-address) 
    
    * Allow general access to port 443 to all IP addresses.

5. To verify that the connection works, on the services host run the following:
    ``` 
    sudo yum install -y nc
    nc -v -z  <IP or DNS of the SAS Data Agent host> 443
    ``` 
6. Register the SAS Data Agent with the SAS Viya Environment. As the deployment vmuser, log into the Ansible controller VM and run the following from the /sas/install/setup/orchestration directory:

``` 
ansible-playbook ansible.dataprep2dataagent.yml \
       -e "adminuser=sasadmin adminpw=<password of admin user>" \
       -e "data_agent_host=<FQDN (DNS) of SAS Data Agent machine>" \
       -e “secret=<handshake string>” \
       -i "/sas/install/setup/orchestration/sas_viya_playbook/inventory.ini"
```
 
The password of the admin user is the value that you specified during deployment for the SASAdminPass input parameter.

7. Register the SAS Viya environment with the SAS Data Agent. Copy the following file from the Ansible controller in your SAS Viya deployment into the playbook directory (sas_viya_playbook) on your SAS Data Agent deployment:

``` 
/sas/install/code/postconfig-helpers/dataagent2dataprep.yml
``` 
 
From within the deployment directory for the SAS Data Agent, run the following:
 ``` 
ansible-playbook dataagent2dataprep.yml \
       -e "data_prep_host=<DNS of SAS Viya endpoint>" \
      - e “secret=<handshake string>” 
```
 
Note: The DNS of the SAS Viya endpoint is the value of the SASDrive output parameter, without the " prefix and the "/SASDrive" suffix.

8. Validate the environment, including round-trip communication. For details, see the "Validation" chapter of the [SAS Data Agent for Linux Deployment Guide](https://go.documentation.sas.com/?docsetId=dplydagent0phy0lax&docsetTarget=n1v7mc6ox8omgfn1qzjjjektc7te.htm&docsetVersion=2.3&locale=en )

## Usage 

To access SAS Viya applications, navigate to the Outputs screen and access SAS Drive or SAS Studio. 

![Outputs Screen](https://gitlab.sas.com/iaas-deployment-templates/quickstart-sas-viya-azure/raw/master/sas-viya/outputs.jpg)

## Addendum A: Configuring the Identities Service
### Verify Security Settings
Ensure that port 389 on your Lightweight Directory Access Protocol (LDAP) machine is accessible by the SAS Viya machines.
### Create Service Account
Create a service account in your LDAP system. The service account must have permission to read the users and groups that will log into the system.
### Configure the Identities Service
In the SAS Environment Manager, on the Configuration tab, select the Identities service. There are three sections to configure: connection, user, and group. 
#### Connection
*	host - the DNS address or IP address of your LDAP machine
*	password - the password of the service account that SAS Viya will use to connect to your LDAP machine.
*	port - the port your LDAP server uses
*	userDN - the DN of the LDAP service account
#### User
*	accountID - the parameter used for the user name. This may be uid, samAccountName or name depending on your system
*	baseDN - DN to search for users under
#### Group
*	accountID - the parameter used for the name of the group
*	baseDN - DN to search for groups under
Set the default values to work with a standard Microsoft Active Directory system.

**Note:**   OpenLDAP systems and customized AD setups may require additional configuration that is beyond the scope of this guide.
For further details about configuring the identities service, see [SAS Viya 3.4 for Linux: Deployment Guide](https://go.documentation.sas.com/?docsetId=dplyml0phy0lax&docsetTarget=titlepage.htm&docsetVersion=3.4&locale=en).
 
### Verify the Configuration
To verify:
1.	Log in to SAS Viya with your LDAP accounts. You may need to restart SAS Viya for the LDAP changes to take effect.
2.	Run the ldapsearch command from one of the SAS Viya machines.
```
ldapsearch -x -h <YOUR LDAP HOST> -b <YOUR DN> -D <YOUR LDAP SERVICE ACCOUNT> -W 
```
4.	Enter the password to your LDAP service account.
If verification is successful, the list of your users and groups is displayed.

## Configure PAM for SAS Studio
SAS Studio does not use the SAS Logon Manager, and thus has different requirements for integration with an LDAP system. SAS Studio manages authentication through a pluggable authentication module (PAM). You can use System Security Services Daemon (SSSD) to integrate the programming machine's (Prog) PAM configuration with your LDAP system.
To access SAS Studio the following conditions must be met:
*	The user must exist locally on the system.
*	The user must have an accessible home directory.

For a step by step guide for configuring SSSD against your LDAP setup, see the RedHat documentation. In many cases SSSD is configured to automatically create home directories when a user logs into the system either via SSH or locally. SAS Studio does not do this; therefore, you must manually create home directories for each remote user.
After SSSD has been configured, you may need to restart the Prog machine.
 
## Addendum B: Managing Users for the Provided OpenLDAP Server

### To log in and list all users and groups:
From the Ansible controller VM, log into the 'Stateful' VM: 
```
ssh services.viya.sas
```
### To list all users and groups: 

``` 
ldapsearch -x -h localhost -b "dc=sasviya,dc=com" 
```

### To add a user: 
1.	 Create a user file that contains all the user info. 

**Note:**    You must increment the UID from the last one displayed by the ldapsearch command.

```
newuser, sasviya.com
dn: uid=newuser,ou=users,dc=sasviya,dc=com=
cn: newuser
givenName: New
sn: User
objectClass: top
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: posixAccount
loginShell: /bin/bash
uidNumber: 100011
gidNumber: 100001
homeDirectory: /home/newuser
mail: newuser@stateful.viya.sas
displayName: New User 
```

2.	Run the following command. 
```
ldapadd -x -h localhost -D "cn=admin,dc=sasviya,dc=com" -W -f /path/to/user/file 
```

**Note:**    You will be prompted for the admin password (the same one you set when you created the stack).

3.	To allow the new user to access Viya products, add the user as a member of the sasusers group by creating an ldif file with the following data:
```
dn: cn=sasusers,ou=groups,dc=sasviya,dc=com
changetype: modify
add: memberUid
memberUid: newuser

add: member
member: uid=newuser,ou=users,dc=sasviya,dc=com
ldapadd -x -h localhost -D "cn=admin,dc=sasviya,dc=com" -W -f /path/to/user/file
```
4.	Add the home directories for your new user on the programming machine (prog.viya.sas) and the CAS controller (controller.viya.sas). From the Ansible controller VM:
```
ssh services
sudo mkdir -p /home/newuser
sudo chown newuser:sasusers /home/newuser
exit
ssh controller
sudo mkdir -p /home/newuser/casuser
sudo chown newuser:sasusers /home/newuser
sudo chown newuser:sasusers /home/newuser/casuser
exit
```
### To change a password or set the password for a new user:
```
ldappasswd -h localhost -s USERPASSWORD -W -D cn=admin,dc=sasviya,dc=com -x "uid=newuser,ou=users,dc=sasviya,dc=com" 
```
**Note:**    To prevent the command from being saved to the bash history, preface this command with a space. The string following the -x should match the dn: attribute of the user.

### To delete a user:
```
ldapdelete –h localhost -W -D "cn=admin,dc=sasviya,dc=com" "uid=newuser,ou=users,dc=sasviya,dc=com"
```



