FROM ruby:2.7.1
MAINTAINER "YanYan@42paris"

COPY srcs/ /data

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -;\
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN	apt update;\
	apt install -y screen nodejs yarn;\
	apt install -y build-essential zsh vim;\
	sed -i -e s/SECLEVEL=2/SECLEVEL=1/g /etc/ssl/openssl.cnf

RUN	cd /data/ft_transcendence/;\
	gem install rails;\
	bundle install;\
	yarn install --check-files

CMD cd /data/ft_transcendence;bash ./install.sh;tail -F /dev/null
