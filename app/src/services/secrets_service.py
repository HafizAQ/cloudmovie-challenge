import json
import os

import boto3


def get_tmdb_token():

    secret_id = os.environ["TMDB_SECRET_ID"]

    client = boto3.client(
        "secretsmanager",
        region_name=os.environ.get(
            "AWS_REGION",
            "eu-central-1"
        )
    )


    response = client.get_secret_value(
        SecretId=secret_id
    )


    secret = json.loads(
        response["SecretString"]
    )


    return secret["TMDB_API_TOKEN"]

