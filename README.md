<details> <summary>Установка minikube, kubectl и VMWare </summary>

</details>

<details> <summary> Поднятие Jenkins </summary>

Сначала запустим сам Minikube:
```
minikube start
```

Запустим скрипт deploy.sh, который задеплоит Jenkins в minikube:

```
chmod +x deploy.sh

./deploy.sh
```

Запустим команду, которая откроет dashboard minikube в браузере:
```
minikube dashboard
```
Для дальнейшей работы понадобится ещё один терминал, т.к. эта команда его блокирует

Видим, что Jenkins задеплоился:
![---](misc/check_jenkins.png)  

Теперь чтобы подключиться к Jenkins нам нужен пароль от пользователя admin и сам IP адрес Jenkins, чтобы настроить его для работы с Kubernetes.
Сначала найдём пароль, который нам сгенерировал Jenkins. Он лежит в `/var/jenkins_home/secrets/initialAdminPassword` Для этого нам нужно получить название пода и вывести содержимое файла по указанному пути. Во второй команде нужно указать название контейнера, которое вывела первая команда (поле NAME):
```
>kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
jenkins-7946485b96-7fl7b   1/1     Running   0          23m
>kubectl exec --stdin --tty jenkins-7946485b96-7fl7b -- /bin/bash
jenkins@jenkins-7946485b96-7fl7b:/$ cat /var/jenkins_home/secrets/initialAdminPassword
1f03a2a254d347a68306af464245203f
jenkins@jenkins-7946485b96-7fl7b:/$ exit
exit
```
Для получения IP достаточно узнать адрес, на котором работает нода minikube, т.к. порт при деплое был указан как равный `31600`:
```
minikube ip
192.168.49.2
```
Значит к Jenkins можно подключиться по адресу 192.168.49.2:31600. Подключаемся, используя пароль, который мы получили на предыдущем шаге.:
![---](misc/jenkins_accessed.png)  




</details>

<details> <summary>Настройка Jenkins для создания агентов в Kubernetes </summary>
Настроим Kubernetes как агент для выполнения jobs.

Перейдем в Dashboard->Manage Jenkins->Clouds->New cloud и создадим облако, например kubernetes (тип облака ставим Kubernetes)
Нужно заполнить поле Kubernetes URL и Jenkins URL. Kubernetes URL берём из следующей команды:
```
>kubectl cluster-info
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

```
Kubernetes URL в данном случае равен https://192.168.49.2:8443 (Kubernetes control plane)
Jenkins URL получаем таким образом (айди пода мы знаем из предыдущих шагов):
```
>kubectl describe pod jenkins-7946485b96-7fl7b | grep "IP:" | head -n 1
IP:               10.244.0.5

```
Jenkins URL в данном случае равен  http://10.244.0.5:8080, т.к. порт стандартный — 8080.
</details>
