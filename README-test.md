# Fully managed load-testing for PetClinic app

This example shows how to config managed load testing for PetClinic by using Azure load Testing. It enables developers and testers to generate high-scale load and run simulations that reveal actionable insights into app performance, scalability, and capacity with a fully managed load-testing service. Get started quickly using existing Apache JMeter scripts, gain specialized recommendations backed by comprehensive metrics and analytics, and support continuous improvement through automated continuous integration and continuous delivery (CI/CD) workflows—all with a testing service built for Azure.

There you need to install [JMeter](https://jmeter.apache.org/download_jmeter.cgi) first, latest version's recommended

1. Config test by using JMeter
2. Deploy the test to Azure Load Testing
3. Run & Evaluating the test

## 1. Config test by using JMeter

Open `tests/petclinic-test-all.jmx` from JMeter

![test all](media/alt-jmeter1.png)

In the test plan, there you can find three Thread Groups on the left. 
- `user-scenario-01` is scenario test navigating pages on PetClinic app which you may want to run for load testing. 
- `api-testing-01` is for API test. API test's configured for 4 apis. It's for sythetic monitoring in operation
- `api-monitoring-01` is for monitoring which calls actuator end-points instrumented in the app

What's actuator ? Monitoring the Spring Boot app, gathering metrics, understanding traffic, or the state of our database become trivial with this dependency. The main benefit of Actuator is that you can get production-grade tools without having to actually implement these features yourself. 
Actuator is mainly used to expose operational information about the running application — health, metrics, info, dump, env, etc. It uses HTTP endpoints or JMX beans to enable us to interact with it.
Once this dependency is on the classpath, several endpoints are available for us out of the box. As with most Spring modules, we can easily configure or extend it in many ways.






## 2. Deploy the test to Azure Load Testing

## 3. Run & Evaluating the test

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
