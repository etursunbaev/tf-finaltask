#!/bin/bash
# 
# Builds a Docker image and pushes to an AWS ECR repository
#
# Invoked by the terraform-aws-ecr-docker-image Terraform module.
#
# Usage:
#
# # Acquire an AWS session token
# $ ./push.sh . 123456789012.dkr.ecr.us-west-1.amazonaws.com/hello-world latest
#

set -e

#source_path="$1"
repository_url=${repo_url}
tag="latest"

region="$(echo "$repository_url" | cut -d. -f4)"
image_name=${image_name}

#(cd "$source_path" && docker build -t "$image_name" .)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 298205446974.dkr.ecr.us-east-1.amazonaws.com/dynamo
docker pull $image_name
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"
docker tag "$image_name" "$repository_url":"$tag"
docker push "$repository_url":"$tag"