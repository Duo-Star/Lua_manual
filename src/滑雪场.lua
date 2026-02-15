require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Canvas = luajava.bindClass "android.graphics.Canvas"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"


function init()
  black_P = Paint();
  black_P.setColor(0xbb424242)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.FILL)
  .setStrokeWidth(5)


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
  .setStrokeWidth(10)

  blue_P_=Paint();
  blue_P_.setColor(0xfa1E88E5)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(15)



  purple_P = Paint();
  purple_P.setColor(0xff7E57C2)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(5)

  purple_P_ = Paint();
  purple_P_.setColor(0xff7E57C2)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(10)



  textUIPT = Paint();
  textUIPT.setColor(0xFF111111)
  .setAntiAlias(true)
  .setTextAlign(Paint.Align.LEFT)
  .setTextSize(50)
  .setStrokeCap(Paint.Cap.ROUND)
  .setStyle(Paint.Style.FILL)
  .setStrokeWidth(3)



  Lambda_m=0.8

  duo=
  {
    LinearLayout,
    layout_width="fill",
    layout_height="fill",
    orientation='vertical';
    { FrameLayout,
      layout_width='fill',
      layout_height='fill',
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
            Lambda_m=Lambda_m*1.5
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
            Lambda_m=Lambda_m*0.5
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
  }
  activity.setContentView(loadlayout(duo))


  h=activity.getHeight()
  w=activity.getWidth()
  lo=math.sqrt(h^2+w^2)
  local ox=w/10
  local oy=h/2
  local sx=0
  local sy=0
  local ox_new=ox
  local oy_new=oy
  local Lambda=1
  local v_Lambda=0

  local track={vector()}
  track_l=30
  track_n=1
  local K=5000
  local Map=function(x)
    if x<3.14 then
      return cos(x)
     elseif x>3.14 and x<28
      return e^(-(x-20)^2)-1
     elseif x>28
      return 0.1*(x-18)-2

    end
  end
  local x0=0.1
  local A=object({})

  A.x.x=x0
  A.x.y=Map(x0)


  data={
    {A,blue_P_},
    {Map,purple_P},
  }

  function get_kv(f,x0)
    local k=derivative(f,x0)
    return vector(-k*sqrt(1/(1+(k)^2)), sqrt(1/(1+(k)^2)))
  end


  function main()
    local dx_=(Map(A.x.x)-A.x.y)
    local G=gravity(A)
    local F0=v_scale(key(dx_)*K*dx_, get_kv(Map,A.x.x))
    local F=force_add(G,F0)
    force_on(A,F)
    update(A)
  end



  dt=0.01
  t=0
  timer_1=Ticker()
  timer_1.Period=dt*1000
  timer_1.onTick=function()--执行事件
    v_Lambda=(Lambda_m-Lambda)*15
    Lambda=Lambda+v_Lambda*dt
    main()
  end
  timer_1.start()



  timer_2=Ticker()
  timer_2.Period=0.01*1000
  timer_2.onTick=function()--执行事件
    track[track_n]=A.x
    if track_n~=track_l then
      track_n=track_n+1
     else
      track_n=1
    end
    -- print(dump(track))
  end
  timer_2.start()
  function onDestroy()--退出时执行
    timer_2.stop()
    timer_1.stop()
  end



  function onTouchEvent(v)
    if v.action==1 then
      if (x_t-x_b)^2+(y_t-y_b)^2<=10 then
        local tx=(x_b-ox)/(Lambda*100)
        local ty=-(y_b-oy-80)/(Lambda*100)
        --print("点击:(".. tx..",".. ty..")")
        --data[#data+1]={point(tx,ty),purple_P}

      end
    end
    if v.action==0 then --落笔位置
      x_b=v.x
      y_b=v.y
      x_t=v.x
      y_t=v.y
      purple_P.setStrokeWidth(5)
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


  function draw(data,pen)
    switch get.type(data[1])
     case "function"
      local x0=(0-ox)/(Lambda*100)
      local x1=(w-ox)/(Lambda*100)
      local dx=0.05*(1/Lambda)
      local p0={x0,data[1](x0) or 0}
      local p1=p0
      for x=x0,x1,dx do
        y=data[1](x) or 0
        p1={x,y}
        line_(p0[1],p0[2],p1[1],p1[2],data[2])
        p0=p1
      end

     case "point"
      dot(data[1].x,data[1].y, data[2])
     case "vector"
      dot(data[1].x,data[1].y, data[2])
     case "object"
      dot(data[1].x.x,data[1].x.y, data[2])
     case "number"
      dot(data[1],0)
    end
  end

  local DrewPanel = LuaDrawable(
  function(canvas, paint, panel)
    h=canvas.getHeight()
    w=canvas.getWidth()
    lo=math.sqrt(h^2+w^2)
    function dot(x,y,p)
      if p==nil then
        p=blue_P
      end

      return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, 2, p)
    end

    function circle_(x,y,r,p)
      if p==nil then
        p=green_P
      end
      local x=x-sx

      return canvas.drawCircle(x*Lambda*100+ox, y*Lambda*100+oy, r*Lambda*100, green_P)
    end
    function line_(x0,y0,x1,y1,p)
      if p==nil then
        p=black_P
      end
      canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p)
    end



    for n=1,#data do
      draw(data[n])
    end



    for n=1,#track do
      dot(track[n].x,track[n].y,black_P)
    end


    dot(1,0,p)
    dot(0,1,p)
    canvas.drawLine(-ox+ox,0+oy,(w-ox)+ox,0+oy, black_P)
    canvas.drawLine(0+ox,-oy+oy,0+ox,(h-oy)+oy, black_P)
    dot(0,0,blue_P)
    panel.invalidateSelf()
  end)

  back.setBackground(DrewPanel)

end




--[[**
 * @Name: nature.lua
 * @Date: 2023-06-03 12:16:18
 * @Description: No special instructions
 *
**]]
-- which is use to import Java class and lua module
require "import"

info={
  author="Duo",
  version=5.01,
  date="2023.6.3",
  info=[[分享_自用数学库，将嵌入Duo Nature,可能存在错误，欢迎大家指出。将持续更新(因为学业原因，更新周期较长为一个月左右)。包括函数，统计，解析几何等，自习课写的程序长达50页,之后将加入线段，向量，三角形，圆锥曲线等几何类型(本来在纸上写好了，每次回来时间不太够，慢慢码吧)。提供互相作用，例如，求公共点，求垂直，平分线，平行线，角分线，等等等等()在Duo Nature环境下，可以直观展示各个几何类型及相互作用]],
  history={
    v1={"2023.3.05","基本初等函数，常数，统计，逻辑与判断"},
    v2={"2023.4.03","点，直线，更普遍的加减乘除"},
    v3={"2023.5.1","点，向量，直线，全部替换为二维和三维通用，新增平面，操作控制台输出，向量运算，空间直线的位置关系初步"},
    v4={"2023.5.25","新增物理环境"},
    v5={"2023.6","用class重写"}
  },
}

e=math.exp(1)
pi=math.pi
huge=math.huge
inf=huge
phi=(math.sqrt(5)-1)/2
x="x"


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


  }
}
setmetatable(is, is)


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
         case object return "object"

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

fun={}

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
        return
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
      return vector(m.x+n.x,m.y+n.y,m.z+n.z)
    end,
    sub=function(m,n)
      return vector(m.x-n.x,m.y-n.y,m.z-n.z)
    end,
    div=function(m,n)
      local out = vector()
      out.x =m.x+n.x
      out.y =m.y+n.y
      out.z =m.z+n.z
      return out
    end,
    dot=function(m,n)--点积
      return m.x*n.x + m.y*n.y + m.z*n.z
    end,
    inner=function(m,n)--内积
      return m.x*n.x + m.y*n.y + m.z*n.z
    end,
    mul=function(m,n)
      local out = vector()
      out.x =m.x*n.x
      out.y =m.y*n.y
      out.z =m.z*n.z
      return out
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

v_project=vector.project
v_cross=vector.cross
v_unit=vector.unit
v_sub=vector.sub
v_add=vector.add
v_dot=vector.dot
v_len=vector.len
v_abs=vector.len
v_scale=vector.scale




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



--###############################################################
--计算机代数系统
Add_="Add_"
Sub_="Sub_"
Mul_="Mul_"
Div_="Div_"
Sec_="Sec_"
Log_="Log_"
Sin_="Sin_"
Cos_="Cos_"
Tan_="Tan_"

function sym(data) return setmetatable({cas(data)}, cas) end
function Add(m,n) return cas({Add_,cas(m),cas(n)}) end
function Sub(m,n) return cas({Sub_,cas(m),cas(n)}) end
function Mul(m,n) return cas({Mul_,cas(m),cas(n)}) end
function Div(m,n) return cas({Div_,cas(m),cas(n)}) end
function Sec(m,n) return cas({Sec_,cas(m),cas(n)}) end
function Log(m,n) return cas({Log_,cas(m),cas(n)}) end
function Ln(m) return Log(e,m) end
function Lg(m) return Log(10,m) end
function Sqrt(m) return Sec(m,0.5) end
function Sin(m) return cas({Sin_,cas(m),1}) end
function Cos(m) return cas({Cos_,cas(m),1}) end
function Tan(m) return cas({Tan_,cas(m),1}) end

cas={
  __call=function(_, data)
    if type(data)=='number' then
      return data
     elseif type(data)=='string'then
      return data
     elseif type(data)=='table' and #data==1 then
      return data[1]
     else
      local c=data[1]
      local m=cas(data[2])
      local n=cas(data[3])
      if type(m)=="number" and type(n)=="number" then
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
       elseif type(m)=="number" and type(n)=="string" then
        switch c
         case Add_ return data
         case Sub_ return data
         case Mul_
          if m==0 then return 0
           else return data
          end
         case Div_ return data
         case Log_ return data
         case Sec_
          if m==1 then return n
           else return data
          end
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       elseif type(m)=="string" and type(n)=="number" then
        switch c
         case Add_ return data
         case Sub_ return data
         case Mul_
          if n==0 then return 0
           else return data
          end
         case Div_ return data
         case Log_ return data
         case Sec_
          if n==1 then return m
           else return data
          end
         case Sin_ return data
         case Cos_ return data
         case Tan_ return data
        end
       else
        --print(dump(m),dump(n),c)
        if type(m)=="table" and type(n)=="number" then--C,N
          --{c,{m[1],?,?}==m,n}==data
          local A=m[2]
          local B=m[3]
          local C=n
          --{c,{m[1],A,B},C}
          switch c
           case Add_
            switch m[1]
             case Add_ return data --不做处理
             case Sub_ return data --不做处理
             case Mul_ return data --不做处理
             case Div_ return data --不做处理
             case Sec_ return data --不做处理
             case Log_ return Log(A,Mul(B,Sec(A,C)))
            end
           case Sub_
            switch m[1]
             case Add_ return data --不做处理
             case Sub_ return data --不做处理
             case Mul_ return data --不做处理
             case Div_ return data --不做处理
             case Sec_ return data --不做处理
             case Log_ return Log(A,Div(B,Sec(A,C)))
            end
           case Mul_
            switch m[1]
             case Add_ return Add(Mul(A,C), Mul(B,C))--(A+B)*C  --乘法对加法分配律
             case Sub_ return Sub(Mul(A,C), Mul(B,C))
             case Mul_ return data
             case Div_ return data
             case Sec_ return data--Sec(A, Add(Log(A,C), B) )
             case Log_ return Sec(A, Sub(Log(A,C), B) )
            end
           case Div_
            switch m[1]
             case Add_ return Add(Div(A,C), Div(B,C))--(A+B)/C
             case Sub_ return Sub(Div(A,C), Div(B,C))--(A-B)/C
             case Mul_ return data --(A*B)/C
             case Div_ return data --(A/B)/C
             case Sec_ return Sec(A,Sub(B,Log(A,C)))--(A^B)/C
             case Log_ return Log(A,Sec(B,Div(1,C)))--log(A,B)/C
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
            end
          end
         elseif type(m)=="number" and type(n)=="table" then
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
             case Div_ return data
             case Sec_ return data
             case Log_ return data
            end
           case Sub_
            switch n[1]
             case Add_ return data
             case Sub_ return data
             case Mul_ return data
             case Div_ return data
             case Sec_ return data
             case Log_ return data
            end
           case Mul_
            switch n[1]
             case Add_ return cas(Add(Mul(A,B), Mul(A,C)))---------------------------
             case Sub_ return data
             case Mul_ return data
             case Div_ return cas(Div(Mul(A,B),C))
             case Sec_ return cas(Sec(B,Add(Log(B,A),C)))
             case Log_ return data
            end
           case Div_
            switch n[1]
             case Add_ return data
             case Sub_ return data
             case Mul_ return data
             case Div_ return data
             case Sec_ return cas(Sec(B,Sub(Log(B,A),C)))
             case Log_ return data
            end
           case Sec_
            switch n[1]
             case Add_ return data
             case Sub_ return data
             case Mul_ return data
             case Div_ return data
             case Sec_ return data
             case Log_ return data

            end
           case Log_
            switch n[1]
             case Add_ return data
             case Sub_ return data
             case Mul_ return data
             case Div_ return data
             case Sec_ return data
             case Log_ return data
            end
          end
         elseif type(m)=="table" and type(n)=="table" then
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
          end
          return data
        end
      end
    end
  end,
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
   elseif type(data)=='string'then
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
     case Sec_ return Mul(Sec(m,n-1),n)
     case Log_ return Div(Sub( Div(Mul(Ln(m),Derivative(n)),n),Div(Mul(Ln(n),Derivative(m)),m) ) , Sec(Ln(m),2) )
     case Sin_ return Cos(m)
     case Cos_ return Mul(-1,Sin(m))

    end
  end
end

function derivative(f,x0)--数值导数
return (f(x0+Env.dx)-f(x0))/Env.dx
end




--###############################################################

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




object={
  __call=function(_,data)
    return object.new(data)
  end,
  __index={
    new=function(data)
      if data.x==nil then data.x=vector() end
      if data.a==nil then data.a=vector() end
      if data.v==nil then data.v=vector() end
      if data.m==nil then data.m=1 end
      return setmetatable(data, object)
    end,
    x=function(data)
      return data.x or vector()
    end,
    v=function(data)
      return data.v or vector()
    end,
    a=function(data)
      return data.a or vector()
    end,
    m=function(data)
      return data.m or vector()
    end,
    doc={
      name="object & 质点 & 物体",
      info=[[函数:新建物体
参数说明:单参数,table,物体运动学参数
返回值:单参数,object,物体]],
      demo=[[ball=object({x=vector(1,2),a=vector(-1,5),m=2})]],
      var=object
    },
  }
}
setmetatable(object, object)
质点=object
物体=object
位矢=object.x
速度=object.v
加速度=object.a
质量=object.m

medium={
  __index={
    gravity=function(data)
      local f_G=v_scale(data.m,vector(0,Env.g))
      return f_G
    end,
    gravity_doc={
      name="gravity & 重力",
      info=[[函数:计算物体重力
参数说明:单参数,object,物体
返回值:单参数,vector,物体重力向量]],
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
      info=[[函数:新建杆
参数说明:单参数,table,杆的物理参数
返回值:单参数,stick,杆]],
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
      info=[[函数:新建万有引力
参数说明:单参数,table,万有引力的物理参数
返回值:单参数,gravitation,万有引力]],
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
      info=[[函数:新建绳(绳仅对正方向的形变产生作用力)
参数说明:单参数,table,绳的物理参数
返回值:单参数,rope,绳]],
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
      info=[[函数:新建弹簧(弹簧仅对负方向的形变产生作用力，相当于未粘连物体)
参数说明:单参数,table,弹簧的物理参数
返回值:单参数,spring,弹簧]],
      demo=[[sp1=spring({l=1,k=1000})]],
      var=spring
    },
  }
}
setmetatable(medium, medium)
重力=medium.gravity
杆=medium.stick
万有引力=medium.gravitation
绳=medium.rope
弹簧=medium.spring

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
force_add=v_add

force_doc={
  name="force & 作用力",
  info=[[函数:根据不同的物体及它们的作用介质计算它们的作用力
参数说明:三参数,(object ,作用介质, object),目标物体和作用介质
返回值:单参数,vector,后一物体所受到的力]],
  demo=[[force(定点,杆,球)]],
  var=force
}




function force_on(object_, force_)
  object_.a=v_scale(1/object_.m,force_)
end
作用于=force_on
force_on_doc={
  name="force_on & 作用于",
  info=[[函数:将力作用于物体上,使之产生加速度
参数说明:双参数,(object ,force),目标物体和力
返回值:无返回值]],
  demo=[[force_on(ball,F)]],
  var=force_on
}

function update(object_)
  object_.v=v_add(object_.v,v_scale(Env.dt,object_.a))
  object_.x=v_add(object_.x,v_scale(Env.dt,object_.v))
end




function see_able(data)
  switch get.type(data)
   case nil return dump(data)
   case "complex" return data.x.."+"..data.y.."i"
   case "vector" return '('..data.x..","..data.y..","..data.z..')'
   case 'table' return dump(data)
   case 'number' return data
   case "boolean" return data
  end
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

}


init()
return nature
