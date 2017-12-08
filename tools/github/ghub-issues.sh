TOKEN=$(<ghub_teladoc_token)
TITLE=''
BODY=''
ghcreateissue jeremy-donson/teladoc-exercise --title "${TITLE}" -useragent jeremy --body "${BODY}" --token ${TOKEN}
