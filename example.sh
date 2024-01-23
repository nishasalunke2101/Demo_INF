#!/bin/bash

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "    -s, --sprint-name       Application name comma separated like: all or admin,edw"
  echo "    -ns, --new-sprint-name       Application name comma separated like: all or admin,edw"
  echo ""
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
  case "$1" in
  -s | --sprint-name)
    param_s="$2"
    shift 2
    ;;
  -ns | --new-sprint-name)
    param_ns="$2"
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
API_BASE_URL="https://nishasalunke.atlassian.net/"
CONF_API_BASE_URL="https://nishasalunkee.atlassian.net"
URL2="https://inferyx.atlassian.net/" #Url for bot jira and conf
PROJECT_NAME="JJ"
PROJECT_NAME2="Inferyx Platform Engineering"
SPRINT_NAME="$param_s"
#SPRINT_NAME="JJ Sprint 3"  # this is  example frm N&M 
NEW_SPRINT_NAME="$param_ns"
NEW_VERSION="${NEW_SPRINT_NAME#INS }"
VERSION="${SPRINT_NAME#INS }"
STATUS="Done"
#ORIGINBOARDID=""
current_date=$(date +%F)

PARENT_PAGE_ID="33296" #get from api
PARENT_PAGE_NAME="INFERYX12345"
SPACE_KEY="DM"
SPACE_KEY2="IAP"
PROJECT_KEY="JJ"
DISC="<p>Your child page</p>"
PROJECT_DISC="<p><a href='https://newlink.com'>5.9.1</a></p> \
              <p><a href='https://newlink.com'>5.9.2</a></p> \
              <p><a href='https://newlink.com'>5.9.3</a></p> \
              <p><a href='https://newlink.com'>5.9.4</a></p> \
              <p><a href='https://newlink.com'>5.9.5</a></p> \
              <p><a href='https://newlink.com'>5.9.6</a></p>"

# # Get user input for the new version
# read -p "Enter the new version: " new_version_input

# # Add a new entry to PROJECT_DISC based on the user input
# new_entry="<p><a href='https://newlink.com'>$new_version_input</a></p>"
# PROJECT_DISC=$(echo -e "$PROJECT_DISC\n$new_entry" | tr -d '\n' | sed 's/<p>/\n<p>/g')

# # Display the updated PROJECT_DISC
# echo -e "Updated PROJECT_DISC:\n$PROJECT_DISC"


# new=$(echo -e "$PROJECT_DISC" | tr -d '\n' | sed 's/<p>/\n<p>/g')
# echo "$new"
# echo ""
# echo ""
# echo ""
# echo ""

GTOKEN="ATATT3xFfGF0HCkPP3IUsFri35_wElht3_EAtXjQpt4O0_AtTItcSuRZ1_m6ccsaN1YA0iptFsBAxehgIkfzWze9KfgF3HonxdZ1kkx2oIgnZQ4GT1pvjeBgZZuaZUKn789iN2Brt7QDjxaaAhlvZNwvQBp4_CL2bAIyyI6yYsTJgYVmaNEDios=CB55DB53"                
AUTH_TOKEN="c2FsdW5rZS5uaXNoYTIxMDFAZ21haWwuY29tOkFUQVRUM3hGZkdGME96Q2Rld0xJQlRSMy0tdmZTUGM0cGdxeE95cl9aTEhqSDIwb0RMWTI4Nkw0UDRWSnNOTVBDM0JwWko1VndrSjlFZEdyVnRBWTV2VXF4R3hwUmNoZnp6c29TWDRFdVRfVFRQZUhOVlJqbV9oQ3U0dkNCd1VpWnRYcW5abFhsOGxUdmNsRmdmUl8zazk1bWtsU0plN3hZZEtLNDZ5ZEhaRFpJZmx0Nm9rdlpjUT0wMkUxMTQ1Ng=="
post_api_call() {
  echo "calling post api"
  local api_url="$1"
  local jql_query="$2"
  local auth_token="$3"

  response=$(curl --location "$api_url" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Basic $auth_token" \
    --data "$jql_query")

  echo "$response"
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
  echo "calling Get api"
  local api_url="$1"
  local auth_token="$2"

  response=$(curl --location "$api_url" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Basic $auth_token")

  echo "$response"
}

#Get task by sprint name.
getTaskBySprintName(){
  echo "Version: $VERSION"
json_data="{
  \"jql\": \"project = '$PROJECT_NAME' AND Sprint IN ('$VERSION') AND Status=$STATUS\"
}"
post_api_call "$API_BASE_URL/rest/api/2/search" "$json_data" "$AUTH_TOKEN"
wait
}

#Create Realease Page
createPage() {             # this creates child page 
  json_data="
{
  \"type\": \"page\",
  \"title\": \"$VERSION\",
  \"ancestors\": [{\"type\": \"page\", \"id\": \"$PARENT_PAGE_ID\"}], 
  \"space\": {\"key\": \"$SPACE_KEY\"},
  \"body\": {
    \"storage\": {
      \"value\": \"$DISC\",
      \"representation\": \"storage\"
    }
  }
}"
  post_api_call "$CONF_API_BASE_URL/wiki/rest/api/content" "$json_data" "$AUTH_TOKEN"
}

#Update a parent page discriptions
updateDiscriptions(){
response=$(get_api_call "$CONF_API_BASE_URL/wiki/rest/api/content/33296?expand=version" "$AUTH_TOKEN")
pageNumber=$(echo "$response" | grep -o '"number":[0-9]*' | awk -F':' '{print $2}')
echo "pageVersion $pageNumber"
wait
newPageNumber=$((pageNumber + 1))
echo "newPageNumber $newPageNumber"

# Get existing content
existing_content=$(curl --location --request GET 'https://nishasalunkee.atlassian.net/wiki/rest/api/content/33296?expand=body.storage' \
--header 'Authorization: Basic c2FsdW5rZS5uaXNoYTIxMDFAZ21haWwuY29tOkFUQVRUM3hGZkdGME96Q2Rld0xJQlRSMy0tdmZTUGM0cGdxeE95cl9aTEhqSDIwb0RMWTI4Nkw0UDRWSnNOTVBDM0JwWko1VndrSjlFZEdyVnRBWTV2VXF4R3hwUmNoZnp6c29TWDRFdVRfVFRQZUhOVlJqbV9oQ3U0dkNCd1VpWnRYcW5abFhsOGxUdmNsRmdmUl8zazk1bWtsU0plN3hZZEtLNDZ5ZEhaRFpJZmx0Nm9rdlpjUT0wMkUxMTQ1Ng==' \
| jq -r '.body.storage.value')


formatted_content=$(echo "${existing_content}" | sed -E 's|<p><a href="https://newlink.com">([0-9]+\.[0-9]+\.[0-9]+)</a></p>|<p><a href="https://newlink.com">\1</a></p>\n|g' | tr -s '[:space:]')

# Add a newline at the end of existing content
formatted_content="${formatted_content}
"

# Append "<p>skks<p/>" at the end of each line
formatted_content="${formatted_content//'<p><a href="https://newlink.com"></p>'/'<p>skks<p/>'}"

#combined_content="\"${formatted_content}\""
# echo "${combined_content}"
# echo -e "Formatted Content:\n${formatted_content}\nNew Content:\n${new_content}"  # Display the content with newline separation for verification

# Get user input for the new version

read -p "Enter the new version: " new_version_input

# Escape double quotes within HTML content
formatted_content="${formatted_content//\"/\\\"}"
formatted_content="${formatted_content//$'\n'/\\n}"

 # Append new content on a new line
#new_content="<p><a href='https://newlink.com'>5.9.7</a></p>\n"
new_entry="<p><a href='https://newlink.com'>$new_version_input</a></p>"
formatted_content="${formatted_content}${new_entry}"


# Combine existing and new content
# combined_content="${existing_content}${new_content}" 
#combined_content="${formatted_existing_content}"
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
}

#Create New Sprint

createNewSprintByVersion(){
startDate="$current_date"
endDate=$(date -d "$current_date +7 days" +%F)
#GET BOARD ID
#ORIGINBOARDID=response=$(get_api_call "$API_BASE_URL/rest/agile/1.0/board?projectKey=$PROJECT_NAME" "$AUTH_TOKEN")


#Extract board IDs
id=$(get_api_call "$API_BASE_URL/rest/agile/1.0/board?name=$PROJECT_NAME" "$AUTH_TOKEN")

# Debug statement to print the entire response
  echo "Response from get_api_call: $id"

  # Extract the board ID using jq
  id=$(echo "$id" | jq -r '.values[0].id')
  # orgId=$(echo "$ORIGINBOARDID" | jq -r '.values[0].location.projectId')
# echo "$ORIGINBOARDID"
# orgId=$(jq -r '.values[0].id' <<< "$response")
# echo "The orgId is: $orgId"
# Output the extracted ID
if [ -n "$id" ]; then
  echo "Board ID: $id"
else
  echo "Failed to extract Board ID."
fi


# # Output the extracted ID
# echo "Board ID: $id"
# # Print the IDs or use them as needed
# echo "Board IDs: ${ids[@]}"



# Debug statement to print the entire response
#echo "Response from get_api_call: $ORIGINBOARDID"

# Extract the originBoardId
#ORIGINBOARDID=$(echo "$ORIGINBOARDID" | jq -r '.values[0].id')

# Debug statement to print the extracted originBoardId
#echo "Extracted originBoardId: $ORIGINBOARDID"

#build logic....
exit 1
parent_disc="{
  \"name\": \"IAP21 $NEW_VERSION\",
  \"goal\": \"Sprint goal description\",
  \"startDate\": \"$startDate\",
  \"endDate\": \"$endDate\",
  \"originBoardId\": \"$id\"
}"

echo "$parent_disc"

post_api_call "$API_BASE_URL/rest/agile/1.0/sprint" "$parent_disc" "$AUTH_TOKEN"

}

#Release version

#post_api_call "$API_BASE_URL/rest/api/2/version/10008" "$AUTH_TOKEN"

#Create New version
# read -p "Enter the new version name: " NEW_VERSION
# Check if a new version name is provided as a command-line argument
# if [ $# -eq 0 ]; then
#   echo "Usage: $0 <new_version_name>"
#   exit 1
# fi

# # Extract the new version name from the command-line argument
echo "Param: $2"
NEW_VERSION="$param_s"


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

}

# getTaskBySprintName 
#createPage
updateDiscriptions
# createNewSprintByVersion
# CreateNewVersion