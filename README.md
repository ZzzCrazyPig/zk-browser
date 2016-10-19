## Introduction

zk-browser make it easy to browse zookeeper directory content in web ui, rather than using the zkCli.sh command!

## Requirements

- jdk7
- maven

## Usage

First, download the source code, and run maven command to build the code in root directory:

```
mvn package -Dmaven.test.skip=true
```

Then, find the software package(file format in zip) in target sub directory :

```bash
zk-browser-standalone.zip
```

unzip it , config the `zkUrl`:

```
cd zk-browser/conf
vi application.properties
```

finllay run :

```
cd zk-browser/bin
./start.sh
```

On Windows, run `start.bat` instead.

Open your web browser, visit [localhost:8080/zk-browser](localhost:8080/zk-browser)

## Technology Stack

- spring mvc
- embedded jetty
- curator ( zookeeper third party lib to visit zookeeper )
- boostrap + jquery
