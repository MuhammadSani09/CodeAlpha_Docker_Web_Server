# Task 4 verification record

These results were transcribed from Muhammad Sani's terminal output and screenshots supplied on October 17, 2026. They are not a new automated test run or a complete raw terminal log.

## Successful deployment

Image: `codealpha-web:1.0`  
Main container: `codealpha-web` (`916696641ffa`)  
Host mapping: `127.0.0.1:8088` to container port `8080`  
Observed status: `Up About a minute (healthy)`

```text
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/plain

healthy
```

## Monitoring and runtime user

```text
CPU: 0.00%
Memory: 8.551 MiB / 128 MiB (6.68%)
PIDs: 9
uid=101(nginx) gid=101(nginx) groups=101(nginx)
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

These resource values are a single idle snapshot, not a load benchmark. Nginx logs showed version `1.30.6` and successful requests for `/`.

## Lifecycle

`docker stop codealpha-web` succeeded. `docker ps -a` showed `Exited (0)`. Both `docker start codealpha-web` and `docker restart codealpha-web` succeeded. The subsequent HTTP check returned 200 with `healthy` at `15:38:22 GMT`.

## Port conflict, diagnosis, and fix

Launching `codealpha-port-test` on the already allocated host port 8088 produced:

```text
Bind for 127.0.0.1:8088 failed: port is already allocated
```

`docker ps --filter publish=8088` identified the running main container as the owner. The failed test container was removed, and the main server still returned HTTP 200 at `15:40:26 GMT`.

The test container was recreated as `8938e1c7ee73` with host port **8089**, keeping internal port **8080**. A request to `http://127.0.0.1:8089/health` returned:

```text
HTTP/1.1 200 OK
Date: Sat, 17 Oct 2026 15:42:35 GMT
Content-Type: text/plain

healthy
```

Final cleanup of this successful temporary container has not been confirmed. It can be stopped and removed without removing the main server.

## Original screenshots

- `website.png`: the custom page served locally.
- `lifecycle-and-port-conflict.png`: stopped status, start/restart, port conflict, diagnosis, failed-container removal, and HTTP recovery of the main server.

No screenshot of the successful 8089 response was available in this package; that result is supported by the pasted terminal output above.
