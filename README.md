<p align="center">
<img src="https://github.com/djtoler2/Deployment6/blob/main/assets/Graphic%20Design-7.png">
</p>

## Purpose
#### The goal of Deployment 6 was to enhance the reliability of our banking application infrastructure. By doing this, we increase the confidence of our users, ensuring they have consistent and uninterrupted access to our services. This growth in user confidence will cause an increase in user loyalty which directly translates into more transactions & revenue.

#### Our last deployment, 5.1, decoupled our application from our Jenkins server. This partially addressed the single point of failure issue and using Jenkins agents made our system architecture more distributed. However, our infrastructure was still allocated in a single region, leaving our system vulnerabe to a disaster and possible latency issues. We were also using SQLite, leaving our customers data exposed to anything that has access to our server. Our 2nd application server was also just used as a standby instance incase an availability zone went down.

#### In Deployment 6, we solved several issues that our last deployment left us with.
* #### We added an additional 2 application servers in US-West-2 for a multi-region infrastructure that'll fully address the single point of failure issue (minus configuration), ensuring that our application is prepared to still service customers in the event of a disaster
* #### We added a single load balancer in each region to equally distribute ingreess traffic amongst our 2 instances that are in seperate AZs, increasing our banking applications availability to facilitate users transactions.
* #### We decoupled our database from our application by moving away from SQLite and using AWS RDS and this came at a cost of an increase in latency sinces we're no longer reading and writing data locally. However, we increased the scalability and flexibility of our database conponent. We also took a step ij the direction of making our users data more secure.
* #### We intergrated Terraform into our Jenkins pipeline, deploying our infrastructure via a Jenkins agent, which optimized our applications infrastructure depoyment proceess.

___

## Issues
#### 1. Load balancer return 504 error

 Using Load balancer URL directly in browser                 | Using CURL with URL in command line                    |
| ----------------------------------- | ----------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/elberror2.PNG) | ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/elberror.PNG) |

#### We found that we needed to add a rule to our security group that allows egreess traffic to port 8000, our applicatoions port.

 Default Outbound Security Group rules                 | Updated Outbound Security Group rules                   |
| ----------------------------------- | ----------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/elberror3.PNG) | ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/elberror4.PNG) |

#### 2. Incompatable dependency versions during application install

<p align="center">
<img src="https://github.com/djtoler/Deployment6/blob/main/assets/configdrifterror.PNG">
</p>

#### This error occured during the installation of our setup process on our application instances. I ran the commands line by line once the application didnt deploy automatically. I noticed that because we were not running these commands inside our Python virtual enviornment, we were experiencing configuration drift. To fix this, I simply switched the order of setup commands and we had a successful application launch.

___

## Steps
#### 1. Download banking application source code from GitHub to local machine
* ##### _Create a GitHub token_
> 
```
# Go to GitHub settings
# Go to "Developer Settings" on the left panel
# Click "Personal Access Tokens"
# Click "Generate New Token" then "Generate Classic Token"
# Select repo, admin:org, admin:repo_hook
# Copy the token and paste it somewhere safe for future use
```

* ##### _Run this script to create a remote GitHub repository using your token (GitHub Repo Creation Script)_
>
```
# Have you GitHub token ready & think of a name for your new repo
curl -O https://github.com/djtoler/automated_installation_scripts/blob/main/auto-github_repo_create.sh
chmod +x auto-github_repo_create.sh
./auto-github_repo_create.sh <YourGitHubToken> <NameOfYourRepo>
```
* ##### _Set the remote GitHub repository in your local repository_
>
```
git remote add origin http://github.com/<YourUserName>/<NameOfYourRepo>.git
```
* ##### _Clone the source code from GitHub into our local repo and push into the remote repo_
>
```
git clone https://github.com/djtoler2/Deployment6.git
cd Deployment6
git add .
git commit -m'pushing source code to remote repo'
git push
```
* ##### _Create our second branch calld `dev1` to build our infrastructure_
```
git checkout -b dev1
git push -u origin dev1
```
#### 2. Use Terraform to deploy our CICD infrastructure using Jenkins controller/agent architecture
* ##### _Create 3 Terraform files called `main.tf` `variables.tf` & `terraform.tfvars`_
* ##### _Using Terraform, configure 2 EC2 instances, 1 for our Jenkins controller server and 1 for our Jenkins agent server_
    * ##### [`main.tf`](https://github.com/djtoler2/Deployment6/blob/main/main.tf), [`variables.tf`](https://github.com/djtoler2/Deployment6/blob/main/variables.tf) & [`terraform.tfvars`](https://github.com/djtoler2/Deployment6/blob/main/terraform.tfvars)_
* ##### _Create a userdata script to install the dependencides for each instance_
>
```
curl -O https://raw.githubusercontent.com/djtoler2/Deployment6/main/ud_jenkins_agent_tf.sh
curl -O https://github.com/djtoler2/Deployment6/blob/main/ud_jenkins_controller.sh
```

 Make sure our userdata scripts are in root directory                  | Use them in main.tf like this                     |
| ----------------------------------- | ----------------------------------- |
| ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/Screenshot%202023-10-31%20at%201.30.12%20PM.png) | ![aaaaaa.png](https://github.com/djtoler2/Deployment6/blob/main/assets/Screenshot%202023-10-31%20at%201.35.53%20PM.png) | 

* ##### _Deploy the 2 Jenkins instances_
    * Run `./tf_deploy.sh`

3. #### Store AWS credentials as enviornment variables in Jenkins
* ##### [_Follow the steps outlined here to store credintals in Jenkins_](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)

4. #### _Set up AWS RDS database_
* ##### [_Follow the steps outlined here to set up AWS Relational Database Service_](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw)


5. #### Deploy our multi-region banking application infrastructure from our Jenkins agent using Terraform
* ##### _Configure Terraform files to deploy and launch our application on each instance:_
    * ##### _2 VPC's (US-East-1, US-West-2)_
    * ##### _2 Route Tables_
    * ##### _2 Subnets in each region (US-East-1, US-West-2)_
    * ##### _2 Availability Zones in each region (US-East-1, US-West-2)_
    * ##### _1 Internet Gateway in each region (US-East-1, US-West-2)_
    * ##### _2 EC2 instances in each region (US-East-1, US-West-2)_
    * ##### _2 Route Tables_
>
```
cd terraformInit
git add .
git commit -m"pushing infrastructure"
git push
```

6. #### Configure a load balancer for each region our banking application is deployed in
* ##### _Create a target group for each application instance_
 * <p align="left"><img src="https://github.com/djtoler2/Deployment6/blob/main/assets/lb5050.PNG" width="75%"></p>

* ##### _Create a load balancer_
* ##### _Attach each task to the load balancer_
* ##### _Check our application at the load balancers URL_

___


## System Diagram

<p align="center">
<img src="https://github.com/djtoler2/Deployment6/blob/main/assets/dp6duagram.png">
</p>

___

## Optimization
#### Security: _Move our RDS into a private subnet for better security of our users' data_
#### Security: _Move our application servers into a private subnet_
#### Reliability: _Configure our infrastructure to failover to our alternate region if 1 region fails_
#### Performance: _Add a cache in front of our database_
#### Performance: _Add read replicas in the specific availability zones our application instances are in_
#### Availability: _Add auto-scaling capabilities to our instances_
