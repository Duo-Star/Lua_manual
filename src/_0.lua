print(0/0)           -->nan
print((-1)^0.5)      -->nan
--but:
print(0/0==0/0)      -->false
print(0/0==math.huge)-->false
print(0/0==(-1)^0.5) -->false


print(1/0)           -->inf
print(1/0==math.huge)-->true
print(1/0==1/0)      -->true
--and:
print(1/0==2/0)      -->true
--but:
print(1/0<=2/0)      -->true
print(1/0>=2/0)      -->true

--]]

--nan 意思是 not a number
--比较是否相等，大小都会得到false

--inf 意思是 infinity
--比较是否相等，大小都会得到true