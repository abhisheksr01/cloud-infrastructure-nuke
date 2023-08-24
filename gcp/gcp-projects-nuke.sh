#!/bin/bash
set -e

# Array of GCP Projects which should not be automatically deleted
DO_NOT_DELETE_PROJECTS=("live-application", "gcp-projects-nuke")

ALL_GCP_PROJECTS=$(gcloud projects list --format=json | jq -r '.[] | .projectId')
echo ">>>>>>  Executing gcp-projects-nuke.sh <<<<<<<"

for gcp_project in $ALL_GCP_PROJECTS
do
    if [[ " ${DO_NOT_DELETE_PROJECTS[*]} " =~ "$gcp_project" ]]; then
        echo "### Skipping Deletion of GCP Project: '$gcp_project' from DO NOT DELETE list ###"
    else
        echo "*** NOT - Deleting GCP Project: $gcp_project ***"
        gcloud projects delete $gcp_project --quiet
        echo "*** NOT - Deleted GCP Project: $gcp_project succesffully ***"
    fi
done
echo ">>>>>>  Execution of gcp-projects-nuke.sh completed <<<<<<<"