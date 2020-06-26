# config

# Command to change the default home directory of a user
https://stackoverflow.com/questions/20797819/command-to-change-the-default-home-directory-of-a-user

### Change the user's home directory:

    usermod -d /newhome/username username


`usermod` is the command to edit an existing user. <br>
`-d` (abbreviation for `--home`) will change the user's home directory.  
<br>


### Change the user's home directory + Move the contents of the user's current directory:


    usermod -m -d /newhome/username username


`-m` (abbreviation for `--move-home`) will move the content from the user's current directory to the new directory.
