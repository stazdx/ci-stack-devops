#!/bin/bash

sed -i 's/\- \/usr\/local\/bin\/docker:\(\/usr\/bin\/docker\)/- \1:\1/' docker-compose.yml
