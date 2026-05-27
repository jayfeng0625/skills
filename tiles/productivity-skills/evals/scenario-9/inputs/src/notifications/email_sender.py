# Existing ad-hoc email notification logic
import smtplib
from email.mime.text import MIMEText

SMTP_HOST = "smtp.internal"
SMTP_PORT = 587

def send_order_confirmation(user_email, order_id, total):
    msg = MIMEText(f"Your order #{order_id} for ${total:.2f} has been confirmed.")
    msg["Subject"] = "Order Confirmation"
    msg["From"] = "noreply@example.com"
    msg["To"] = user_email
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.sendmail("noreply@example.com", [user_email], msg.as_string())

def send_password_reset(user_email, reset_token):
    msg = MIMEText(f"Click here to reset: https://app.example.com/reset?token={reset_token}")
    msg["Subject"] = "Password Reset"
    msg["From"] = "noreply@example.com"
    msg["To"] = user_email
    with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
        server.sendmail("noreply@example.com", [user_email], msg.as_string())
