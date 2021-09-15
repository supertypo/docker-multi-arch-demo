#!/bin/bash

# Sørg for at Rosetta er tilgjengelig (på Mac)
# softwareupdate --install-rosetta

# Sett opp buildx-bygger
docker buildx create --name mybuilder --use

# Opprett Dockerfile
echo -n 'FROM openjdk:11-jre-slim

ADD test.sh ./
RUN chmod 755 ./test.sh

CMD [ "./test.sh" ]
' > Dockerfile

# Opprett test.sh
echo -n '#!/bin/sh

echo
echo Uname: $(uname -m)
echo Java: $(java -XshowSettings 2>&1|grep os.arch)
java -version
echo
' > test.sh

# Bygg Docker Image med støtte for arm64 og amd64
docker buildx build --platform linux/arm64,linux/amd64 -t mthoring/multi-arch-test:0.0.0 --push .

echo ============================
echo Kjører image i amd64-versjon
echo ============================
docker run --pull always --rm --platform linux/amd64  mthoring/multi-arch-test:0.0.0

echo ============================
echo Kjører image i arm64-versjon
echo ============================
docker run --pull always --rm --platform linux/arm64 mthoring/multi-arch-test:0.0.0
