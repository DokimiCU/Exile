# Quick start guide to contributing to Exile

## Initial setup
 Fork this repository on GitHub, using the fork button.
 Then clone your fork locally:

        $ git clone https://github.com/YOUR_USERNAME/Exile.git

 Move into the directory and add my repository as a remote

        $ cd Exile
        $ git remote add -f upstream https://github.com/jeremyshannon/Exile

## To update your local copy
 Check out the master branch

                $ git checkout master
 Then pull from the corresponding upstream branch:

                $ git pull --ff-only upstream master

## Making changes
 Create a new branch for each PR you plan on doing:

                $ git checkout -b BRANCH_NAME
 Make your changes and commit(s), then

                $ git push origin BRANCH_NAME

 Now you can go to your github page and submit a pull request to master, via the handy web interface.

#Github Personal Access tokens
 Github doesn't support using password anymore, so you need to use either an SSH key or a personal access token, and store it wherever you kept your password.
 https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
 

# Some simple guidelines

 Try to keep your PRs focused. Don't be a politician and bundle your "fund the schools" PR together with your "build a bridge to my summer home" PR. One PR per feature/bugfix please.

 Try to keep your commits manageably small. The platonic ideal is to have them be atomic, ie as small as possible without leaving the code in a broken state. Git allows you to find the exact commit that introduced a bug via git bisect, which is more useful the smaller that commit turns out to be.
 That said, don't worry about it too much, as long as your individual commits aren't like seven hundred lines long each, I can probably deal with it.

 If you're not sure about some change or whatever, maybe open a discussion, or file an issue and we can talk it over. Or just make a draft PR and we'll figure it out.

 The master branch is where development is going on right now, with the 0.2.3 branch getting backports for anyone on an older (5.3.0) version of Minetest.
