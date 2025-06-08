#!/bin/bash

# Check for necessary environment variables
if [ -z "$GITHUB_ACCOUNT" ]; then
    echo "Error: GITHUB_ACCOUNT is not set. Please define it in the environment."
    exit 1
fi

if [ -z "$GITHUB_REPO_NAME" ]; then
    echo "Error: GITHUB_REPO_NAME is not set. Please define it in the environment."
    exit 1
fi


if [ -z "$GITHUB_PAT_KEY" ]; then
    echo "Error: GITHUB_PAT_KEY is not set. Please define it in the environment."
    exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not set. Please define it in the environment."
    exit 1
fi

echo "All environment variables are set. Proceeding with setup."
