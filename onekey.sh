#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}

bash mkker.sh $os_name
bash mkinit.sh $os_name
bash patch.sh $os_name
[ -e custom.sh ] && bash custom.sh $os_name
bash pack.sh $os_name
