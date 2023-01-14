import argparse
import os

#Get the loader name as a var
parser = argparse.ArgumentParser(description="Takes loader and decides what to do with it.")
parser.add_argument('loader', type = str, help = 'path to loader')

args = parser.parse_args()
loader_name = args.loader

root = '../loaders'

def freeze_requirements(loader_name):
    cd = f"""
    cd ../loaders/{loader_name}/
    source venv/bin/activate
    pip3 freeze > requirements.txt"""
    os.system(cd)
    
    
freeze_requirements(loader_name)