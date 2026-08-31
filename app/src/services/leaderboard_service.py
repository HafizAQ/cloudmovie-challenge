import os
import uuid

import boto3


class LeaderboardService:
    def __init__(self):
        table_name = os.environ.get("DYNAMODB_TABLE")

        if not table_name:
            raise RuntimeError(
                "DYNAMODB_TABLE environment variable is not configured."
            )

        region = os.environ.get(
            "AWS_REGION",
            "eu-central-1",
        )

        dynamodb = boto3.resource(
            "dynamodb",
            region_name=region,
        )

        self.table = dynamodb.Table(table_name)

    def save_score(self, player, score):
        item = {
            "player_id": str(uuid.uuid4()),
            "player": player,
            "score": int(score),
        }

        self.table.put_item(
            Item=item,
        )

        return item

    def get_scores(self):
        response = self.table.scan()

        scores = response.get(
            "Items",
            [],
        )

        return sorted(
            scores,
            key=lambda item: int(item["score"]),
            reverse=True,
        )[:10]
    