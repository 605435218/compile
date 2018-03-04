# -*- coding:utf-8 -*-
# 发送html内容的邮件
import smtplib, time
from email.mime.text import MIMEText
from email.header import Header

class send_mail:
    def __init__(self):
        self.sender="pengh5852@fiberhome.com"
        self.receiver_list=["pengh5852@fiberhome.com",]
        self.image_names=[]
        self.image_run_cmd=[]
        self.subject="subject"

    def _get_html_content(self):
        mail_body="<!DOCTYPE html>\
                  <html>  \
                  <head>\
<meta charset="UTF-8"> \
<title>${ENV, var="JOB_NAME"}-第${BUILD_NUMBER}次构建日志</title>
</head>

<body leftmargin="8" marginwidth="0" topmargin="8" marginheight="4"
    offset="0">
    <table width="95%" cellpadding="0" cellspacing="0"  style="font-size: 11pt; font-family: Tahoma, Arial, Helvetica, sans-serif">
        <tr>
            <td>各位同事，大家好，以下为${PROJECT_NAME }项目构建信息</td>
        </tr>
        <tr>
            <td><br />
            <b><font color="#0B610B">构建信息</font></b>
            <hr size="2" width="100%" align="center" /></td>
        </tr>
        <tr>
            <td>
                <ul>
                    <li>项目名称 ： ${PROJECT_NAME}</li>
                    <li>构建编号 ： 第${BUILD_NUMBER}次构建</li>
                    <li>触发原因： ${CAUSE}</li>
                    <li>构建状态： ${BUILD_STATUS}</li>
                    <li>构建日志： <a href="${BUILD_URL}console">${BUILD_URL}console</a></li>
                    <li>构建  Url ： <a href="${BUILD_URL}">${BUILD_URL}</a></li>
                    <li>工作目录 ： <a href="${PROJECT_URL}ws">${PROJECT_URL}ws</a></li>
                    <li>项目  Url ： <a href="${PROJECT_URL}">${PROJECT_URL}</a></li>
                </ul>
            </td>
        </tr>
    </table>
</body>
</html>  "
        return MIMEText(mail_body, _subtype='html', _charset='utf-8')

    def send(self):
        try:
            smtp = smtplib.SMTP('smtp.fiberhome.com', timeout=20)
            smtp.login("pengh5852@fiberhome.com", "fh0211005852")
            msg = self._get_html_content()
            msg['Subject'] = Header(self.subject, 'utf-8')
            msg['From'] = self.sender
            msg['To'] = ','.join(self.receiver_list)
            smtp.sendmail(self.sender, self.receiver_list, msg.as_string())
        except Exception as e:
            print e
            print("邮件发送失败！")
        else:
            print("邮件发送成功！")
        finally:
            smtp.quit()

if __name__=="__main__":
    send_mail().send()

