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
                                     
		$Yellow- Harsh Dhamaniya - @PyTh0n | Samuel Valmiki - @sign3tsh3l1"
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
	read -p "$Cyan[$Time] $Red[Alert]$White Enter S3 Bucket Region (Example ap-south-1): " region
	for r in ${region[@]}
	do
	aws configure set default.region $r
	echo -e "$Cyan[$Time] $Green[INFO]$White $i Bucket Region is set to: $Yellow" $r
	echo "$Cyan[$Time] $Yellow[NOTE]$White Fetching Account ID."
	aws sts get-caller-identity --output text &> accountid.txt
	accountid=`cut -c1-12 accountid.txt`
	echo "$Cyan[$Time] $Green[INFO]$White Account ID is Set to : " $accountid
	echo "$Cyan[$Time] $Green[INFO]$White Configuration Updated..!!"
	echo "$Cyan[$Time] $Yellow[Note]$White Fetching Buckets From DB.."
	sleep 1;
	aws s3api list-buckets --query "Buckets[].Name" --output table
	done
done;;

n ) echo -e "$Cyan[$Time] $Red[ALERT]$White AWS Keys Are Not Updated..!"
echo -e "$Cyan[$Time] $Green[INFO]$White Using Preconfigured Keys.."
echo "$Cyan[$Time] $Yellow[NOTE]$White Fetching Account ID."
aws sts get-caller-identity --output text &> accountid.txt
accountid=`cut -c1-12 accountid.txt`
echo "$Cyan[$Time] $Green[INFO]$White Account ID is Set to : " $accountid
echo "$Cyan[$Time] $Yellow[Note]$White Fetching Buckets From DB.."
sleep 1;
aws s3api list-buckets --query "Buckets[].Name" --output table
echo -e "$Cyan[$Time] $Yellow[NOTE]$White Please Configure AWS Keys to Mitigate False Positive Output";;
* ) echo -e "$Cyan[$Time] $Red[ALERT]$White AWS Keys Are Not Updated..!"
echo -e "$Cyan[$Time] $Green[INFO]$White Using Preconfigured Keys.."
echo "$Cyan[$Time] $Yellow[NOTE]$White Fetching Account ID."
aws sts get-caller-identity --output text &> accountid.txt
accountid=`cut -c1-12 accountid.txt`
echo "$Cyan[$Time] $Green[INFO]$White Account ID is Set to : " $accountid
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
read -p "$Cyan[$Time] $Red[Alert]$White Enter S3 Bucket Region (Example ap-south-1): " region
        for r in ${region[@]}
        do
        aws configure set default.region $r
        echo -e "$Cyan[$Time] $Green[INFO]$White $i Bucket Region is set to: $Yellow" $r
done
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
echo -e "$Green: Scanned Successfully "
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  DNS Compliant S3 Bucket Names Scanning.."
aws s3api list-buckets	--query 'Buckets[*].Name' &> "$i/DNS Compliant S3 Bucket Names"
grep -q '[^[:space:]]' "$i/DNS Compliant S3 Bucket Names" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
bucketname=$( grep -ic "\." "$i/DNS Compliant S3 Bucket Names" )
if [ $bucketname -eq 1 ]
	then
                status="$Red Failed"
                else
                status="$Green Passed"
fi

echo -e "$Green Scanned Successfully - $Cyan $status"
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Encryption at Rest Scanning.."
aws s3api get-bucket-encryption --bucket $i &> "$i/Enable Encryption at Rest"
value=$( grep -ic "ServerSideEncryptionConfigurationNotFoundError" "$i/Enable Encryption at Rest" )
grep -q '[^[:space:]]' "$i/Enable Encryption at Rest" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable Encryption at Rest" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"
#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable MFA Delete for S3 Buckets Scanning.."
aws s3api get-bucket-versioning --bucket $i --query 'MFADelete' &> "$i/Enable MFA Delete for S3 Buckets"
value=$( grep -ic -e "null" -e "None" "$i/Enable MFA Delete for S3 Buckets" )
grep -q '[^[:space:]]' "$i/Enable MFA Delete for S3 Buckets" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable MFA Delete for S3 Buckets" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"
#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Block Public Access for AWS Accounts Scanning.."
aws s3control get-public-access-block --region $r --account-id $accountid &> "$i/Enable S3 Block Public Access for AWS Accounts"
value=$( grep -ic -e "NoSuchPublicAccessBlockConfiguration" -e "false" "$i/Enable S3 Block Public Access for AWS Accounts" )
grep -q '[^[:space:]]' "$i/Enable S3 Block Public Access for AWS Accounts" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable S3 Block Public Access for AWS Accounts" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Block Public Access for S3 Buckets Scanning.."
aws s3api get-public-access-block --bucket $i --query 'PublicAccessBlockConfiguration' &> "$i/Enable S3 Block Public Access for S3 Buckets"
value=$( grep -ic -e "NoSuchPublicAccessBlockConfiguration" -e "false" "$i/Enable S3 Block Public Access for S3 Buckets" )
grep -q '[^[:space:]]' "$i/Enable S3 Block Public Access for S3 Buckets" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable S3 Block Public Access for S3 Buckets" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Green Passed"
		else
		status="$Red Failed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"
# 
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Versioning for S3 Buckets Scanning.."
aws s3api get-bucket-versioning --bucket $i --query 'Status' &> "$i/Enable Versioning for S3 Buckets"
value=$( grep -ic -e "null" -e "Suspended" -e "None" "$i/Enable Versioning for S3 Buckets" )
grep -q '[^[:space:]]' "$i/Enable Versioning for S3 Buckets" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable Versioning for S3 Buckets" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users FULL CONTROL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users FULL CONTROL Access"
value=$( grep -ic -e '\[]' -e '"Permission": "FULL_CONTROL"' "$i/S3 Bucket Authenticated Users FULL CONTROL Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Authenticated Users FULL CONTROL Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Authenticated Users FULL CONTROL Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#


echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable S3 Bucket Keys Scanning.."
aws s3api get-bucket-encryption --bucket $i --query 'ServerSideEncryptionConfiguration.Rules[?ApplyServerSideEncryptionByDefault.SSEAlgorithm==`aws:kms`].BucketKeyEnabled' &> "$i/Enable S3 Bucket Keys"
value=$( grep -ic -e "false" -e '\[]' -e "ServerSideEncryptionConfigurationNotFoundError" "$i/Enable S3 Bucket Keys" )
grep -q '[^[:space:]]' "$i/Enable S3 Bucket Keys" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable S3 Bucket Keys" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#


echo -e "$Cyan[$Time] $Yellow[TASK]$White  Enable Server Access Logging for S3 Buckets Scanning.."
aws s3api get-bucket-logging --bucket $i --query 'LoggingEnabled' &> "$i/Enable Server Access Logging for S3 Buckets"
value=$( grep -ic -e "null" -e "None" "$i/Enable Server Access Logging for S3 Buckets" )
grep -q '[^[:space:]]' "$i/Enable Server Access Logging for S3 Buckets" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Enable Server Access Logging for S3 Buckets" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#


echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users READ Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Authenticated Users READ Access"
value=$( grep -ic -e '"Permission": "READ"' -e '\[]' "$i/S3 Bucket Authenticated Users READ Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Authenticated Users READ Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Authenticated Users READ Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users READ ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users READ ACP Access"
value=$( grep -ic -e '"Permission": "READ_ACP"' -e '\[]' "$i/S3 Bucket Authenticated Users READ ACP Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Authenticated Users READ ACP Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Authenticated Users READ ACP Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users WRITE Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users WRITE Access"
value=$( grep -ic -e '"Permission": "WRITE"' -e '\[]' "$i/S3 Bucket Authenticated Users WRITE Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Authenticated Users WRITE Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Authenticated Users WRITE Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Authenticated Users WRITE ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AuthenticatedUsers`)]' &> "$i/S3 Bucket Authenticated Users WRITE ACP Access"
value=$( grep -ic -e '"Permission": "WRITE_ACP"' -e '\[]' "$i/S3 Bucket Authenticated Users WRITE ACP Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Authenticated Users WRITE ACP Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Authenticated Users WRITE ACP Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public FULL CONTROL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public FULL CONTROL Access"
value=$( grep -ic -e '"Permission": "FULL_CONTROL"' -e '\[]' "$i/S3 Bucket Public FULL CONTROL Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public FULL CONTROL Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public FULL CONTROL Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public READ Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public READ Access"
value=$( grep -ic -e '"Permission": "READ"' -e '\[]' "$i/S3 Bucket Public READ Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public READ Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public READ Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public READ ACP Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public READ ACP Access"
value=$( grep -ic -e '"Permission": "READ_ACP"' -e '\[]' "$i/S3 Bucket Public READ ACP Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public READ ACP Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public READ ACP Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public WRITE ACL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public WRITE ACL Access"
value=$( grep -ic -e '"Permission": "WRITE"' -e '\[]' "$i/S3 Bucket Public WRITE ACL Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public WRITE ACL Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public WRITE ACL Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public WRITE ACP ACL Access Scanning.."
aws s3api get-bucket-acl --bucket $i --query 'Grants[?(Grantee.URI==`http://acs.amazonaws.com/groups/global/AllUsers`)]' &> "$i/S3 Bucket Public WRITE ACP ACL Access"
value=$( grep -ic -e '"Permission": "WRITE_ACP"' -e '\[]' "$i/S3 Bucket Public WRITE ACP ACL Access" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public WRITE ACP ACL Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public WRITE ACP ACL Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Bucket Public Access Via Policy Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text > bucket-policy.json &> "$i/S3 Bucket Public Access Via Policy"
value=$( grep -ic -e '"Effect":"Allow"' -e '"Principal":"*"' -e '"AWS":"*"' -e 'NoSuchBucketPolicy' "$i/S3 Bucket Public Access Via Policy" )
grep -q '[^[:space:]]' "$i/S3 Bucket Public Access Via Policy" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Bucket Public Access Via Policy" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets Encrypted with Customer-Provided CMKs Scanning.."
aws s3api get-bucket-encryption --bucket $i --query 'ServerSideEncryptionConfiguration.Rules[*].ApplyServerSideEncryptionByDefault' &> "$i/S3 Buckets Encrypted with Customer-Provided CMKs"
value=$( grep -ic -e '"SSEAlgorithm": "AES256"' -e 'ServerSideEncryptionConfigurationNotFoundError' -e '"SSEAlgorithm": "aws:kms"||"KMSMasterKeyID": "arn:aws:kms:' "$i/S3 Buckets Encrypted with Customer-Provided CMKs" )
grep -q '[^[:space:]]' "$i/S3 Buckets Encrypted with Customer-Provided CMKs" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Buckets Encrypted with Customer-Provided CMKs" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets Lifecycle Configuration Scanning.."
aws s3api get-bucket-lifecycle-configuration --bucket $i --query 'Rules' &> "$i/S3 Buckets Lifecycle Configuration"
value=$( grep -ic -e 'NoSuchLifecycleConfiguration' -e '"Status": "Disabled"' "$i/S3 Buckets Lifecycle Configuration" )
grep -q '[^[:space:]]' "$i/S3 Buckets Lifecycle Configuration" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Buckets Lifecycle Configuration" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Buckets with Website Hosting Configuration Enabled Scanning.."
aws s3api get-bucket-website --bucket $i &> "$i/S3 Buckets with Website Hosting Configuration Enabled"
value=$( grep -ic -e 'NoSuchWebsiteConfiguration' -e '"Suffix": "index.html"' "$i/S3 Buckets with Website Hosting Configuration Enabled" )
grep -q '[^[:space:]]' "$i/S3 Buckets with Website Hosting Configuration Enabled" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Buckets with Website Hosting Configuration Enabled" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Configuration Changes Scanning.."
echo -e "$Cyan[$Time]$Red[ERROR]$Yellow S3 Configuration Changes :$White AWS Cli Rules not Available"
echo -e "$Cyan[$Time]$Red[ERROR]$White Please Reference : https://www.trendmicro.com/cloudoneconformity/knowledge-base/aws/S3/configuration-changes.html"
#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Cross Account Access Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text &> "$i/S3 Cross Account Access"
value=$( grep -ic '"Effect":"Allow"' "$i/S3 Cross Account Access" )
grep -q '[^[:space:]]' "$i/S3 Cross Account Access" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Cross Account Access" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Object Lock Scanning.."
aws s3api get-object-lock-configuration --bucket $i --query 'ObjectLockConfiguration.ObjectLockEnabled' &>  "$i/S3 Object Lock"
value=$( grep -ic "ObjectLockConfigurationNotFoundError" "$i/S3 Object Lock" )
grep -q '[^[:space:]]' "$i/S3 Object Lock" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Object Lock" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  S3 Transfer Acceleration Scanning.."
aws s3api get-bucket-accelerate-configuration --bucket $i --query 'Status' &> "$i/S3 Transfer Acceleration"
value=$( grep -ic -e 'null' -e '"Suspended"' "$i/S3 Transfer Acceleration" )
grep -q '[^[:space:]]' "$i/S3 Transfer Acceleration" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/S3 Transfer Acceleration" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Secure Transport Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text &> "$i/Secure Transport"
value=$( grep -ic -e '"Condition":{ "Bool":{ "aws:SecureTransport":"false"}}"' -e '"Effect":"Allow"' -e 'NoSuchBucketPolicy' "$i/Secure Transport" )
grep -q '[^[:space:]]' "$i/Secure Transport" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Secure Transport" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#
echo -e "$Cyan[$Time] $Yellow[TASK]$White  Server Side Encryption Scanning.."
aws s3api get-bucket-policy --bucket $i --query Policy --output text > s3-bucket-access-policy.json &> "$i/Server Side Encryption" 
value=$( grep -ic -e '"NoSuchBucketPolicy' -e 'ServerSideEncryptionConfigurationNotFoundError' "$i/Server Side Encryption" )
grep -q '[^[:space:]]' "$i/Server Side Encryption" || echo "$Cyan[$Time] $Red[Alert]$Yellow Empty Response from AWS"
auth=$( grep -ic "Access Denied" "$i/Server Side Encryption" )

if [ $auth -eq 0 ]
  then
	if [ $value -eq 1 ]
		then
		status="$Red Failed"
		else
		status="$Green Passed"
    fi
else  
        status="Auth Failed"
fi
echo -e "$Green Scanned Successfully - $Cyan $status"

#
#
#
#
#
#
#

echo "$Yellow[*] Pʟᴇᴀsᴇ Aɴᴀʟʏsᴇ ᴛʜᴇ ʀᴇsᴜʟᴛs sᴀᴠᴇᴅ ɪɴ in $i Dɪʀᴇᴄᴛᴏʀʏ"
echo "$Cyan[$Time] $Green[INFO]$White Sᴄᴀɴ Cᴏᴍᴘʟᴇᴛᴇᴅ"
done