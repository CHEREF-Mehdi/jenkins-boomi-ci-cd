# Boomi CI & CD : Boomi CLI - Jenkins - Jobs - SonarQube - Docker

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

2. Docker commands 
    1. SonarQube back up: Create a new folder inside the root folder with ***sonarqube*** as given name.

    2. Create external docker volume : [Read documentation](https://devopsheaven.com/docker/docker-compose/volumes/2018/01/16/volumes-in-docker-compose.html)
    ```
    docker volume create --opt type=none --opt device="full/path/to/your/jenkins-boomi-ci-cd/sonarqube" --opt o=bind sonarqube
    ```

    3. Run Containers:
    ```
    docker compose up
    ```

3. Wait for :
    * Jenkins container to print INFO Log : ***"Jenkins is fully up and running"***.
    * Sonar container to print INFO Log : ***"SonarQube is up"***

4. Go to http://localhost:${JENKINS_PORT}/ & Log in with **${JENKINS_USER}** and **${JENKINS_PASS}** values you have configured in the .env file

5. Install Plugins & Configure Jenkins settings 
    1. In ***Dashboard*** select ***Manage Jenkins***, scroll down to ***System Configuration***, click on ***Manage Plugins*** & select ***Available*** Tab.
        * search for *SonarQube Scanner* and install it.
        * search for *Sonar Quality Gates* and install it.
        * Restart Jenkins after installation.

    2. Go back to ***Manage Jenkins***, scroll down to ***System Configuration*** & Click on ***Configur System*** & update the following :
        * ***Maven Project Configuration*** set the value of ***"# of executors"*** to : 10 ( :bangbang: You must update this value each time you restart the Jenkins container)
        * In ***Git plugin*** add a global Git user config by setting your **"*user.name"*** & **"*user.email"***
        * In ***Shell*** set the value of ***"Shell executable"*** to : */bin/bash*
        * Click ***Apply & Save***
    
    2. Go back to ***Manage Jenkins***, scroll down to ***Security***, Click on ***Configure Global Security***, scroll down to ***Authorize JSONP or primitive XPath requests by whitelist*** & check the box ***"Allow requests without Referer"***.

6. Configuring Boomi Account
    * Go to ***Dashboard*** & Click on the ***Account_{Rename}*** folder:

        1. Click on ***configure***, update the ***"accountId"*** in **folder propriety** & click **Apply & save**. (To find your **Boomi __accountId__** Log in to your Boomi account and go to **Settings » Account Information**.)

        2. Click on ***Credentials*** & update the authToken to the Boomi API Token (Format) ***BOOMI_TOKEN.user@company.com:bOomi-aPi-ToKen***. (To configure your Boomi API Token Log in to your Boomi account and go to ***Settings » Token Management*** & add new Token)

7. Test Job execution 
    1. Go to ***Dashboard***, click on ***the Account_{Rename}*** folder & select the ***Publish Reports*** Tab.
    2. Select ***List Atoms*** & click on ***Build now***
    3. Once the build is compelete refresh the page and select the html report.

8. GIT Advance Settings (There are four jobs that use a GIT Credentials as ***"git_id"***)

    * Go to ***Dashboard*** & click on ***the Account_{Rename}*** folder :
        1. Select  ***Credentials***, under ***Stores scoped to Account_{Rename}*** click on ***the Account_{Rename}***, Select ***Global credentials (unrestricted)*** folder & click on ***Add Credentials*** :
            * ***User name*** : "Use your git username"
            * ***Password*** : Past your Git Token.  [How to generate Git Token?](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
            * ***ID*** : git_id
            * Click OK

        2. Search for all Jobs that have GIT (there should be 4).
            * On each job click ***configure*** : 
                * ***Source Code Management*** update the ***Repository URL*** to point to your GIT repository where the component files will be uploaded.
                * Under ***Post-build Actions*** add the Branches to push to remote repositories.
                * click on ***Apply & save**.

9. Sonar Advance Settings
    1. Test your sonar container Boomi code quality checks:
        * Open sonar container CLI and Test the instalation by running this command :
            ```
            sonar-scanner \
            -Dsonar.projectKey=BoomiSonar \
            -Dsonar.sources=. \
            -Dsonar.host.url=http://localhost:9000 \
            -Dsonar.login=82e12d4fcdfd583f963e680c63dd85d441c738e8
            ```
        * You should have a success message at the end of the execution:
            ```
            INFO: ------------------------------------------------------------------------
            INFO: EXECUTION SUCCESS
            INFO: ------------------------------------------------------------------------
            ```
        
        * Go to http://localhost:9000 and Login with :
            * login : *admin* 
            * password : *admin*

    2. Jenkins Settings :
        1. Go to ***Dashboard*** & Click on the ***Account_{Rename}*** folder:
            1. Click on ***Credentials*** & update the ***sonarToken*** set the ***Secret*** to : *82e12d4fcdfd583f963e680c63dd85d441c738e8*
            2. Click on ***Configure*** in ***Folder Properties*** look for *sonarProjectKey* propretie and replace it by *SONAR_PROJECT_KEY* ( :bangbang: **IMPORTANT** do not replace the ***Value*** replace the ***Name***)

        2. Go back to ***Dashboard***, select ***Manage Jenkins***, scroll down to ***System Configuration***, click on ***Global Tool Configuration***, Scroll down to ***SonarQube Scanner*** & Click on ***Add SonarQube Scanner*** button:
            * ***Name*** : *SonarQube Scanner Boomi Sonar*
            * ***Install*** from Maven Central : Choose *4.2.0.1873*
            * Click ***apply & save***
        
        3. Go back to ***Dashboard***, select ***Manage Jenkins***, scroll to ***System Configuration*** and click on ***Configure System*** :
            * Scroll down to ***SonarQube servers*** & Click on ***Add SonarQube*** button:
                * ***Name*** : *Boomi Sonar*
                * ***Server URL*** : *http://sonar:9000/*

            * Scroll down to ***Quality Gates - Sonarqube*** & Click on ***Add Sonar instance*** button:
                * ***Name*** : *Boomi Sonar*
                * ***SonarQube Server URL*** : *http://sonar:9000/*
                * ***SonarQube account token*** : *82e12d4fcdfd583f963e680c63dd85d441c738e8*
                * Click ***apply & save***

10. You're done! :relaxed: