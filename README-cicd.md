# Automated CI/CD in practice

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository, or deploy merged pull requests to production.

GitHub Actions goes beyond just DevOps and lets you run workflows when other events happen in your repository. For example, you can run a workflow to automatically add the appropriate labels whenever someone creates a new issue in your repository.

This document introduces practical cases of CI/CD pipelines that you may want to implement on GitHub Action

1. [The architecture of CI/CD automation](#1-the-architecture-of-cicd-automation)
2. [Workflows for build and test](#2-workflows-for-build-and-test-ci)
3. [Workflows for build, test and deploy](3-workflows-for-build-test-and-deploy-cicd)
4. [Workflows for tests](4-workflows-for-continuous-validation-cv)
5. [Workflows for security(penetration) test](5-workflows-for-securitypenetration-test-cv)

## 1. The architecture of CI/CD automation 

This diagram presents key components and preconfigured pipelines 

![Components and Elements](media/cicd-architecture.png)

It contains 

* Automated build and unit test for CI
  * Automated static test for the Java code 
  * Automated functional tests for the apps and the APIs 
* Automated deployment with required verification for CD
  * Automated load tests for the apps 
  * Synthetic monitoring for the APIs 
  * Automated security test for the app 

## 2. Workflows for Build and Test (CI)

Configuration of the pipeline looks like this which you can find from `.github/workflows/ci-build-test-all-customer.yml`

![CI](media/devo-ci.png)

- Single job in the workflow
- Triggered by push request
- No cache's required
- Includes pre-validation steps for tests
  - Verifing build environment such as JDK type and version, Maven version and so on
  - Dependency check, checks vulnarabilities from all dependencies in the Maven project
  - Static test for Java code
- Unit test by JUnit
- Code(Test) coverage

Number of 3rd party plugins were instrumented for this in Maven build file. And you can find Github Action plugins from Marketplace for [Code quality](github.com/marketplace?category=code-quality&type=actions) and [Code review](https://github.com/marketplace?category=code-review&type=actions)

- Environment verification by enforcer plugin. [screenshot](media/devo-ci1.png){:target="_blank"}
- OWASP vulnarability check by dependency-check plugin. [screenshot](media/devo-ci2.png){:target="_blank"}
- Vulnarability checks for Java code by SpotBugs plugin 
  - What it looks like on the console, on succeed [screenshot](media/devo-ci3.png){:target="_blank"}
  - On the report in XML format, on succeed [screenshot](media/devo-ci3-1.png){:target="_blank"}
  - What it looks like on the console, on failure [screenshot](media/devo-ci3-2.png){:target="_blank"}
  - On the report, on failure [screenshot](media/devo-ci3-3.png){:target="_blank"}
- Unit test results which defined in JUnit, on succeed [screenshot](media/devo-ci4.png){:target="_blank"}
- Code coverage report by JaCoCo plugin
  - Overview [screenshot](media/devo-ci5.png){:target="_blank"}
  - Browse by classes (code) [screenshot](media/devo-ci5-1.png){:target="_blank"}
  - Browse by instances (runtime) [screenshot](media/devo-ci5-2.png){:target="_blank"}

On your Github Action

![GH A2](media/devo-s02.png)


## 3. Workflows for Build, Test and Deploy (CI/CD)

Configuration of the pipeline looks like this which you can find from  `.github/workflows/cd-build-deploy-customer.yml`

![CICD](media/devo-cicd.png)

- Multiple jobs in the workflow, init, build, deploy skipping test
- Cache's configured 

Each jobs on Github Action runners start in a clean virtual environment and must download dependencies each time, causing increased network utilization, longer runtime, and increased cost. To help speed up the time it takes to recreate these files, GitHub can cache dependencies you frequently use in workflows

In this example there are 2 cache's defined for builds and deploys to store .m2 repo and app packages for each jobs

On your Github Action

![GH A3](media/devo-s03.png)

## 4. Workflows for Continuous Validation (CV)

Configuration of the pipeline looks like this which you can find from `.github/workflows/cv-tests-scenarios.yml`

![CV](media/devo-cv.png)

- Same config's found from `cv-tests-apis.yml`, `cv-monitorings-apis.yml` 

These workflows calls Azure Load Testing with tests and test configs as arguments which you can find `tests` folder. Tests need to be configured separately, you can find instructions from [here](README-test.md)

Test results are found from Azure Load Testing portal 

![Test Results](media/alt-test1.png)

These tests are scheduled. You can schedule them to run at specific UTC times using POSIX cron syntax. Scheduled workflows run on the latest commit on the default or base branch. Find further details from [here](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)

![Shceduled](media/devo-02.png)

On your Github Action

![GH A1](media/devo-s01.png)


## 5. Workflows for Security(Penetration) Test (CV)

Configuration of the pipeline looks like this which you can find from `.github/workflows/cv-security-test.yml`

![Sec](media/devo-sec.png)

In this example, ZAP pluin's used (https://www.zaproxy.org/) for (full scan), baseline scan and API scan. 

Pentesting in this example follows these stages:

- Explore – The tester attempts to learn about the system being tested. This includes trying to determine what software is in use, what endpoints exist, what patches are installed, etc. It also includes searching the site for hidden content, known vulnerabilities, and other indications of weakness.
- Attack – The tester attempts to exploit the known or suspected vulnerabilities to prove they exist.
- Report – The tester reports back the results of their testing, including the vulnerabilities, how they exploited them and how difficult the exploits were, and the severity of the exploitation.

ZAP plugin posts the test report as Issue on your repo. Here's an example

![ZAP Report](media/devo-01.png)

On your Github Action

![GH A1](media/devo-s01.png)


On your Github Action

![GH A0](media/devo-s00.png)




## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.