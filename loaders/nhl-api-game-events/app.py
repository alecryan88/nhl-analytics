import requests
import datetime
import boto3
import io
import os
from dotenv import load_dotenv

load_dotenv()


client = boto3.client('s3')


def get_game_data(game_id):
    url =f'https://statsapi.web.nhl.com/api/v1/game/{game_id}/feed/live'
    r = requests.get(url = url)
    bytes = r.content
    return bytes


def handler(event=None, context=None):

    today = datetime.datetime.today()
    yesterday = today - datetime.timedelta(days=1)
    yesterday_str = yesterday.strftime('%Y-%m-%d')

    url = f'https://statsapi.web.nhl.com/api/v1/schedule'

    params = {'startDate': yesterday_str, 'endDate': yesterday_str}

    r = requests.get(url=url, params=params)

    j = r.json()

    for games in j['dates']:
        date = games['date']
        print(f"Uploading objects for: {date}")
        for game in games['games']:
            game_id = game['gamePk']   

            obj = get_game_data(game_id)

            #Store reponse as bytes
            bytes = io.BytesIO(obj)

            client.put_object(
                Body=bytes,
                Bucket=os.environ['S3_BUCKET_NAME'],
                Key=f'partition_date={date}/{game_id}.json'
            )

            print(f"Uploaded {game_id}.json to s3.")

    print("Done.")

if __name__ == "__main__":
    handler()