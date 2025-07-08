# The Orange Primer 🍊

Welcome to a quick primer on getting setup on Github, Remote Machines, and running simulations!

## GitHub
Github is not only the source of this primer but where you will be able to upload any scripts, data, or other items as you go along!

1. Create a Github Account at https://github.com/ using your Syracuse email address
2. Open finder on your computer and create a new folder in your Documents directory named "Development"
3. Open your the Terminal app on your computer and enter `cd ~/.ssh` and press return, this will navigate you to that folder
    - The `cd` command stands for "Change Directory" and is how you will navigate around your folders. You can see other [helpful commands](##Terminal-Cheat-Sheet) below
4. Run the following command to generate a unique key: `ssh-keygen -b 4096 -t rsa`. This key will be used specifically for connecting to Github
5. Run the following command to output the public version of the unique key to the terminal. You can then highlight and copy it
5. In a browser navigate to https://github.com/settings/keys and click the green  "New SSH Key" button, give the new key a descriptive name like "Syracuse MacBook Key" and paste the key in. Hit the Green "Add SSH Key" button to add it to your account
    ![image](./images/AddSSHKey.png)
6. Run `cd ~/Documents/Development` to navigate to the development folder you created earlier
7. Click the green "Clone" button at the top of this repository and copy the ssh url
    ![image](./images/CloningARepo.png)
8. Enter the following in your terminal `git clone <repolink>` and press return, this will clone the repo locally for you

Congratulations! You now have this repo locally and can begin the next steps of the process!

## Remote Machine Setup
There are three different types of remove machines you'll likely interact with while working here. The first two are known as High Performance Computing (HPC) systems and the third is a Virtual Machine (VM). The two HPC systems are named OrangeGrid and OrangeZest (Sometimes referred to by just Grid and Zest or HTCondor and HPC respectively).

Here are the urls you'll need to know:
OrangeGrid: TODO: <url>
OrangeZest: TODO: <url>

To access these machines you'll need to run the following command:

`ssh <user-name>@<url>` (i.e. `ssh jkniblo@zest.syr.edu`)

This will prompt you to enter your password and then grant you access to your home directory on that machine.

## Running your first simulation

TODO: Add folders with specific instructions for each type of simulation they might run and add a link here to those markdown documents

## Terminal Cheat Sheet

| Command / Symbol | Use |
| --- | --- |
| `~` | An alias for your home directory |
| `cd <directory>` | Navigating around folders in the terminal |
| `ls -al` | Lists the contents of your current directory |
| `ssh <username>@<url>` | Allows you to remotely access one of the super computers or virtual machines |