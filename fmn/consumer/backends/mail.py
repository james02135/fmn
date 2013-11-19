from fmn.consumer.backends.base import BaseBackend
import fedmsg.meta

import smtplib
import email


confirmation_template = """
{username} has requested that notifications be sent to this email address
* To accept, visit this address:
  {acceptance_url}
* Or, to reject you can visit this address:
  {rejection_url}
Alternatively, you can ignore this.  This is an automated message, please
email {support_email} if you have any concerns/issues/abuse.
"""

reason = """
You received this message due to your preference settings at
{base_url}/{user}/email/{chain}
"""


class EmailBackend(BaseBackend):

    def __init__(self, *args, **kwargs):
        super(EmailBackend, self).__init__(*args, **kwargs)
        self.mailserver = self.config['fmn.email.mailserver']
        self.from_address = self.config['fmn.email.from_address']

    def send_mail(self, recipient, subject, content):
        self.log.debug("Sending email")

        if 'email address' not in recipient:
            self.log.warning("No email address found.  Bailing.")
            return

        email_message = email.Message.Message()
        email_message.add_header('To', recipient['email address'])
        email_message.add_header('From', self.from_address)

        email_message.add_header('Subject', subject)

        # Since we do simple text email, adding the footer to the content
        # before setting the payload.
        footer = self.config.get('fmn.email.footer', '')

        if 'chain' in recipient and 'user' in recipient:
            base_url = self.config['fmn.base_url']
            footer = reason.format(base_url=base_url, **recipient) + footer

        if footer:
            content += '/n--/n {0}'.format(footer)

        email_message.set_payload(content)

        server = smtplib.SMTP(self.mailserver)
        server.sendmail(
            self.from_address.encode('utf-8'),
            [recipient['email address'].encode('utf-8')],
            email_message.as_string().encode('utf-8'),
        )
        server.quit()
        self.log.debug("Email sent")

    def handle(self, recipient, msg):
        content = fedmsg.meta.msg2repr(msg, **self.config)
        subject = fedmsg.meta.msg2subtitle(msg, **self.config)

        self.send_mail(recipient, subject, content)

    def handle_confirmation(self, confirmation):
        confirmation.set_status(self.session, 'valid')
        acceptance_url = self.config['fmn.acceptance_url'].format(
            secret=confirmation.secret)
        rejection_url = self.config['fmn.rejection_url'].format(
            secret=confirmation.secret)

        content = confirmation_template.format(
            acceptance_url=acceptance_url,
            rejection_url=rejection_url,
            support_email=self.config['fmn.support_email'],
            username=confirmation.user_name,
        ).strip()
        subject = '[FMN] Confirm notification email'

        recipient = {'email address' : confirmation.detail_value}

        self.send_mail(recipient, subject, content)
