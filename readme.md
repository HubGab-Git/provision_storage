# Well Architected S3 and EFS

## Description

This terraform project provision ready well architected S3 with bellow features:
-   Created S3 Bucket
-   Enabled Blocking Public Access to S3 bucket
-   Enabled Encryption on the previously created bucket
-   Created Two Custom IAM Roles and assigned them to Two Users
-   Role1: Allowing only for Read-Only access to Previously Created S3 Bucket
-   Role2: Allowing For Read-Write access to previously Created S3
-   Enabled Object Versioning Enabled on S3
-   Configured S3 Replication across the region
-   Created S3 Gateway Endpoint.
-   User with access for Create and modify EFS and connect to ec2 Instance

Files s3.tf, iam.tf are for s3 bucket
Files ec2.tf iam-for-efs.tf and sg.tf Are for provision user, ec2 instance sg roups for instruction of create EFS and efs replication

### Further manual actions

To enable MFA Delete you have to do below command by AWS CLI as Root user of account:

  

```md

aws s3api put-bucket-versioning --bucket nebo-bucket --versioning-configuration Status=Enabled,MFADelete=Enabled --mfa "SERIAL TOKEN"

```

  
  

## For EFS disk

  

After terraform apply:

  

1. Log to AWS console as newly created User "neboUser-efs"

(Before you log in you have to set console password for mentioned user)

2. Go to EFS service site: https://console.aws.amazon.com/efs

3. Click on orange button "Create file system"

  ![Create file system](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/1.png)

4. In new windows click "Customize"

  ![Customize](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/2.png)

5. Type name of you efs and click next on the bottom of site

  ![type name](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/3.png)

6. In this windows chose security group created by terraform "allow_nfs_for_efs" for every availability zone

  ![Security Groups](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/4.png)

7. Click Next in this window and also click next in window "File system policy" and in last windows "Review and create" click create on bottom of site

8. When you efs is created click on its name or ID

  ![efsID](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/5.png)

9. In this window click "Attach"

  ![attach](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/6.png)

10. Copy second command for mount nfs in instance

  ![copy command](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/7.png)

11. Go to ec2 service site: https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:instanceState=running

12. Connect to instance "NeboInstance"

  ![connect](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/8.png)

13. Choose option "EC2 Instance Connect" and press "Connect"

  ![Connectv2](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/9.png)

14. When you will be in instance console create folder "efs" and the run command copied from point 10.

  

```md

mkdir efs

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <ID  OF  YOUR  EFS>.efs.eu-west-1.amazonaws.com:/ efs

```

  

### Create replication

  

To create replication of efs back to efs site https://console.aws.amazon.com/efs

1. Check details of your efs like in point 8.

2. Press tab "Replication" and then Click "Create Replication"

![Create Replication](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/10.png)

4. Choose any other region which you already created efs and press "Create Replication"

  ![Choose region](https://raw.githubusercontent.com/HubGab-Git/provision_storage/main/images/11.png)

### Delete Replication

To delete Replication just go to details of your EFS, "Replication" Tab press "Delete Replication" button and confirm deletion.

Deletion can take few minutes after that you can delete your EFS disk and NeboInstance to save costs.