# ProjetCloud


# Mettre à jour l'image du  front-end
```bash
git clone https://gitlab.unistra.fr/jbrelot/projetcloud -b front-end
```
*** Opérer les modifications nécessaires ***
```bash
docker build ./ --tag projetcloud/front-end
docker tag projetcloud/front-end docker.io/jbunistras/cloud-front-end
docker push docker.io/jbunistras/cloud-front-end
```
# Mettre à jour l'image du back-end
```bash
git clone https://gitlab.unistra.fr/jbrelot/projetcloud -b front-end
```
### Opérer les modifications nécessaires
```bash
docker build ./ --tag projetcloud/front-end
docker tag projetcloud/front-end docker.io/jbunistras/cloud-front-end
docker push docker.io/jbunistras/cloud-front-end
```
Normalement, les images sont maintenues à jour sur le dockerhub 
via un job gitlab qui se déclenche à chaque push sur la branche front-end ou back-end

# Configuration de l'accès aux machines et configuration de l'ip flottante
```bash
echo "
Host bastion-cloud
    Hostname bastion.100do.se
    User student

Host racaillou
    Hostname racaillou.internal.100do.se
    User ubuntu
    ProxyJump bastion-cloud

Host gravalanch
    Hostname gravalanch.internal.100do.se
    User ubuntu
    ProxyJump bastion-cloud

Host grolem
    Hostname grolem.internal.100do.se
    User ubuntu
    ProxyJump bastion-cloud
" >> ~/.ssh/config

echo "
-----BEGIN-----
	CLE SSH
-----END-----
" >> ~/.ssh/cloud_key
chmod 600 ~/.ssh/cloud_key
ssh-add ~/.ssh/cloud_key
```

# Configuration de l'ip flottante
```bash
ssh racaillou
sudo ip address add dev vxlan12 172.16.12.110/24
exit

ssh gravalanch
sudo ip address add dev vxlan12 172.16.12.110/24
exit

ssh grolem
sudo ip address add dev vxlan12 172.16.12.110/24
exit

ssh gravalanch
sudo ip address add dev vxlan12 172.16.12.110/24
exit
```
# Deploiement de l'application
```bash
ssh racaillou
echo "
-----BEGIN-----
	CLE SSH
-----END-----
" >> ~/.ssh/cloud_key
chmod 600 ~/.ssh/cloud_key
ssh-add ~/.ssh/cloud_key

git clone https://gitlab.unistra.fr/jbrelot/projetcloud
sh install-ansible.sh
ansible-playbook -i ansible/inventory.yaml ansible/playbook.yaml
```