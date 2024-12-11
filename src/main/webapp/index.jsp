<html>
<body>
<h2>Hello World!</h2>
<%--


7)Docker CMD  
--------------------
1)tomcat running using docker
  
>sudo su
>yum install docker -y

>service docker start

>docker pull tomcat

>docker images

>docker run -d --name tomcat_container -p 8081:8080 tomcat

>docker exec -it tomcat_conrainer /bin/bash

>ls -l webapps

>cp -R webapps.dist/* webapps

>ls -l webapps

>docker start  tomcat_container

2)tomcat using dockerfile in docker

>sudo su

>nano dockerfile
	dockerfile contents :
		FROM tomcat:latest
		RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
>to image build 
>docker bulid -t dtomcat .

>docker run -d --name dtomcat_container -p 8082:8080 dtomcat

>docker start dtomcat_container


---------------------------------------------------------------------------------------------
8)pipeline using docker and Jenkins

----->Creating dockeradmin
	
	>useradd dockeradmin
	>passwd dockeradmin
	>usermod -aG docker dockeradmin 
CONGIGURE DOCKERADMIN
 >nano /etc/ssh/sshd_config
	-->PasswordAuthentication no-->yes
 >service sshd reload

>su - dockeradmin

>cd /opt

>mkdir docker
	-->change owner 
		>chown -R dockeradmin:dockeradmin docker
>cd docker

>nano dockerfile
	CONTENTS IN DOCKERFILE
		>>FROM tomcat:latest
		  RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
		  COPY ./*.war /usr/local/tomcat/webapps/

----->JENKINS START<----------
>service Jenkins start

>adding docker server in system
    
>in new iteam POST BUILD ACTIONS
>source file:target/*.war
>remove prefix :target/
>remote directory ://opt//docker
---->EXECUTE COMMANDS<---

>cd /opt/docker
docker build -t dtomcat .
docker run -d --name dtomcat-container -p 8084:8080 dtomcat

---->BUILD THE PROJECT<-------




9)ANSIBLE,DOCKER,JENKINS
------------------------------------------

>create ansadmin in ansible and docker
--->ANSIBLE:-
----->same steps for both docker and ansible<----
-->useradd ansadmin
-->passwd ansadmin
-->sudo su - ansadmin 
-->sudo visudo
----->ansadmin	ALL=(ALL)	ALL<-----ADD below root user
-->nano /etc/ssh/sshd_config --PasswordAuthentication no-->yes
-->service sshd reload

----->login in ansadmin and create keygen<-----
	>ssh-keygen
	>cd .ssh
	>ssh-copy-id <docker private ip>
	>sudo nano /etc/ansible/hosts
		-->[dockerhost]
		   <docker private ip>
		   [ansiblehost]
		   <ansible private ip>

-->install docker<--
>sudo yum install docker -y

>sudo usermod -aG docker ansadmin

>sudo service docker start

>cd /opt/

>mkdir docker 
	>chown -R ansadmin:ansadmin docker

>cd docker

>nano dockerfile
	FROM tomcat:latest
	RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
	COPY ./*.war /usr/local/tomcat/webapps/

>cd .ssh
>ssh-copy-id <ansible private ip>

-->DockerHub login<---
>docker login

-->create helloworld.yml playbook<---

>nano hello_world.yml
	CONTENT
---
- hosts: ansiblehost
  tasks:
  - name: create docker image
    command: docker build -t hello_world:latest .
    args:
     chdir: /opt/docker
  - name: create tag to push image onto dockerHub
    command: docker tag hello_world:latest dockerhub_username/hello_world:latest
  - name: Push docker image
    command: docker push dockerhub_username/hello_world:latest

--->create deploy_hello_world.yml playbook<----

Content:-

---
- hosts: dockerhost
  tasks:
  - name: create container
    command: docker run -d --name hello_world_server -p 808*:8080 dockerhub_username/hello_world


check syntax
>ansible-playbook hello_world.yml --syntax-check
>ansible-playbook deploy_hello_world.yml --syntax-check

________DOCKER_________


after ansadmin creation same as done in ansible 

useradd ansadmin
-->passwd ansadmin
-->sudo su - ansadmin 
-->sudo visudo
----->ansadmin	ALL=(ALL)	ALL<-----ADD below root user
-->nano /etc/ssh/sshd_config --PasswordAuthentication no-->yes
-->service sshd reload


>chmod 777 /var/run/docker.sock


---->in Jenkins EXEC commands<-----

ansible-playbook /home/ansadmin/hello_world.yml
sleep 10;
ansioble-playbook /home/ansadmin/deploy_hello_world.yml

--%>
<h1>Nag</h1>
</body>
</html>
