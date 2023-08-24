#!/usr/bin/env bash
# set -e

emojiFunction() {
  printf "\033[92m"
  for i in {1..150}; do
    printf "$1"
  done
  printf '\n'
}

displayExecutionLogs() {
  emojiFunction "\xE2\x99\xA0"
  emojiFunction "\xE2\x99\xA0"
  printf "\033[92m"
  echo "AWS Nuke executed successfully and the number of recources it $2 are :"
  grep -E "Scan complete|Nuke complete" "$1"-nuke.log
  emojiFunction "\xE2\x99\xA0"
  echo "The filtered resources are not displayed in the console for performance perspective."
  echo "For detailed execution logs, download '$1-nuke.log' & '$1-nuke-error.log' artifact which contains stdout and error logs."
  echo "'$1-nuke-error.log' must be reviewed for any potential execution errors."
  emojiFunction "\xE2\x99\xA0"
  echo "Listing down all the resources AWS Nuke $2 :"
  emojiFunction "\xE2\x99\xA0"
  grep "$2" "$1"-nuke.log
  echo "*** If the list of recources is empty it means no resources are available to be nuked. ***"
  emojiFunction "\xE2\x99\xA0"
  echo "Listed all the nukeable resources successfully."
  emojiFunction "\xE2\x99\xA0"
  emojiFunction "\xE2\x99\xA0"
}

echo "Installing all the dependencies"
make aws-nuke-install-linux

echo "Assuming AWS role for running aws nuke on $1 account."
aws sts assume-role --role-arn "$ASSUME_ROLE_ARN" --role-session-name \
"$1-account-aws-nuke-session" --query "Credentials" > $line.json;
ACCESS_KEY_ID=$(cat $line.json | jq -r .AccessKeyId);
SECRET_ACCESS_KEY=$(cat $line.json | jq -r .SecretAccessKey);
SESSION_TOKEN=$(cat $line.json | jq -r .SessionToken)

echo "changing dir to ./aws/nuke-configs"
cd ./aws/nuke-configs

echo "Executing AWS Nuke on $1 account...."
aws-nuke -c "$1"-account.yml --force --quiet --no-dry-run --access-key-id $ACCESS_KEY_ID \
--secret-access-key $SECRET_ACCESS_KEY --session-token $SESSION_TOKEN > "$1"-nuke.log 2> "$1"-nuke-error.log
  
displayExecutionLogs "$1" "removed"
