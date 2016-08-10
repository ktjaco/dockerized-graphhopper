# Dockerized Graphhopper

This Dockerfile builds image with grapphopper web app installed. You need to provide .pbf files through /data mount point. Please refer to instructions bellow.

### Building image

Take a look on files in assets directory:
* config.properties - graphhopper properties.
* start.sh - graphhopper run script. You can customize JAVA\_OPTS here (heap size, etc.).
* init.sh -  downloads and extracts installation .zip file to /graphhopper directory.

Make necessary changes in config files and build image:

```
$ sudo docker build -t graphhopper .
```

### Downloading pbf files

You need to download .pbf files and put them in directory on your host. Then mount this directory to container /data volume.

Example (Monaco):

```
mkdir -p /private/osm-data/
cd /private/osm-data/
wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
```

### Running container

When running container, you have to mount directory where .pbf file is placed to container /data volume. Moreover do not forget about port mapping.

Initial container run might take some time as GraphHopper needs to processes .pbf file and create additional work files. Tail logs till you see that server is started.


```
$ sudo docker run \
      -d \
      --name=graphhopper-monaco \
      -v /private/osm-data/:/data \
      -p 8990:8989 \
      graphhopper \
      /graphhopper/start.sh
$ sudo docker logs -f graphhopper-monaco
...
2016-08-10 05:20:31,564 [main] INFO  graphhopper.http.DefaultModule - loaded graph at:/data/monaco-latest.osm-gh, source:/data/monaco-latest.osm.pbf, acceptWay:car, class:LevelGraphStorage
2016-08-10 05:20:32,106 [main] INFO  graphhopper.http.GHServer - Started server at HTTP 8989
```

Check if web interface is available: [http://localhost:8990/](http://localhost:8990/)

You can easily run more instances of Grapphopper on different ports. Please make sure that you use separate directories for .pbf file and additional graphhopper work files. 

### Customizing JAVA\_OPTS

You can change JAVA\_OPTS by creating env.sh file in mounted directory. This can be usefull when you want to change heap size.

Example (use only 128MB for heap):

```
$ cat /private/osm-data/env.sh
JAVA_OPTS="-Xms128m -Xmx128m -XX:MaxPermSize=64m -Djava.net.preferIPv4Stack=true -server -Djava.awt.headless=true -Xconcurrentio"
```
