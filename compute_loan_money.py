amount_of_money = 50 #万 贷款的总金额
r = 0.058 #年化总利率 = LPR + 基准点
# 计算方式为等额本息
for N in (10, 15, 20, 25, 30):
    
    month_r = 0.0565 / 12 #实际计算中，年化利率换算为月利率
    month_N = N * 12 #总的还款月数
    
    def _get_times(N, r): # 利用等比数列求和公式计算得到倍数公式
        
        times = N * (1 + r) ** N * r / ((1 + r)**N - 1)
        return times
    
    times = _get_times(month_N, month_r) #还款总数和贷款总数的比值
    
    print('贷款%d 年, 利率%.3f%%，还款总额的倍数是贷款总额的 %.3f倍。'% (N, r * 100, times))
    
    each_month_pay = amount_of_money * 10000 * times / (N * 12)
    
    print('贷款总额为%d万元，还款总额%.2f万元，月供是%.2f元' % (amount_of_money, 
                                             amount_of_money * times,
                                             each_month_pay))
