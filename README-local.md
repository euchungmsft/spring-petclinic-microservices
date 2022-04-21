# Running PetClinic app locally

First you need to work through all steps to [Configure config-server by Azure Spring Cloud](README.md#configure-config-server-by-azure-spring-cloud) from the begining in the previous document [here](README.md)

Run servers and services in sequence

1. config-server 
2. discovery-server 
3. api-gateway 
4. admin-server 
5. consumer 
6. customers-service 
7. vets-service 
8. visits-service 

Be careful that `discovery-server` and `api-gateway` requires `config-server`, and rest of servers/services requires `discovery-server` and `api-gateway`

From the commandline, start `config-server`

```

bin/run.sh config-server

```

It normally takes minutes. Check `config-server` logs from `logs`

![Config Server Log](media/local-config-server.png)

Start `discovery-server`, `api-gateway` and `admin-server`

```

bin/run.sh discovery-server api-gateway
bin/run.sh admin-server

```

Then, you can run all the rest at once

```

bin/run.sh customers-service vets-service visits-service consumer 

```

After all instances up, open `http://localhost:8761/` from your web browser for Eureka Dashboard

![Eureka Dashboard](media/local-eureka.png)

Open `http://localhost:9090/` for Spring Boot Admin Console

![SP Admin 1](media/local-admin.png)
![SP Admin 2](media/local-admin2.png)

And open `http://localhost:8080/` for PetClinic app

![PetClinic 1](media/local-petclinic.png)
![PetClinic 2](media/local-petclinic2.png)


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