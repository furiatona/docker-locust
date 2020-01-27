Docker-Locust
=============
This repository provides a ready and easy-to-use version of [locust.io].

Architecture
------------
This docker-locust is started in 2 different roles:

- `master`: Runs Locust's web interface where you start and stop the load test and see live statistics.
- `slave`: Simulates users and attacks the target url based on user parameters.

Requirements
------------
1. [docker engine] version 1.9.1+

Getting Started
---------------
Run the application with the command:
```bash
make all
```

Access from port 8089
```bash
http://localhost:8089
```

Stop and clean up
```bash
make stop-all
```

[locust.io]: <http://locust.io>
[docker engine]: <https://docs.docker.com/engine/installation/>