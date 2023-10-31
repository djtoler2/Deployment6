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

#### 1. Download banking application source code from GitHub to local machine
* ###### Create a GitHub token
* ###### Run this script to create a remote GitHub repository using your token (GitHub Repo Creation Script)
* ##### Set the remote GitHub repository in your local repository
* ##### Clone the source code from GitHub into our local repo and push into the remote repo
* ##### Create our second branch calld "dev1" to build our infrastructure

#### 2. Use Terraform to deploy our CICD infrastructure using Jenkins controller/agent architecture
* ##### Switch to our "dev1" branch
* ##### Create 3 Terraform files called "main.tf", "variables.tf" & "terraform.tfvars"
* ##### Usimg Terraform, configure 2 EC2 instances, 1 for our Jenkins controller server and 1 for our Jenkins agent server
* #### Create a userdata script to install the dependencides for each instance
* ##### Deploy the 2 Jenkins instances

3. #### Store AWS credentials as enviornment variables in Jenkins
* #### Follow the steps outlined here to store credintals in GitHub

4. #### Set up AWS RDS database
* ##### Follow the steps outlined here to store credintals in GitHub

5. #### Deploy our multi-region banking application infrastructure from our Jenkins agent using Terraform
* ##### Configure Terraform files to deploy:
*    * ##### 2 VPC's (US-East-1, US-West-2)
*    * ##### 2 Route Tables
*    * ##### 2 Subnets in each region (US-East-1, US-West-2)
*    * ##### 2 Availability Zones in each region (US-East-1, US-West-2)
*    * ##### 1 Internet Gateway in each region (US-East-1, US-West-2)
*    * ##### 2 EC2 instances in each region (US-East-1, US-West-2)
*    * ##### 2 Route Tables
* ##### Use the following setup script to download and launch our application on each instance

6. #### Configure a load balancer for each region our banking application is deployed in
* #### Create a task for each application instance
* #### Create a load balancer
* #### Attach each task to the load balancer
* #### Check our application at the load balancers URL




## System Diagram

<p align="center">
<img src="https://github.com/djtoler2/Deployment6/blob/main/assets/dp6duagram.png">
</p>

Optimization
