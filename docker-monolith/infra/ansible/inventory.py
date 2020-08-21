#!/usr/bin/python
import sys, json
import commands
inventory = {}
instances = commands.getoutput('yc  compute instances list --format="json"')
instances = json.loads(instances)
#all_hosts = []
for instance in instances:
    inst_name = instance['name']
    isnst_ip = instance['network_interfaces'][0]['primary_v4_address']['one_to_one_nat']['address']
    inventory[inst_name] = {'hosts':[isnst_ip]}
   # inventory['all'] =inventory['all'] + {'hosts':[isnst_ip]}
#print (inventory)
print json.dumps(inventory)
