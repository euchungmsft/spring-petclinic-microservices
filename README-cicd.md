# PetClinic on Automated CI/CD with GitHub Action <DRAFT>

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository, or deploy merged pull requests to production.

GitHub Actions goes beyond just DevOps and lets you run workflows when other events happen in your repository. For example, you can run a workflow to automatically add the appropriate labels whenever someone creates a new issue in your repository.

This example shows you how to implement & config GitHub Actions with Maven to deploy an existing Java Spring Boot/Cloud application to Azure. When you're finished, you can continue to design, implement and integrate line of tools that requires for your needs in DevOps & DevSecOps.

## Contents

GitHub Actions to automate your CI/CD pipelines 

* Introduction
  * What will you experience
  * What you will need

* Workflows
  * The architecture

* Implementing CI/CD pipelines for your Petclinic app
  * Build
  * Build & Unit Test
  * Build & Deploy
  * Functional Test as Scenario Test
  * API Tests & Monitoring
  * Security Tests

## What will you experience

You will
- Build GitHub Action workflows with an existing Spring Boot/Cloud application
- Understand tests automatically instrumented in Maven builds
  - Build environment verification
  - Unit Test
  - Code Coverage
  - Static tests against potential vulnarabilities in Java Code
  - OWASP check
- Documentation for all defects 
- Understand tests automatically instrumented in Maven builds

## What you will need

To extend your experiences in GitHub Actions, you need to complete basic configuration explained in the previous step first, [Deploying PetClinic App, step by step instruction](https://github.com/euchungmsft/spring-petclinic-microservices/blob/gene/README.md#deploying-petclinic-app-step-by-step-instruction)

In addition, you will need the following:

| [Git latest](https://git-scm.com/)
| [JMeter latest](https://jmeter.apache.org/download_jmeter.cgi)

## CI/CD Configuration 

### The architecture

This diagram presents key components and preconfigured pipelines 

![Components and Elements](media/cicd-architecture.png)

* Automated build and unit test 
* Automated deployment with required verification
* Automated code verification as a part of deployment
* Automated functional tests for the apps and the APIs
* Automated load tests for the apps in a scenario
* Minitoring the APIs by running API tests in a schedule

## PetClinic on Automated CI/CD with GitHub Action

In your `.github/workflows/` folder, there you can find these pre-configured workflows for GitHub Actions

1. Build all modules, ci-build-all.yml
2. Build & run all tests for Customers module, ci-build-test-all-customer.yml
3. Build & deploy for all modules, cd-build-deploy-all.yml
4. Build & deploy for Customers module, cd-build-deploy-customer.yml
5. cv-tests-all.yml
6. cv-tests-apis.yml
7. cv-tests-scenarios.yml
8. cv-monitorings-apis.yml
9. cv-security-test.yml

### Continuous Integration, CI

#### 1. Build all modules, ci-build-all.yml

It consists of these steps 

1. Checkout 
2. JDK Setup with Maven Cache
2. Azure Login 
3. Create redisson.json for Redis config
4. Run Maven
5. Azure logout

In the step #4, it simply runs `mvn -B package -DskipTests -Denv=cloud` building all modules by skipping tests. 
At the sametime it is for SIT, System Integration Testing, performs to verify the interactions between the components/dependencies in the app. It deals with the verification of the high and low-level app requirements specified in the app requirements specification and the software design document. 
It also verifies a software system’s coexistence with others and tests the interface between modules of the application. In this type of testing, modules are first tested individually by building them and then combined to make entire application by integrating them each other.

#### 2. Build & run all tests for Customers module, ci-build-test-all-customer.yml

It runs for a module, `consumer-service` in this example. It consists of these steps 

1. Checkout 
2. JDK Setup with Maven Cache
3. Verifying build environment
4. OWASP check 
5. Static test for Java Code 
6. Run Maven with Unit Test
7. Upload all test documents to Blob

In the step #3, it runs `mvn -B enforcer:display-info` by using [Maven enforcer](https://maven.apache.org/enforcer/maven-enforcer-plugin/) plug-in, and it's instrumented in the `pom.xml`, 

```
<build>  
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-enforcer-plugin</artifactId>
      <version>3.0.0</version>
      <executions>
        <execution>
          <id>enforce-versions</id>
          <goals>
            <goal>enforce</goal>
          </goals>
          <configuration>
            <rules>
              <bannedPlugins>
                <!-- will only display a warning but does not fail the build. -->
                <level>WARN</level>
                <excludes>
                  <exclude>org.apache.maven.plugins:maven-verifier-plugin</exclude>
                </excludes>
                <message>Please consider using the maven-invoker-plugin (http://maven.apache.org/plugins/maven-invoker-plugin/)!</message>
              </bannedPlugins>
              <requireMavenVersion>
                <version>3.5</version>
              </requireMavenVersion>
              <requireJavaVersion>
                <version>11</version>
              </requireJavaVersion>
              <requireOS>
                <family>unix</family>
              </requireOS>
            </rules>
          </configuration>
        </execution>
      </executions>
    </plugin>
    ..
```

In this example, it constraints Java and Maven version and you can easily add for more environment verifications such as OS, plugin, file, external dependencies and so on. Check [Built-In Rules](https://maven.apache.org/enforcer/enforcer-rules/index.html) for further details. 

In the step #4, it runs `mvn -B dependency-check:check ` by using [dependency-check](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/) plug-in, and it's instrumented in the `pom.xml`. The dependency-check plugin is tied to the verify or site phase depending on if it is configured as a build or reporting plugin. It runs vulnerability tests based on National Vulnerability Database (NVD) hosted by [NIST]( https://nvd.nist.gov) 


```
<build>  
  <plugins>
    <plugin>
      <groupId>org.owasp</groupId>
      <artifactId>dependency-check-maven</artifactId>
      <version>6.5.3</version>
      <executions>
        <execution>
          <id>owasp-check</id>
          <goals>
            <goal>check</goal>
          </goals>
        </execution>
      </executions>
      <configuration>
        <failBuildOnCVSS>8</failBuildOnCVSS>
      </configuration>  
    </plugin>
    ..
..

  <reporting>
    <plugins>
      <plugin>
        <groupId>org.owasp</groupId>
        <artifactId>dependency-check-maven</artifactId>
        <version>6.5.3</version>
                <reportSets>
                    <reportSet>
                        <reports>
                            <report>aggregate</report>
                        </reports>
                    </reportSet>
                </reportSets>       
      </plugin>
      ..
```

In the step #5, it runs `mvn -B spotbugs:check` by using [SpotBugs](https://spotbugs.github.io/) plug-in, and it's instrumented in the `pom.xml` too. It is for static analysis to look for bugs in Java code. 

```
<build>  
  <plugins>
    <plugin>
      <!--com.github.spotbugs:spotbugs-maven-plugin:3.1.7:spotbugs-->
      <groupId>com.github.spotbugs</groupId>
      <artifactId>spotbugs-maven-plugin</artifactId>
      <version>4.5.3.0</version>
      <dependencies>
        <!-- overwrite dependency on spotbugs if you want to specify the version of spotbugs -->
        <dependency>
          <groupId>com.github.spotbugs</groupId>
          <artifactId>spotbugs</artifactId>
          <version>4.5.3</version>
        </dependency>
      </dependencies>
      <executions>
        <execution>
          <id>spotbugs</id>
          <goals>
            <goal>check</goal>
          </goals>
        </execution>
      </executions>
      <configuration>
        <effort>Max</effort>
        <threshold>Low</threshold>
        <plugins>
          <plugin>
            <groupId>com.h3xstream.findsecbugs</groupId>
            <artifactId>findsecbugs-plugin</artifactId>
            <version>1.10.1</version>
          </plugin>
        </plugins>
      </configuration>
    </plugin>
    ..

```

In the step #6, it runs `mvn -B package test -Denv=cloud` which's automated unit test for functional verification of the module generating code coverage reports by using [JaCoCo](https://www.eclemma.org/jacoco/) plug-in, and it's instrumented in the `pom.xml` too. 

Code coverage, also called test coverage, is a measure of how much of the application’s code has been executed in testing. Essentially, it's a metric that many teams use to check the quality of their tests, as it represents the percentage of the production code that has been tested and executed. 

This gives development teams reassurance that their programs have been broadly tested for bugs and should be relatively error-free.

```
<build>  
  <plugins>
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.7</version>
      <executions>
        <execution>
          <id>prepare-agent</id>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
        </execution>
        <execution>
          <id>report</id>
          <phase>prepare-package</phase>
          <goals>
            <goal>report</goal>
          </goals>
        </execution>
        <execution>
          <id>post-unit-test</id>
          <phase>test</phase>
          <goals>
            <goal>report</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
    ..

```

If you want [SonarQube](https://www.sonarqube.org/) integration with JaCoCo plugin in Maven build, see [this](https://www.baeldung.com/sonarqube-jacoco-code-coverage)

Test reports generated from all steps above will be uploaded in the blob which you created in the previous step, [Deploying PetClinic App, step by step instruction](https://github.com/euchungmsft/spring-petclinic-microservices/blob/gene/README.md#deploying-petclinic-app-step-by-step-instruction)


#### 3. Build & deploy for all modules, cd-build-deploy-all.yml

It consists of these steps 

1. Checkout 
2. JDK Setup with Maven Cache
3. Azure Login 
4. Create redisson.json for Redis config
5. Run Maven for build and package all modules skipping test
6. Deploy modules in sequence - api-gateway, admin-server, customers-service, vets-service, visits-service, consumer-service, 
7. Azure logout

Sequence of the steps from build to deploy

#### 4. Build & deploy for Customers module, cd-build-deploy-customer.yml

It consists of these steps 

1. Checkout 
2. JDK Setup with Maven Cache
3. Azure Login 
4. Create redisson.json for Redis config
5. Run Maven for build and package Customer module skipping test
6. Deploy Customer module
7. Azure logout

In this example, the pipeline's structured and separated into three jobs, init - build - deploy. To separate these jobs, cache's configured and passed to the next job. You need to check cache first and prepare cache for the result of current job, then it's checked in the next job.

It looks like this in the second job, build

```
  build:
    steps:

      - name: Check Maven Cache, restore m2 cache
        uses: actions/cache@v2
        id: cache_m2_repo         # check cache stored in the previous job with path and cache key
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}

      - name: Cache Build Path, cache builds
        uses: actions/cache@v2
        with:                     # build cache for the next job with path and the cache key
          path: ${{ env.CACHED_BUILD_PATHS }}
          key: ${{ env.BUILD_CACHE_KEY }}

      - name: Package, Unit test, Code Coverage
        if: steps.cache_m2_repo.outputs.cache-hit == '' # if no cache run this or skip this
        working-directory: spring-petclinic-${{ env.CUSTOMERS_SERVICE }}
        run: |
           mvn -B package -DskipTests -Denv=cloud  

      <step for build>
```

Before you skip to next step, you need to prepate JMeter test first, go to [/tests](/tests) folder and load petclinic-test-all.jmx file from your JMeter

![Test All](media/cicd-jmeter-testall.png)

Click on user-scenario-01 node on the right

![User Scenario](media/cicd-jmeter-scenario-01.png)

Screenshots above presents how test configs are externalized, how ${VUSER_COUNT}, ${RAMPUP_PERIOD}, ${LOOP_COUNT} are defined in the first shot. Those variables will be configured when you set up a test on Azure Load Test. To create the instance and set up your first test, see this page for step by step instructions [Quickstart: Create and run a load test with Azure Load Testing Preview](https://docs.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test)

Once you have created test and finally succeeded to run the test, you will find the test results like below

![Test Results](media/cicd-alt-tests.png)

Click on the item

![Test Report](media/cicd-alt-report.png)

To run these test from GitHub Action, steps in the workflow looks like this

```
env:
  AZURE_CRED: ${{ secrets.AZURE_CREDENTIALS01 }}
  LOAD_TEST_RESOURCE: "spcm016-test"
  LOAD_TEST_RESOURCE_GROUP: "spcm016-rg"
  TARGET_DOMAIN: "spcm016-springcloud-api-gateway.azuremicroservices.io"

jobs:

  loadTest:
    name: Load Test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout GitHub Actions 
        uses: actions/checkout@v2

      - name: Login to Azure
        uses: azure/login@v1
        continue-on-error: false
        with:
          creds: ${{ env.AZURE_CRED }}        

      - name: Azure Load Testing
        uses: azure/load-testing@v1
        with:
          loadTestConfigFile: 'tests/petclinic-test-all-config.yml'
          loadTestResource: ${{ env.LOAD_TEST_RESOURCE }}
          resourceGroup: ${{ env.LOAD_TEST_RESOURCE_GROUP }}
          env: |
            [
                {
                "name": "TARGET_DOMAIN",
                "value": "${{ env.TARGET_DOMAIN }}"
                },
          ...
```

AZURE_CRED is the token when you need to run Azure CLI, LOAD_TEST_RESOURCE and LOAD_TEST_RESOURCE_GROUP are parameters to run `azure/load-testing@v1` as GitHub Action plugin to run Azure Load Testing remotely from GitHub Actions. See this [page](https://github.com/marketplace/actions/azure-load-testing) for further details of the plugin

All externalized configs are defined in the previous step are found from  `env`

Test config file of `loadTestConfigFile` looks like this

```
version: v0.1
testName: petclinic-test-all
testPlan: petclinic-test-all.jmx
description: 'PetClinic test all'
engineInstances: 1
failureCriteria:
  - avg(response_time_ms) > 300
  - percentage(error) > 50
```

It finds `petclinic-test-all` from your tests created in the previous steps, count of load generators are `engineInstances`, See this [page](https://docs.microsoft.com/en-us/azure/load-testing/reference-test-config-yaml) to find all details of the parameters

Synthetic monitoring, or synthetic testing, is an application performance monitoring practice that emulates the paths users might take when engaging with an application. It uses scripts to generate simulated user behavior for different scenarios, geographic locations, device types, and other variables.

After collecting and analyzing this valuable performance data, a synthetic monitoring solution can:

- Give you crucial insight into how well your application is performing
- Automatically keep tabs on application uptime and tell you how your application responds to typical user behavior
- Zero in on specific business transactions — for example, by alerting you to issues users might experience while attempting to complete a purchase or fill out a web form

With the workflows defined 

```
on:
  workflow_dispatch:
  schedule:
    - cron: '*/30 * * * *'
```    







## Known issues

TBD

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.