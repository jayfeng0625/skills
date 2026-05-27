# Existing Slack notification logic — no retry, no error handling
import requests

SLACK_WEBHOOK = "https://hooks.slack.com/services/PLACEHOLDER"

def notify_ops_channel(message):
    requests.post(SLACK_WEBHOOK, json={"text": message})

def notify_deployment(service_name, version, deployed_by):
    msg = f":rocket: *{service_name}* v{version} deployed by {deployed_by}"
    requests.post(SLACK_WEBHOOK, json={"text": msg})
