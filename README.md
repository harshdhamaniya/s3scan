# s3scan

A Tool to Check for Security Best Practises for S3 Buckets.

# Best practice rules for Amazon S3
AWS Simple Storage Service (S3) is a storage device for the Internet.
It has a web service that makes storage and retrieval simple at any time, 
from anywhere on the web, regardless of the amount of data. 
S3 is designed to make web-scale computing simple for developers by providing highly scalable,
fast, reliable and inexpensive data storage infrastructure.

This checker enforces the rules for S3 Best Practices Compliance listed by this page: 
https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/

In particular, it enforces that:

* Amazon Macie Finding Statistics for S3
Capture summary statistics about Amazon Macie security findings on a per-S3 bucket basis.

* DNS Compliant S3 Bucket Names
Ensure that Amazon S3 buckets always use DNS-compliant bucket names.

* Enable Encryption at Rest
Ensure that encryption at rest is enabled for your Amazon S3 buckets and their data.

* Enable MFA Delete for S3 Buckets
Ensure that MFA Delete feature is enabled for your Amazon S3 buckets.

* Enable S3 Block Public Access for AWS Accounts
Ensure that Amazon S3 public access is blocked at the AWS account level for data protection.

* Enable S3 Block Public Access for S3 Buckets
Ensure that Amazon S3 public access is blocked at the S3 bucket level for data protection.

* Enable S3 Bucket Keys
Ensure that Amazon S3 buckets are using S3 bucket keys to optimize service costs.

* Enable Server Access Logging for S3 Buckets
Ensure that Server Access Logging is enabled for your Amazon S3 buckets.

* Enable Versioning for S3 Buckets
Ensure that Amazon S3 object versioning is enabled for an additional level of data protection.

* S3 Bucket Authenticated Users 'FULL_CONTROL' Access
Ensure that S3 buckets do not allow FULL_CONTROL access to AWS authenticated users via ACLs.

* S3 Bucket Authenticated Users 'READ' Access
Ensure that S3 buckets do not allow READ access to AWS authenticated users via ACLs.

* S3 Bucket Authenticated Users 'READ_ACP' Access
Ensure that S3 buckets do not allow READ_ACP access to AWS authenticated users via ACLs.

* S3 Bucket Authenticated Users 'WRITE' Access
Ensure that S3 buckets do not allow WRITE access to AWS authenticated users via ACLs.

* S3 Bucket Authenticated Users 'WRITE_ACP' Access
Ensure that S3 buckets do not allow WRITE_ACP access to AWS authenticated users via ACLs.

Find More at https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/

## How to run the scanner

```
git clone https://github.com/harshdhamaniya/s3scan.git
chmod +x S3BucketScanner.sh
./S3BucketScanner.sh
```
