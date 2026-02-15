require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Canvas = luajava.bindClass "android.graphics.Canvas"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"

-- import "nature"


--import "nature"

function init()





  h=activity.getHeight()
  w=activity.getWidth()
  lo=math.sqrt(h^2+w^2)

  black_P = Paint().setColor(0xbb424242).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(4)
  grey_P = Paint().setColor(0x50424242).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(4)
  green_P = Paint().setColor(0xff4CAF50).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.STROKE).setStrokeWidth(5)
  blue_P = Paint().setColor(0xff1E88E5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.STROKE).setStrokeWidth(8)
  textUIPT = Paint().setColor(0xFF111111).setAntiAlias(true).setTextAlign(Paint.Align.LEFT).setTextSize(50).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)

  e=1

  local ox=w/2
  local oy=h/2
  ox_new=ox
  oy_new=oy
  Lambda=1

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
    { TextView,--文本控件
      --layout_gravity='center',
      textSize='25dp',--文字大小
      id="tips",
      text="",
      style="blod",
    },
  }
  activity.setContentView(loadlayout(duo))




  A=object({
    x=vector(0, 0),
    v=vector(0, 0)
  })
  B=object({
    x=vector(0,3),
    v=vector(1, 0)
  })--建造AB物体

  s=stick({l=3,k=10000})--AB之间的杆

  Env.dt = 0.001 --环境时间微分
  Env.g = -9.8 --环境重力加速度

  function main()

    F_AB=force(A,s,B)--A给B的作用力

    force_on(A,vector(v_scale(-1,F_AB).x,0))
    object.update(A)--作用于A, 并更新路径

    force_on(B,v_add(F_AB,medium.gravity(B)))
    object.update(B)--作用于B, 并更新路径

  end

  function ondraw(canvas, paint, panel)
    dot(A.x.x,A.x.y)--画图
    dot(B.x.x,B.x.y)
    line_(A.x.x,A.x.y,B.x.x,B.x.y)
  end





  timer_=Ticker()
  timer_.Period=Env.dt*1000
  timer_.onTick=function()--执行事件
    Env.t = Env.t + Env.dt
    v_Lambda=(e-Lambda)*15
    Lambda=Lambda+v_Lambda*Env.dt
    main()
    tips.setText(
    "dt="..Env.dt.."\n"..
    "t="..floor(Env.t*1000)*0.001
    )

  end
  timer_.start()
  function onDestroy()--退出时执行
    timer_.stop()
    --printf(a)
  end


  local DrewPanel = LuaDrawable(
  function(canvas, paint, panel)
    function dot(x,y,p)
      if p==nil then p=blue_P end
      return canvas.drawCircle(100*x*Lambda+ox, -100*y*Lambda+oy, 6, p)
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
    --canvas.drawLine(0+ox,-oy+oy,0+ox,(h-oy)+oy, black_P)
    dot(0,0,blue_P)
    panel.invalidateSelf()
  end)

  back.setBackground(DrewPanel)


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



end


--[[**
 * @Name: nature.lua
 * @Date: 2023-06-03 12:16:18
 * @Description: No special instructions
 *
**]]
-- which is use to import Java class and lua module
require "math"



info={
  author="Duo",
  version=5.02,
  date="2023.6.3",
  info=[[分享_自用数学库，将嵌入Duo Nature,可能存在错误，欢迎大家指出。将持续更新(因为学业原因，更新周期较长为一个月左右)。包括函数，统计，解析几何等，自习课写的程序长达50页,之后将加入线段，向量，三角形，圆锥曲线等几何类型(本来在纸上写好了，每次回来时间不太够，慢慢码吧)。提供互相作用，例如，求公共点，求垂直，平分线，平行线，角分线，等等等等()在Duo Nature环境下，可以直观展示各个几何类型及相互作用]],
  history={
    v1={"2023.3.05","基本初等函数，常数，统计，逻辑与判断"},
    v2={"2023.4.03","点，直线，更普遍的加减乘除"},
    v3={"2023.5.1","点，向量，直线，全部替换为二维和三维通用，新增平面，操作控制台输出，向量运算，空间直线的位置关系初步"},
    v4={"2023.5.25","新增物理环境"},
    v5={"2023.6","重写"}
  },
}


--常用常量
e=math.exp(1)
pi=math.pi
huge=math.huge
inf=huge
phi=(math.sqrt(5)-1)/2
x="x"
i="稍后定义"

--环境
Env={
  e=math.exp(1),
  pi=math.pi,
  huge=math.huge,
  inf=math.huge,
  phi=(math.sqrt(5)-1)/2,
  t=0,
  dt=0.01,
  dx=0.001,
  d=10^(-7),
  g=-10,
}

--好东西
debug.setmetatable(521,{__index=math})


--#####################################################
--常用函数

--指,对数
function log(a,b) return math.log10(b)/math.log10(a) end--对数
function lg(a) return math.log10(a) end--常用对数
function ln(a) return math.log(a) end--自然对数
function exp(a) return math.exp(a) end--自然指数函数
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
function mod(a,b) return a%b end
function atan2(a,b) return math.atan2(a,b) end--坐标转换
function random(a,b) return math.random(a,b) end--随机
function sqrt(a) return math.sqrt(a) end

function sinc(x)--信号分析
  if x==0 then return 1
   else
    return sin(x)/x
  end
end

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

function key0(x)--自然单位阶跃函数
  return (sgn(x)+1)/2
end

function key1(x)--经典单位阶跃函数
  if x>=0 then
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
function duo_nature(x)
  return (sin(e^(2)*x))/(e^(2)*x)
end
function factorial(x)--阶乘
  local w=1
  for n=1,x do
    w=w*n
  end
  return w
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
--###########################################################


function is() end--编辑器高亮
is={
  __index={
    oddnumber=function(x)--判断奇数
      if is.integer(x) and not(is.evennumber(x)) then
        return true
       else return false
      end
    end,
    integer=function(x)--判断整数
      if x==floor(x) then
        return true
       else return false
      end
    end,
    evennumber=function(x)--判断偶数
      if is.integer(x) and x%2==0 then
        return true
       else return false
      end
    end,
    zero=function(data)--判断一个: 整数等于零 or 浮点数接近零
      return abs(data)<=Env.d
    end,
    equality=function(a,b)--判断一个: 整数相等 or 浮点数接近
      return is.zero(a-b)
    end,
    vector=function(data)--判断是否为向量
      return vector.is.this(data)
    end,
    angle=function(data)--判断是否为向量
      return angle.is.this(data)
    end,
    point=function(data)--判断是否为向量
      return point.is.this(data)
    end,
    number=function(data)--判断是否为数字
      return type(data)=='number'
    end,
    table=function(data)--判断是否为数组
      return type(data)=='table'
    end,
    compute=nil,--判断是否为cas计算函数
    sym=nil,--判断是否为代数
    operator=nil,
    constant=nil,
    cas=nil,
  }
}
setmetatable(is, is)

function get() end
get={
  __index={
    type=function(data)--获取类型
      local metatable= getmetatable(data)
      if metatable==nil then
        return type(data)
       else
        switch metatable
         case point return 'point'
         case vector return 'vector'
         case complex return 'complex'


        end
      end
    end,
  }
}
setmetatable(get, get)
--print(get.type(1))

function X(data) return data.x end

function Y(data) return data.y end

function Z(data) return data.z end

function point() end
point={
  __call=function(_,x,y,z)
    return point.new(x,y,z)
  end,
  __index={
    new=function(x, y, z)--新建点
      return setmetatable({ x = x or 0, y = y or 0, z = z or 0 }, point)
    end,
    is={
      this=function(data)
        return getmetatable(data) == point
      end,
      zero=function(data)
        return data.x==0 and data.y==0 and data.z==0
      end
    },
    len=function(data)--计算点到原点距离
      local x=data.x
      local y=data.y
      local z=data.z
      return math.sqrt(x^2+y^2+z^2)
    end,
  }
}
setmetatable(point, point)

function angle() end
angle={
  __call=function(_,x,y)
    return angle.new(x,y)
  end,
  __index={
    new=function(a,b)
      return setmetatable({theta=a,phi=b},angle)
    end,
    is={
      this=function(data)
        return getmetatable(data) == angle
      end,
    },


  }
}
setmetatable(angle,angle)



function vector() end
vector={
  __call=function(_,x,y,z)
    return vector.new(x,y,z)
  end,
  __add=function(m,n)
    return vector.add(m,n)
  end,
  __sub=function(m,n)
    return vector.sub(m,n)
  end,
  __mul=function(m,n)
    if is.vector(m) and is.vector(n) then
      return vector.dot(m,n)
     elseif (is.number(m) and is.vector(n)) then
      return vector.scale(m,n)
     elseif (is.number(n) and is.vector(m)) then
      return vector.scale(n,m)
    end
  end,
  __div=function(m,n)
    return vector.div(m,n)
  end,
  __len=function(m)
    return vector.len(m)
  end,
  __unm = function(m)
    return vector.scale(-1,m)
  end,
  __index={
    new=function(a,b,c)
      if is.angle(a) and is.number(b) and c==nil then
        --vector(<angle> ,<l>)
        local theta=a.theta or 0
        local phi=a.phi or 0
        local l=b or 1
        local x=cos(theta)*cos(phi)*l
        local y=sin(theta)*cos(phi)*l
        local z=sin(phi)*l
        local v=point(x,y,z)
        return setmetatable({x=x,y=y,z=z },vector)
       elseif is.point(a) and is.point(b) and b~=nil then
        --vector( <point> , <point> )
        local v=point(X(b)-X(a),Y(b)-Y(a),Z(b)-Z(a))
        local x=X(v)
        local y=Y(v)
        local z=Z(v)
        return setmetatable({x=x,y=y,z=z },vector)
       else --is.number(a) and is.number(b) and is.number(c) then
        --vector( <x> , <y> , <z> )
        local x=a or 0.0
        local y=b or 0.0
        local z=c or 0.0
        return setmetatable({x=x,y=y,z=z },vector)
      end
    end,
    is={
      this=function(data)
        return getmetatable(data) == vector
      end,
      zero=function(data)
        return data.x==0 and data.y==0 and data.z==0
      end,
      vi=function(data)
        return data.x==1 and data.y==0 and data.z==0
      end,
      vj=function(data)
        return data.x==0 and data.y==1 and data.z==0
      end,
      vk=function(data)
        return data.x==0 and data.y==0 and data.z==1
      end,
      parallel=function(a,b)
        return vector.is.zero(vector.cross(a,b))
      end,
      vertical=function(a,b)
        return is.zero(vector.dot(a,b))
      end,

    },
    to={
      point=function(data)
        return point(data.x, data.y ,data.z)
      end,
      complex=function(data)
        return complex(data.x, data.y)
      end,
    },
    add=function(m,n)
      return vector(m.x+n.x, m.y+n.y, m.z+n.z)
    end,
    sub=function(m,n)
      return vector(m.x-n.x, m.y-n.y, m.z-n.z)
    end,
    div=function(m,n)
      return vector(m.x/n.x, m.y/n.y, m.z/n.z)
    end,
    dot=function(m,n)--点积
      return m.x*n.x + m.y*n.y + m.z*n.z
    end,
    mul=function(m,n)
      return vector(m.x*n.x, m.y*n.y, m.z*n.z)
    end,
    scale=function(m,n)
      return vector(m*n.x,m*n.y,m*n.z)
    end,
    len=function(m)
      return math.sqrt(m.x^2 + m.y^2 +m.z^2)
    end,
    angle=function(m,n)
      return math.acos(vector.dot(m,n)/(vector.len(m)*vector.len(n)))
    end,
    clone=function(m)
      return vector(m.x, m.y, m.z)
    end,
    unit=function(m)
      return vector.scale(1/vector.len(m), m)
    end,
    project=function(m,n)
      return vector.len(m)*(vector.dot(m,n)/(vector.len(m)*vector.len(n)))*vector.unit(n)
    end,
    cross = function(v, u)--叉积
      local out = vector()
      local a, b, c = v.x, v.y, v.z
      out.x = b * u.z - c * u.y
      out.y = c * u.x - a * u.z
      out.z = a * u.y - b * u.x
      return out
    end,
  }
}
setmetatable(vector, vector)

--快捷访问
v_project=vector.project
v_cross=vector.cross
v_unit=vector.unit
v_sub=vector.sub
v_add=vector.add
v_dot=vector.dot
v_len=vector.len
v_abs=vector.len
v_scale=vector.scale
--中文支持
转为单位向量=vector.unit
向量加=vector.add
向量减=vector.sub
向量数乘=vector.scale
向量数量积=vector.dot
向量模=vector.len




--########################################################
--复数
function complex() end
complex={
  __call=function(_,x,y) return complex.new(x,y) end,
  __add=function(m,n) return complex.add(m,n) end,
  __sub=function(m,n) return complex.sub(m,n) end,
  __mul=function(m,n) return complex.mul(m,n) end,
  __div=function(m,n) return complex.div(m,n) end,
  __len=function(m,n) return complex.len(m,n) end,
  __unm = function(m) return complex.mul(m,-1) end,
  __index = {
    new=function(x,y)
      return setmetatable({x=x or 0,y=y or 0 },complex)
    end,
    is={
      this=function(_,data)
        return getmetatable(data) == complex
      end,
      zero=function(data)
        return data.x==0 and data.y==0
      end
    },
    add=function(m,n)
      if not(complex.is.this(m)) and type(m)=="number" then
        m=complex(m)
      end
      if not(complex.is.this(n)) and type(n)=="number" then
        n=complex(n)
      end
      return complex.new(m.x+n.x,m.y+n.y)
    end,
    sub=function(m,n)
      if not(complex.is.this(m)) and type(m)=="number" then
        m=complex(m)
      end
      if not(complex.is.this(n)) and type(n)=="number" then
        n=complex(n)
      end
      return complex.new(m.x-n.x,m.y-n.y)
    end,
    mul=function(m,n)
      if not(complex.is.this(m)) and type(m)=="number" then
        m=complex(m)
      end
      if not(complex.is.this(n)) and type(n)=="number" then
        n=complex(n)
      end
      return complex.new(m.x*n.x - m.y*n.y , m.x*n.y + m.y*n.x)
    end,

    div=function(m,n)
      local a,b=m.x,m.y
      local c,d=n.x,n.y
      return complex.new( (a*c+b*d)/(c^2+d^2), (b*c-a*d)/(c^2+d^2) )
    end,
    len=function(m)
      return math.sqrt(m.x^2+m.y^2)
    end,
    real=function(m)
      return m.x
    end,
    imagine=function(m)
      return m.y
    end,
    complex_unit=function()
      return complex(0,1)
    end,
  }
}
setmetatable(complex, complex)
i=complex.complex_unit()
--#######################################################





--###############################################################
--计算机代数系统

--计算符常量
Add_="Add_"
Sub_="Sub_"
Mul_="Mul_"
Div_="Div_"
Sec_="Sec_"
Log_="Log_"
Sin_="Sin_"
Cos_="Cos_"
Tan_="Tan_"
Operator={
  Add_,Sub_,Mul_,Div_,
  Sec_,Log_,
  Sin_,Cos_,Tan_
}
is.operator=function(data)--判断是否为cas计算符常量
  local zz=false
  for n=1,#Operator do
    if Operator[n]==data then
      zz=true
    end
  end
  return zz
end

is.cas=function(data)
  if is.table(data) then
    return is.operator(data[1])
   else return false
  end
end


--符号常量
E="e_"
Inf="Inf_"
Pi="Pi_"
I="I_"
Nan="Nan_"

Constant={
  E,Inf,I,Nan
}
is.constant=function(data)--判断是否为cas符号常量
  local zz=false
  for n=1,#Constant do
    if Constant[n]==data then
      zz=true
    end
  end
  return zz
end

--计算函数
function sym(data)
  return cas(data)
end
function Add(m,n) return cas({Add_,cas(m),cas(n)}) end
function Sub(m,n) return cas({Sub_,cas(m),cas(n)}) end
function Mul(m,n) return cas({Mul_,cas(m),cas(n)}) end
function Div(m,n) return cas({Div_,cas(m),cas(n)}) end
function Sec(m,n) return cas({Sec_,cas(m),cas(n)}) end
function Log(m,n) return cas({Log_,cas(m),cas(n)}) end
function Ln(m) return Log(E,m) end
function Lg(m) return Log(10,m) end
function Sqrt(m) return Sec(m,0.5) end
function Sin(m) return cas({Sin_,cas(m),1}) end
function Cos(m) return cas({Cos_,cas(m),1}) end
function Tan(m) return cas({Tan_,cas(m),1}) end

is.sym=function(data)--判断是否为代数
  if type(data)=="string"
    if is.constant(data)--符号常量
      return false
     else return true
    end
  end
end

Compute={--cas计算函数组
  Add, Sub,Mul,Div,
  Sec, Log,Ln ,Lg,
  Sqrt,Sin,Cos,Tan
}
is.compute=function(data)--判断是否为cas计算函数
  local zz=false
  for n=1,#Compute do
    if Compute[n]==data then
      zz=true
    end
  end
  return zz
end



cas={
  __call=function(_, data)
    if is.number(data) then
      return data
     elseif is.sym(data) then
      return data
     elseif is.cas(data) then

      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b

      if is.number(m) and is.number(n) then--  N,N
        return cas.N_N(data)--  数字, 数字

       elseif is.cas(m) and is.cas(n) then--  C,C
        return cas.C_C(data)--  结构式, 结构式

       elseif is.sym(m) and is.sym(n) then--  S,S
        return cas.S_S(data)--  代数, 代数

       elseif is.number(m) and is.sym(n) then--  N,S
        return cas.N_S(data)--  数字, 代数

       elseif is.sym(m) and is.number(n) then--  S,N
        return cas.S_N(data)--  代数, 数字

       elseif is.cas(m) and is.number(n) then--  C,N
        return cas.C_N(data)--  结构式, 数字

       elseif is.number(m) and is.cas(n) then--  N,C
        return cas.N_C(data)--  数字, 结构式

       elseif is.constant(m) and is.constant(n) then-- E,E


       elseif is.constant(m) and is.number(n) then-- E,N


       elseif is.number(m) and is.constant(n) then-- N,E





      end
    end
  end,

  __index={


    N_N=function(data)
      --  数字  与  数字
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b
      switch c
       case Add_ return m+n
       case Sub_ return m-n
       case Mul_ return m*n
       case Div_
        if is.integer((m/n)*1000) then return m/n
         else return {Div_,m,n}
        end
       case Log_
        if is.integer(log(m,n)*1000) then return log(m,n)
         else return {Log_,m,n}
        end
       case Sec_
        if is.integer((m^n)*1000) then return m^n
         else return {Sec_,m,n}
        end
       case Sin_
        if is.integer((sin(m))*1000) then return sin(m)
         else return {Sin_,m,1}
        end
       case Cos_
        if is.integer((cos(m))*1000) then return cos(m)
         else return {Cos_,m,1}
        end
       case Tan_
        if is.integer((tan(m))*1000) then return tan(m)
         else return {Tan_,m,1}
        end
      end
    end,



    N_S=function(data)
      --  数字  与  代数
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b
      switch c
       case Add_
        if m==0 then
          return n
         else
          return data
        end
       case Sub_ return data--这个没招
       case Mul_
        if m==0 then return 0
         else return data
        end
       case Div_
        if m==0 then
          return 0--零除以任何数都得零
         else return data
        end
       case Log_
        if m==1 then
          return Nan
         else return data
        end
       case Sec_
        if m==1 then
          return 1
         elseif m == 0 then
          if n > 0 then
            return 0
           elseif n==0 then
            return Nan
           else
            return Inf
          end
        end
       case Sin_ return data
       case Cos_ return data
       case Tan_ return data
      end
    end,



    S_N=function(data)
      --  代数  与  数字
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b
      switch c
       case Add_--  +
        if n==0 then
          return m
         else return data
        end
       case Sub_--  -
        if n==0 then
          return m
         else return data
        end
       case Mul_--  *
        if n==0 then
          return 0
         else return data
        end
       case Div_
        if n==1 then
          return m
         elseif n==0 then
          return Inf
         else
          return data
        end
       case Log_
        if n>=0 then
          if n==0 then
            return Inf
           elseif n==1 then
            return 0
           else
            return data
          end
         else
          return Nan
        end
       case Sec_
        if n==1 then return m
         else return data
        end
       case Sin_ return data
       case Cos_ return data
       case Tan_ return data
      end
    end,



    C_N=function(data)
      --  结构式  与  数字
      --{c,{m[1],?,?}==m,n}==data
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b

      local A=m[2]
      local B=m[3]
      local C=n
      --{c,{m[1],A,B},C}
      switch c
       case Add_
        switch m[1]
         case Add_
          if type(B)=="number" then return Add(A, B+C)
           elseif type(A)=="number" then return Add(B, A+C)
           else return data
          end
         case Sub_ return data
         case Mul_ return data --不做处理
         case Div_ return data --不做处理
         case Sec_ return data --不做处理
         case Log_ return Log(A,Mul(B,Sec(A,C)))
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sub_
        switch m[1]
         case Add_ return data --不做处理
         case Sub_ return data --不做处理
         case Mul_ return data --不做处理
         case Div_ return data --不做处理
         case Sec_ return data --不做处理
         case Log_ return Log(A,Div(B,Sec(A,C)))
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Mul_
        switch m[1]
         case Add_ return Add(Mul(A,C), Mul(B,C))--(A+B)*C  --乘法对加法分配律
         case Sub_ return Sub(Mul(A,C), Mul(B,C))
         case Mul_ return data
         case Div_ return data
         case Sec_ return data--Sec(A, Add(Log(A,C), B) )
         case Log_ return Sec(A, Sub(Log(A,C), B) )
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Div_
        switch m[1]
         case Add_ return Add(Div(A,C), Div(B,C))--(A+B)/C
         case Sub_ return Sub(Div(A,C), Div(B,C))--(A-B)/C
         case Mul_ return data --(A*B)/C
         case Div_ return data --(A/B)/C
         case Sec_ return Sec(A,Sub(B,Log(A,C)))--(A^B)/C
         case Log_ return Log(A,Sec(B,Div(1,C)))--log(A,B)/C
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sec_
        if n==1 then
          return m
         else
          switch m[1]
           case Add_ return data
           case Sub_ return data
           case Mul_ return data
           case Div_ return data
           case Sec_
            --print(A,B,C)
            return Sec(A,Mul(B,C))
           case Log_ return data --A^(log(B,C))
           case Sin_ return data
           case Cos_ return data
           case Tan_ return data
          end
        end
       case Log_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sin_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Cos_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Tan_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
      end
    end,



    N_C=function(data)
      --  数字  与  结构式
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b

      local A=m
      local B=n[2]
      local C=n[3]
      --{c,A,{n[1],B,C}}
      switch c --{c,m,{n[1],?,?}==n}==data
       case Add_
        switch n[1]
         case Add_ return data
         case Sub_ return data
         case Mul_ return data
         case Div_ return Div(Add(Mul(C,A),B),C)
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sub_
        switch n[1]
         case Add_ return data
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Mul_
        if A==0 then return 0 --零乘任何数都得零
         else
          switch n[1]
           case Add_ return cas(Add(Mul(A,B), Mul(A,C)))---------------------------
           case Sub_ return data
           case Mul_ return data
           case Div_ return cas(Div(Mul(A,B),C))
           case Sec_ return cas(Sec(B,Add(Log(B,A),C)))
           case Log_ return data
           case Sin_ return data
           case Cos_ return data
           case Tan_ return data
          end
        end
       case Div_
        switch n[1]
         case Add_ return data
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return cas(Sec(B,Sub(Log(B,A),C)))
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sec_
        switch n[1]
         case Add_ return data
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Log_
        switch n[1]
         case Add_ return data
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Sin_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Cos_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       case Tan_
        switch m[1]
         case Add_ return data--log(A+B,C)
         case Sub_ return data
         case Mul_ return data
         case Div_ return data
         case Sec_ return data
         case Log_ return data
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
      end
    end,



    C_C=function(data)
      --  结构式  与  结构式
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b

      local A=m[2]
      local B=m[3]
      local C=n[2]
      local D=n[3]
      --{c,{m[1],A,B},{n[1],C,D}}
      switch c
       case Add_
        switch m[1]
         case Div_
          switch n[1]
           case Div_ return Div(Add(Mul(A,D),Mul(B,C)),Mul(B,D))
          end

        end
       case Sub_ return data
       case Mul_ return data
       case Div_ return data
       case Sec_ return data
       case Log_ return data
       case Sin_ return data
       case Cos_ return data
       case Tan_ return data
      end
      return data
    end,



    S_S=function(data)
      --  代数  与  代数
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b
      --{c, m, n}
      switch c
       case Add_
        if m==n then
          return Mul(2,m)
         else return data
        end
       case Sub_
        if m==n then
          return 0
         else return data
        end
       case Mul_
        if m==n then
          return Sec(m,2)
         else return data
        end
       case Div_
        if m==n then
          return 1
         else return data
        end
       case Sec_ return data
       case Log_ return data
       case Sin_ return data
       case Cos_ return data
       case Tan_ return data
      end
      return data
    end,


    E_N=function(data)
      --  常数  与  数字
      local c=data[1]--计算符
      local m=cas(data[2])--计算项a
      local n=cas(data[3])--计算项b
      switch c
       case Add_--  +
        if n==0 then
          return m
         else return data
        end
       case Sub_--  -
        if n==0 then
          return m
         else return data
        end
       case Mul_--  *
        if n==0 then
          return 0
         else return data
        end
       case Div_
        if n==1 then
          return m
         elseif n==0 then
          return Inf
         else
          return data
        end
       case Log_
        if n>=0 then
          if n==0 then
            return Inf
           elseif n==1 then
            return 0
           else
            return data
          end
         else
          return Nan
        end
       case Sec_
        if n==1 then return m
         else return data
        end
       case Sin_ return data
       case Cos_ return data
       case Tan_ return data
      end
    end,


  },
  __add=Add,
  __sub=Sub,
  __mul=Mul,
  __div=Div,
  __pow=Sec,
}
setmetatable(cas, cas)


function Derivative(data)--导函数
  if type(data)=='number' then
    return 0
   elseif type(data)=='string' then
    return 1
   elseif type(data)=='table' and #data==1 then
    return Derivative(data[1])
   else
    local c=data[1]
    local m=cas(data[2])
    local n=cas(data[3])
    switch c
     case Add_ return Add(Derivative(m), Derivative(n))
     case Sub_ return Sub(Derivative(m), Derivative(n))
     case Mul_ return Add(Mul(Derivative(m),n), Mul(m,Derivative(n)))
     case Div_ return Div(Sub(Mul(Derivative(m),n), Mul(m,Derivative(n))),Sec(n,2))
     case Sec_ return Mul(Sec(m,Sub(n,1)), Add( Mul(n,Derivative(m)), Mul(Mul( Derivative(n), Ln(m)), m) ))--Mul(Sec(m,n-1),n)
     case Log_ return Div(Sub( Div(Mul(Ln(m),Derivative(n)),n),Div(Mul(Ln(n),Derivative(m)),m) ) , Sec(Ln(m),2) )
     case Sin_ return Cos(m)
     case Cos_ return Mul(-1,Sin(m))
    end
  end
end







--###############################################################
--数列
list={
  __call=function(_,data)
    return list.new(data)
  end,
  __index={
    new=function(data)
      local to=data
      to["ty"]="list"
      return to
    end,
    sort=function(data)--排序
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
    end,
    reverse=function(data)--倒序
      local to={}
      local m=1
      for n=#data,1,-1 do
        to[m]=data[n]
        m=m+1
      end
      return to
    end,
    exist= function (a,data)--存在
      local num=false
      for n=1,#data do
        if data[n]==a then
          num=n
        end
      end
      return num --返回false或者该元素在集合中排第几个
    end,
    summation=function (data)--求和
      local w=0
      for n=1,#data do
        w=w+data[n]
      end
      return w
    end,
    quadrature=function (data)--求积
      local w=1
      for n=1,#data do
        w=w*data[n]
      end
      return w
    end,
    disruption= function (data)--打乱
      for n=1,#data do
        m=math.random(1,#data)
        n=math.random(1,#data)
        local center=data[m]
        data[m]=data[n]
        data[n]=center
      end
      return data
    end,
    average= function (data)--平均数
      return list.summation(data)/#data
    end,
    median= function (data)--中位数
      local data=list.sort(data)
      local len=#data
      if is.oddnumber(len) then --print(1+(floor(len/2)))
        return data[1+(floor(len/2))]
       else
        return list.average({data[len/2],data[1+(len/2)]})
      end
    end,
    variance= function (data)--方差
      local center=list.average(data)
      local each_={}
      local num=#data
      for n=1,num do
        each_[n]=((data[n]-center)^2)/num
      end
      return list.summation(each_)
    end,
    standard_deviation=function (data)--标准差
      return math.sqrt(list.variance(data))
    end,
    range=function (data)--极差
      local a=list.sort(data)
      return a[#a]-a[1]
    end,
    rantake=function (data)--任取
      return data[random(1,#data)]
    end,
  }
}
setmetatable(list, list)
--快捷访问
排序=list.sort
倒序=list.reverse
存在=list.exist
求和=list.summation
求积=list.quadrature
打乱=list.disruption
平均数=list.average
中位数=list.median
方差=list.variance
标准差=list.standard_deviationrange
任取=list.rantake
--a=list({1,2,3})
--print(list.variance(a))

--##################################################################




--##################################################
--物理环境

object={
  __call=function(_,data)--默认为新建物体
    return object.new(data)
  end,
  __index={
    new=function(data)--新建物体  <物体>
      if data.x==nil then data.x=vector() end
      if data.a==nil then data.a=vector() end
      if data.v==nil then data.v=vector() end
      if data.m==nil then data.m=1 end
      if data.q==nil then data.q=1 end
      return setmetatable(data, object)
    end,
    x=function(data)--获得物体位矢  <向量>
      return data.x or vector()
    end,
    v=function(data)--获得物体速度  <向量>
      return data.v or vector()
    end,
    a=function(data)--获得物体加速度  <向量>
      return data.a or vector()
    end,
    m=function(data)--获得物体质量   <数字>
      return data.m or 1
    end,
    q=function(data)--获得物体电荷量   <数字>
      return data.q or 1
    end,
    doc={
      name="object & 质点 & 物体",
      info=[[函数:新建物体 //参数说明:单参数,table,物体运动学参数({x=?,v=?,a=?,m=?,q=?}) //返回值:单参数,object,物体]],
      demo=[[ball=object({x=vector(1,2),a=vector(-1,5),m=2})]],
      var=object
    },
    update=function(object_)--更新计算
      object_.v=v_add(object_.v,v_scale(Env.dt,object_.a))
      object_.x=v_add(object_.x,v_scale(Env.dt,object_.v))
    end,
    momentum=function(object_)--获得动量  <向量>
      return v_scale(object_.m, object_.v)
    end,
    energy=function(object_)--获得动能   <数字>
      return (1/2)*object_.m*(v_abs(object_.v))^2
    end,




  }
}
setmetatable(object, object)
--快捷访问
质点=object
物体=object
位矢=object.x
速度=object.v
加速度=object.a
质量=object.m


function gravity_f(x_vector)--重力场函数
  -- 物体位矢  [映射函数]-->   物体加速度
  -- 物体位矢  [映射函数]-->   物体受力


  --return vector(0,Env.g)
end


field={--场
  __call=function(fun_)


  end,
  __index={
    new=function(fun_)
      return setmetatable({fun_}, field)
    end,


  },
}
setmetatable(field, field)



medium={
  __index={
    gravity=function(data)
      local f_G=v_scale(data.m,vector(0,Env.g))
      return f_G
    end,
    gravity_doc={
      name="gravity & 重力",
      info=[[函数:计算物体重力 //参数说明:单参数,object,物体 //返回值:单参数,vector,物体重力向量]],
      demo=[[f_G=gravity(ball)]],
      var=gravity
    },
    stick=function(data)
      if data.l==nil then data.l=1 end
      if data.k==nil then data.k=1000 end
      data.ty="stick"
      return data
    end,
    stick_doc={
      name="stick & 杆",
      info=[[函数:新建杆 //参数说明:单参数,table,杆的物理参数 //返回值:单参数,stick,杆]],
      demo=[[st1=stick({l=1,k=1000})]],
      var=stick
    },
    gravitation=function(data)
      if data.G==nil then data.G=Env.G end
      data.ty="gravitation"
      return data
    end,
    gravitation_doc={
      name="gravitation & 万有引力",
      info=[[函数:新建万有引力 //参数说明:单参数,table,万有引力的物理参数 //返回值:单参数,gravitation,万有引力]],
      demo=[[gra1=gravitation({G=Env.G})]],
      var=gravitation
    },
    rope=function()
      if data.l==nil then data.l=1 end
      if data.k==nil then data.k=1000 end
      data.ty="rope"
      return data
    end,
    rope_doc={
      name="rope & 绳",
      info=[[函数:新建绳(绳仅对正方向的形变产生作用力) //参数说明:单参数,table,绳的物理参数 //返回值:单参数,rope,绳]],
      demo=[[ro1=rope({l=1,k=1000})]],
      var=rope
    },
    spring=function()
      if data.l==nil then data.l=1 end
      if data.k==nil then data.k=1000 end
      data.ty="spring"
      return data
    end,
    spring_doc={
      name="spring & 弹簧",
      info=[[函数:新建弹簧(弹簧仅对负方向的形变产生作用力，相当于未粘连物体) //参数说明:单参数,table,弹簧的物理参数 //返回值:单参数,spring,弹簧]],
      demo=[[sp1=spring({l=1,k=1000})]],
      var=spring
    },
  }
}
setmetatable(medium, medium)
--快捷访问
重力=medium.gravity
杆=medium.stick
万有引力=medium.gravitation
绳=medium.rope
弹簧=medium.spring
--英文
gravity=medium.gravity
stick=medium.stick
gravitation=medium.gravitation
rope=medium.rope
spring=medium.spring



function force(object_a, medium, object_b)
  switch medium.ty
   case "gravitation"--万有引力
    local v=v_sub(object_a.x, object_b.x)
    local f=medium.G * object_a.m * object_b.m * (1/ v_abs(v))
    local F=v_scale(f,v_unit(v))
    return F
   case "stick"--杆
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k
    local F=v_scale(f,v_unit(v))
    return F
   case "rope"--绳
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k*key(v_abs(v)-medium.l)
    local F=v_scale(f,v_unit(v))
    return F
   case "spring"--弹簧
    local v=v_sub(object_a.x, object_b.x)
    local f=(v_abs(v)-medium.l)*medium.k*key(medium.l-v_abs(v))
    local F=v_scale(f,v_unit(v))
    return F
  end
end
作用力=force
相互作用力=function(F)
  return v_scale(-1,F)
end
合力=v_add

force_doc={
  name="force & 作用力",
  info=[[函数:根据不同的物体及它们的作用介质计算它们的作用力 //参数说明:三参数,(object ,作用介质, object),目标物体和作用介质 //返回值:单参数,vector,后一物体所受到的力]],
  demo=[[force(定点,杆,球)]],
  var=force
}




function force_on(object_, force_)
  object_.a=v_scale(1/object_.m,force_)
end
作用于=force_on
force_on_doc={
  name="force_on & 作用于",
  info=[[函数:将力作用于物体上,使之产生加速度 //参数说明:双参数,(object ,force),目标物体和力 //返回值:无返回值]],
  demo=[[force_on(ball,F)]],
  var=force_on
}
--##########################################################

local a="f(x)=x"
local b="duo=1"
local c="duo"

function sun() end

sun={}

sun.is_mathfun=function(str)
  local str=tostring(str)
  if str:find(")=")~=nil and str:find("==")==nil then
    return true
   else return false
  end
end

sun.get_varname0=function(str)--获取变量名(<文本表达式>)
  local varName = ""
  for i = 1, #str do
    if string.sub(str, i, i) == "=" then
      return varName
     else
      varName = varName .. string.sub(str, i, i)
    end
  end
end

sun.have_var=function(str)
  if sun.is_mathfun(str) then
    return true
   else
    if sun.get_varname0(str) then
      return true
     else return false
    end
  end
end

sun.no_var=function(str)
  return not(sun.have_var(str))
end

sun.tonormalfun=function(str)
  return "function "..tostring(str):gsub("=","\n  return ").."\nend"
end

sun.get_fun_name=function(str)--获取变量名(<文本表达式>)
  local varName = ""
  for i = 1, #str do
    if string.sub(str, i, i) == "(" then
      return (varName.."love"):match("function (.-)love")
     else
      varName = varName .. string.sub(str, i, i)
    end
  end
end

--print(sun.get_fun_name(sun.tonormalfun(a)))

sun.get_varname=function(str)
  if sun.have_var(str) then
    if sun.is_mathfun(str) then
      return sun.get_fun_name(sun.tonormalfun(a))
     else
      return sun.get_varname0(str)
    end
   else
    return ""
  end
end

sun.getvar=function(str)
  Result_= "!"
  if sun.have_var(str) then
    if sun.is_mathfun(str) then
      pcall(function() assert(loadstring("function "..tostring(s):gsub("=","\n  return ").."\nend"))() end)
      pcall(function() assert(loadstring(sun.tonormalfun(str)))() end)
      pcall(function()
        Result_= load("return "..tostring(sun.get_varname(str)),nil, nil,_ENV)()
      end)
      return Result_ or "!"
     else
      if tostring(s):find("y=")~=nil or tostring(s):find("x=")~=nil or tostring(s):find("ρ=")~=nil then
        local s=string.gsub(tostring(s),"y=","f(x)=")
        pcall(function() assert(loadstring("function "..tostring(s):gsub("=","\n  return ").."\nend"))() end)
        pcall(function() assert(loadstring(sun.tonormalfun(str)))() end)
        pcall(function()
          Result_= load("return "..tostring(sun.get_varname(str)),nil, nil,_ENV)()
        end)
        return Result_ or "!"
       else
        pcall(function() assert(loadstring(str))() end)
        pcall(function()
          Result_= load("return "..tostring(sun.get_varname(str)),nil, nil,_ENV)()
        end)
        return Result_ or "!"
      end
    end
   else
    pcall(function()
      Result_=load("return "..tostring(str),nil, nil,_ENV)() or nil
    end)
    return Result_ or "!"
  end
end
--print(sun.get_varname(a))
--print((sun.getvar(a)(2)))
--print(sun.getvar(b))
--print(sun.getvar(c))
--pcall(function() assert(loadstring("function f(x) return x end"))() end)
function see_list(data)
  to="list: ("
  for n=1,#data do
    if n~=#data then
      to=to..to_seeable(data[n])..","
     else
      to=to..to_seeable(data[n])..")"
    end
  end
  return to
end

function sun.toseeable(data)
  -- print(get.type(data))
  switch get.type(data)
   case "point"
    if data.x~=nil and data.y~=nil and data.z~=nil then
      local str="("..data.x..","..data.y..","..data.z..")"
      return str
     else
      return "$point"
    end
   case "angle"
    return "angle{θ="..theta..",Φ="..phi.."}"
   case "vector"
    if data.x~=nil and data.y~=nil and data.z~=nil then
      local str="("..data.x..","..data.y..","..data.z..")"
      return str
     else
      return "$vector"
    end
   case "complex" return data.x.."+"..data.y.."i"
   case "line"
    return "("..data["A"]["x"]..","..data["A"]["y"]..","..data["A"]["z"]..")+λ("..data["v"]["x"]..","..data["v"]["y"]..","..data["v"]["z"]..")"
   case "plane"
    return ""..data["A"].."*x+"..data["B"].."*y+"..data["C"].."*z+"..data["D"].."=0"
   case "list"
    return see_list(data)
   case "number"
    return ""..data-- tostring( 保留小数(data,保留小数位数,是否四舍五入))
   default return dump(data)
  end

end


function see_able(data)
  return sun.toseeable(data)
end

function printf(data)
  print(see_able(data))
end

nature={
  info=info,
  fun=fun,
  Env=Env,
  point=point,
  complex=complex,
  i=i,
  cas=cas,
  list=list,
  is=is,
  sun=sun,





}

init()




