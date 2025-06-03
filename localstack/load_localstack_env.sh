#!/bin/bash

# Script to load LocalStack environment variables from .env.localstack

ENV_FILE=".env.localstack"

if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from $ENV_FILE..."
  echo "LocalStack environment variables loaded."
else
  echo "Error: $ENV_FILE not found. Please create it."
  exit 1
fi

echo "AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID"
echo "AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION"
echo "AWS_ENDPOINT_URL: $AWS_ENDPOINT_URL"
