import os

# Configuration bassed to celery
# See https://docs.celeryq.dev/en/stable/userguide/configuration.html
celery = {
    # Transport used to send messages
    # See https://docs.celeryq.dev/en/stable/userguide/configuration.html#broker-url
    "broker_url": os.environ.get("CELERY_BROKER_URL","redis://localhost:6379/0"),
    
}

# Configuration passed to boto3
# See https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html#boto3.session.Session.resource
s3 = {
    "endpoint_url": os.environ.get("S3_ENDPOINT_URL", "https://s3.100do.se/"),
    "aws_access_key_id": os.environ.get("AWS_ACCESS_KEY_ID", "perle"),
    "aws_secret_access_key": os.environ.get("AWS_SECRET_ACCESS_KEY","GEW3SgnHTJcKC1oTiDlV"),
    "region_name": os.environ.get("AWS_REGION_NAME", "us-east-1"),
    
}


# Name of the bucket used for uploading images
bucket_name = os.environ.get("S3_BUCKET_NAME", "images")
