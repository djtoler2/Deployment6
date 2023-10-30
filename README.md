## Deployment 6

## Purpose
#### The goal of Deployment 6 was to enhance the reliability of our banking application infrastructure. By doing this, we increase the confidence of our users, ensuring they have consistent and uninterrupted access to our services. This growth in user confidence will cause an increase in user loyalty which directly translates into more transactions & revenue.

#### Our last deployment, 5.1, decoupled our application from our Jenkins server. This partially addressed the single point of failure issue and using Jenkins agents made our system architecture more distributed. However, our infrastructure was still allocated in a single region, leaving our system vulnerabe to a disaster and possible latency issues. We were also using SQLite, leaving our customers data exposed to anything that has access to our server. Our 2nd application server was also just used as a standby instance incase an availability zone went down.

#### In Deployment 6, we solved several issues that our last deployment left us with.
* #### We added an additional 2 application servers in US-West-2 for a multi-region infrastructure that'll fully address the single point of failure issue.
* #### We added a single load balancer in each region to equally distribute ingreess traffic amongst our 2 instances that are in seperate AZs, increasing our banking applications availability.
* #### We decoupled our database from our application by moving away from SQLite and using AWS RDS. This increased the scalability andflexibility of our database conponent and made our users data more secure. This came at a cost of an increase in latency sinces we're no longer reading and writing data locally.
* #### We also intergrated Terraform into our Jenkins pipeline, deploying our infrastructure via a Jenkins agent, which optimized our applications infrastructure depoyment proceess.

___

Issues



## Steps
* #### Download banking application source code from GitHub to local machine
* #### Create our second branch calld "dev"
* #### Use Terraform to deploy our CICD infrastructure using Jenkins controller/agent architecture
* #### Srore AWS credentials as enviornment variables in Jenkins
* #### Set up AWS RDS database
* #### Deploy our multi-region banking application infrastructure from our Jenkins agent using Terraform
* #### Configure a load balancer for each region our banking application is deployed in



System Diagram

Optimization
