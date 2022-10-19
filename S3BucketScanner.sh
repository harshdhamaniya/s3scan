#!/usr/bin/bash

# Colors and Date and Time Variables //
Green=$'\e[1;32m'
Red=$'\e[1;31m'
Blue=$'\e[1;34m'
Cyan=$'\e[1;36m'
White=$'\e[1;37m'
Yellow=$'\e[1;33m'
BGreen=$'\e[1;92m'
Purple='\033[1;35m'
Time=$(date +"%T")
Date=$(date '+%Y-%m-%d')

#Introductory Message //

echo -e "$BGreen                                      $Yellow Amazon $Green

███████████████████████████████████████████████████████████████████████████████████████████████████
█─▄▄▄▄█▄▄▄░███▄─▄─▀█▄─██─▄█─▄▄▄─█▄─█─▄█▄─▄▄─█─▄─▄─███─▄▄▄▄█─▄▄▄─██▀▄─██▄─▀█▄─▄█▄─▀█▄─▄█▄─▄▄─█▄─▄▄▀█
█▄▄▄▄─██▄▄░████─▄─▀██─██─██─███▀██─▄▀███─▄█▀███─█████▄▄▄▄─█─███▀██─▀─███─█▄▀─███─█▄▀─███─▄█▀██─▄─▄█
▀▄▄▄▄▄▀▄▄▄▄▀▀▀▄▄▄▄▀▀▀▄▄▄▄▀▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▀▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▀▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀ 
                                     
				$Yellow- Harsh Dhamaniya"
echo -e "$Blue[INFO]$White Reference : https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/"

# Checking if AWS CLI Package is installed in the machine or not //

echo -e "$Cyan[$Time] $Yellow[NOTE] Checking for AWS CLI Package..."
sleep 1;
if ! which aws > /dev/null
then
echo -e "$Cyan[$Time] $Red[ALERT]$White AWS CLI is Not Installed.! Install it Now? (Press Enter Else Katti) \c"
read
sudo -s apt-get install awscli -y &> /dev/null
echo "$Cyan[$Time] $Green[INFO]$White$White AWS CLI is installed..!!"
else echo "$Cyan[$Time] $Green[INFO]$White AWS CLI is installed Proceeding..!"
fi

#Asking User Prompt Input for AWS Keys Configuration //

read -p "Do You Want to Update AWS Access Key and Secret Access Key Configuration (y/n): " yn
case $yn in
y ) for l in ${yn[@]}
do
	read -p "$Cyan[$Time] $Red[Alert]$White Please Enter Access Key: " accesskey
	aws configure set aws_access_key_id $accesskey &> /dev/null
	read -p "$Cyan[$Time] $Red[Alert]$White Please Enter Secret Access Key: " secretaccesskey
	aws configure set aws_secret_access_key $secretaccesskey &> /dev/null
	echo "$Cyan[$Time] $Green[INFO]$White Configuration Updated..!!"
	echo "$Cyan[$Time] $Yellow[Note]$White Fetching Buckets From DB.."
	sleep 1;
	aws s3api list-buckets --query "Buckets[].Name" --output table
done;;
n ) echo -e "$Cyan[$Time] $Red[ALERT]$White AWS Keys Are Not Updated..!"
echo -e "$Cyan[$Time] $Green[INFO]$White Using Preconfigured Keys.."
echo "$Cyan[$Time] $Yellow[Note]$White Fetching Buckets From DB.."
sleep 1;
aws s3api list-buckets --query "Buckets[].Name" --output table
echo -e "$Cyan[$Time] $Yellow[NOTE]$White Please Configure AWS Keys to Mitigate False Positive Output";;
* ) echo -e "$Cyan[$Time] $Red[ALERT]$White AWS Keys Are Not Updated..!"
echo -e "$Cyan[$Time] $Green[INFO]$White Using Preconfigured Keys.."
echo "$Cyan[$Time] $Yellow[Note]$White Fetching Buckets From DB.."
sleep 1;
aws s3api list-buckets --query "Buckets[].Name" --output table
echo -e "$Cyan[$Time] $Yellow[NOTE]$White Please Configure AWS Keys to Mitigate False Positives Results";;
esac

# Asking User Bucket Name and Region //

read -p "$Cyan[$Time] $Red[Alert]$White Enter S3 Bucket Name: " input
for i in ${input[@]}
do
	mkdir "$i"
	echo -e "$Cyan[$Time] $Green[INFO]$White S3 Bucket is Set to: $Yellow" $i
done
read -p "$Cyan[$Time] $Red[Alert]$White Enter S3 Bucket Region (Example ap-south-1): " region
for r in ${region[@]}
do
 aws configure set default.region $r
 echo -e "$Cyan[$Time] $Green[INFO]$White $i Bucket Region is set to: $Yellow" $r
 echo "$Cyan[$Time] $Yellow[NOTE]$White Fetching Account ID."
 aws sts get-caller-identity --output text &> accountid.txt
 accountid=`cut -c1-12 accountid.txt`
 echo "$Cyan[$Time] $Green[INFO]$White Account ID is Set to : " $accountid
# Scan Started //

echo "[*] Starting S3 Bucket Scan for $i @$Time/$Date"
spinner=( '|' '/' '-' '\' ); 
count(){
  spin &
  pid=$!
 
  for j in `seq 1 3`
  do
    sleep 1;
  done
 
  kill $pid  
}
 
spin(){
  while [ 1 ]
  do 
    for j in ${spinner[@]}; 
    do 
      echo -ne "\r$j";
      sleep 0.2;
    done;
  done
}
 
count
echo ""
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Amazon Macie Finding Statistics for S3 Scanning.."
aws macie2 get-finding-statistics --region $r --group-by resourcesAffected.s3Bucket.name &> "$i/Amazon Macie Finding Statistics for S3.txt"
echo -e "$White Amazon Macie Finding Statistics for S3 Scanning $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  DNS Compliant S3 Bucket Names Scanning.."
aws s3api list-buckets	--query 'Buckets[*].Name' &> "$i/DNS Compliant S3 Bucket Names"
echo -e "$White DNS Compliant S3 Bucket Names Scanning $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Encryption at Rest Scanning.."
aws s3api get-bucket-encryption --bucket $i &> "$i/Enable Encryption at Rest.txt"
echo -e "$White Enable Encryption at Rest Scanning $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable MFA Delete for S3 Buckets Scanning.."
aws s3api get-bucket-versioning --bucket $i --query 'MFADelete' &> "$i/Enable MFA Delete for S3 Buckets"
echo -e "$White Enable MFA Delete for S3 Buckets Scanning $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Block Public Access for AWS Accounts Scanning.."
aws s3control get-public-access-block --region $r --account-id $accountid &> "$i/Enable S3 Block Public Access for AWS Accounts"
echo -e "$White Enable S3 Block Public Access for AWS Accounts Scanning $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Block Public Access for S3 Buckets Scanning.."
aws s3api get-public-access-block --bucket $i --query 'PublicAccessBlockConfiguration' &> "$i/Enable S3 Block Public Access for S3 Buckets"
echo -e "$White Enable S3 Block Public Access for S3 Buckets $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Versioning for S3 Buckets Scanning.."
aws s3api get-bucket-versioning --bucket $i --query 'Status' &> "$i/Enable Versioning for S3 Buckets"
echo -e "$White Enable Versioning for S3 Buckets $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users FULL CONTROL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users FULL CONTROL Access"
echo -e "$White S3 Bucket Authenticated Users FULL CONTROL Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Bucket Keys Scanning.."
aws s3api get-bucket-encryption --bucket $i --query 'ServerSideEncryptionConfiguration.Rules[?ApplyServerSideEncryptionByDefault.SSEAlgorithm==`aws:kms`].BucketKeyEnabled' &> "$i/Enable S3 Bucket Keys"
echo -e "$White Enable S3 Bucket Keys $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Server Access Logging for S3 Buckets Scanning.."
aws s3api get-bucket-logging --bucket $i --query 'LoggingEnabled' &> "$i/Enable Server Access Logging for S3 Buckets"
echo -e "$White Enable Server Access Logging for S3 Buckets $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users READ Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users READ Access"
echo -e "$White S3 Bucket Authenticated Users READ Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users READ ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users READ ACP Access"
echo -e "$White S3 Bucket Authenticated Users READ ACP Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users WRITE Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users WRITE Access"
echo -e "$White S3 Bucket Authenticated Users WRITE Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users WRITE ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users WRITE ACP Access"
echo -e "$White S3 Bucket Authenticated Users WRITE ACP Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public FULL CONTROL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public FULL CONTROL Access"
echo -e "$White S3 Bucket Public FULL CONTROL Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public READ Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public READ Access"
echo -e "$White S3 Bucket Public READ Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public READ ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public READ ACP' Access"
echo -e "$White S3 Bucket Public READ ACP Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public WRITE ACL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public WRITE ACL Access"
echo -e "$White S3 Bucket Public WRITE ACL Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public WRITE ACP ACL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public WRITE ACP ACL Access"
echo -e "$White S3 Bucket Public WRITE ACP ACL Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public Access Via Policy Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text > bucket-policy.json &> "$i/S3 Bucket Public Access Via Policy"
echo -e "$White S3 Bucket Public Access Via Policy $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets Encrypted with Customer-Provided CMKs Scanning.."
aws s3api get-bucket-encryption --bucket $i --query 'ServerSideEncryptionConfiguration.Rules[*].ApplyServerSideEncryptionByDefault' &> "$i/S3 Buckets Encrypted with Customer-Provided CMKs"
echo -e "$White S3 Buckets Encrypted with Customer-Provided CMKs $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets Lifecycle Configuration Scanning.."
aws s3api get-bucket-lifecycle-configuration --bucket $i --query 'Rules' &> "$i/S3 Buckets Lifecycle Configuration"
echo -e "$White S3 Buckets Lifecycle Configuration $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets with Website Hosting Configuration Enabled Scanning.."
aws s3api get-bucket-website --bucket $i &> "$i/S3 Buckets with Website Hosting Configuration Enabled"
echo -e "$White S3 Buckets with Website Hosting Configuration Enabled $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Configuration Changes Scanning.."
echo -e "$Cyan[$Time]$Red[ERROR]$Yellow S3 Configuration Changes :$White AWS Cli Rules not Available"
echo -e "$Cyan[$Time]$Red[ERROR]$White Please Reference : https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/configuration-changes.html"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Cross Account Access Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text &> "$i/S3 Cross Account Access"
echo -e "$White S3 Cross Account Access $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Object Lock Scanning.."
aws s3api get-object-lock-configuration --bucket $i --query 'ObjectLockConfiguration.ObjectLockEnabled' &>  "$i/S3 Object Lock"
echo -e "$White S3 Object Lock $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Transfer Acceleration Scanning.."
aws s3api get-bucket-accelerate-configuration --bucket $i --query 'Status' &> "$i/S3 Transfer Acceleration"
echo -e "$White S3 Transfer Acceleration $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Secure Transport Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text &> "$i/Secure Transport"
echo -e "$White Secure Transport $Green: Scanned Successfully"
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Server Side Encryption Scanning.."
aws s3api get-bucket-policy --bucket cc-client-data --query Policy --output text > s3-bucket-access-policy.json &> "$i/Server Side Encryption" 
echo -e "$White Server Side Encryption $Green: Scanned Successfully"

echo "$Yellow[*] Pʟᴇᴀsᴇ Aɴᴀʟʏsᴇ ᴛʜᴇ ʀᴇsᴜʟᴛs sᴀᴠᴇᴅ ɪɴ in $i Dɪʀᴇᴄᴛᴏʀʏ"
echo "$Cyan[$Time] $Green[INFO]$White Sᴄᴀɴ Cᴏᴍᴘʟᴇᴛᴇᴅ"

done