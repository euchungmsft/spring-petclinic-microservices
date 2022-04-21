# Automated CI/CD in practice

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository, or deploy merged pull requests to production.

GitHub Actions goes beyond just DevOps and lets you run workflows when other events happen in your repository. For example, you can run a workflow to automatically add the appropriate labels whenever someone creates a new issue in your repository.

This document introduces pratical cases of CI/CD pipelines implemented in GitHub Action

1. The architecture of CI/CD automation 
2. Workflows for build and test
3. Workflows for build, test and deploy
4. Workflows for tests
5. Workflows for security test

## 1. The architecture of CI/CD automation 

This diagram presents key components and preconfigured pipelines 

![Components and Elements](media/cicd-architecture.png)

It covers 

* Automated build and unit test 
* Automated deployment with required verification
* Automated static test for the Java code 
* Automated functional tests for the apps and the APIs 
* Automated load tests for the apps 
* Synthetic monitoring for the APIs 
* Automated security test for the app

## 2. Workflows for Build and Test (CI)

Pipeline looks like this in `.github/workflows/ci-build-test-all-customer.yml`

![CI](media/devo-ci.png)

- Single job in the workflow
- No cache's required
- Includes pre-validation steps
  - Verifing build environment such as JDK type and version, Maven version and so on
  - OWASP dependency-check, checks vulnarabilities from all dependencies in the Maven project
  - Static test for Java code
- Code coverage (JaCoCo)

SonarQube plugin's preferred which can be easily integrated to JaCoCo

Environment verification by enforcer plugin

![CI1](media/devo-ci1.png)

OWASP vulnarability check by dependency-check plugin

![CI2](media/devo-ci2.png)

Vulnarability checks for Java code by SpotBugs plugin what it looks like on the console, on succeed

![CI3](media/devo-ci3.png)

What it looks like on the report in XML format, on succeed

![CI3-1](media/devo-ci3-1.png)

What it looks like on the console, on failure

![CI3-2](media/devo-ci3-2.png)

What it looks like on the report, on failure. Listed by methods, fields, classes and so on

![CI3-3](media/devo-ci3-3.png)

Unit test results which defined in JUnit, on succeed

![CI4](media/devo-ci4.png)

Code coverage report by JaCoCo plugin, overview

![CI5](media/devo-ci5.png)

Browse by classes (code)

![CI5-1](media/devo-ci5-1.png)

Browse by instances (runtime)

![CI5-2](media/devo-ci5-2.png)


## 3. Workflows for Build, Test and Deploy (CI/CD)
## 4. Workflows for Continuous Validation (CV)
## 5. Workflows for Security Test (CV)

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.