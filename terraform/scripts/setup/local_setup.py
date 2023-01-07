import yaml
import os
import argparse
from dotenv import load_dotenv

load_dotenv()

git_ignore = """

venv
.env

"""

env = f"""
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
S3_BUCKET_NAME={os.environ['S3_BUCKET_NAME']}

"""

app = """
import os
from dotenv import load_dotenv

load_dotenv()

def handler(event=None, context=None):
    print(os.environ["S3_BUCKET_NAME"])

if __name__ == "__main__":
    handler()


"""

def create_venv(path):
    cmd = f"python3 -m venv ../loaders/{path}/venv"
    os.system(cmd)

def install_dot_env(path):
    cmd = f"source ../loaders/{path}/venv/bin/activate && pip install python-dotenv"
    os.system(cmd)
    
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


def create_file_if_not_exists(dir, filename, contents=None, **kwargs):
    path =  os.path.join(dir, filename)
    if not os.path.exists(path):
        pass
        #print("File does not exist. Creating.")
    else:
        pass
        #print("File exists.")
    # Creates a new file
    with open(path, 'w') as fp:
        if contents is None:
            pass
        else:
            fp.write(contents)

#Get the loader name as a var
parser = argparse.ArgumentParser(description="Takes loader and decides what to do with it.")
parser.add_argument('loader', type = str, help = 'path to loader')

args = parser.parse_args()
loader_name = args.loader

loader_config = open('../config.yml', 'r')

loader_yaml = yaml.safe_load(loader_config)

root = '../loaders'

full_loader_path = root+'/'+loader_name

#Collect all of the current_directories
dirs = [f.path for f in os.scandir(root) if f.is_dir()]

#Create set of all loaders + current directories
loader_set = (set([full_loader_path]+dirs))

for file in loader_set:
    if file == full_loader_path:  
        dir = create_dir_if_not_exists(file)
        create_file_if_not_exists(dir, "app.py", app.strip().format("test"))
        create_file_if_not_exists(dir, ".gitignore", git_ignore.strip())
        create_file_if_not_exists(dir, ".env", env.strip())
        create_venv(dir)
        install_dot_env(dir)
        

    else:
       pass
