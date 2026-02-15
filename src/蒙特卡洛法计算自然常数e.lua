--蒙特卡洛法计算自然常数e
--作者：Duo  QQ:113530014
--原理:
--【多少个[0,1]随机数之和会大于1-哔哩哔哩】 https://b23.tv/G2TXVZ5


data={}
for m=1,1234 do
  sum=0
  n=0
  while sum<=1 do
    sum=sum+math.random(0,100000)*0.00001
    n=n+1
  end
  data[m]=n
end
cen=0
for w=1,#data do
  cen=cen+data[w]
end
cen=cen/#data
print(cen)