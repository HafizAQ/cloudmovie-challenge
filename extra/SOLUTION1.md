# CloudMovie Challenge - SOLUTION1

## 1. Project Overview

**CloudMovie Challenge** is a cloud engineering capstone project that deploys a movie-guessing web application on AWS using a production-oriented architecture. The application presents emoji-based movie challenges, allows users to play interactively, and stores leaderboard scores in Amazon DynamoDB.

This `SOLUTION1.md` file documents the implemented solution using the **20 solution screenshots** provided for the project.

---

## 2. Solution Summary

### Application Features
- Home page to start the challenge
- Game page for emoji-based movie guessing
- Leaderboard page to save and view scores
- Persistent score storage using **Amazon DynamoDB**

### AWS Infrastructure Components Evidenced in the Screenshots
- **VPC**
- **Subnets**
- **Route Tables**
- **Internet Gateway**
- **Elastic IP**
- **NAT Gateway**
- **Security Groups**
- **EC2**
- **Application Load Balancer (ALB)**
- **Target Group**
- **DynamoDB**

---

## 3. Application Screens

### 3.1 Home Page
**Image path:** `docs/screenshots/01-application-home-page.png`

The home page introduces the CloudMovie Challenge and provides entry points to start the game or open the leaderboard.

![Application Home Page](docs/screenshots/01-application-home-page.png)

### 3.2 Game Page
**Image path:** `docs/screenshots/02-application-game-page.png`

The game page displays emoji clues, multiple-choice answers, the current score, and an option to save the score.

![Application Game Page](docs/screenshots/02-application-game-page.png)

### 3.3 Leaderboard Page
**Image path:** `docs/screenshots/03-application-leaderboard-page.png`

The leaderboard page displays stored scores and confirms that application data is integrated with Amazon DynamoDB.

![Application Leaderboard Page](docs/screenshots/03-application-leaderboard-page.png)

---

## 4. Networking Layer (AWS VPC)

### 4.1 VPC Dashboard - Resources by Region
**Image path:** `docs/screenshots/04-vpc-dashboard-resources-by-region.png`

This screenshot shows the VPC dashboard summary for the Frankfurt region and confirms the presence of VPC-related resources such as subnets, route tables, NAT gateways, internet gateways, and security groups.

![VPC Dashboard Resources by Region](docs/screenshots/04-vpc-dashboard-resources-by-region.png)

### 4.2 VPC Resource Map
**Image path:** `docs/screenshots/05-vpc-resource-map.png`

This view shows the main custom VPC `cloudmovie-challenge-dev-vpc`, including its subnets, route tables, and attached network connections.

![VPC Resource Map](docs/screenshots/05-vpc-resource-map.png)

### 4.3 Subnets
**Image path:** `docs/screenshots/06-subnets.png`

The architecture includes four subnets split across two Availability Zones:
- `cloudmovie-challenge-dev-public-1`
- `cloudmovie-challenge-dev-public-2`
- `cloudmovie-challenge-dev-private-1`
- `cloudmovie-challenge-dev-private-2`

This reflects a more production-like network layout with separation between public and private resources.

![Subnets](docs/screenshots/06-subnets.png)

### 4.4 Route Tables
**Image path:** `docs/screenshots/07-route-tables.png`

The route table view confirms separate public and private route tables for traffic control within the VPC.

![Route Tables](docs/screenshots/07-route-tables.png)

### 4.5 Internet Gateway
**Image path:** `docs/screenshots/08-internet-gateway.png`

The custom internet gateway `cloudmovie-challenge-dev-igw` is attached to the project VPC, allowing internet connectivity for public-facing resources.

![Internet Gateway](docs/screenshots/08-internet-gateway.png)

### 4.6 Elastic IP Addresses
**Image path:** `docs/screenshots/09-elastic-ip-addresses.png`

Elastic IP allocation is visible here. One of the addresses is clearly associated with the NAT gateway used for outbound internet access from private resources.

![Elastic IP Addresses](docs/screenshots/09-elastic-ip-addresses.png)

### 4.7 NAT Gateway
**Image path:** `docs/screenshots/10-nat-gateway.png`

The NAT gateway is shown as **Available**. Its purpose is to allow private resources, such as private EC2 instances, to reach the internet for outbound traffic without exposing them directly to inbound public traffic.

![NAT Gateway](docs/screenshots/10-nat-gateway.png)

### 4.8 Security Groups
**Image path:** `docs/screenshots/11-security-groups.png`

The security groups shown include dedicated groups for:
- the Application Load Balancer
- the application EC2 instances
- default VPC groups

This confirms security segmentation at the network access layer.

![Security Groups](docs/screenshots/11-security-groups.png)

---

## 5. Compute and Load Balancing Layer

### 5.1 EC2 Dashboard
**Image path:** `docs/screenshots/12-ec2-dashboard.png`

The EC2 dashboard confirms the presence of core compute resources in the Frankfurt region, including a running instance, load balancer, security groups, and related EC2 resources.

![EC2 Dashboard](docs/screenshots/12-ec2-dashboard.png)

### 5.2 EC2 Instances Overview
**Image path:** `docs/screenshots/13-ec2-instances-overview.png`

This screenshot shows the application instances. One instance is currently **running**, while another previous instance is shown as **terminated**. This is useful evidence of iterative deployment and environment testing.

![EC2 Instances Overview](docs/screenshots/13-ec2-instances-overview.png)

### 5.3 EC2 Instance Details
**Image path:** `docs/screenshots/14-ec2-instance-details.png`

Detailed instance information is shown here for `cloudmovie-challenge-dev-app`, including:
- AMI
- launch time
- platform details
- monitoring status
- instance lifecycle metadata

![EC2 Instance Details](docs/screenshots/14-ec2-instance-details.png)

### 5.4 Running EC2 Instance - Private Network Placement
**Image path:** `docs/screenshots/15-ec2-running-instance-private-network.png`

This screenshot confirms the active EC2 instance is running with a **private IPv4 address** (`10.0.11.28`) inside the custom VPC, which aligns with the architecture pattern where the application sits behind the ALB.

![Running EC2 Instance - Private Network Placement](docs/screenshots/15-ec2-running-instance-private-network.png)

### 5.5 Application Load Balancer
**Image path:** `docs/screenshots/16-application-load-balancer.png`

The Application Load Balancer `cloudmovie-challenge-dev` is shown as:
- **Type:** Application
- **Scheme:** Internet-facing
- **Status:** Active
- deployed across **2 Availability Zones**

This demonstrates a scalable and production-style entry point for the web application.

![Application Load Balancer](docs/screenshots/16-application-load-balancer.png)

### 5.6 Target Group
**Image path:** `docs/screenshots/17-target-group.png`

The target group connected to the load balancer is configured on **HTTP port 5000** and shows **1 healthy target**, confirming successful registration of the application instance behind the ALB.

![Target Group](docs/screenshots/17-target-group.png)

---

## 6. Data Layer - Amazon DynamoDB

### 6.1 DynamoDB Table Overview
**Image path:** `docs/screenshots/18-dynamodb-table-overview.png`

This screenshot shows the leaderboard table:
- **Table name:** `cloudmovie-challenge-dev-leaderboard`
- **Partition key:** `player_id`
- **Status:** Active

It confirms the project uses DynamoDB as a managed NoSQL data store.

![DynamoDB Table Overview](docs/screenshots/18-dynamodb-table-overview.png)

### 6.2 DynamoDB Table Details, Encryption, and Tags
**Image path:** `docs/screenshots/19-dynamodb-table-details-tags-encryption.png`

This view confirms additional table configuration, including:
- TTL section
- encryption at rest using an AWS owned key
- project tags such as `Project`, `ManagedBy`, `Environment`, and `Purpose`

This helps show operational organization and governance.

![DynamoDB Table Details, Encryption, and Tags](docs/screenshots/19-dynamodb-table-details-tags-encryption.png)

### 6.3 DynamoDB Leaderboard Items
**Image path:** `docs/screenshots/20-dynamodb-leaderboard-items.png`

This screenshot shows actual leaderboard items stored in the table, including player names and scores. It serves as direct evidence that the application successfully writes data to DynamoDB.

![DynamoDB Leaderboard Items](docs/screenshots/20-dynamodb-leaderboard-items.png)

---

## 7. End-to-End Solution Flow

The solution flow demonstrated by the application and AWS screenshots can be summarized as follows:

1. A user opens the **CloudMovie Challenge** application.
2. The user starts the movie guessing game.
3. The application runs on an **EC2 instance** inside the custom **VPC**.
4. External traffic enters through the **Application Load Balancer**.
5. The ALB forwards requests to the healthy target in the **target group** on port `5000`.
6. The application stores leaderboard records in **Amazon DynamoDB**.
7. Private network design is supported by **private subnets**, **route tables**, and a **NAT gateway** for outbound access.
8. **Security groups** control network-level access between components.

---

## 8. Key Achievements Demonstrated

This solution demonstrates the following cloud engineering capabilities:

- Designing a custom **AWS VPC network architecture**
- Separating resources into **public and private subnets**
- Using an **Internet Gateway** and **NAT Gateway** appropriately
- Deploying an application on **EC2**
- Exposing the application through an **Application Load Balancer**
- Registering application instances inside a **target group**
- Persisting application data in **Amazon DynamoDB**
- Building a small but complete cloud-hosted application with a real user workflow

---

## 9. Screenshot Inventory and Source Mapping

The following table maps the inserted repository-friendly screenshot paths to the original attached image paths used to prepare this documentation.

| # | Repository image path | Original attached image path |
|---|---|---|
| 01 | `docs/screenshots/01-application-home-page.png` | `/mnt/data/ghostwriter_images/context/90177636-37bf-5773-a1b9-b11682e6167f.png` |
| 02 | `docs/screenshots/02-application-game-page.png` | `/mnt/data/ghostwriter_images/context/5d6928cf-dbb3-592b-b0cb-8b84dd77efc3.png` |
| 03 | `docs/screenshots/03-application-leaderboard-page.png` | `/mnt/data/ghostwriter_images/context/800f096b-7dba-5c47-815f-013ba86bccff.png` |
| 04 | `docs/screenshots/04-vpc-dashboard-resources-by-region.png` | `/mnt/data/ghostwriter_images/context/ebbc5763-236c-5342-a147-a6f6f5636888.png` |
| 05 | `docs/screenshots/05-vpc-resource-map.png` | `/mnt/data/ghostwriter_images/context/9f34c807-81b4-530d-abb1-23fe406363ec.png` |
| 06 | `docs/screenshots/06-subnets.png` | `/mnt/data/ghostwriter_images/context/77519a81-5cee-5175-b710-1cb478d9ea58.png` |
| 07 | `docs/screenshots/07-route-tables.png` | `/mnt/data/ghostwriter_images/context/43df8d34-de43-5597-a66e-c50c4c871723.png` |
| 08 | `docs/screenshots/08-internet-gateway.png` | `/mnt/data/ghostwriter_images/context/eb24f5e9-483d-5980-ae1f-fdfddddb6a47.png` |
| 09 | `docs/screenshots/09-elastic-ip-addresses.png` | `/mnt/data/ghostwriter_images/context/515cbbaf-9db8-5c7f-909b-b13b01fafca7.png` |
| 10 | `docs/screenshots/10-nat-gateway.png` | `/mnt/data/ghostwriter_images/context/5d3d51f7-306d-5075-b6f5-c2ede82dc479.png` |
| 11 | `docs/screenshots/11-security-groups.png` | `/mnt/data/ghostwriter_images/context/b2eb929b-b645-578f-8377-4f7e34575d38.png` |
| 12 | `docs/screenshots/12-ec2-dashboard.png` | `/mnt/data/ghostwriter_images/context/30c6939e-886c-576e-8b7c-1395406bc4ac.png` |
| 13 | `docs/screenshots/13-ec2-instances-overview.png` | `/mnt/data/ghostwriter_images/context/5f470c45-e216-57dd-a5df-e7daa83ba2cf.png` |
| 14 | `docs/screenshots/14-ec2-instance-details.png` | `/mnt/data/ghostwriter_images/context/f654130c-0a9e-540f-8da6-b12c3349870e.png` |
| 15 | `docs/screenshots/15-ec2-running-instance-private-network.png` | `/mnt/data/ghostwriter_images/context/f58318b4-b4e6-5e53-b4ca-55d8b45871f6.png` |
| 16 | `docs/screenshots/16-application-load-balancer.png` | `/mnt/data/ghostwriter_images/context/490d9ff6-b35f-5d32-bda2-c53f5bb58dde.png` |
| 17 | `docs/screenshots/17-target-group.png` | `/mnt/data/ghostwriter_images/context/16fe8044-fd93-5e5f-99d6-0b8d37344453.png` |
| 18 | `docs/screenshots/18-dynamodb-table-overview.png` | `/mnt/data/ghostwriter_images/context/49a9b89f-c686-5178-a2ff-63f733b97fc4.png` |
| 19 | `docs/screenshots/19-dynamodb-table-details-tags-encryption.png` | `/mnt/data/ghostwriter_images/context/c1e18d82-5b4b-5174-b9a8-f5ac88534dfa.png` |
| 20 | `docs/screenshots/20-dynamodb-leaderboard-items.png` | `/mnt/data/ghostwriter_images/context/721eaf15-b73c-55d6-b21e-57774c510ebd.png` |

---

## 10. Final Note

If you place `SOLUTION1.md` at the root of your GitHub repository and keep the screenshots under `docs/screenshots/`, the Markdown image links will work cleanly in GitHub.
