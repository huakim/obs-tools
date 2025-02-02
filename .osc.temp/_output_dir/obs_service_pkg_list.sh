#!/bin/bash
obs_service_list | sed 's/^\(.*\)/obs-service-\1/'
obs_pkg_list
