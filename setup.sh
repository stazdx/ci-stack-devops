#!/bin/sh

echo "Create docker machine"
docker-machine create -d virtualbox --virtualbox-memory "6000" docker-ci-tools

echo "Setup environment"
eval $(docker-machine env docker-ci-tools)

echo "Checkout Git Repository"
git clone https://github.com/stazdx/ci-stack-devops.git
cd ci-stack-devops

echo "Startup Docker Compose"
docker-compose up
