import os
from dotenv import load_dotenv

load_dotenv()

def handler(event=None, context=None):
    print(os.environ["S3_BUCKET_NAME"])

if __name__ == "__main__":
    handler()