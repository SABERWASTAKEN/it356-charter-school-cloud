# Ann Arbor Charter School Cloud Infrastructure (IT356)

This repository contains the Terraform Infrastructure-as-Code (IaC) configuration to provision a secure, segmented cloud network and server environment on Amazon Web Services (AWS) for a charter school located in Ann Arbor, Michigan (~20 staff members and 150–200 students).

## Repository Structure
* `provider.tf` – Configures the Terraform version constraints and the AWS provider targeting the `us-east-2` (Ohio) region.
* `network.tf` – Provisions the Virtual Private Cloud (`10.0.0.0/16`), external/public (`10.0.1.0/24`) and internal/private (`10.0.2.0/24`) subnets, Internet Gateway, NAT Gateway, and route tables.
* `security.tf` – Defines Security Groups and network access control rules separating public-facing traffic from internal identity and administrative services.
* `compute.tf` – Deploys the 8 EC2 virtual machines (4 Windows Servers and 4 Linux Servers) across the internal and external subnets.

## Architecture Overview
* **Cloud Provider & Region:** AWS `us-east-2` (US East – Ohio) selected for geographic proximity and low network latency to Ann Arbor, MI.
* **Network Segmentation:**
  * **External / Public Subnet (`10.0.1.0/24`):** Hosts public-facing Linux services and outbound NAT routing.
  * **Internal / Private Subnet (`10.0.2.0/24`):** Isolates core Windows identity infrastructure and internal Linux application servers from direct public internet exposure.
* **Compute Instances (8 Total VMs):**
  * **Windows Servers (Internal Subnet — 4 vCPU / 8 GB RAM, `c5.xlarge`):**
    * `DC01` & `DC02`: Active Directory Domain Controllers (primary and redundant)
    * `MSCA01`: Microsoft Certificate Authority (PKI)
    * `NPS01`: Network Policy Server (RADIUS authentication)
  * **Linux Servers (2 vCPU / 4 GB RAM, `t3.medium`):**
    * `Linux-Ext-01` & `Linux-Ext-02` (External Subnet)
    * `Linux-Int-01` & `Linux-Int-02` (Internal Subnet)

## How to Deploy
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/SABERWASTAKEN/it356-charter-school-cloud.git](https://github.com/SABERWASTAKEN/it356-charter-school-cloud.git)
   cd it356-charter-school-cloud
