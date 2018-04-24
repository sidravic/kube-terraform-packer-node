#!/bin/bash

docker login

docker tag chomeshvan:latest supersid/chomeshvan

chomeshvan git:(master) ✗ docker push

