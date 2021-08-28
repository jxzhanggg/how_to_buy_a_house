# 自动对小区所有户号按照得分进行排序
from collections import namedtuple, OrderedDict

# 楼号和对应打分（1-10分）
LOU = {"#1":4, "#2":5, "#3":7, "#5":9, "#6":10, "#10":6}


# 33 层楼根据层数打分
CENG_33 = {
    "01":1, "02":1, "03":1, "04":1, "05":2,
    "06":3, "07":4, "08":5, "09":6, "10":7,
    "11":10, "12":9, "13":9, "14":6, "15":9,
    "16":12, "17":10, "18":12, "19":9, "20":9,
    "21":8, "22":8, "23":8, "24":7, "25":7,
    "26":6, "27":5, "28":4, "29":4, "30":4,
    "31":4, "32":2, "33":1
}
# 20层楼楼层打分
CENG_20 = {
    "01":1, "02":1, "03":2, "04":2, "05":3,
    "06":4, "07":6, "08":8, "09":8, "10":9,
    "11":10, "12":10, "13":10, "14":6, "15":10,
    "16":10, "17":9, "18":9, "19":6, "20":1
}
# 31层楼打分
CENG_30 = {
    "01":1, "02":1, "03":1, "04":1, "05":2,
    "06":3, "07":4, "08":5, "09":6, "10":7,
    "11":10, "12":9, "13":9, "14":6, "15":9,
    "16":12, "17":10, "18":12, "19":9, "20":9,
    "21":8, "22":8, "23":7, "24":6, "25":5,
    "26":4, "27":3, "28":3, "29":2, "30":1, "31":1,
}

# 所有户型和对应打分
HUXING = {
    "A":  3, # 105 m^2, 1: 1.83, 3，5栋东西边户
    "B":  3, # 105 m^2, 1: 1.05,  1，3，5，6，10栋中间户 
    "C":  6, # 115 m^2, 1: 1.05,  2栋为中间户，6栋为东边户，10栋为东西边户
    "D":  5, # 115 m^2, 1: 1.98,  1，2栋东西边户
    "E":  8  # 135 m^2, 1: 1.04,  6栋西边户
}
HUXING_DETAIL = {
    "A":  "约105平，宽长比 1:1.83",
    "B":  "约105平，宽长比 1:1.05",
    "C":  "约115平，宽长比 1:1.05",
    "D":  "约115平，宽长比 1:1.98", 
    "E":  "约135平，宽长比 1:1.04"
}
# 各种打分所占权重多少
CENG_WEIGHT = 0.3 #楼层权重
LOU_WEIGHT = 0.3 # 楼号权重
HUXING_WEIGHT = 0.2 # 户型打分
HUHAO_WEIGHT = 0.2 # 户号打分
# 户号权重在下面每个户号中添加score=？设置

def get_all_rooms():
    Lou = namedtuple("lou", ["lou", "danyuan"])
    Danyuan = namedtuple("danyuan", ["danyuan", 'huhao'])
    Huhao = namedtuple('huhao', ['huhao', 'ceng', 'huxing', 'score', 'type'])
    # 默认户号的得分为5分
    Huhao.__new__.__defaults__ = (None, None, None, 5, None)
    
    
    ###### # 1 #######
    # 一单元靠近拐角，降低分数， type表示当前户号从西到东所处位置，如 1 _ _ 表示西边户，共三户
    huhao1 = Huhao(ceng=range(3, 31), huhao="01", huxing='B', score=3, type='_ _ 1 _ _ _ _')
    huhao2 = Huhao(ceng=range(3, 30), huhao="02", huxing='B', score=2, type="_ 1 _ _ _ _ _")
    # 十字路口拐角位置，故分数设置为1
    huhao3 = Huhao(ceng=range(3, 31), huhao="03", huxing='D', score=1, type="1 _ _ _ _ _")
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2, huhao3))
    
    huhao1 = Huhao(ceng=range(3, 31), huhao="01", huxing='B', type='_ _ _ _ 1 _ _')
    huhao2 = Huhao(ceng=range(3, 31), huhao="02", huxing='B', type='_ _ _ 1 _ _ _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    huhao1 = Huhao(ceng=range(3, 31), huhao="01", huxing='D', type='_ _ _ _ _ _ 1')
    # 靠东中间户，视野较好
    huhao2 = Huhao(ceng=range(3, 30), huhao="02", huxing='B', type='_ _ _ _ _ 1 _ ', score=6)
    danyuan3 = Danyuan(danyuan="3", huhao=(huhao1, huhao2))
    
    lou1 = Lou(lou='#1', danyuan=(danyuan1, danyuan2, danyuan3))
    ###### # 2 #######
    # 正前方开阔
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='C', score=6, type=' _ _ 1 _ _')
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='C', type=" _ 1 _ _ _")
    ## 下有商业住户故分数设置为1
    huhao3 = Huhao(ceng=range(3, 33), huhao="03", huxing='D', score=1, type='1 _ _ _ _')
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2, huhao3))
    
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='D', type= '_ _ _ _ 1')
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='C', type='_ _ _ 1 _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    lou2 = Lou(lou='#2', danyuan=(danyuan1, danyuan2))
    #########  # 3 ##########
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='B', type='_ 1 _ _')
    # 西边户降低分数
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='A', score=4, type='1 _ _ _')
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2))
    
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='A', type='_ _ _ 1')
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='B', type='_ _ 1 _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    lou3 = Lou(lou='#3', danyuan=(danyuan1, danyuan2))
    #########  # 5 ##########
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='B', type= '_ 1 _  _')
    # 西边户降低分数
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='A', score=4, type='1 _ _ _')
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2))
    
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='A', type=' _ _ _ 1')
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='B', type= '_ _ 1 _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    lou5 = Lou(lou='#5', danyuan=(danyuan1, danyuan2))
    #########  # 6 ##########
    huhao1 = Huhao(ceng=range(1, 20), huhao="01", huxing='B', type='_ 1 _ _')
    # 西边户降低分数
    huhao2 = Huhao(ceng=range(1, 20), huhao="02", huxing='E', score=4, type='1 _ _ _')
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2))
    
    huhao1 = Huhao(ceng=range(1, 20), huhao="01", huxing='C', type= '_ _ _ 1')
    huhao2 = Huhao(ceng=range(1, 20), huhao="02", huxing='B', type= '_ _ 1 _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    lou6 = Lou(lou='#6', danyuan=(danyuan1, danyuan2))
    #########  # 10 ##########
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='B', type=" _ 1 _ _")
    # 西边户,且靠近路降低分数
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='C', score=3, type= '1 _ _ _')
    danyuan1 = Danyuan(danyuan="1", huhao=(huhao1, huhao2))
    
    huhao1 = Huhao(ceng=range(1, 33), huhao="01", huxing='C', type="_ _ _ 1")
    huhao2 = Huhao(ceng=range(1, 33), huhao="02", huxing='B', type='_ _ 1 _')
    danyuan2 = Danyuan(danyuan="2", huhao=(huhao1, huhao2))
    
    lou10 = Lou(lou='#10', danyuan=(danyuan1, danyuan2))
    
    all_lous = (lou1, lou2, lou3, lou5, lou6, lou10)
    
    return all_lous

    
rooms = get_all_rooms()


def get_ceng_score(ceng_num, ceng):
    if ceng_num in [30, 31]:
        return CENG_30[ceng]
    elif ceng_num == 33:
        return CENG_33[ceng]
    elif ceng_num == 20:
        return CENG_20[ceng]
    else:
        assert False,'Your ceng num %d is not valid.' % ceng_num

cnt = 0
#遍历所有的楼号
scored_rooms = []
for lou in rooms:
    #遍历该栋楼的所有单元
    for danyuan in lou.danyuan:
        # 遍历该单元的户号
        for huhao in danyuan.huhao:
            # 得到当前户号的所有层数
            cengs = list(huhao.ceng)
            cengs.append(cengs[-1] + 1)

            for ceng in cengs:
                # 
                room_name = lou.lou + '-' + danyuan.danyuan + '%02d' % ceng + huhao.huhao

                ceng_score = get_ceng_score(cengs[-1], "%02d" % ceng)
                huxing_score = HUXING[huhao.huxing]
                huhao_score = huhao.score
                lou_score = LOU[lou.lou]

                score = CENG_WEIGHT * ceng_score + \
                        HUXING_WEIGHT * huxing_score + \
                        HUHAO_WEIGHT * huhao_score + \
                            LOU_WEIGHT * lou_score
                scored_rooms.append(
                    [
                        room_name,
                        score,
                        ceng_score,
                        huxing_score,
                        huhao_score,
                        lou_score,
                        huhao.huxing,
                        huhao.type

                    ]
                )

                cnt += 1
#print(cnt) check if your total room is right
scored_rooms = sorted(scored_rooms, key=lambda x: x[1], reverse=True)

score_file = open('score.csv', 'w')

head = '房间号,房间号细节,东西位置,户型,户型描述,总分,层高得分,'
head += '楼得分,户型得分,户号得分\n'
score_file.write(head)
for each in scored_rooms:
    room_name, score, ceng_score, \
    huxing_score, huhao_score, lou_score, \
        huxing, type = each 

    to_write = ''
    to_write += room_name + ','
    to_write += '%s栋 %s单元 %s层 %s户,' % (
        room_name.split('-')[0],
        room_name.split('-')[1][0],
        room_name.split('-')[1][1:3],
        room_name.split('-')[1][3:]
    )
    to_write += type + ','
    to_write += huxing + ','
    to_write += HUXING_DETAIL[huxing] + ','
    to_write += "%.2f" % score + ','
    to_write += '%.1f' % ceng_score + ','
    to_write += '%.1f' % lou_score + ','
    to_write += '%.1f' % huxing_score + ','
    to_write += '%.1f' % huhao_score + '\n'

    score_file.write(to_write)

score_file.close()
    
