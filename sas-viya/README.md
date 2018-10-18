 # SAS Viya Quickstart Template for Azure

This quickstart will take a generic license for SAS Viya and deploy it into its own network. The network and other infrastructure will be created for this and at the end you should will have in your outputs the web endpoints for a deployed viya on recommended vms. 

This SAS Viya Quickstart Template for Azure documentation provides step-by-step instructions for deploying the following SAS Viya products on the Azure cloud:

* SAS Visual Analytics 8.3 on Linux
* SAS Visual Statistics 8.3 on Linux
* SAS Visual Data Mining and Machine Learning 8.3 on Linux

This Quickstart is a reference architecture for users who want to deploy the SAS platform, using microservices and other cloud-friendly technologies. By deploying the SAS platform on Azure, you get SAS analytics, data visualization, and machine learning capabilities in an Azure-validated environment. 

## Costs and Licenses
You are responsible for the cost of the Azure services used while running this Quick start reference deployment. There is no additional cost for using the Quickstart.
You will need a SAS license to launch this Quick Start. Your SAS account team and the SAS Enterprise Excellence Center can advise on the appropriate software licensing and sizing to meet workload and performance needs.
The SAS Viya Quickstart Template for Azure creates 3 instances, including 
* 1 compute virtual machine (VM), the Cloud Analytic Services (CAS) controller
* 1 VM for administration, the Ansible controller
* 1 VM for the SAS Viya services


## Prerequisites
Before deploying SAS Viya Quickstart Template for Azure, you must have the following:
* Azure user account with Contributor/Admin Role
* Sufficient Quota of at least 28 Cores (assuming 4 licensed SAS cores)
* A SAS Software Order Confirmation e-mail that contains supported Quick Start products:

 		* SAS Visual Analytics 8.3 on Linux
		* SAS Visual Statistics 8.3 on Linux
        * SAS Visual Data Mining and Machine Learning 8.3 on Linux
*  The license .zip file from your software order uploaded to a blob.
  
## Solution Summary
By default, Quickstart deployments enable Transport Layer Security (TLS) to help ensure that communication is secure.

Deploying this Quick Start with default parameters builds the following SAS Viya environment in the Microsoft Azure  Cloud, shown in 

XX NEED PIC XX

## Upload the License .ZIP file to a Microsoft Azure Blob and Getting a SAS URI.

When you run the deployment, you will need the blob Shared Access SIgnature (SAS) URL as a parameter. 

Before you run the deployment:
1. Upload the license file to the Azure block blob.  Follow the Microsoft Azure instructions to 
["Create a Container" and "Upload a Block Blob"]({https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-portal).

2. Create a Shared Access signature (SAS) token.  For details, see 
 ["Using Shared Access Signatures"]({https://docs.microsoft.com/en-us/azure/storage/common/storage-dotnet-shared-access-signature-part-1).
 
 3. Create a Service SAS. Navigate to the license file blob and select **Generate SAS**, then click **Generate blob SAS token and URL.**

4. Make a note of the blob SAS URL for use during deployment. 

s
## Deployment Steps
You can click the "Deploy to Azure" button at the beginning of this document or follow the instructions for command line deployment using the scripts in the root of this repo.

The deployment takes about 90 to 180 minutes.

## Optional Post-Deployment 
### Create a Record for the DNS Name in Order to Associate a Certificate

By default, the Quick Start deployment will generate a highly unique DNS name for your deployment and a self-signed certificate for secure connections. 

The self-signed certificate is untrusted.  To secure your enviornment, add a new shorter DNS name and get a  proper Certificate Authority signed certificate. 

If you acquire a domain address, either:
* create  a CNAME DNS entry at the current unique DNS
* create a traditional A record at the application gateway IP. 
 
If you have aquired a new domain or are using the existing domain, you can create a trusted certificate and upload it to the application gateway. For details, see [Configure an application gateway with SSL termination using the Azure portal](https://docs.microsoft.com/en-us/azure/application-gateway/create-ssl-portal).

### Set Up ODBC 
1. Locate the following two odbc.ini files:
* controller:/opt/sas/viya/home/lib64/accessclients/odbc.ini
* services:/opt/sas/spre/home/lib64/accessclients/odbc.ini

copy sql server template block and then add secret parameters

## Usage 
SASDrive
SASStudio
AnsibleControllerIP

![outputs.jpg]: outputs.jpg "Outputs Screen"

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
```ldapsearch -x -h <YOUR LDAP HOST> -b <YOUR DN> -D <YOUR LDAP SERVICE ACCOUNT> -W ```
4.	Enter the password to your LDAP service account.
If verification is successful, the list of your users and groups is displayed.
##Configure PAM for SAS Studio
SAS Studio does not use the SAS Logon Manager, and thus has different requirements for integration with an LDAP system. SAS Studio manages authentication through a pluggable authentication module (PAM). You can use System Security Services Daemon (SSSD) to integrate the programming machine's (Prog) PAM configuration with your LDAP system.
To access SAS Studio the following conditions must be met:
*	The user must exist locally on the system.
*	The user must have an accessible home directory.
For a step by step guide for configuring SSSD against your LDAP setup, see the RedHat documentation. In many cases SSSD is configured to automatically create home directories when a user logs into the system either via SSH or locally. SAS Studio does not do this; therefore, you must manually create home directories for each remote user.
After SSSD has been configured, you may need to restart the Prog machine.
 
## Addendum B: Managing Users for the Provided OpenLDAP Server

### To log in and list all users and groups:
From the Ansible controller VM, log into the 'Stateful' VM with 
```
ssh stateful.viya.sas
```
### To list all users and groups, run this command 
```ldapsearch -x -h localhost -b "dc=sasviya,dc=com"```

### To add a user: 
1.	 Create a user file that contains all the user info. 
**Note:**    You must increment the UID from the last one displayed by the ldapsearch command.

```newuser, sasviya.com
dn: uid=newuser,ou=users,dc=sasviya,dc=com=
cn: newuser
givenName: New
sn: User
objectClass: top
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: posixAccount
loginShell: /bin/bashuidNumber: 100011
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
```ssh prog.viya.sas
sudo mkdir -p /home/newuser
sudo chown newuser:sasusers /home/newuser
exit
ssh controller.viya.sas
sudo mkdir -p /home/newuser/casuser
sudo chown newuser:sasusers /home/newuser
sudo chown newuser:sasusers /home/newuser/casuser
exit
```
### To change a password or set the password for a new user:
```
ldappasswd –h localhost –s USERPASSWORD –W –D cn=admin,dc=sasviya,dc=com -x “uid=newuser,ou=users,dc=sasviya,dc=com”
```
Note:    To prevent the command from being saved to the bash history, preface this command with a space. The string following the -x should match the dn: attribute of the user.

### To delete a user:
```
ldapdelete –h localhost -W -D "cn=admin,dc=sasviya,dc=com" "uid=newuser,ou=users,dc=sasviya,dc=com"
```




