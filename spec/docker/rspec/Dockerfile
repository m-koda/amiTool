FROM ruby:latest
WORKDIR /work
ADD ./ /work
RUN if [ ! -d "/root/.aws" ] ; then mkdir /root/.aws ; fi
RUN if [ -f "/root/.aws/credentials" ] ; then rm -f /root/.aws/credentials ; fi
RUN if [ ! -f "/root/.aws/credentials" ] ; then printf "[dummy_profile]\n\
aws_access_key_id = AKxxxxxxxxxxxxxxxxxx\n\
aws_secret_access_key = zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n\
region = ap-northeast-1" >> /root/.aws/credentials ; fi
RUN apt-get update && apt-get -y install python-pip
RUN pip install awscli
RUN bundle install