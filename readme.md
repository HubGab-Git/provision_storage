

### Further manual actions
To enable MFA Delete you have to do below command by AWS CLI as Root user of account:

```md
aws s3api put-bucket-versioning --bucket nebo-bucket --versioning-configuration Status=Enabled,MFADelete=Enabled --mfa "SERIAL TOKEN"
```