# -*- coding: utf-8 -*-
__author__ = 'Bright Pan'

import types
import urllib.request
try:
    import simplejson as json
except Exception:
    import json
import pymysql
import datetime
from timeit import Timer

duan ="--------------------------"	#在控制台断行区别的

url_template_1 = "http://seedland-test.weidianit.com/api.php?f=get_token&access_token=760672602f42ebbfdc5a0ae11c163938"
url_template_2 = "http://seedland-test.weidianit.com/api.php?f=set_score&token=%s&phone=15622240888&score=200"


#利用urllib2获取网络数据
def process():
    #从网络上获取数据
    try:
        url = url_template_1
        # print(url)
        data = urllib.request.urlopen(url).read().decode('utf-8')
        # print(len(self.data[0)
    except Exception as e:
        print(e)
    # #解析从网络上获取的JSON数据
    token = json.loads(data)
    #print(duan)
    #print(token)
    try:
        url = url_template_2 % token["token"]
        # print(url)
        data = urllib.request.urlopen(url).read().decode('utf-8')
        # print(len(self.data[0)
    except Exception as e:
        print(e)
    # #解析从网络上获取的JSON数据
    #print(duan)
    #print(json.loads(data))

if __name__ == "__main__":
    from timeit import Timer
    t1=Timer("process()","from __main__ import process")
    print(t1.timeit(10000))