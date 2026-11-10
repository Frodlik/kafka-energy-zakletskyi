# Середовище для практичної роботи з Apache Kafka (Заклецький В., ТР-62мп)
# Ubuntu 22.04 = Java 11 + Python 3.10 (kafka-python 2.0.2 не працює на Python 3.12+)
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Крок 1.2: Java 11, Python і утиліти з методички (wget, nano, tree, netstat, lsof, ps)
# (man1 потрібен інсталятору JDK у мінімальному образі Ubuntu)
RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install -y --no-install-recommends \
        openjdk-11-jdk-headless python3 python3-pip python-is-python3 \
        wget ca-certificates nano tree net-tools lsof procps \
    && rm -rf /var/lib/apt/lists/*

# Крок 1.3: робоча директорія проєкту з прізвищем
WORKDIR /root/kafka-energy-zakletskyi
RUN mkdir -p config data scripts

# Крок 2.1: завантаження Kafka 3.7.1 (версія вже в архіві Apache)
RUN wget -nv https://archive.apache.org/dist/kafka/3.7.1/kafka_2.13-3.7.1.tgz \
    && tar -xzf kafka_2.13-3.7.1.tgz \
    && mv kafka_2.13-3.7.1 kafka \
    && rm kafka_2.13-3.7.1.tgz

# Крок 5.2: Python-залежності
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Крок 2.3: наша конфігурація замість стандартної (оригінали -> *.backup)
COPY config/ config/
RUN cd kafka/config \
    && cp server.properties server.properties.backup \
    && cp zookeeper.properties zookeeper.properties.backup \
    && cp ../../config/server.properties ../../config/zookeeper.properties .

# Контейнер просто працює; ZooKeeper, Kafka і скрипти запускаються вручну через docker exec
CMD ["sleep", "infinity"]
