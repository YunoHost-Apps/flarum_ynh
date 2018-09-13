---
name: Bug report
about: Create a report to help us debug

---

**How to post a meaningful bug report**
1. *Read this whole template first.*
2. *Determine if you are on the right place:*
   - *If you were performing an action on the app from the webadmin or the CLI (install, update, backup, restore, change url...), you are on the right place!*
   - *If the issue is about logging in and out of the forum, it is most likely due to the SSOwat extension. Please post the issue on its [repository](https://github.com/tituspijean/flarum-ext-auth-ssowat/issue).*
   - *Otherwise, the issue may be due to Flarum itself. Refer to its [forum](https://discuss.flarum.org) for help.*
   - *If you have a doubt, post here, we will figure it out together.*
3. *Delete the italic comments as you write over them below, and remove this guide.*
--- 

**Describe the bug**
*A clear and concise description of what the bug is.*

**Versions**
- YunoHost version:
- Package version/branch: *if you did not specify anything, put "latest"*

**To Reproduce**
*Steps to reproduce the behavior.*
- *If you performed a command from the CLI, the command itself is enough. For example:*
    ```sh
    sudo yunohost app install flarum
    ```
- *If you used the webadmin, please perform the equivalent command from the CLI first.*
- *If the error occurs in your browser, explain what you did:*
   1. *Go to '...'*
   2. *Click on '....'*
   3. *Scroll down to '....'*
   4. *See error*

**Expected behavior**
*A clear and concise description of what you expected to happen. You can remove this section if the command above is enough to understand your intent.*

**Logs**
*Perform the command again with `--debug | tee flarum.log` at the end. The log will be available in the `flarum.log` file. Remove any personal information and credentials, and copy and paste it here in a code block. If the log is long, you can use the [YunoPaste](https://paste.yunohost.org) service.*
*If applicable and useful, add screenshots to help explain your problem.*
