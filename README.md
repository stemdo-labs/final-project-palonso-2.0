# final-project-palonso

# Primer Diagrama grupal y planteamiento del trabajo final en equipo

![Sin título-2024-06-13-0739](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/6535855c-6853-4b5a-9c53-9d1bcd263bca)

# Mi diagrama final de toda mi arquitectura
![Sin título-2024-04-11-1642](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/99b03738-39d6-41fb-aaf9-f9c5056d7619)

# Terraform

Dentro del proyecto de Terraform tendremos:

- Una **Virtual Network (VNet)** que contiene todas las subredes.

## Subredes para:

- **AKS Cluster** con un **Load Balancer** asociado.
- **DB VM**.
- **Jump Host**.

## Componentes:

- **Load Balancer**: para distribuir el tráfico entrante al AKS Cluster.
- **Public IP**: asociada al Jump Host.

## Acceso a la App


[Usuario] --> [Public IP] --> [Load Balancer] --> [AKS Cluster] --> [Aplicación]

                         ┌─────────────────────────────┐
                         │       Azure Kubernetes      │
                         │         Service (AKS)       │
                         │                             │
                         │  ┌───────────────────────┐  │
                         │  │   App Deployment      │  │
                         │  └───────────────────────┘  │
                         │      (2 replicas)          │
                         │         │                 │
                         │         │                 │
                         │  ┌───────────────────────┐  │
                         │  │    Load Balancer      │  │
                         │  └───────────────────────┘  │
                         │                             │
                         │         │                  │
                         │         │                  │
                         └─────────┼──────────────────┘
                                   │
                                   │
                 ┌─────────────────┴─────────────────┐
                 │                                   │
      ┌──────────▼──────────┐            ┌───────────▼───────────┐
      │     VM for DB       │            │     VM for Backups    │
      │   (MySQL/PostgreSQL)│            │                      │
      └─────────────────────┘            └───────────────────────┘

    ┌─────────────────────────────────────────────────────────────────┐
    │                         Virtual Network (VNet)                  │
    │ ┌───────────────────────────────────────────────────────────┐  │
    │ │                  Subnet for AKS Nodes                     │  │
    │ └───────────────────────────────────────────────────────────┘  │
    │ ┌───────────────────────────────────────────────────────────┐  │
    │ │          Subnet for VMs (DB, Backups)                     │  │
    │ └───────────────────────────────────────────────────────────┘  │
    │                                                                 │
    └─────────────────────────────────────────────────────────────────┘


```plaintext
## Estructura

terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── nsg/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── load_balancer/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── aks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
└── terraform.tfvars
```

## Connstruir la imagen de docker
```sh
docker build -t palonsoacr.azurecr.io/my-concert-app:latest .
```
## Configurar ACR Y  AKS


### Steps to Configure ACR and AKS

1. **Obtener el ACR ID**
    ```sh
    ACR_ID=$(az acr show --name palonsoACR --resource-group rg-palonso-dvfinlab --query "id" --output tsv)
    echo "ACR_ID obtained: $ACR_ID"
    ```

2. **Obtener el AKS Cluster Identity ID**
    ```sh
    AKS_IDENTITY_ID=$(az aks show --resource-group rg-palonso-dvfinlab --name aks-cluster --query "identityProfile.kubeletidentity.objectId" --output tsv)
    echo "AKS_IDENTITY_ID obtained: $AKS_IDENTITY_ID"
    ```

3. **Asignar el ACRPullRole  al the AKS Cluster**
    ```sh
    az role assignment create --assignee $AKS_IDENTITY_ID --role AcrPull --scope $ACR_ID
    echo "AcrPull role assigned to the AKS cluster."
    ```

4. **Configurar kubectl for the AKS Cluster**
    ```sh
    az aks get-credentials --resource-group rg-palonso-dvfinlab --name aks-cluster
    echo "kubectl configured for the AKS cluster."
    ```
    Sin permisos esta forma de hacerlo nos dará errores por la autorización denegada al no tener un rol que permita crear roles.
0. **Como en nuestro caso no tenemos la autorización correspondiente consumiremos el secreto de docker con las credenciales facilitadas en el ACR**
  

5. **Crear Docker Secret en AKS Cluster**
    ```sh
    kubectl create secret docker-registry regcred \
      --docker-server=palonsoacr.azurecr.io \
      --docker-username=palonsoACR \
      --docker-password=<YOUR_PASSWORD> \
      --docker-email=palonso@stemdo.io
    echo "Docker Secret created in AKS cluster."
    ```

    Replace `<YOUR_PASSWORD>` with your actual ACR password. This secret will be used to authenticate Docker with the ACR from the AKS cluster.


5. **Acceso a la app a través del clúster**

![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/af7545a7-95ca-4e76-84f7-c11821e5c555)
La Ip pública se ha tenido que crear dentro del grupo de recursos Mg donde se localiza el cluster. 

## Ansible
La vm_backup tendrdá una ip pública y funcionará como nodo maestro.

1. **Conexión por ssh a la vm_backup**

```sh
ssh -i ~/.ssh/id_rsa adminuser@52.174.32.157
```

![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/692e2965-731f-42e1-924a-6c8e58cccef4)

2. **Instalar ansible en  vm_backup**
 ```sh
   sudo apt update
sudo apt install ansible -y
```
Después hay que preparar la conxión entre las dos vms a través de la clave pública y privada. Copiaremos la clave pública a la vm de bd y le daremos los permisos:
```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub adminuser@10.0.2.4
chmod 600 ~/.ssh/id_rsa
```
2. **Creo el inventario y los playbooks**
   

 Para poder almacenar la copia de la bd en azure tengo que crear un contenedor dentro de mi storage account y usar su key.
```ssh
az storage container create --name mycontainer --account-name stapalonsodvfinlab
```
Ejecución del playbook de setup_db
![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/c4f12262-8152-498a-9ec7-973f3fb2ccf8)
Ejecución del playbook setup_backup
![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/ba79d4b0-97ed-4b6a-862e-1c427c866f5c)
Como podemos observar dentro del storage account se ha creado la copia de backup a través de la configuración de Ansible
![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/3eef3806-159a-4a04-9091-76f3f73c8b6d)
3. **Preparar Mysql y siembra de la bd**

Para poder conectarnos a la db tenemos que permitir las conexiones remotas editando mysqld.conf:
bind-address = 0.0.0.0
Y realizamos la siembra de la base de datos con el script de SQL.

## Conexión a ip pública de la aplicación 
A través de la ip pública nos conectamos a la app que se conecta con la vm de bd a través de su ip privada y el puerto 3306
![image](https://github.com/stemdo-labs/final-project-pilarAlonsoSTEMDO/assets/166375061/1d151653-a136-464d-a5ab-e553fd94f18d)

## Borrar discos de las vm

Los discos de almacenamiento de las vms no se borrarán con el destroy

```sh
az disk delete --resource-group RG-PALONSO-DVFINLAB --name backup-vm-osdisk --yes
az disk delete --resource-group RG-PALONSO-DVFINLAB --name db-vm-osdisk --yes
```
# Github Actions
Diagram:

![githubActions](https://github.com/stemdo-labs/final-project-palonso/assets/166375061/2ee1b212-33a0-46a1-818b-21c5ba6be552)
En el fichero ci-infra haremos un init y un terraform plan si se ejecuta correctamente se ejecutará el cd-infra y así con todos los workflows
en el cd-infra haremos el terraform apply
en el ci obtendremos la version del composer y tambien la password del acr creado en cd_infra. Taggearemos la imagen con la etiqueta latest y la etiqueta del composer , para poder referenciar la última como latest.
subiremos las imágenes al acr 
Después se ejecutará el cd ejecutaremos el deploy y service de AKS
Después de esto tendremos un workflow manual para las vms de ansible.
Haremos que la vm_back up sea self hosted :

![image](https://github.com/stemdo-labs/final-project-palonso/assets/166375061/6863d49c-aaae-4b64-b7bd-379c6d962ed2)
en ese playbook se pasa la variable que sube la copia de backup al storage account para que desde el playbook de ansible se pueda utilizar.
y haré el sembrado de la base de datos manualmente.

# Disaster recovery

El objetivo del proceso de disaster recovery es restaurar la base de datos MySQL desde el último respaldo almacenado en Azure Blob Storage. Este procedimiento es crucial para garantizar la continuidad del servicio en caso de una falla catastrófica.
El workflow de GitHub Actions se ejecuta manualmente mediante workflow_dispatch. Consta de varios pasos que incluyen la descarga del último respaldo de la base de datos, la transferencia del archivo de respaldo a una máquina virtual específica y la restauración de la base de datos utilizando MySQL.

![disastr_recovery](https://github.com/stemdo-labs/final-project-palonso/assets/166375061/dda4e454-bdee-4ebf-8fe7-f943204646fe)
