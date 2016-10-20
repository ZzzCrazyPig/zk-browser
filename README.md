# Introduction

zk-browser make it easy to browse zookeeper directory content in web ui, rather than using the zkCli.sh command!

the web ui like this:

![zk-browser-web-ui](http://7xtamf.com1.z0.glb.clouddn.com/image/blog/realize-zk-browser/zk-browser-web-ui.png)

# Requirements

- jdk7
- maven

# Usage

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

Open your web browser, visit [http://localhost:8080/zk-browser](http://localhost:8080/zk-browser)

# Technology Stack

- spring mvc
- embedded jetty
- curator ( zookeeper third party lib to visit zookeeper )
- bootstrap + jquery
