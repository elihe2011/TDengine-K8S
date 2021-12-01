# 1. 编译镜像

暂不支持 arbitrator，采用奇数节点方式

```bash
cd image
docker build -t tdengine:2.2.2.0 .
```



# 2. 存储准备

暂定本地磁盘存储

```bash
mkdir -p /data/tdengine
```



# 3. 创建集群

```bash
cd ..
kubectl apply -f taos.yml
```



# 4. 集群状态

```bash
# kubectl
kubectl exec -it tdengine-0 -n taos-cluster -- taos -s "show dnodes;"

Welcome to the TDengine shell from Linux, Client Version:2.2.2.0
Copyright (c) 2020 by TAOS Data, Inc. All rights reserved.

taos> show dnodes;
   id   |           end_point            | vnodes | cores  |   status   | role  |       create_time       |      offline reason      |
======================================================================================================================================
      1 | tdengine-0.taosd.taos-clust... |      0 |      2 | ready      | any   | 2021-11-26 02:42:25.932 |                          |
      2 | tdengine-1.taosd.taos-clust... |      1 |      2 | ready      | any   | 2021-11-26 02:42:35.633 |                          |
      3 | tdengine-2.taosd.taos-clust... |      1 |      2 | ready      | any   | 2021-11-26 02:42:48.004 |                          |
Query OK, 3 row(s) in set (0.001099s)

# 2. restful
curl -H 'Authorization: Basic cm9vdDp0YW9zZGF0YQ==' -d 'show databases;' 192.168.80.240:36041/rest/sql
{"status":"succ","head":["name","created_time","ntables","vgroups","replica","quorum","days","keep","cache(MB)","blocks","minrows","maxrows","wallevel","fsync","comp","cachelast","precision","update","status"],"column_meta":[["name",8,32],["created_time",9,8],["ntables",4,4],["vgroups",4,4],["replica",3,2],["quorum",3,2],["days",3,2],["keep",8,24],["cache(MB)",4,4],["blocks",4,4],["minrows",4,4],["maxrows",4,4],["wallevel",2,1],["fsync",4,4],["comp",2,1],["cachelast",2,1],["precision",8,3],["update",2,1],["status",8,10]],"data":[["log","2021-11-26 02:42:26.936",6,1,1,1,10,"30",1,3,100,4096,1,3000,2,0,"us",0,"ready"],["iec61850","2021-12-01 01:13:56.176",59,1,1,1,10,"365",16,6,100,4096,1,3000,2,0,"ms",0,"ready"]],"rows":2}
```



参考资料：

https://github.com/taosdata/TDengine-Operator  【官方 kubernetes 安装tdengine 方案】