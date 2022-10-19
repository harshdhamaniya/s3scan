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

## How to run the scanner

```
git clone https://github.com/harshdhamaniya/s3scan.git
chmod +x S3BucketScanner.sh
./S3BucketScanner.sh
```

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

* S3 Bucket Public 'FULL_CONTROL' Access
Ensure that your Amazon S3 buckets are not publicly exposed to the Internet.

* S3 Bucket Public 'READ' Access
Ensure that S3 buckets do not allow public READ access via Access Control Lists (ACLs).

* S3 Bucket Public 'READ_ACP' Access
Ensure that S3 buckets do not allow public READ_ACP access via Access Control Lists (ACLs).

* S3 Bucket Public 'WRITE' ACL Access
Ensure S3 buckets don’t allow public WRITE ACL access

* S3 Bucket Public 'WRITE_ACP' Access
Ensure that S3 buckets do not allow public WRITE_ACP access via Access Control Lists (ACLs).

* S3 Bucket Public Access Via Policy
Ensure AWS S3 buckets do not allow public access via bucket policies.

* S3 Buckets Encrypted with Customer-Provided CMKs
Ensure that Amazon S3 buckets are encrypted with customer-provided KMS CMKs.

* S3 Buckets Lifecycle Configuration
Ensure that lifecycle configuration is enabled for your Amazon S3 buckets.

* S3 Buckets with Website Hosting Configuration Enabled
Ensure that the S3 buckets with website configuration are regularly reviewed (informational).

* S3 Configuration Changes
AWS S3 configuration changes have been detected within your Amazon Web Services account.

* S3 Cross Account Access
Ensure that S3 buckets do not allow unknown cross-account access via bucket policies.

* S3 Object Lock
Ensure that S3 buckets use Object Lock for data protection and/or regulatory compliance.

* S3 Transfer Acceleration
Ensure that S3 buckets use the Transfer Acceleration feature for faster data transfers.

* Secure Transport
Ensure that Amazon S3 buckets enforce encryption in transit to secure S3 data.

* Server Side Encryption
Ensure AWS S3 buckets enforce Server-Side Encryption (SSE)

Find More at https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/
