#!/bin/bash

# Read configuration from the file
ls -lsrt
pwd

source /install/config.sh

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "    -s, --sprint-name             Application name comma separated like: all or admin,edw"
  echo "    -ns, --new-sprint-name       Application name comma separated like: all or admin,edw"
  echo "    -v, --version                Specify the version (e.g., 5.9.1)"
  echo "    -p, --project-name           Specify the project name"
  echo "    -st, --status                Specify the status"
  echo "    -h, --help                   Display usage information"
  echo ""
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
  case "$1" in
  -s | --sprint-name)              # Specify the current sprint name (e.g., INS 5.9.1)
    param_s="$2"
    shift 2
    ;;
  -ns | --new-sprint-name)        # Specify the new sprint name (e.g., INS 5.9.2)
    param_ns="$2"
    shift 2
    ;;
  -p | --project-name)            # Specify the project name 
    PROJECT_NAME="$2"
    shift 2
    ;;
  -st | --status)
    STATUS="$2"
    shift 2
   ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Invalid option: $1" >&2
    exit 1
    ;;
  esac
done


# Set your API variables
# API_BASE_URL="https://nishasalunke.atlassian.net/"
# CONF_API_BASE_URL="https://nishasalunkee.atlassian.net"
URL2="https://inferyx.atlassian.net/" 
# PROJECT_NAME="JJ"
PROJECT_NAME2="Inferyx Platform Engineering"
SPRINT_NAME="$param_s"
NEW_SPRINT_NAME="$param_ns"
NEW_VERSION="${NEW_SPRINT_NAME#INS }"        #Extracted  from the new sprint name(Next Version -ns)
VERSION="${SPRINT_NAME#INS }"                #Extracted  from the sprint name(Current Version  -s)
STATUS="Done"
current_date=$(date +%F)

PARENT_PAGE_ID="33296" #get from api
PARENT_PAGE_NAME="INFERYX12345"
SPACE_KEY="DM"
SPACE_KEY2="IAP"
# PROJECT_KEY="JJ"
DISC=""
# PROJECT_DISC="<p><a href='$baseurl'>5.9.1</a></p> \
#               <p><a href='$baseurl'>5.9.2</a></p> \
#               <p><a href='$baseurl'>5.9.3</a></p> \
#               <p><a href='$baseurl'>5.9.4</a></p> \
#               <p><a href='$baseurl'>5.9.5</a></p> \
#               <p><a href='$baseurl'>5.9.6</a></p>"


GTOKEN="ATATT3xFfGF0HCkPP3IUsFri35_wElht3_EAtXjQpt4O0_AtTItcSuRZ1_m6ccsaN1YA0iptFsBAxehgIkfzWze9KfgF3HonxdZ1kkx2oIgnZQ4GT1pvjeBgZZuaZUKn789iN2Brt7QDjxaaAhlvZNwvQBp4_CL2bAIyyI6yYsTJgYVmaNEDios=CB55DB53"                
AUTH_TOKEN="c2FsdW5rZS5uaXNoYTIxMDFAZ21haWwuY29tOkFUQVRUM3hGZkdGME96Q2Rld0xJQlRSMy0tdmZTUGM0cGdxeE95cl9aTEhqSDIwb0RMWTI4Nkw0UDRWSnNOTVBDM0JwWko1VndrSjlFZEdyVnRBWTV2VXF4R3hwUmNoZnp6c29TWDRFdVRfVFRQZUhOVlJqbV9oQ3U0dkNCd1VpWnRYcW5abFhsOGxUdmNsRmdmUl8zazk1bWtsU0plN3hZZEtLNDZ5ZEhaRFpJZmx0Nm9rdlpjUT0wMkUxMTQ1Ng=="
post_api_call() {
  local api_url="$1"
  local jql_query="$2"
  local auth_token="$3"

  # response=$(
    curl --location "$api_url" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Basic $auth_token" \
    --data "$jql_query"
    #)

}
put_api_call() {
  echo "calling put api"
  local api_url="$1"
  local jql_query="$2"
  local auth_token="$3"
  echo $jql_query
curl --location --request PUT "$api_url" \
--header 'Content-Type: application/json' \
--header "Authorization: Basic $auth_token" \
--data "$jql_query"
}
get_api_call() {
  local api_url="$1"
  local auth_token="$2"

#  response=$(
curl --location "$api_url" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Basic $auth_token"
#)

#  echo "$response"
}

#Get task by sprint name.
getTaskBySprintName(){
  echo "Version: $VERSION"
json_data="{
  \"jql\": \"project = '$PROJECT_NAME' AND Sprint IN ('$VERSION') AND Status=$STATUS\"
}"
response=$(post_api_call "$API_BASE_URL/rest/api/2/search" "$json_data" "$AUTH_TOKEN")
wait
  #echo "Response: $response"

  createrelease_notes "$response"

#sleep 30  # Add sleep after API call
}


#Create Realease Page
createPage() {
  json_data="
{
  \"type\": \"page\",
  \"title\": \"Release Notes -$VERSION\",
  \"ancestors\": [{\"type\": \"page\", \"id\": \"$PARENT_PAGE_ID\"}], 
  \"space\": {\"key\": \"$SPACE_KEY\"},
  \"body\": {
    \"storage\": {
      \"value\": \"$DISC\",
      \"representation\": \"storage\"
    }
  }
}"

  # Make API call to create the child page
  responsee=$(post_api_call "$CONF_API_BASE_URL/wiki/rest/api/content" "$json_data" "$AUTH_TOKEN")

  # Extract child page ID from the API response
  CHILD_PAGE_ID=$(echo "$responsee" | jq -r '.id')

  if [ -n "$CHILD_PAGE_ID" ]; then
    echo "Child page created with ID: $CHILD_PAGE_ID"
  else
    echo "Failed to get child page ID from the API response."
    exit 1
  fi

  # Construct the base URL for release notes using the generated child page ID
  # BASE_URL="$CONF_API_BASE_URL/wiki/spaces/$SPACE_KEY/pages/$CHILD_PAGE_ID/Release+Notes-$VERSION"
}


#Update a parent page discriptions
updateDiscriptions(){
response=$(get_api_call "$CONF_API_BASE_URL/wiki/rest/api/content/33296?expand=version" "$AUTH_TOKEN")
pageNumber=$(echo "$response" | grep -o '"number":[0-9]*' | awk -F':' '{print $2}')
echo "pageVersion $pageNumber"
wait
newPageNumber=$((pageNumber + 1))
echo "newPageNumber $newPageNumber"
baseurl="https://nishasalunkee.atlassian.net/wiki/spaces/$SPACE_KEY/pages/$CHILD_PAGE_ID/Release+Notes+$SPRINT_NAME"

# Get existing content
existing_content=$(curl --location --request GET 'https://nishasalunkee.atlassian.net/wiki/rest/api/content/33296?expand=body.storage' \
--header 'Authorization: Basic c2FsdW5rZS5uaXNoYTIxMDFAZ21haWwuY29tOkFUQVRUM3hGZkdGME96Q2Rld0xJQlRSMy0tdmZTUGM0cGdxeE95cl9aTEhqSDIwb0RMWTI4Nkw0UDRWSnNOTVBDM0JwWko1VndrSjlFZEdyVnRBWTV2VXF4R3hwUmNoZnp6c29TWDRFdVRfVFRQZUhOVlJqbV9oQ3U0dkNCd1VpWnRYcW5abFhsOGxUdmNsRmdmUl8zazk1bWtsU0plN3hZZEtLNDZ5ZEhaRFpJZmx0Nm9rdlpjUT0wMkUxMTQ1Ng==' \
| jq -r '.body.storage.value')


formatted_content=$(echo "${existing_content}" | sed -E 's|<p><a href="$baseurl">([0-9]+\.[0-9]+\.[0-9]+)</a></p>|<p><a href="$baseurl">\1</a></p>\n|g' | tr -s '[:space:]')

# Add a newline at the end of existing content
formatted_content="${formatted_content}"

# Append "<p>skks<p/>" at the end of each line
formatted_content="${formatted_content//'<p><a href="$baseurl"></p>'/'<p>skks<p/>'}"



# Get user input for the new version

# read -p "Enter the new version: " new_version_input

# Escape double quotes within HTML content
formatted_content="${formatted_content//\"/\\\"}"
formatted_content="${formatted_content//$'\n'/\\n}"

 # Append new content on a new line
new_entry="<p><a href='$baseurl'>$param_s</a></p>"
formatted_content="${formatted_content}${new_entry}"


# Combine existing and new content
echo -e "${formatted_content}"  # Display the content with newline separation for verification
echo ""
echo ""
echo ""

parent_disc="{
  \"type\": \"page\",
    \"id\": \"$PARENT_PAGE_ID\",
  \"title\": \"$PARENT_PAGE_NAME\",
  \"version\": {\"number\": \"$newPageNumber\"},
   \"space\": {\"key\": \"$SPACE_KEY\"},
  \"body\": {
    \"storage\": {
       \"value\": \"$formatted_content\",
      \"representation\": \"storage\"
    }
  }
}"
if [[ $newPageNumber != "null" && $newPageNumber != '' ]];then
put_api_call "$CONF_API_BASE_URL/wiki/rest/api/content/33296" "$parent_disc" "$AUTH_TOKEN"

else
  echo "newPageNumber $newPageNumber"
fi
# sleep 30  # Add sleep after API call
}


#Release version

#post_api_call "$API_BASE_URL/rest/api/2/version/10008" "$AUTH_TOKEN"

#Create New Sprint

createNewSprintByVersion(){
startDate="$current_date"
endDate=$(date -d "$current_date +7 days" +%F)
  echo "calling Get api"

response=$(get_api_call "$API_BASE_URL/rest/agile/1.0/board?name=$PROJECT_NAME" "$AUTH_TOKEN")

id=$(echo $response | jq -r '.values[0].id')

if [ -n "$id" ]; then
  echo "Board ID: $id"
  parent_disc="{
  \"name\": \"INS $NEW_VERSION\",
  \"goal\": \"Sprint goal description\",
  \"startDate\": \"$startDate\",
  \"endDate\": \"$endDate\",
  \"originBoardId\": \"$id\"
}"
echo "$parent_disc"
post_api_call "$API_BASE_URL/rest/agile/1.0/sprint" "$parent_disc" "$AUTH_TOKEN"

else
  echo "Board ID Required."
  exit 1
fi
# sleep 30  # Add sleep after API call
}

#Create New version

echo "Param: $2"
NEW_VERSION="$param_ns"


CreateNewVersion(){
startDate="$current_date"

releaseDate=$(date -d "$current_date +7 days" +%F)
new_version="{
  \"name\": \"$NEW_VERSION\",
  \"project\": \"$PROJECT_NAME\",
    \"description\": \"This is new $NEW_VERSION created\",
        \"startDate\": \"$startDate\",
        \"releaseDate\": \"$releaseDate\",
                \"archived\": \"false\",
                        \"released\": \"true\"

}"

post_api_call "$API_BASE_URL/rest/api/2/version" "$new_version" "$AUTH_TOKEN"
# sleep 30  # Add sleep after API call
}



createrelease_notes() {
  local response="$1"
  current_date1=$(date +"%b %d, %Y")

  html_content="<html><head><title>Issue Details</title></head><body>"
  html_content+="<h2 style='color:blue;'>Release Date: $current_date1</h2>"
  html_content+="<table border='1' style='width:100%'>"
  html_content+="<tr><th>Issue Id</th><th>Issue Type</th><th>Reported By</th><th>Summary</th></tr>"

for i in $(seq 0 $(($(jq '.total' <<< "$response") - 1))); do
    issuetype_name=$(jq -r ".issues[$i].fields.issuetype.name" <<< "$response")
    issuetype_id=$(jq -r ".issues[$i].fields.issuetype.id" <<< "$response")
    summary=$(jq -r ".issues[$i].fields.summary" <<< "$response")
    reporter_displayName=$(jq -r ".issues[$i].fields.reporter.displayName" <<< "$response")

    # Append issue details to the HTML table
    html_content+="<tr><td>$issuetype_id</td><td>$issuetype_name</td><td>$reporter_displayName</td><td>$summary</td></tr>"
done


html_content+="</table></body></html>"
DISC="$html_content"
# Now you can use $html_content as needed, for example, echoing it or saving it to a file.
echo "$DISC"

}



# issuetype_id=$(echo $response | jq -r '.issues[0].fields.issuetype.id')  
# issuetype_name=$(echo $response | jq -r '.issues[0].fields.issuetype.name')
# summary=$(echo $response | jq -r '.issues[0].fields.summary')
# reporter_displayName=$(echo $response | jq -r '.issues[0].fields.reporter.displayName')

# # Printing the values

# echo "Issue Type ID: $issuetype_id"
# echo "Issue Type Name: $issuetype_name"
# echo "Summary: $summary"
# echo "Reporter Display Name: $reporter_displayName"




 getTaskBySprintName 
 createPage
 updateDiscriptions
 createNewSprintByVersion
 CreateNewVersion