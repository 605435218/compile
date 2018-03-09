#!/usr/bin/python
# -*- coding:utf-8 -*-
# 发送html内容的邮件
import smtplib
from email.mime.text import MIMEText
from email.header import Header
import requests
import json
import sys
class send_mail:
    def __init__(self,image_info_list):
        self.sender="pengh5852@fiberhome.com"
        #这里填写收件人列表
        self.receiver_list=["pengh5852@fiberhome.com",]
        self.image_info={}
        self.image_info["project_name"]=image_info_list[0]
        self.image_run_cmds=[]
        self.image_names=[]
        for i in image_info_list[1:]:
            name,cmd=i.split(";")
            self.image_names.append(name)
            self.image_run_cmds.append(cmd.replace("__"," "))            
        self.image_info["images_info"]=[]
        for i,j in zip(self.image_names,self.image_run_cmds) :
            self.image_info["images_info"].append([i,j])
        self.subject=self.image_info["project_name"]+"镜像打包完成"


    def _get_html_content(self):
        data = self.image_info
        data = json.dumps(data)
        mail_body = requests.post("http://127.0.0.1:8000/content",
                      data=data).content
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
            sys.exit(1)
        else:
            print("邮件发送成功！")
        finally:
            smtp.quit()

if __name__=="__main__":
    send_mail(sys.argv[1:]).send()

