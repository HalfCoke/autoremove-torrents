FROM python:3.8.5-slim

ENV GIT_REPO 'https://github.com/HalfCoke/autoremove-torrents'
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
WORKDIR /app
RUN apt update \
    && apt -y install cron git\
    && apt clean
RUN git clone $GIT_REPO && cd autoremove-torrents && python3 setup.py install
RUN touch /var/log/autoremove-torrents.log
RUN mkdir /etc/autoremove_torrents && touch /etc/autoremove_torrents/config.yml

RUN crontab -l | { cat; echo "*/15 * * * * /usr/local/bin/autoremove-torrents --conf=/etc/autoremove_torrents/config.yml --log=/var/log"; } | crontab -

CMD /usr/local/bin/autoremove-torrents --conf=/etc/autoremove_torrents/config.yml --log=/var/log --view && cron -f
