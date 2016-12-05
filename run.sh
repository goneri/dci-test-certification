#!/bin/bash
set -eux

[ -z "${DCI_CERTIFICATION_ID}" ] && exit 0

mkdir -p ansible/roles
[ -d ansible/roles/openstack-certification ] || git clone https://github.com/redhat-cip/ansible-role-openstack-certification ansible/roles/openstack-certification
[ -f /etc/yum.repos.d/epel.repo ] || sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --enable epel
sudo yum install -y ansible
sudo yum-config-manager --disable epel


echo "---
- hosts: localhost
  remote_user: stack
  become: yes
  vars:
    certification_id: ${DCI_CERTIFICATION_ID}
    plugin_type: blockstorage
  roles:
    - openstack-certification
" > ansible/main.yaml

cd ansible

ansible-playbook main.yaml || true
