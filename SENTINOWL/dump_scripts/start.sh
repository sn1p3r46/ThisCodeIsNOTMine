#!/bin/bash

python SENTINOWL/dump_scripts/install_beforedump.py

python SENTINOWL/dump_scripts/python dump_bin.py
python SENTINOWL/dump_scripts/dump_etc.py
python SENTINOWL/dump_scripts/dump_home.py
python SENTINOWL/dump_scripts/dump_mnt.py
python SENTINOWL/dump_scripts/dump_sbin.py
python SENTINOWL/dump_scripts/dump_update.py
python SENTINOWL/dump_scripts/dump_data.py
python SENTINOWL/dump_scripts/dump_factory.py
python SENTINOWL/dump_scripts/dump_lib.py
python SENTINOWL/dump_scripts/dump_proc.py
python SENTINOWL/dump_scripts/dump_sys.py
python SENTINOWL/dump_scripts/dump_usr.py
python SENTINOWL/dump_scripts/dump_dev.py
python SENTINOWL/dump_scripts/dump_firmware.py
python SENTINOWL/dump_scripts/dump_licenses.py
python SENTINOWL/dump_scripts/dump_root.py
python SENTINOWL/dump_scripts/dump_tmp.py
python SENTINOWL/dump_scripts/dump_var.py
