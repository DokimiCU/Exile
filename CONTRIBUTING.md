# Quick-Start Guide for Contributing to Exile

## Initial Setup
Fork this repository on GitHub, using the `fork` button.
Then clone your fork locally:

	$ git clone https://github.com/YOUR_USERNAME/Exile.git

Using `cd Exile`, move into the directory, and then `add` my repository as a `remote` codebase:

	$ git remote add -f upstream https://github.com/jeremyshannon/Exile

Having the `upstream` defined is necessary in order to have a fork into which your changes get pulled by the project maintainer.

## Updating Your Local Copy
Check-out the `branch` labeled `master`, which is where the main `upstream` resides:

	$ git checkout master

Then `pull` from the corresponding `upstream` `branch`:

	$ git pull --ff-only upstream master

This ensures that your local copy of the `repo` correctly reflects the current state of the project maintainer’s copy.

## Making Changes
Create a new `branch` for each `pull request` (`PR`) you plan to make:

	$ git checkout -b BRANCH_NAME

Make your changes and `commit`(s), then `push` them:

	$ git push origin BRANCH_NAME

Now you can go to your fork’s GitHub page and submit a `PR` to `master`, via the handy web interface.

# GitHub Personal Access Tokens
GitHub has deprecated the use of passwords to authenticate desktop clients, so you need to use either an `SSH key` or a `personal access token`, and store it within your desktop client or your operating system’s keyring.<sup>[[†]](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)</sup>

# Some Simple Guidelines
Try to keep your `PR`s focused. Don’t be a politician and bundle your “fund the schools” `PR` together with your “build a bridge to my summer home” `PR`. One `PR` per feature/bugfix, please: No omnibus.

Try to keep your `commit`s manageably small. The platonic ideal is to have them be atomic, i.e. as small as possible without leaving the code in a broken state. `Git` allows you to find the exact `commit` that introduced a bug, via `git bisect`, which is more useful the smaller that `commit` turns out to be.

That said, don’t worry about it too much, as long as your individual `commit`s aren’t something like seven hundred lines long each, I can probably deal with it.

If you’re not sure about some change or whatever, maybe open a discussion, or file an issue and we can talk it over. Or just make a draft `PR` and we’ll figure it out.

The `master` branch is where development is going on right now, with the `0.2.3` branch receiving backports for anyone on an older (5.3.0) version of Minetest.

# Rebasing Stale Branches
“The primary reason for rebasing is to maintain a linear project history.”<sup>[[†]](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase)</sup>
