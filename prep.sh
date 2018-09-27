#!/bin/bash

# sed s%ProjectX%Project"$1"%g <virtcreate.yml.template >virtcreate.yml
# sed s%ProjectX%Project"$1"%g <virtdestroy.yml.template >virtdestroy.yml
sed s%ProjectX%Project"$1"%g <custom_inventory.sh.template >custom_inventory.sh
# sed s%ProjectX%Project"$1"%g <RHSM_register.yml.template >RHSM_register.yml
