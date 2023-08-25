#!/bin/bash
set -e

printMessage() {
    printf "$1$1$1 $2 $1$1$1 - $3\n"
}

printf "
███╗   ██╗██╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗      ██████╗  ██████╗██████╗     ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗███████╗
████╗  ██║██║   ██║██║ ██╔╝██║████╗  ██║██╔════╝     ██╔════╝ ██╔════╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝██╔════╝
██╔██╗ ██║██║   ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗    ██║  ███╗██║     ██████╔╝    ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║   ███████╗
██║╚██╗██║██║   ██║██╔═██╗ ██║██║╚██╗██║██║   ██║    ██║   ██║██║     ██╔═══╝     ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║   ╚════██║
██║ ╚████║╚██████╔╝██║  ██╗██║██║ ╚████║╚██████╔╝    ╚██████╔╝╚██████╗██║         ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║   ███████║
╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚═════╝  ╚═════╝╚═╝         ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   ╚══════╝
"
printf "*********************************************************************************************************************************************\n"
# Array of GCP Projects which should not be automatically deleted
DO_NOT_DELETE_PROJECTS=("live-application", "gcp-projects-nuke")

printf "Getting the list of all project_ids that do not start with 'sys-*'\n"
# The sys-* projects are the gsuite/apps-script projects which shouldn't be deleted
ALL_GCP_PROJECTS=$(gcloud projects list --sort-by=projectId --filter="-projectId=sys-*" --format=json | jq -r '.[] | .projectId')

COUNTER=1
printf "Itterating over the list of GCP Projects\n"
printf "*********************************************************************************************************************************************\n"
for gcp_project in $ALL_GCP_PROJECTS
do
    if [[ " ${DO_NOT_DELETE_PROJECTS[*]} " =~ "$gcp_project" ]]; then
        printMessage "\xE2\x99\xA0" "$COUNTER" "Skipping Deletion of GCP Project ID: '$gcp_project' as it's in DO_NOT_DELETE_PROJECTS list"
        printf "\n"
    else
        printMessage "\xE2\x98\xA0" "$COUNTER" "Deleting GCP Project ID: $gcp_project"
        gcloud projects delete $gcp_project --quiet
        printMessage "\xE2\x98\xA0" "$COUNTER" "Deleted GCP Project ID: $gcp_project succesffully"
        printf "\n"
    fi
done
printf "*************************************************************************************************************************************************\n"
printf "
███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗██╗ ██████╗ ███╗   ██╗     ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗███████╗██████╗ 
██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██║██╔═══██╗████╗  ██║    ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██╔════╝██╔══██╗
█████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   ██║██║   ██║██╔██╗ ██║    ██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   █████╗  ██║  ██║
██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██║██║   ██║██║╚██╗██║    ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██╔══╝  ██║  ██║
███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ██║╚██████╔╝██║ ╚████║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   ███████╗██████╔╝
╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═════╝                                                                                                                                                                                                                                                                                             
"