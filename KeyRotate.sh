#!/bin/bash 
#This script is used to automate manual rotation of the KMS key"
#Asks for Alias Name of the existing key that is to be rotated.
#Created BY- Inderpal Singh Version- 1.0
read -p "Enter Alias Name: "  aliasNm
#set the aliasName to the argument passed from the command line. if not run interactively.
if [ -z "$aliasNm"];
then
	aliasNm=$1
fi
echo "Getting Key ID for the existing key attached to the Alias"
KmsKeyId=$(aws kms describe-key --key-id alias/$aliasNm --query "KeyMetadata.KeyId" --output=text)
#Check whether there is any existing key for the entered Alias 
if [ -z "$KmsKeyId" ];
then
	echo "No such key alias found"
else
	echo "Getting policies attached to the key" $KmsKeyId
	policyList=$(aws kms list-key-policies --key-id $KmsKeyId --query "PolicyNames" --output=text)
	echo "Policies attached to the key is/are--" $policyList
	echo "Downloading the key policy attached to the existing key"
	for val in $policyList; do
		echo $val
		keyPolicy=$(aws kms get-key-policy --policy-name $val --key-id $KmsKeyId --query "Policy" --output text > $val.txt)
	done
	#Check to ensure no error in downloading key policy.
	lastcmdsuccess=$?
	if [ $lastcmdsuccess -eq 0 ]; 
	then
		echo "Creating New KMS CMK"
		NewKmsKeyId=$(aws kms create-key --query "KeyMetadata.KeyId" --output=text)
		for val in $policyList; do
			echo "Attaching policy " $val " to the new key"
			aws kms put-key-policy --policy-name $val --key-id $NewKmsKeyId --policy file://$val.txt
		done
		echo "Enabling Auto Key Rotation for the new Key."
		aws kms enable-key-rotation --key-id $NewKmsKeyId
		echo "Attaching Alias to the Generated Key ID" $NewKmsKeyId
		aws kms update-alias --alias-name 'alias/'$aliasNm --target-key-id $NewKmsKeyId
		echo "Alias successfully attached to new key."
		echo "Disabling the previous key."
		aws kms disable-key --key-id $KmsKeyId
		echo "Key Rotation has been done."
	else
		echo "An error occured while listing policy."
	fi	
fi

