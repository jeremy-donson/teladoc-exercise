/*  https://www.npmjs.com/package/github-create-issue

Usage: ghcreateissue [options] slug
 
Options:
 
  -h,  --help                      Print this message.
  -V,  --version                   Print the package version.
       --token token               GitHub access token.
  -ua, --useragent ua              User agent.
       --title title               Issue title.
       --body content              Issue content.
       --assignees user1,user2,... GitHub usernames of assigned users.
       --milestone number          Associated milestone number.
       --labels label1,label2,...  Issue labels.

EXAMPLE:

 ghcreateissue jeremy-donson/teladoc-exercise --title 'Prioritize all issues.' -useragent jeremy --body 'Most crucial issues regard paving workflows in reverse as jenkins pipelines..' --token $TOKEN

*/

var opts = {
    'token': 'tkjorjk34ek3nj4!'
};
 
createIssue( 'jeremy-donson', 'Issue?  I hardly know you! :D', opts, clbk );

To specify a user agent, set the useragent option.

var opts = {
    'token': 'tkjorjk34ek3nj4!',
    'useragent': 'hello-github!'
};
 
createIssue( 'kgryte/test-repo1', 'Big bug.', opts, clbk );