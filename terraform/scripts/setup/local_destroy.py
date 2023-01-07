import yaml
import os
import shutil
import argparse

def create_dir_if_not_exists(path):
    # Check whether the specified path exists or not
    isExist = os.path.exists(path)
    if not isExist:
        # Create a new directory because it does not exist
        os.makedirs(path)
        #print(f"The {path} directory is created!")
    else:
        #print(f"The {path} directory already exists.")
        pass
    return path 

loader_config = open('../config.yml', 'r')

loader_yaml = yaml.safe_load(loader_config)

root = '../loaders'

loaders = loader_yaml['loaders']

loader_names = [root+'/'+loader['name'] for loader in loaders ]

#Collect all of the current_directories
dirs = [f.path for f in os.scandir(root) if f.is_dir()]

diff = list(set(dirs).difference(loader_names))

for dir in diff:
    shutil.rmtree(dir)