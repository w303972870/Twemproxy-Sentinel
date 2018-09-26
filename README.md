```
docker pull w303972870/twemproxy-sentinel
```

### 日志目录
```
/data/logs/
```

### 默认配置文件
```
/etc/redis.conf  # redis用到
/data/conf/sentinel.conf  # sentinel用到
/data/conf/redis_master.conf # twemproxy用到
```

#### 启动命令示例
**在本机测试需要指定--net网络，同时同一net网络下端口不要相同**
```
docker run -dit -p 6370:6370 -v /data/redis/:/data/ --name redis_6370 --net host -e START=redis -e REDIS_PORT=6370 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6371:6371 -v /data/redis/:/data/ --name redis_6371 --net host -e START=redis -e REDIS_PORT=6371 -e REDIS_SLAVEOF_IP=192.168.123.2 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6372:6372 -v /data/redis/:/data/ --name redis_6372 --net host -e START=redis -e REDIS_PORT=6372 -e REDIS_SLAVEOF_IP=192.168.123.2 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
```
```
docker run -dit -p 6370:6370 -v /data/redis/:/data/ --name redis_6370 --net host -e START=redis -e REDIS_PORT=6370 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6371:6371 -v /data/redis/:/data/ --name redis_6371 --net host -e START=redis -e REDIS_PORT=6371 -e REDIS_SLAVEOF_IP=192.168.123.3 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6372:6372 -v /data/redis/:/data/ --name redis_6372 --net host -e START=redis -e REDIS_PORT=6372 -e REDIS_SLAVEOF_IP=192.168.123.3 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
```
```
docker run -dit -p 6370:6370 -v /data/redis/:/data/ --name redis_6370 --net host -e START=redis -e REDIS_PORT=6370 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6371:6371 -v /data/redis/:/data/ --name redis_6371 --net host -e START=redis -e REDIS_PORT=6371 -e REDIS_SLAVEOF_IP=192.168.123.4 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
docker run -dit -p 6372:6372 -v /data/redis/:/data/ --name redis_6372 --net host -e START=redis -e REDIS_PORT=6372 -e REDIS_SLAVEOF_IP=192.168.123.4 -e REDIS_SLAVEOF_PORT=6370 -e REDIS_MASTERAUTH=123456 -e REDIS_REQUIREPASS=123456 -e LISTION=IP docker.io/w303972870/twemproxy-sentinel
```

```
docker run -dit -p 26379:26379 -v /data/redis/:/data/ --name sentinel --net host -e START=sentinel --privileged docker.io/w303972870/twemproxy-sentinel
docker run -dit  --name twemproxy --net host -p 22121:22121  -v /data/redis/:/data/ -e START=twemproxy  docker.io/w303972870/twemproxy-sentinel
```


```
docker run -dit -p 26379:26379  -p 22121:22121 -v /data/redis/:/data/ --name twemproxy-sentinel --net host -e START=both docker.io/w303972870/twemproxy-sentinel
```

#### 我的/data/redis目录结构如下

```
├── redis
│   ├── conf
│   │   ├── client-reconfig.sh
│   │   ├── redis_master.conf
│   │   ├── redis_master.pid
│   │   └── sentinel.conf
│   └── logs
│       ├── redis.log
│       ├── redis_master.log
│       └── sentinel_log.log
```


#### -e参数列表,如果通过-v指定配置文件，以下参数设置将都会失效
|选项|默认值|说明|
|:---|:---|:---|
|START|默认等于redis|公共选项：意思启动的是redis服务模式，sentinel启动的是哨兵模式，twemproxy是启动的twemproxy代理服务，both是同时启动twemproxy代理服务和sentinel哨兵两个服务|
||||
||||
|REDIS_PORT|默认6370|设置redis的访问端口|
|LISTION|默认等于IP|设置redis的监听方式，默认IP意思是通过ip链接，否则就通过sock方式，默认sock文件/data/redis/redis.sock|
|REDIS_REQUIREPASS|默认0|0意思是不设置,设置redis的访问密码，当启动sentinel，这就是配置sentinel访问master的密码|
|REDIS_SLAVEOF_IP|默认0|0意思是不设置，用于配置当前redis的slaveof ip|
|REDIS_SLAVEOF_PORT|默认0|0意思是不设置，用于配置当前redis的slaveof port |
|REDIS_MASTERAUTH|默认0|0意思是不设置，用于配置当前redis的slaveof 主机的密码 |
|REDIS_BIND_IP|默认0.0.0.0|用于配置redis.conf中的bind项| 
|PROTECTED_MODE|默认no|用于配置redis.conf中的protected-mode项，开启赋值yes| 
||||
||||
|SENTINEL_LISTION_SERVER_NAME|默认等于master|sentinel专用选项：用于配置sentinel monitor监听主机别名|
|SENTINEL_LISTION_SERVER_IP|默认等于master|sentinel专用选项：用于配置sentinel monitor监听主机ip|
|SENTINEL_LISTION_SERVER_PORT|默认等于6379|sentinel专用选项：用于配置sentinel monitor监听主机端口|
|SENTINEL_QUORUM|默认等于2|sentinel专用选项：用于配置sentinel monitor，多少个进程认为不可用即弃用|
|SENTINEL_DOWN_AFTER|默认1000|sentinel专用选项：sentinel down-after-milliseconds PONG监测响应时间范围|
|SENTINEL_FAILOVER|默认1000|sentinel专用选项：用于配置sentinel failover-timeout|


#### 提供一个简单的/data/conf/sentinel.conf配置文件

```
port 26379 
dir /data/conf/
logfile "/data/logs/sentinel_log.log"

protected-mode no 

#master主机名为redis_master_group1，ip地址为192.168.12.2，端口为6370，当有1个slave同意重新选举master时，则集群重新选举master，同时，Sentinel会重写配置文件  
sentinel monitor redis_master_group1 192.168.12.20 6370 1

#sentinel连接master的验证密码，最好保证集群中redis的实例的验证密码是相同的，以便Sentinel监控集群中redis的实例
sentinel auth-pass redis_master_group1 123456 

# 当多久sentinel检测到Master不可达时，认为master宕机(3秒)
sentinel down-after-milliseconds redis_master_group1 3000

# 当集群中master宕机时，Sentinels重新配置redis实例为master的超时时间，当超时时间仍没有配置完，Sentinels将redis实例重新配置成与parallel-syncs slave redis实例一样
sentinel failover-timeout redis_master_group1 3000

# 当集群中master宕机时，为了保证集群能可以接受查询请求，配置salve不进行选择，  能做为slave的数量  
sentinel parallel-syncs redis_master_group1 1 

# 当master宕机时，sentinel的报警脚本
#sentinel notification-script redis_master_group1 /data/conf/notify.sh  

# 当master宕机时，sentinel的通知clients的脚本，通知内容为，配置文件已将改变，当前redis实例的role，state信息，及新的master ip
# 参数顺序：<master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>  
sentinel client-reconfig-script redis_master_group1 /data/conf/client-reconfig.sh

sentinel monitor redis_master_group2 192.168.12.30 6370 1 
sentinel auth-pass redis_master_group2 123456 
sentinel down-after-milliseconds redis_master_group2 3000 
sentinel failover-timeout redis_master_group2 3000
sentinel parallel-syncs redis_master_group2 1 
sentinel client-reconfig-script redis_master_group2 /data/conf/client-reconfig.sh

sentinel monitor redis_master_group3 192.168.12.40 6370 1 
sentinel auth-pass redis_master_group3 123456 
sentinel down-after-milliseconds redis_master_group3 3000 
sentinel failover-timeout redis_master_group3 3000
sentinel parallel-syncs redis_master_group3 1
sentinel client-reconfig-script redis_master_group3 /data/conf/client-reconfig.sh

```


#### 提供一个简单的/data/conf/redis_master.conf配置文件

```
redis_master:
 listen: 0.0.0.0:22121
 hash: fnv1a_64
 distribution: ketama
 auto_eject_hosts: true
 redis: true
 redis_auth: 123456
 server_retry_timeout: 10000
 server_failure_limit: 2
 servers:
  - 192.168.12.20:6370:1
  - 192.168.12.30:6370:1
  - 192.168.12.40:6370:1
```



