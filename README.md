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

with same path but different file name.

---

### Installation

Step-by-step guide to get your development environment running.

0.  **Terraform format the syntax:**
    ```bash
    terraform fmt
    ```
1.  **Terraform dry-run or preview changes:**
    ```bash
    terraform plan
    ```
2.  **Terraform apply the changes to Azure:**
    ```bash
    terraform apply -auto-approve
    ```
3.  **Terraform destroy resources:**
    ```bash
    terraform apply -destroy
    ```
4.  **Terraform list existing resources:**
    ```bash
    terraform state list
    ```
5.  **Terraform show specific resource info:**
    ```bash
    terraform state show <resouce name> 
    ```    
---

## 🚀 Usage

should Run the command and deploy to Azure.

```bash
# Comment
to be updated
```

connect to VM
```bash
ssh -i ~/.ssh/terraform-test-azure adminuser@<public ip address>
```
to find public ip address run terraform cli to check VM detail
```bash
terraform state show azurerm_linux_virtual_machine.terraform-test-vm
```