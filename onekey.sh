#!/bin/bash
# Copyright (C) 2021 Pengyu Liu (SeedClass 2018)

os_name=${1:-lpyos}
feature=${2:-iwlwifi}

bash prepare.sh
bash mkker.sh $os_name $feature
bash mkinit.sh $os_name $feature
bash patch.sh $os_name $feature
[ -e custom.sh ] && bash custom.sh $os_name
bash pack.sh $os_name
