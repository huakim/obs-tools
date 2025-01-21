#!/bin/bash
obs_service_list | sed 's/^\(.*\)/obs-service-\1/'
