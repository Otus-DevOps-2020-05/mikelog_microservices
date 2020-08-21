#!/usr/bin/env bash
packer_dir=./infra/packer
ansible_dir=./infra/ansible
terraform_dir=./infra/terraform
cd $packer_dir
if [ $(packer validate -var-file=./variables.json docker-host.json) -eq "" ]
then
  echo "Truing to build custom image. Whait..."
  build_image=$(packer build -var-file=./variables.json docker-host.json)
  image_id=$(echo $build_image| grep "yandex: A disk image was created:" | awk -F"id: " '{print $2}' | awk -F ")" '{print $1}')
  if [ $image_id -eq ""]
  then
    echo "Something wrongs"
    echo $build_image
  else
   cd ../../$terraform_dir
   t_init=$(terraform init)
   if [$(echo $t_init | grep 'Terraform has been successfully initialized!' -c) -eq "1"]
   then
    sed -E -i 's/image_id(.+)=(.+)"(.+)"/image_id="'$image_id'"/g' terraform.tfvars
    t_plan=$(terraform plan)
    if [ $(echo $tplan | grep 'Error:' -c ) -eq "0"]
    then
     echo "Trying to apply terraform. Please whait..."
     t_apply=$(terraform apply --auto-approve)
     if [ $(echo $t_apply | grep 'Error:' -c) -eq "0"]
     then
      echo $t_apply | awk '/Apply complete! Resources:.*$/ { matched = 1 } matched'
      echo ""
      echo "Trying to provision app in docker"
      cd ../../$ansible_dir
      ansible=$(ansible-playbook  playbooks/provision.yml)
      if [$(echo $ansible | grep "failed=[1-9]" -c) -eq "0"]
      then
       echo "Go to http://lb_ip_addr:9292"
      else
       echo "Something wrong"
       echo "$ansible"
      fi
     else
      echo "Something wrongs!"
      echo "$t_apply"
     fi
    else
     echo "Something wrongs!"
     echo "$t_plan"
    fi
   else
    echo "Something wrongs!"
    echo "$t_init"
   fi
  fi
else
 echo "Packer validate failed. STOP. Edit >> variables.json <<"
fi
