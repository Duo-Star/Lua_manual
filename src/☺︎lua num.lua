require "import"

function Copy(data)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(data))
end

local printWhat={}

function p(_)
  printWhat[#printWhat+1]=_
end

local a=1.4142135623731
local b=math.sqrt(2)
local inf_=1/0 --无穷
local nan_=0/0 --未定义


--下面打印这两个值
p(a)-->1.4142135623731
p(b)-->1.4142135623731

--Lua开始装逼了
p(a^2)-->2.0
p(b^2)-->2.0

--然后就有点意外
p(a^2 == 2.0)-->false
p(b^2 == 2.0)-->true


--露馅
p(math.sqrt(2)
==
1.414213562373095)-->true  (!!!!!)

--e
p(a == b)-->false


--原来如此
p(a - b)-->4.8849813083507e-15


--看看类型
p(math.type(a))-->float
p(math.type(b))-->float
p(math.type(a^2))-->float
p(math.type(b^2))-->float


--下面打印这两个值
p(inf_)--> inf
p(nan_)--> nan

--自身和自身比较
p(inf_==inf_)--> true
p(nan_==nan_)--> false

--和math.huge比较
p(inf_==math.huge)--> true
p(nan_==math.huge)--> false

--inf运算
p(inf_ + 1)--> inf
p(inf_ - inf_)--> nan
p(math.sin(inf_))--> nan
p(inf_ * 0)--> nan

--nan运算
p(nan_ + 1)--> nan
p(nan_ - nan_)--> nan


-- <叫什么来着> 宾馆()
p(inf_==inf_+1)--> true

--不等关系
p(1/0 < 2/0)--> false
p(1/0 > 2/0)--> false

p(0/0 > 0/0)--> false
p(0/0 < 0/0)--> false

--nan 意思是 not a number
--比较是否相等，大小都会得到false

--inf 意思是 infinity
--比较是否相等，大小都会得到true


print(dump(printWhat))