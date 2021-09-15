# Docker - Multi Arch

## Mac (testet på M1 og Intel)
Multi-arch bygging og kjøring (buildx) er støttet out-of-the-box i Docker for Mac.

### Rosetta kreves for Docker
```
softwareupdate --install-rosetta
```
Deretter installer Docker for Mac.

### Bygge multi arch Docker Image

#### Opprett en builder for å få tilgang til multi-arch bygging, og sett den some forhåndsvalgt
```
docker buildx create --name mybuilder --use
```

#### Gå til valgfri mappe og opprett en Dockerfile
```
echo -n 'FROM openjdk:11-jre-slim

ADD test.sh ./
RUN chmod 755 ./test.sh

CMD [ "./test.sh" ]
' > Dockerfile
```

#### Opprett test.sh i samme mappe
```
echo -n '#!/bin/sh

echo
echo Uname: $(uname -m)
echo Java: $(java -XshowSettings 2>&1|grep os.arch)
java -version
echo
' > test.sh
```

####  Bygg Docker Image med støtte for arm64 og amd64:
```
docker buildx build --platform linux/arm64,linux/amd64 -t mthoring/multi-arch-test:0.0.0 --push .
```

#### Kjør image i amd64-versjon:
```
docker run --pull always --rm --platform linux/amd64  mthoring/multi-arch-test:0.0.0
```
Skal printe: x86_64

#### Kjør image i arm64-versjon:
```
docker run --pull always --rm --platform linux/arm64 mthoring/multi-arch-test:0.0.0
```
Skal printe: aarch64
