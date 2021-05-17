# Boomi CI & CD Using Jenkins

# RESSOURCES

* Links: 
    * [Boomi DevOps](https://boomi.com/form/devops-assets-success/)
    * [Docker Jenkins Boomi CI/CD](https://hub.docker.com/r/boomicicd/jenkins) 
    * [Official Boomi CI/CD with Jenkins jobs](https://github.com/OfficialBoomi/boomicicd-jenkinsjobs)
    * [Integrationguru Boomi CI/CD with Jenkins jobs](https://github.com/integrationguru/boomicicd-jenkinsjobs)
    * [Implementation](https://community.boomi.com/s/article/Boomi-CI-CD-Reference-Implementation)
    * [Video Tutorial](https://www.youtube.com/watch?v=DZgJgCw6Z7s)
    * [For more informations about Boomi CI/CD CLI](https://github.com/OfficialBoomi/boomicicd-cli)

# Configuration

1. Add .env file to the root folder with the same variable names in env-example file

2. Run : 
```
docker compose up
```

3. Wait for Jenkins to print Log info message : ***"Jenkins is fully up and running"***

4. Go to http://localhost:${PORT}/ & Log in with **${JENKINS_USER}** and **${JENKINS_PASS}** values you have configured in the .env file

5. Configure Jenkins basic settings
    * Go to ***Manage Jenkins*** scroll to ***System Configuration*** & Click on ***Configur System*** & update the following :
        * ***Maven Project Configuration*** set the value of ***"# of executors"*** to : 10
        * In ***Git plugin*** Add a Git user global config by setting your **"*user.name"*** & **"*user.email"***
        * In ***Shell*** set the value of ***"Shell executable"*** to : /bin/bash
        * Click ***Apply & Save***
    
    * Go to ***Manage Jenkins*** scroll to ***Security*** & Click on ***Configure Global Security*** scroll tp ***Authorize JSONP or primitive XPath requests by whitelist*** & check the box ***"Allow requests without Referer"*** [x].

6. Configuring Boomi Account
    * Go to ***Dashboard*** & Click on the ***Account_{Rename}*** folder.

    * Click on ***configure*** & update the ***"accountId"*** in **folder propriety** & click **Apply & save**. (To find your **Boomi __accountId__** Log in to your Boomi account and go to **Settings » Account Information**.)

    * Click on ***Credentials*** & update the authToken to the Boomi API Token (Format) ***BOOMI_TOKEN.user@company.com:bOomi-aPi-ToKen***. (To configure your Boomi API Token Log in to your Boomi account and go to ***Settings » Token Management*** & add new Token)

7. Test Job execution 
    * Go to ***Dashboard*** & click on ***the Account_{Rename}*** folder & go to ***Publish Reports*** Tab.
    * Select ***List Atoms*** & click on ***Build now***
    * This Job should return a list of all your Boomi atoms.

8. GIT Advance Settings (There are four jobs that use a GIT Credentials as ***"git_id"***)
    * Go to ***Dashboard*** & click on ***the Account_{Rename}*** folder & under ***Stores scoped to Account_{Rename}*** click on ***the Account_{Rename}*** & set :
    * Select ***Global credentials (unrestricted)*** & click on ***Add Credentials*** :
        * ***User name*** : "your git user name"
        * ***Password*** : Past your Git Token generated from [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
        * ***ID*** : git_id
        * Click Add
    * Under the Account Folder search for all Jobs that have GIT (there should be 4).
    * Click ***configure*** on each job and : 
        * ***Source Code Management*** update the ***Repository URL*** to point to your GIT repository where the component files will be uploaded.
        * Under ***Post-build Actions*** add the Branches to push to remote repositories.
        * click on ***Apply & save**.