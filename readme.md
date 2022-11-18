

### Further manual actions 
To enable MFA Delete you have to do below command by AWS CLI as Root user of account:

```md
aws s3api put-bucket-versioning --bucket nebo-bucket --versioning-configuration Status=Enabled,MFADelete=Enabled --mfa "SERIAL TOKEN"
```


## For EFS disk

After terraform apply:

1. Log to AWS console as newly created User "neboUser-efs"
    (Before you log in you have to set console passwod for mentioned user)
2. Go to EFS service site: https://console.aws.amazon.com/efs
3. Click on orange button "Create file system"

4. In new windows click "Customize"

5. Type name of you efs and click next on the bottom of site

6. In this windows chose security group created by terraform "allow_nfs_for_efs" for every avalibility zone

7. Click Next in this window and also click next in window "File system policy" and in last windows "Review and create" click create on bottom of site
8. When you efs is created click on its name or ID

9. In this window click "Attach"

10. Copy second command for mount nfs in instance

11. Go to ec2 service site: https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:instanceState=running
12. Connect to instance "NeboInstance" 

13. Choose option "EC2 Instance Connect" and press "Connect" 

14. When you will be in instance console create folder "efs" and the run command copied from point 10. 

```md
mkdir efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <ID OF YOUR EFS>.efs.eu-west-1.amazonaws.com:/ efs
```

### Create replication

To create reoplication of efs back to efs site https://console.aws.amazon.com/efs
1. Check details of your efs like in point 8. 
2. Press tab "Replication" and then Click "Create Replication"
3. Choose any other region which you alredy created efs and press "Create Replication"

### Delete Replication
To delete Replication just go to details of your EFS, "Replication" Tab press "Delete Replication" button and confirm deletion.
Deletion can take few minutes after that you can delete your EFS disk and NeboInstance to save costs.
