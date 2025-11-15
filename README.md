Follow this link to see the project demo: https://drive.google.com/file/d/1ivDhKmfAY2mlGXH6MnDMe04hkgXalMOT/view?usp=sharing

📘 Project: End-to-End Terraform Deployment Pipeline Using Azure DevOps

**Overview**
This project demonstrates a complete Infrastructure-as-Code (IaC) deployment workflow using Terraform and Azure DevOps Pipelines.
It includes:
* Modular Terraform code for provisioning Azure resources
* Parameterized YAML pipeline templates for `terraform init`, `plan`, and `apply`
* Integration with Azure DevOps Variable Groups
* Backend state management using Azure Storage
* Support for multi-environment deployments (dev/test/prod)
* Automated terraform apply/destroy workflow

This mirrors a real-world enterprise DevOps setup and showcases how to design scalable and maintainable Terraform deployment pipelines.


🏗️ **Architecture / Flow**
1. Developer updates Terraform modules in Azure DevOps Repo
2. Azure DevOps Pipeline triggers
3. Pipeline fetches variables from a Variable Group
4. Runs:
   * `terraform init`
   * `terraform plan`
   * `terraform apply`
5. Azure Storage Account is used as the remote backend to maintain the state files
6. Resources are deployed into Azure automatically

<img width="1536" height="1024" alt="Architecture" src="https://github.com/user-attachments/assets/8d11a5ca-cce8-4c5a-a3af-56064c05341c" />



⚙️ **Pipeline Highlights**
* Written completely in YAML, no Classic pipelines
* Uses pipeline templates for reuse
* Dynamically loads variable files
* Supports destroy operations
* Error handling + conditions for different stages
* ServiceNow notification logic (optional)

🧩 **Terraform Highlights**
* Modular structure for reusability
* Uses `*.tfvars` for environment-specific config
* Remote backend configured dynamically
* Role Assignments / Private Endpoints / VM deployments depending on module
* Sensitive values pulled from Azure DevOps Variable Groups

🚀 **How to Run**
1. Clone the repository
2. Update the tfvars files under `pipelines/azure/var_files/resourece_name.tfvars`
3. Configure the variable group in Azure DevOps
4. Run the main YAML pipeline
5. Azure resources will be deployed automatically

🔐 **Security Note**
All secrets (SP credentials, connection strings) are referenced from Azure DevOps Variable Groups and not stored in the repository.

📝 Additional Notes
This project is only a demonstration of the pipeline structure and IaC design.
Actual production credentials and sensitive configurations are removed.
