# Terraform with Azure

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-lightgrey)](https://github.com/your-username/your-repo-name/releases/tag/v0.0.1)

---

## 📝 Table of Contents

* [About The Project](#about-the-project)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)


---

## 🚀 About The Project

This project is for Terraform basics with utilize Visual Studio Code to deploy Azure resources and an Azure VM that you can SSH into to have your own redeployable environment that will be perfect for future projects!

---


## 🛠️ Getting Started

Instructions on how to set up your project locally.

### Prerequisites

List any software, tools, or accounts required before setting up the project.

* `VS code`
* `Azure CLI`
* `Terraform CLI`
* `VS code Terraform extension`
* `Git`
---
## Generate ssh-key
```bash
ssh-keygen -t rsa
```

with same path but use different file name to identify the keys.

Rename file `terraform.tfvars.example` to `terraform.tfvars` and update variables for Windows local user folder name.

---

### Terraform Commands

Some helpful Terraform commands

0.  **Terraform format the syntax:**
    ```bash
    # format the terraform files.
    terraform fmt
    ```
1.  **Terraform dry-run or preview changes:**
    ```bash
    #  execution plan that shows you exactly what Terraform will do.
    terraform plan
    ```
2.  **Terraform apply the changes to Azure:**
    ```bash
    # executes the actions defined in the execution plan, making the actual changes to your cloud infrastructure.
    terraform apply -auto-approve
    ```
3.  **Terraform destroy resources:**
    ```bash
    # generate a plan that will destroy all resources
    terraform apply -destroy
    ```
4.  **Terraform list existing resources:**
    ```bash
    # lists all the resources currently being managed by your Terraform configuration
    terraform state list
    ```
5.  **Terraform show specific resource info:**
    ```bash
    # displays the attributes and values of a specific resource as they are recorded in state file(terraform.tfstate).
    terraform state show <resouce name> 
    ```
6.  **Terraform replace specific resource:**
    ```bash
    #  destroy a specific resource and then immediately recreate it
    terraform apply -replace <resouce name> 
    ```
7.  **Terraform state refresh without making any infrastructure changes:**
    ```bash
    # This command is primarily used for drift detection and state synchronization when you suspect manual changes have occurred in your cloud environment outside of Terraform.
    terraform apply -refresh-only 
    ```

---

### Azure Commands

Some helpful Azure commands

0.  **Azure find machine images sku with offer and publisher:**
    ```bash
    # Since offer being changed for Ubuntu version after 18.04
    az vm image list-skus --location useast --publisher Canonical --offer 0001-com-ubuntu-server-jammy --output table 
    ```

---


## 🚀 Usage

should Run the command and deploy to Azure.

```bash
terraform apply -auto-approve
```

connect to VM
```bash
ssh -i ~/.ssh/terraform-test-azure adminuser@<public ip address>
```
to find public ip address run terraform cli to check VM detail
```bash
terraform state show azurerm_linux_virtual_machine.terraform-test-vm
```