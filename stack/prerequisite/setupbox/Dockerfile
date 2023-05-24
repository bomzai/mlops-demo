FROM ubuntu:22.04

# Prerequisites
RUN apt-get update \
	&& apt-get install -y \
	curl \
	postgresql-client \
	&& rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://coder.com/install.sh | sh

WORKDIR /setup-container