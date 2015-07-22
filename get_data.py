# -*- coding: utf-8 -*-
__author__ = 'Bright Pan'

import types
import urllib.request
try:
    import simplejson as json
except Exception:
    import json
import pymysql

duan ="--------------------------"	#在控制台断行区别的

class DB(object):
    def __init__(self, host="localhost", user="root", passwd="", db="", charset="utf-8"):
        self.conn=pymysql.connect(host=host,user=user,passwd=passwd,db=db,charset=charset)
        self.cur = self.conn.cursor()

    def insert_data(self, data, table_name = ""):
        self.cur.execute("delete from %s" % table_name)
        if type(data) is list:
            for d in data:
                sql = "INSERT INTO %s set " % table_name
                for key, value in d.items():
                    if value is None:
                        sql += key + " = 'NULL',"
                    else:
                        if type(value) is dict:
                            sql += key + " = '%s-%s-%s %s:%s:%s'," % (value['year']+1900, value["month"]+1, value['date'], value["hours"], value['minutes'], value['seconds'])
                        else:
                            sql += key + " = '%s'," % value
                sql = sql[:-1]
                #print(sql)
                self.cur.execute(sql)
            self.conn.commit()
    def __del__(self):
        self.conn.close()

url_template = "http://api.seedland.cc/ws/json?key=%s&token=%s"
api_token = "DBA7AEF165F514232423999B6B81EA63";
rc_parameters = {
    'key' : "9C9F73DC8D821F4861D0D0C2038F2CB1",
    'table_name':"my_rc",
}
rg_parameters = {
    'key' : "947A80532AD54B83F7674B8B7AAAF436",
    'table_name':"my_rg",
}
qy_parameters = {
    'key' : "654A7B61CAACC62BC4770ABC8BB7DA56",
    'table_name':"my_qy",
}
kf_parameters = {
    'key' : "A9EAA88BF63D3F0DC7F454F74D8BC06E",
    'table_name':"my_kf",
}

#利用urllib2获取网络数据
class ProcessData(object):
    def __init__(self):
        self.db = DB(db="test", charset="utf8")

    def process(self, parameters):
        #从网络上获取数据
        try:
            url = url_template % (parameters['key'], api_token)
            self.data = urllib.request.urlopen(url).read().decode('utf-8')
        except Exception as e:
            print(e)
        #写入文件
        file = open("%s.txt" % parameters['table_name'],"w")
        file.write(self.data)
        file.close()
        #解析从网络上获取的JSON数据
        self.j_data = json.loads(self.data)
        print(duan)
        for value in self.j_data[0:5]:
            print (value)
            print (duan)
        self.db.insert_data(self.j_data,table_name=parameters['table_name'])

    def __del__(self):
        del self.db

def registerUrl():
    try:
        url = "http://api.seedland.cc/ws/json?key=9C9F73DC8D821F4861D0D0C2038F2CB1&token=DBA7AEF165F514232423999B6B81EA63"
        data = urllib.request.urlopen(url).read().decode('utf-8')
        return data
    except Exception as e:
        print(e)

#写入文件
def jsonFile(fileData):
    file = open("d:\json.txt","w")
    file.write(fileData)
    file.close()

#解析从网络上获取的JSON数据
def praserJsonFile(jsonData):
    j_value = json.loads(jsonData)[0:10]
    print(duan)
    for value in j_value:
        print (value)
        print (duan)
    return j_value



if __name__ == "__main__":
    # xinput = raw_input()
    # x = 130
    # xvalue = cmp(x,xinput)
    # print xvalue
    # print x/100.0
    # db = DB(db="test", charset="utf8")
    # data = registerUrl()
    # jsonFile(data)
    # db.insert_my_rc(praserJsonFile(data))
    pd = ProcessData()
    pd.process(rc_parameters)
    pd.process(rg_parameters)
    pd.process(qy_parameters)
    pd.process(kf_parameters)
