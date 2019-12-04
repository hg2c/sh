#!/usr/bin/env bash

mvn:install:dir() {
    find ${1:-vendor} -name "*.pom" -print0 |
        while IFS= read -r -d '' POM; do
            install:pom $POM
            done
}

install:pom() {
    local POM=$1
    local JAR

    JAR=${POM%.pom}.jar
    if [ -s $JAR ]; then
        mvn:install-file $POM $JAR jar
        return
    fi

    JAR=${POM%.pom}-tests.jar
    if [ -s $JAR ]; then
        mvn:install-file $POM $JAR test-jar
        return
    fi

    mvn:install-file $POM $POM pom
}

mvn:install-file() {
    mvn install:install-file -DpomFile=$1 -Dfile=$2 -Dpackaging=$3 ${MVN_OPTS}
}
