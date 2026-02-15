--计算机物理环境
--更新 优化视觉效果，优化算法


require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Canvas = luajava.bindClass "android.graphics.Canvas"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"

print "拖动滑条"

function init()

  h=activity.getHeight()
  w=activity.getWidth()
  lo=math.sqrt(h^2+w^2)

  black_P = Paint();
  black_P.setColor(0xbb424242)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.FILL)
  .setStrokeWidth(3)

  grey_P = Paint();
  grey_P.setColor(0x50424242)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.FILL)
  .setStrokeWidth(4)

  green_P = Paint();
  green_P.setColor(0xff4CAF50)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(5)

  blue_P = Paint();
  blue_P.setColor(0xff1E88E5)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(8)

  textUIPT = Paint();
  textUIPT.setColor(0xFF111111)
  .setAntiAlias(true)
  .setTextAlign(Paint.Align.LEFT)
  .setTextSize(50)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.FILL)
  .setStrokeWidth(3)



  e=1

  duo=
  {
    LinearLayout,
    layout_width="fill",
    layout_height="fill",
    orientation='vertical';
    { FrameLayout,
      layout_width='fill',
      layout_height='80%h',
      background='#25FAFAFA',
      id="back",
      { TextView,--文本控件
        layout_gravity='center|top',
        textSize='15dp',--文字大小
        text="i",
        style="blod",
        id="info",
      },
      { LinearLayout,--线性布局
        orientation='vertical',--方向
        layout_width='fill',--宽度
        layout_height='wrap',--高度
        layout_gravity="right|bottom",
        layout_margin='10dp';
        { MaterialCardView,
          radius="3dp",
          layout_width="40dp",
          layout_height="40dp",
          layout_gravity="right|bottom",
          layout_margin='10dp';
          cardElevation=3,
          cardBackgroundColor="#FFFFFFFF",
          onClick=function()
            e=e+0.3
          end,
          { TextView,--文本控件
            layout_gravity='center',
            textSize='25dp',--文字大小
            text="+",
            style="blod",
          },
        },
        { MaterialCardView,
          radius="3dp",
          layout_width="40dp",
          layout_height="40dp",
          layout_gravity="right|bottom",
          layout_margin='10dp';
          cardElevation=3,
          cardBackgroundColor="#FFFFFFFF",
          onClick=function()
            e=e-0.3
          end,
          { TextView,--文本控件
            layout_gravity='center',
            textSize='25dp',--文字大小
            text="-",
            style="blod",
          },
        },
      },
    },
    {
      Slider,--滑动条
      layout_gravity="center",
      id="var_b",
      ValueFrom=5,
      Value=8,
      ValueTo=15,
    },
  }
  activity.setContentView(loadlayout(duo))

  local ox=w/20
  local oy=h/5
  ox_new=ox
  oy_new=oy
  Lambda=1


  function onTouchEvent(v)
    if v.action==1 then
      if (x_t-x_b)^2+(y_t-y_b)^2<=10 then
        print("点击:("..x_b..","..y_b..")")
      end
    end
    if v.action==0 then --落笔位置
      x_b=v.x
      y_b=v.y
      x_t=v.x
      y_t=v.y
     elseif v.getAction()==MotionEvent.ACTION_UP then--如果是松开事件
      --保存屏幕移动位置
      ox_new=ox
      oy_new=oy
     else
      --屏幕移动到的位置
      x_t=v.x
      y_t=v.y
      ox=ox_new+0.8*(x_t-x_b)--屏幕变化量
      oy=oy_new+0.8*(y_t-y_b)
      info.setText("ox:"..floor(ox).."\noy:"..floor(oy))
    end
  end


  Env.dt=0.01
  Env.g=-10
  st=杆({l=0.2, k=200})
  A=物体({x=vector(0,0),m=0.1})
  data={}
  for x=0.2,8,0.2 do
    data[#data+1]=物体({x=vector(x,0),m=0.5})
  end
  data[#data+1]=物体({x=vector(10,0),m=0.5})

  b=8
  var_b.addOnChangeListener({
    onValueChange=function(view,value,bool)
      b=tonumber(value)
    end
  })


  function main()
    data[#data]=物体({x=vector(b,0),m=0.5})
    local f1=作用力(A,st,data[1])
    local f2=作用力(data[2],st,data[1])
    作用于(data[1],合力(合力(f1,f2),gravity(data[1])))
    for n=2,#data-1 do
      local f1=作用力(data[n-1],st,data[n])
      local f2=作用力(data[n+1],st,data[n])
      作用于(data[n],合力(合力(合力(f1,f2),gravity(data[n])),v_n_mul(-2,data[n].v)))
    end
  end



  timer_=Ticker()
  timer_.Period=Env.dt*1000
  timer_.onTick=function()--执行事件
    Env.t=Env.t+Env.dt
    v_Lambda=(e-Lambda)*15
    Lambda=Lambda+v_Lambda*Env.dt

    main()

  end
  timer_.start()
  function onDestroy()--退出时执行
    timer_.stop()
  end


  function ondraw(canvas, paint, panel)

    dot(A.x.x,A.x.y)


    local dx=1*(1/Lambda)
    local p0={A.x.x,A.x.y}
    local p1=p0
    for n=1,#data do
      --dot(data[n].x.x,data[n].x.y)
      p1={data[n].x.x,data[n].x.y}
      line_(p0[1],p0[2],p1[1],p1[2])
      p0=p1
    end

  end


  local DrewPanel = LuaDrawable(
  function(canvas, paint, panel)
    function dot(x,y,p)
      if p==nil then p=blue_P end
      return canvas.drawCircle(100*x*Lambda+ox, -100*y*Lambda+oy, 4, p)
    end
    function circle_(x,y,r,p)
      if p==nil then p=green_P end
      return canvas.drawCircle(100*x*Lambda+ox, 100*y*Lambda+oy, 100*r*Lambda, green_P)
    end
    function line_(x0,y0,x1,y1,p)
      if p==nil then p=black_P end
      canvas.drawLine(100*x0*Lambda+ox,-100*y0*Lambda+oy,100*x1*Lambda+ox,-100*y1*Lambda+oy, p)
    end
    ondraw(canvas, paint, panel)
    canvas.drawLine(-ox+ox,0+oy,(w-ox)+ox,0+oy, black_P)
    canvas.drawLine(0+ox,-oy+oy,0+ox,(h-oy)+oy, black_P)
    panel.invalidateSelf()
  end)

  back.setBackground(DrewPanel)

end


require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local nature={}
nature.author="Duo"
nature.version=3.2
nature.date="2023.5.25"
nature.info=[[分享_自用数学库，将嵌入Duo Nature,可能存在错误，欢迎大家指出。将持续更新(因为学业原因，更新周期较长为一个月左右)。包括函数，统计，解析几何等，自习课写的程序长达50页,之后将加入线段，向量，三角形，圆锥曲线等几何类型(本来在纸上写好了，每次回来时间不太够，慢慢码吧)。提供互相作用，例如，求公共点，求垂直，平分线，平行线，角分线，等等等等()在Duo Nature环境下，可以直观展示各个几何类型及相互作用]]
nature.history={
  v1={"2023.3.05","基本初等函数，常数，统计，逻辑与判断"},
  v2={"2023.4.03","点，直线，更普遍的加减乘除"},
  v3={"2023.5.1","点，向量，直线，全部替换为二维和三维通用，新增平面，操作控制台输出，向量运算，空间直线的位置关系初步"},
  v4={"2023.5.25","新增物理环境"},

}


Duo=loadlayout
{ LinearLayout;
  orientation="vertical";
  layout_width='fill',--宽度
  layout_height='fill',--高度
  {
    ScrollView,
    id="scrollView",
    layout_width="fill",
    layout_height="fill",
    backgroundColor="#151B5E20";
    { LinearLayout;
      orientation="vertical";
      layout_width='fill',--宽度
      layout_height='fill',--高度
      background='#00FFFFFF',--背景
      id="broad",
      {TextView,
        text="操作控制台输出",
        textSize="18dp",
        --textColor="#FFFFFFFF",
        textStyle="bold",
        padding="2dp",
        layout_gravity="center|top"
      },
      {TextView,
        text="Out[1]: Hello (๑>؂<๑）",
        textSize="23dp",
        --textColor="#FFFFFFFF",
        textStyle="bold",
        padding="2dp",
        layout_gravity="top|left",
        id="dna_see"
      },
    },
  },
}
--activity.contentView=Duo


local 保留小数位数=0.001
local 是否四舍五入=1

function n_type(data)--获取类型
  return data['ty']
end



local see_n=1
function printf(data)
  see_n=see_n+1
  if type(data)=="table" then
    data=(dump(data))
   else
    data=(tostring(data))
  end
  broad.addView(loadlayout(
  { LinearLayout,
    orientation='vertical',--方向
    {TextView,
      text="Out["..see_n.."]: "..data,
      textSize="23dp",
      --textColor="#FFFFFFFF",
      textStyle="bold",
      padding="2dp",
      layout_gravity="top|left",
    },
  }))
end
function see(data)
  see_n=see_n+1
  data=(to_seeable(data))
  broad.addView(loadlayout(
  { LinearLayout,
    orientation='vertical',--方向
    {TextView,
      text="Out["..see_n.."]: "..data,
      textSize="23dp",
      --textColor="#FFFFFFFF",
      textStyle="bold",
      padding="2dp",
      layout_gravity="top|left",
    },
  }))
end

function add(a,b)
  if ( type(a)==number_ and type(b)==number_ ) then
    return (a+b)
   elseif ( type(a)==boolean_ and type(b)==boolean_ ) then
    return (a or b)
   elseif ( type(a)==table_ and type(b)==table_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]+b[n]
    end
    return to
   elseif ( type(a)==table_ and type(b)==number_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]+b
    end
    return to
   elseif ( type(a)==number_ and type(b)==table_ ) then
    local to={}
    for n=1,#b do
      to[n]=a+b[n]
    end
    return to
  end
end


function sub(a,b)
  if ( type(a)==number_ and type(b)==number_ ) then
    return (a-b)
   elseif ( type(a)==boolean_ and type(b)==boolean_ ) then
    return (a or b)
   elseif ( type(a)==table_ and type(b)==table_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]-b[n]
    end
    return to
   elseif ( type(a)==table_ and type(b)==number_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]-b
    end
    return to
   elseif ( type(a)==number_ and type(b)==table_ ) then
    local to={}
    for n=1,#b do
      to[n]=a-b[n]
    end
    return to
  end
end
function mul(a,b)
  if ( type(a)==number_ and type(b)==number_ ) then
    return (a*b)
   elseif ( type(a)==boolean_ and type(b)==boolean_ ) then
    return (a and b)
   elseif ( type(a)==table_ and type(b)==table_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]*b[n]
    end
    return to
   elseif ( type(a)==table_ and type(b)==number_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]*b
    end
    return to
   elseif ( type(a)==number_ and type(b)==table_ ) then
    local to={}
    for n=1,#b do
      to[n]=a*b[n]
    end
    return to
  end
end
function div(a,b)
  if ( type(a)==number_ and type(b)==number_ ) then
    return (a/b)
   elseif ( type(a)==boolean_ and type(b)==boolean_ ) then
    return (a and b)
   elseif ( type(a)==table_ and type(b)==table_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]/b[n]
    end
    return to
   elseif ( type(a)==table_ and type(b)==number_ ) then
    local to={}
    for n=1,#a do
      to[n]=a[n]/b
    end
    return to
   elseif ( type(a)==number_ and type(b)==table_ ) then
    local to={}
    for n=1,#b do
      to[n]=a/b[n]
    end
    return to
  end
end

huge=math.huge--无穷
e=math.exp(1)--自然常数
pi=math.pi--圆周率
number_=type(1)
boolean_=type(true)
table_=type({})

Env={--环境变量
  huge=math.huge,
  e=math.exp(1),
  pi=math.pi,
  d=0.0001, --用于检验几何关系，数值相等关系
  dx=0.005, --用于求导数值，积分值
  dt=0.005, --物理环境时间刷新间隔
  G=10,
  g=-10,
  c=2.997*10^8,
  t=0,
}

--特殊
function exp(a) return math.exp(a) end--自然指数函数
function mod(a,b) return a%b end
--对数
function log(a,b) return math.log10(b)/math.log10(a) end--对数
function lg(a) return math.log10(a) end--常用对数
function ln(a) return math.log(a) end--自然对数
--三角
function sin(a) return math.sin(a) end--一般
function cos(a) return math.cos(a) end
function tan(a) return math.tan(a) end
function sinh(a) return math.sinh(a) end--双曲
function cosh(a) return math.cosh(a) end
function tanh(a) return math.tanh(a) end
function arcsin(a) return math.asin(a) end--反
function arccos(a) return math.acos(a) end
function arctan(a) return math.atan(a) end
--其它
function abs(a) return math.abs(a) end
function floor(a) return math.floor(a) end--向下取整
function ceil(a) return math.ceil(a) end--向上取整
function deg(a) return math.deg(a) end--角度转换
function rad(a) return math.rad(a) end
function max(...) return math.max(...) end--值
function min(...) return math.min(...) end
function atan2(a,b) return math.atan2(a,b) end--坐标转换
function huge() return math.huge end
function random(a,b) return math.random(a,b) end--随机
function sqrt(a) return math.sqrt(a) end
function sgn(x)--析离符号
  if x>0 then
    return 1
   elseif x==0
    return 0
   else
    return -1
  end
end
function key(x)--开关函数
  if x>0 then
    return 1
   else
    return 0
  end
end
function root(x)--根函数
  if x==0 then
    return 1
   else
    return 0
  end
end
function sin2cos(s,x)--三角函数互转
  return sqrt(1-(sin(s))^2)*sgn(x)
end
function cos2sin(c,y)
  return sqrt(1-(cos(c))^2)*sgn(y)
end
function sin2tan(s,x)
  return (sin(s)/sqrt(1-(sin(s))^2))*sgn(x)
end
function cos2tan(c,y)
  return (sqrt(1-(cos(c))^2)/cos(c))*sgn(y)
end
function tan2sin(t,y)
  return sqrt(1/(1+(1/(tan(t))^2)))*sgn(y)
end
function tan2cos(t,x)
  return sqrt(1/(1+((tan(t))^2)))*sgn(x)
end
function sin2w(s,x)--三角函数转角
  return arcsin(s)+(1/2)*(1-sgn(x))*(math.pi-2*arcsin(s))
end
function cos2w(c,y)
  return arccos(c)*sgn(y)
end
function tan2w(t,y)
  return arctan(t)+(math.pi/2)*(1-sgn(y))
end
function is_integer(x)--判断整数
  if x==floor(x) then
    return true
   else return false
  end
end
function is_evennumber(x)--判断偶数
  if is_integer(x) and x%2==0 then
    return true
   else return false
  end
end
function is_oddnumber(x)--判断奇数
  if is_integer(x) and not(is_evennumber(x)) then
    return true
   else return false
  end
end
function 逻辑加(a,b)
  return sgn(a+b)
end
function 逻辑乘(a,b)
  return sgn(a*b)
end
function 逻辑反(a)
  return sgn(a*(-1))
end
function 大于(x,a)
  return key(x-a)
end
--print(大于(0,1))
--print(大于(1,1))
--print(大于(2,1))
function 等于(x,a)
  return root(x-a)
end
--print(等于(2,2))
function 小于(x,a)--同时满足不大于也不等于
  return 逻辑乘(逻辑反(大于(x,a)),逻辑反(等于(x,a)))
end
function 大于等于(x,a)--满足大于或等于
  return 逻辑加(大于(x,a),等于(x,a))
end
--print(大于等于(1,2))
function 小于等于(x,a)--不满足大于
  return 逻辑反(大于(x,a))
end
function 不等于(x,a)
  return 逻辑反(等于(x,a))
end
function 数字位数(x)
  return floor(lg(x))+1
end
function 整数部分(x)
  return floor(x)
end
function 小数部分(x)
  return x-整数部分(x)
end
--print(小数部分(pi))
function 取位数字(x,s)
  local a=floor(x*(1/s))
  return a-(floor(0.1*a))*10
end
--print(取位数字(pi,0.001))
function 保留小数(x,s,i)
  --  print(取位数字(x,0.1*s))

  return floor(x*(1/s))*s+大于等于(取位数字(x,s*0.1),5)*s*i
end
--print(保留小数(3.1415926,0.0001,1))


function list(data)
  local to=data
  to["ty"]="list"
  return to
end

--print(dump(list({1})))

function factorial(x)--阶乘
  local w=1
  for n=1,x do
    w=w*n
  end
  return w
end
--print(factorial(10))
function sort(data)--排序
  local uu=1
  for m=1,#data-1 do
    for n=m+1,#data do
      if data[m]>data[n] then
        local center=data[m]
        data[m]=data[n]
        data[n]=center
      end
    end
  end
  return data
end
--print(dump(sort(a)))
function reverse(data)--倒序
  local to={}
  local m=1
  for n=#data,1,-1 do
    to[m]=data[n]
    m=m+1
  end
  return to
end
--print(dump(Reverse(sort(a))))
function exist(a,data)--存在
  local num=false
  for n=1,#data do
    if data[n]==a then
      num=n
    end
  end
  return num --返回false或者该元素在集合中排第几个
end
--print(exist(1,a))
function summation(data)--求和
  local w=0
  for n=1,#data do
    w=w+data[n]
  end
  return w
end
--print(summation(a))
function quadrature(data)--求积
  local w=1
  for n=1,#data do
    w=w*data[n]
  end
  return w
end
--print(quadrature(a))
function disruption(data)--打乱
  for n=1,#data do
    m=math.random(1,#data)
    n=math.random(1,#data)
    local center=data[m]
    data[m]=data[n]
    data[n]=center
  end
  return data
end
--print(dump(disruption(a)))
function average(data)--平均数
  return summation(data)/#data
end



--print(dump(average(a)))
function median(data)--中位数
  local data=sort(data)
  local len=#data
  if is_oddnumber(len) then --print(1+(floor(len/2)))
    return data[1+(floor(len/2))]
   else
    return average({data[len/2],data[1+(len/2)]})
  end
end
--print(median(a))
function variance(data)--方差
  local center=average(data)
  local each_={}
  local num=#data
  for n=1,num do
    each_[n]=((data[n]-center)^2)/num
  end
  return summation(each_)
end
function standard_deviation(data)--标准差
  return math.sqrt(variance(data))
end
function l_range(data)--极差
  local a=sort(data)
  return a[#a]-a[1]
end
function random_take(data)--任取
  return data[random(1,#data)]
end
function permutations(data)-------全排列表  存在问题
  local to={}
  local n=1
  while n~=factorial(#data) do
    m=disruption(data)
    if exist(m,to) then else
      to[n]=m
      n=n+1
    end
  end
  return to
end



function point(a,b,c)--定义点
  if a==nil then a=0 end
  if b==nil then b=0 end
  if c==nil then c=0 end
  return {x=a,y=b,z=c,ty='point'}
end
point_doc={
  info=[[函数:定义点
参数说明:三参数(可空),number,点的坐标
返回值:单参数,point,点]],
  demo=[[p1=point(1,2)]]
}


O=point(0,0,0)
O_doc={
  info=[[值:原点
数据:原点]],
  demo=[[O=O]]
}


function X(data)
  return data.x
end

function Y(data)
  return data.y
end

function Z(data)
  return data.z
end


function point_l(data)--点到原点的距离
  return math.sqrt(X(data)^2+Y(data)^2+Z(data)^2)
end


function angle(a,b)--广义角
  if not(a) then
    local a=0
  end
  if not(b) then
    local b=0
  end
  return {theta=a,phi=b,ty="angle"}
end

function angle_add(m,n)
  return angle(m["theta"]+n["theta"],m["phi"]+n["phi"])
end

function vector(a,b,c)
  if a~=nil and type(a)=="table" and not(b) and not(c) then
    --vector({ ang=<ang> , l=<l> })
    local ang=a["ang"]
    local theta=ang["theta"]
    local phi=ang["phi"]
    local l=a["l"]
    local x=cos(theta)*cos(phi)*l
    local y=sin(theta)*cos(phi)*l
    local z=sin(phi)*l
    local v=point(x,y,z)
    return {v=v,x=x,y=y,z=z,l=l,ty="vector"}
   elseif a~=nil and type(a)=="table" and b~=nil and type(b)=="table" and not(c) then
    --vector( <point> , <point> )
    local v=point(X(b)-X(a),Y(b)-Y(a),Z(b)-Z(a))
    local x=X(v)
    local y=Y(v)
    local z=Z(v)
    local l=point_l(v)
    return {v=v,x=x,y=y,z=z,l=l,ty="vector"}
   else
    --vector( <x> , <y> , <z> )
    if a==nil then
      a=0
    end
    if b==nil then
      b=0
    end
    if c==nil then
      c=0
    end
    local v=point(a,b,c)
    local x=X(v)
    local y=Y(v)
    local z=Z(v)
    local l=point_l(v)
    return {v=v,x=x,y=y,z=z,l=l,ty="vector"}
  end
end

i=vector(1,0,0)
j=vector(0,1,0)
k=vector(0,0,1)

--p=vector({ang=angle(pi/4,pi/2),l=1})
--print(to_seeable(p))



function v_to_point(a)--将向量转化成点
  return point(X(a),Y(a),Z(a))
end


function v_add(m,n)--向量相加(<vector>,<vector>)
  return vector(X(m)+X(n),Y(m)+Y(n),Z(m)+Z(n))
end
矢量和=v_add
合力=v_add

function v_sub(m,n)--向量相减(<vector>,<vector>)
  return vector(X(m)-X(n),Y(m)-Y(n),Z(m)-Z(n))
end

function v_n_mul(m,n)--向量数乘
  return vector(X(n)*m,Y(n)*m,Z(n)*m)
end


function v_d_pro(m,n)--向量数量积
  return X(m)*X(n)+Y(m)*Y(n)+Z(m)*Z(n)
end

function v_c_pro(m,n)--向量叉乘
  local x=Y(m)*Z(n)-Y(n)*Z(m)
  local y=Z(m)*X(n)-Z(n)*X(m)
  local y=X(m)*Y(n)-X(n)*Y(m)
  return vector(x,y,z)
end

function opposite_vector(m)--相反向量(<vector>)
  return v_n_mul(-1,m)
end
相互作用力=opposite_vector



function v_abs(m)--向量取模
  return m["l"]
end

function v_unit(m)--转为单位向量(<vector>)
  return v_n_mul((1/v_abs(m)),m)
end

function v_roll(m,n)--旋转向量(<vector>,<angle>(derta))
  return vector({L=m["L"],ang=angle_add(m["ang"],n)})
end

function project(m,n)--m向n上的投影向量
  return v_n_mul((v_d_pro(m,n)/v_abs(n)),v_unit(n))
end
--printf(project(vector(6,2),vector(6,6)))


function v_ang(m,n)--向量角
  if n==nil then
    local theta=tan2w(Y(m)/X(m),Y(m))
    local phi=tan2w(Z(m)/((X(m)^2+Y(m)^2)^0.5),Z(m))
    local ang=angle(theta,phi)
    return ang
   else
    return cos2w(v_n_mul(m,n),1)
  end
end

function midpoint(m,n)--中点
  if m~nil and n==nil then--线段中点
    return point( (X(m["F"])+X(m["T"]))/2 , (Y(m["F"])+Y(m["T"]))/2 )
   elseif m~=nil and n~=nil then
    return point( (X(m)+X(n))/2 , (Y(m)+Y(n))/2 )
  end
end

function distances(A,B)--点点间距
  return vector(A,B)["l"]
end

function 判定向量共线(m,n)--向量共线
  local Lambda=X(m)/X(n)
  if Y(m)-Lambda*Y(n)<=Env["d"] and Z(m)-Lambda*Z(n)<=Env["d"] then
    return true
   else
    return false
  end
end

function 判定向量垂直(m,n)--向量垂直
  if v_d_pro(m,n)<=Env["d"] then
    return true
   else
    return false
  end
end



--l:A+λv
function line(A,B)--直线(<point> ,<point>) & (<point> ,<vector>)
  if n_type(A)=="point" and n_type(B)=="point" then
    local v=v_unit(vector(A,B))--直线方向单位向量
    local A=A--直线起始点位置
    return {v=v,A=A,B=B,ty="line"}
   elseif n_type(A)=="point" and n_type(B)=="vector" then
    local v=v_unit(B)
    local A=A
    local B=point(X(A)+X(B),Y(A)+Y(B),Z(A)+Z(B))
    return {v=v,A=A,B=B,ty="line"}
  end
end






function 点在直线上的投影点(P,l)--点在直线上的投影点(<point> ,<line>)
  local P=P
  local A=l["A"]
  local v=l["v"]
  local AP=vector(A,P)
  local AB=project(AP,v)
  local OA=vector(O,A)
  local OB=v_add(OA,AB)
  local B=v_to_point(OB)
  return B
end
--[[
A=point(0,0,2)
B=point(2,3,0)
l=line(A,B)
C=point(2,0,0)
see(点在直线上的投影点(C,l))
--]]
function 点到直线的距离(P,l)
  local B=点在直线上的投影点(P,l)
  return distances(B,P)
end

function 直线的方向单位向量(l)
  return l["v"]
end

function 直线的A点(l)
  return l["A"]
end

function 直线的B点(l)
  return v_to_point(v_add(vector(O,直线的A点(l)),直线的方向单位向量(l)))
end


function 判定点在直线上(P,l)
  b1=false
  --
  local A=l["A"]
  local v=l["v"]
  local x0=X(A)
  local y0=Y(A)
  local z0=Z(A)
  local dx=X(v)
  local dy=Y(v)
  local dz=Z(v)
  local x=X(P)
  local y=Y(P)
  local z=Z(P)
  local Lambda_x=(x-x0)/dx
  local Lambda_y=(y-y0)/dy
  local Lambda_z=(z-z0)/dz
  local b1= (Lambda_x==Lambda_y and Lambda_y==Lambda_z)
  --]]
  if b1==true then
    return b1
   elseif b1==false then
    if 点到直线的距离(P,l)<=Env["d"] then
      return true
     else
      return false
    end
  end
end


--[[
A=point(1,2,3)
B=point(-1,1,2)
C=point(3,3,4)
l=line(A,B)
see(判定点在直线上(C,l))
--]]



function 平行直线(P,l)
  return line(P,直线的方向单位向量(l))
end

function 判定直线平行(l1,l2)
  b1=判定向量共线(直线的方向单位向量(l1),直线的方向单位向量(l2))
  b2=判定点在直线上(直线的A点(l1),l2)
  if b1 and not(b2) then
    return true
   else
    return false
  end
end


function solve_3_linear_equations( A, B, C )
  a11, a12, a13, b1 = A[1] , A[2] ,A[3] ,A[4]
  a21, a22, a23, b2 = B[1] , B[2] ,B[3] ,B[4]
  a31, a32, a33, b3 = C[1] , C[2] ,C[3] ,C[4]

  local detA = a11 * (a22 * a33 - a23 * a32) - a12 * (a21 * a33 - a23 * a31) + a13 * (a21 * a32 - a22 * a31)

  local detX = b1 * (a22 * a33 - a23 * a32) - b2 * (a21 * a33 - a23 * a31) + b3 * (a21 * a32 - a22 * a31)
  local detY = a11 * (b2 * a33 - b3 * a32) - a12 * (b1 * a33 - b3 * a31) + a13 * (b1 * a32 - b2 * a31)
  local detZ = a11 * (a22 * b3 - a23 * b2) - a12 * (a21 * b3 - a23 * b1) + a13 * (a21 * b2 - a22 * b1)

  local x = detX / detA
  local y = detY / detA
  local z = detZ / detA

  return {x, y, z}
end
--print(solve_3_linear_equations({1, 1, 0, 1}, {1, 0, 1, 1}, {0, 1, 1, 1}))

function solve_1_square_equations(a,b,c)
  local derta=b^2-4*a*c
  return {(-b+sqrt(derta))/(2*a) , (-b-sqrt(derta))/(2*a)}
end

function circle(a,b) --circle(<point> , r) & circle(<point> , <point>)
  if a~=nil and b~=nil then
    if type(a)=="table" and type(b)=="table" then
      local r=distances(a,b)
      local center=a
      local p=X(center)
      local q=Y(center)
      local a=1
      local b=0
      local c=1
      local d=-2*p
      local e=-2*q
      local f=p^2+q^2-r^2
      return {center=center,r=r,p=p,q=q,
        a=a,b=b,c=c,
        d=d,e=e,f=f,ty="circle"}
     elseif type(a)=="table" and type(b)=="number" then
      local r=b
      local center=a
      local p=X(center)
      local q=Y(center)
      local a=1
      local b=0
      local c=1
      local d=-2*p
      local e=-2*q
      local f=p^2+q^2-r^2
      return {center=center,r=r,p=p,q=q,
        a=a,b=b,c=c,
        d=d,e=e,f=f,ty="circle"}
    end
  end
end




function get_public_point_line_circle(a,b)
  if n_type(a)=="line" and n_type(b)=="circle" then
    local x0=X(a["A"])
    local y0=Y(a["A"])
    local dx=X(a["v"])
    local dy=Y(a["v"])
    local r=b["r"]
    local p=b["p"]
    local q=b["q"]
    local a=dx^2+dy^2
    local b=2*dx*(x0-p)+2*dy*(y0-q)
    local c=(x0-p)^2+(y0-q)^2-r^2
    local Lambda_=solve_1_square_equations(a,b,c)
    return {point(x0+Lambda_[1]*dx,y0+Lambda_[1]*dy),point(x0+Lambda_[2]*dx,y0+Lambda_[2]*dy)}
   elseif n_type(a)=="circle" and n_type(b)=="line" then
    local a,b=b,a
    local x0=X(a["A"])
    local y0=Y(a["A"])
    local dx=X(a["v"])
    local dy=Y(a["v"])
    local r=b["r"]
    local p=b["p"]
    local q=b["q"]
    local a=dx^2+dy^2
    local b=2*dx*(x0-p)+2*dy*(y0-q)
    local c=(x0-p)^2+(y0-q)^2-r^2
    local Lambda_=solve_1_square_equations(a,b,c)
    return {point(x0+Lambda_[1]*dx,y0+Lambda_[1]*dy),point(x0+Lambda_[2]*dx,y0+Lambda_[2]*dy)}
   else
    return "error"
  end
end


function plane(P1,P2,P3)
  local D=1
  local data1={X(P1),Y(P1),Z(P1),D}
  local data2={X(P2),Y(P2),Z(P2),D}
  local data3={X(P3),Y(P3),Z(P3),D}
  local ABC=solve_3_linear_equations(data1,data2,data3)
  local A=ABC[1]
  local B=ABC[2]
  local C=ABC[3]
  if A==0 and B==0 and C==0 then
    local D=0
    local data1={X(P1),Y(P1),Z(P1),D}
    local data2={X(P2),Y(P2),Z(P2),D}
    local data3={X(P3),Y(P3),Z(P3),D}
    local ABC=solve_3_linear_equations(data1,data2,data3)
    return {
      P1=P1, P2=P2, P3=P3,
      A=A, B=B, C=C, D=D, ty="plane"
    }
   else
    return {
      P1=P1, P2=P2, P3=P3,
      A=A, B=B, C=C, D=D, ty="plane"
    }
  end
end


function 线线夹角(l1,l2)
  return v_ang(直线的方向单位向量(l1),直线的方向单位向量(l2))
end

function 平行线间距(l1,l2)
  点到直线的距离(直线的A点(l1),l2)
end




function object(data)
  if data.x==nil then data.x=vector() end
  if data.a==nil then data.a=vector() end
  if data.v==nil then data.v=vector() end
  if data.m==nil then data.m=1 end
  data.ty="object"
  return data
end
质点=object
物体=object
object_doc={
  name="object & 质点 & 物体",
  info=[[函数:新建物体
参数说明:单参数,table,物体运动学参数
返回值:单参数,object,物体]],
  demo=[[ball=object({x=vector(1,2),a=vector(-1,5),m=2})]],
  var=object
}



function gravity(data)
  local f_G=v_n_mul(data.m,vector(0,Env.g))
  return f_G
end
重力=gravity
gravity_doc={
  name="gravity & 重力",
  info=[[函数:计算物体重力
参数说明:单参数,object,物体
返回值:单参数,vector,物体重力向量]],
  demo=[[f_G=gravity(ball)]],
  var=gravity
}

function stick(data)
  if data.l==nil then data.l=1 end
  if data.k==nil then data.k=1000 end
  data.ty="stick"
  return data
end
杆=stick
stick_doc={
  name="stick & 杆",
  info=[[函数:新建杆
参数说明:单参数,table,杆的物理参数
返回值:单参数,stick,杆]],
  demo=[[st1=stick({l=1,k=1000})]],
  var=stick
}

function gravitation(data)
  if data.G==nil then data.G=Env.G end
  data.ty="gravitation"
  return data
end
万有引力=gravitation
gravitation_doc={
  name="gravitation & 万有引力",
  info=[[函数:新建万有引力
参数说明:单参数,table,万有引力的物理参数
返回值:单参数,gravitation,万有引力]],
  demo=[[gra1=gravitation({G=Env.G})]],
  var=gravitation
}



function rope()
  if data.l==nil then data.l=1 end
  if data.k==nil then data.k=1000 end
  data.ty="rope"
  return data
end
绳=rope
spring_doc={
  name="rope & 绳",
  info=[[函数:新建绳(绳仅对正方向的形变产生作用力)
参数说明:单参数,table,绳的物理参数
返回值:单参数,rope,绳]],
  demo=[[ro1=rope({l=1,k=1000})]],
  var=rope
}



function spring()
  if data.l==nil then data.l=1 end
  if data.k==nil then data.k=1000 end
  data.ty="spring"
  return data
end
弹簧=spring
spring_doc={
  name="spring & 弹簧",
  info=[[函数:新建弹簧(弹簧仅对负方向的形变产生作用力，相当于未粘连物体)
参数说明:单参数,table,弹簧的物理参数
返回值:单参数,spring,弹簧]],
  demo=[[sp1=spring({l=1,k=1000})]],
  var=spring
}


function force(object_a, medium, object_b)
  switch medium.ty
   case "gravitation"--万有引力
    local v=v_sub(object_a.x, object_b.x)
    local f=medium.G * object_a.m * object_b.m * (1/ v_abs(v))
    local F=v_n_mul(f,v_unit(v))
    return F
   case "stick"--杆
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k
    local F=v_n_mul(f,v_unit(v))
    return F
   case "rope"--绳
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k*key(v_abs(v)-medium.l)
    local F=v_n_mul(f,v_unit(v))
    return F
   case "spring"--弹簧
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k*key(medium.l-v_abs(v))
    local F=v_n_mul(f,v_unit(v))
    return F
  end
end
作用力=force
force_doc={
  name="force & 作用力",
  info=[[函数:根据不同的物体及它们的作用介质计算它们的作用力
参数说明:三参数,(object ,作用介质, object),目标物体和作用介质
返回值:单参数,vector,后一物体所受到的力]],
  demo=[[force(定点,杆,球)]],
  var=force
}




function force_on(object_, force_)
  object_.a=v_n_mul(1/object_.m,force_)
  object_.v=v_add(object_.v,v_n_mul(Env.dt,object_.a))
  object_.x=v_add(object_.x,v_n_mul(Env.dt,object_.v))
end
作用于=force_on
force_on_doc={
  name="force_on & 作用于",
  info=[[函数:将力作用于物体上,使之产生加速度速度和位移
参数说明:双参数,(object ,force),目标物体和力
返回值:无返回值]],
  demo=[[force_on(ball,F)]],
  var=force_on
}

function frictional(object_, mu)
  return v_n_mul(-mu, object_.v)
end

init()
