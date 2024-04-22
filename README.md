# 環境構築方法
## 初期準備
1. VirtualBoxをダウンロードする
1. vagrant をインストトールする
1. テーミナルを開き、omotenashi-pf-provision ディレクトリに移動
1. 以下のコマンドを実施して、仮想環境を作成する
```:bash
vagrant up
vagrant ssh
cd app/omotenashi-pf-provision
bash provision.sh
```

## データベースの更新
```:bash
vagrant ssh
docker-compose --rm [api|anon|api-job|anon-job|api-cronjob|anon-cronjob] bundle exec rails db:migrate
```

## gem を追加した時の作業
```:bash
vagrant ssh
cd apps/omotenashi-pf-provision
docker-compose run --rm [api|anon|api-job|anon-job|api-cronjob|anon-cronjob] bundle install
```

## 稼働中の仮想マシンの状態を確認
```
vagrant ssh
docker-compose ps
```

## サーバ一覧
### 開発

|サーバ名|ポート|役割|
|---|---|---|
|auth|8081|ID許諾サーバ|
|api|3000|APIサーバ|
|anon|3100|APIサーバ（匿名加工処理）|
|api-job||JOBサーバ|
|anon-job||JOBサーバ（匿名加工処理）|
|api-cronjob||CRON JOBサーバ|
|anon-cronjob||CRON JOBサーバ（匿名加工処理）|
|mssql|1443|蓄積DB/匿名加工DB|
|analyze|1444|解析DB|
|web|8080|Webサーバ|


## サーバ構成図
[このツール](https://chrome.google.com/webstore/search/Pegmatite)をインストールすると確認できます。

```uml
@startuml
title 本番サーバ構成図
cloud インターネット
node LB
node ID許諾1
node ID許諾2
node API1
node API2
node 匿名加工LB
node 匿名加工1
node 匿名加工2
node JOB1
node JOB2
node データベース

インターネット -- LB
LB -- ID許諾1
LB -- ID許諾2
ID許諾1 -- 匿名加工LB
ID許諾2 -- 匿名加工LB
ID許諾1 -- API1
ID許諾1 -- API2
ID許諾2 -- API1
ID許諾2 -- API2
匿名加工LB -- 匿名加工1
匿名加工LB -- 匿名加工2
匿名加工1 -- データベース
匿名加工2 -- データベース
API1 -- データベース
API2 -- データベース
JOB1 -- データベース
JOB2 -- データベース
@enduml
```

## 本番環境構築
以下の手順で作業を実施する  
```
sudo su -
yum install git docker -y
systemctl start docker.service
systemctl enable docker.service
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

mkdir -p /var/apps
cd /var/apps
git clone https://github.com/cm-manage/omotenashi-pf-authorization.git
git clone https://github.com/cm-manage/omotenashi-pf-provision.git
git clone https://github.com/cm-manage/omotenashi-pf-api.git


bash provision.sh [staging | uat | production]
```

WEBサーバの場合は以下の手順となる。
```
sudo su - 

yum install git docker -y
systemctl start docker.service
systemctl enable docker.service
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

mkdir -p /var/apps
cd /var/apps
git clone https://github.com/cm-manage/omotenashi-pf-provision.git
git clone https://github.com/cm-manage/omotenashi-pf-web.git
git clone https://github.com/cm-manage/omotenashi-pf-chatbot.git

docker-compose -f docker-compose.web-[staging | uat | production].yml build
docker-compose -f docker-compose.web-[staging | uat | production].yml up -d
```

Install composer on each container
```
docker exec -it chatbot sh
composer install

docker exec -it web sh
composer install
```

```
CHATAPIサーバの場合は以下の手順となる。
```
sudo su - 

yum install git docker -y
systemctl start docker.service
systemctl enable docker.service
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

mkdir -p /var/apps
cd /var/apps
git clone https://github.com/cm-manage/omotenashi-pf-provision.git
git clone https://github.com/cm-manage/omotenashi-pf-chatapi.git

cd /var/apps/omotenashi-pf-provision

bash provision-chatapi.sh [staging | uat | production]
```
