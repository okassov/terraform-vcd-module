# Terraform custom module (VMWare vCloud Director)

This custom module automating creation of Virtual Machnine in VMWare vCloud.

## Prerequisits

 - terraform  >= 1.0.4
 - vmware/vcd >= 1.0.3
 
## How to use module

 - Install terragrunt
 - Source this module in terragrunt.hcl
 - Run terragrunt

### Example of default project structure

```
project-name/
  |__dev/
       |__terragrunt.hcl
       |__postgresql/
            |__terragrunt.hcl
  |__stage/
       |__terragrunt.hcl
       |__postgresql/
            |__terragrunt.hcl
  |__prod/
       |__terragrunt.hcl
       |__postgresql/
            |__terragrunt.hcl
```

### Example of terragrunt.hcl for create single VM

```
terraform {
  source = "github.com/okassov/terraform-vcd-module.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vcd_org                  = "Magnum_JSC"
  vcd_vdc                  = "Magnum_vDC1"
  vcd_url                  = "https://vcloud.kazteleport.kz/api"
  vcd_max_retry_timeout    = 240
  vcd_allow_unverified_ssl = false

  vcd_catalog_name  = "Magnum_catalog"
  vcd_template_name = "ubuntu2004-template"

  env = "dev"
  project = "ecomm"
  role = "db"
  app = "postgresql"

  virtual_machines = {
    vserverxxx = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.100"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
    }
  },
}
```

### Example of terragrunt.hcl for create multiple VM

```
terraform {
  source = "github.com/okassov/terraform-vcd-module.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vcd_org                  = "Magnum_JSC"
  vcd_vdc                  = "Magnum_vDC1"
  vcd_url                  = "https://vcloud.kazteleport.kz/api"
  vcd_max_retry_timeout    = 240
  vcd_allow_unverified_ssl = false

  vcd_catalog_name  = "Magnum_catalog"
  vcd_template_name = "ubuntu2004-template"

  env = "dev"
  project = "ecomm"
  role = "db"
  app = "postgresql"

  virtual_machines = {
    vserverxxx = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.100"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
    },
    vserveryyy = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.200"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
    }
  },
}
```

### Example of terragrunt.hcl for create multiple VM with independent external disk

In this example we have new variable ***data_disk***. For each VM will be created second external data disk.

```
terraform {
  source = "github.com/okassov/terraform-vcd-module.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vcd_org                  = "Magnum_JSC"
  vcd_vdc                  = "Magnum_vDC1"
  vcd_url                  = "https://vcloud.kazteleport.kz/api"
  vcd_max_retry_timeout    = 240
  vcd_allow_unverified_ssl = false

  vcd_catalog_name  = "Magnum_catalog"
  vcd_template_name = "ubuntu2004-template"

  env = "dev"
  project = "ecomm"
  role = "db"
  app = "postgresql"

  data_disk = {
    data = {
      size         = 102400
      unit_number  = 1
      bus_number   = 0
      profile      = "vSAN-FTT1-ST3"
      bus_type     = "SCSI"
      bus_sub_type = "lsilogic"
    }
  }

  virtual_machines = {
    vserverxxx = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.100"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
    },
    vserveryyy = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.200"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
    }
  },
}
```

### Example of terragrunt.hcl for create VM with additional network interface

```
terraform {
  source = "github.com/okassov/terraform-vcd-module.git?ref=v0.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vcd_org                  = "Magnum_JSC"
  vcd_vdc                  = "Magnum_vDC1"
  vcd_url                  = "https://vcloud.kazteleport.kz/api"
  vcd_max_retry_timeout    = 240
  vcd_allow_unverified_ssl = false

  vcd_catalog_name  = "Magnum_catalog"
  vcd_template_name = "ubuntu2004-template"

  env = "dev"
  project = "ecomm"
  role = "db"
  app = "postgresql"

  virtual_machines = {
    vserverxxx = {
      vapp               = "Infrastructure vApp"
      memory             = 4096
      cpu                = 2
      storage_profile    = "vSAN-FTT1-ST3"
      network            = "Magnum-Infrastructure-orgnet"
      network_type       = "org"
      ip_allocation_mode = "MANUAL"
      ip                 = "192.0.0.100"
      netmask            = "24"
      gateway            = "192.0.0.1"
      dns                = "8.8.8.8"
      additional_networks = {
        Magnum-Infrastructure-orgnet = {
          type = "org"
          ip_allocation_mode = "MANUAL"
          ip = "192.0.0.101"
        }
      }
    }
  },
}
```

## How to resize independent disk

 - Stop service that using disk
 - Unmount disk
 - Detach independent disk from VM
 - Resize disk in vCloud with GUI
 - Attach disk to VM
 - Mount disk
 - Start service
 - Refresh terraform state with command "terraform refresh"
