#!/bin/bash

# Variables
BUCKET_NAME=$1
REGION=$2

if [ -z "$BUCKET_NAME" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <bucket-name> <region>"
  exit 1
fi

# List all S3 buckets in the given region
BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text --region "$REGION")

# Check if the bucket with the given name already exists
if echo "$BUCKETS" | grep -wq "$BUCKET_NAME"; then
  echo "Bucket '$BUCKET_NAME' already exists."
else
  # Create the S3 bucket
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION"

  if [ $? -eq 0 ]; then
    echo "Bucket '$BUCKET_NAME' created successfully."
  else
    echo "Failed to create bucket '$BUCKET_NAME'."
  fi
fi
