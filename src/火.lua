--删了点没用的东西
require "import"
import "android.os.*"
import "android.app.*"
import "android.view.*"
import "android.widget.*"
import "android.graphics.*"
import "android.animation.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Canvas = luajava.bindClass "android.graphics.Canvas"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"


function init()


  function print(_)--救救孩子
    if (toast != nil)then
      toast.cancel();
    end
    local _=tostring(_)
    local Toast = luajava.bindClass "android.widget.Toast"
    toast=Toast.makeText(activity,"#",Toast.LENGTH_SHORT).setView(loadlayout({ LinearLayout, { TextView, background="#cc000000", textSize="15sp", TextColor="#ffeeeeee", gravity="center",padding="10dp", text="".._ }})).setGravity(Gravity.BOTTOM,0,120).show()
  end

  function print_(...)
    $toast=Toast.makeText(activity,table.concat({...}," "),Toast.LENGTH_SHORT)
    toast.getView().getChildAt(0).setMaxLines(math.huge)
    toast.show()
  end

  local paint = Paint()
  .setColor(0xff616161)
  .setStyle(Paint.Style.STROKE)
  .setStrokeWidth(5)
  .setAntiAlias(true)
  .setStrokeCap(Paint.Cap.ROUND)

  function newPaint(data)
    local p= Paint()
    .setColor(data.color)
    .setStyle(Paint.Style.STROKE)
    .setStrokeWidth(data.width)
    .setAntiAlias(true)
    .setStrokeCap(Paint.Cap.ROUND)
    if data.sun[1] then
      p.setShadowLayer(data.sun[2],data.sun[3],data.sun[4],data.sun[5])
    end
    return p
  end


  bonfires={}

  bonfire_Colors={
    0xFFFCF9E8,
    0xFFFAEBDB,
    0xFFF5DECE,
    0xFFF5D9CB,
    0xFFF4C9BD,
    0xFFF6C3B3,
    0xFFF0BCB0,
    0xFFF0B7A8,
    0xFFEDABA0,
    0xFFEEA595,
    0xFFEDA597,
    0xFFE79E8B,
    0xFFC78277,
    0xFFB4756C,
    0xFF976056,
    0xFF825D59,
    0xFF594E54,
    0xFF3A5067

  }

  function newBonfire(data)
    local data = data or object()
    data.alpha=1
    data.color=bonfire_Colors[1]
    return data
  end



  Env.dt=0.01

  Env.wind=vector()

  Env.ff=vector(0,1)


  function main()
    Env.wind=vector(a)
    for n=1,#bonfires do
      local item=bonfires[n]
      item.a=Env.ff + Env.wind
      object.update(item)
      local hh=math.floor(item.x.y*3+1.5)
      item.color=bonfire_Colors[hh] or bonfire_Colors[#bonfire_Colors]

      if hh>=#bonfire_Colors+1 then
        bonfires[n]=newBonfire(object({v=vector(math.random(-50,50)/100,math.random(-50,50)/100)}))
      end

    end

  end



  timer_=Ticker()
  timer_.Period=Env.dt*1000
  timer_.onTick=function()
    Env.t=Env.t+Env.dt
    main()
  end
  timer_.start()
  function onDestroy()
    timer_.stop()
    timer_2.stop()
  end


  timer_2=Ticker()
  timer_2.Period=0.15*1000
  timer_2.onTick=function()
    if #bonfires<=20 then
      bonfires[#bonfires+1]=newBonfire(object({v=vector(math.random(-60,60)/100,math.random(-10,80)/100)}))

    end
  end
  timer_2.start()


  h=activity.getHeight()
  w=activity.getWidth()
  ox=w/2
  oy=h/1.3
  ox_new=ox
  oy_new=oy
  Lambda=1.5
  x_b=ox
  y_b=oy


  animation = ValueAnimator.ofFloat({ 0, 1 })
  animation.setDuration(3000)
  animation.setRepeatCount(-1)
  animation.setRepeatMode(2)
  animation.start()


  local layout =
  {
    FrameLayout,
    layout_width = 'fill',
    layout_height = 'fill',
    {
      SurfaceView;
      layout_width = 'fill',
      layout_height = 'fill',
      id = "surface",
      alpha=1,
    },
    {
      Slider,--滑动条
      layout_marginBottom="50dp",
      layout_gravity="bottom",
      id="var_a",
      ValueFrom=-5,
      Value=0,
      ValueTo=5,
      alpha=0.9,
    },


  };
  activity.setContentView(loadlayout(layout))





  a=0
  var_a.addOnChangeListener({
    onValueChange=function(view,value,bool)
      a=tonumber(value)

    end
  })




  local holder = surface.getHolder()
  holder.addCallback(SurfaceHolder.Callback {
    surfaceChanged = function(holder, format, width, height)
    end,
    surfaceChanged = function(holder)
    end,
    surfaceCreated = function(holder)
      animation.addUpdateListener(ValueAnimator.AnimatorUpdateListener {
        onAnimationUpdate = function(animate)
          local k = animate.getAnimatedValue()
          local canvas = holder.lockCanvas()


          if canvas ~= nil then
            canvas.drawColor(bonfire_Colors[#bonfire_Colors])
            function dot(x,y,r,p)
              local p=p or paint
              local r=r or 5
              return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r, p)
            end
            function circle_(x,y,r,p)
              local p=p or paint
              return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r*Lambda*100, p)
            end
            function line_(x0,y0,x1,y1,p)
              local p=p or paint
              canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p)
            end

            function change(x,y)
              return {x=x*Lambda*100+ox, y=-y*Lambda*100+oy}
            end



            local P=Paint()
            .setColor(bonfire_Colors[1])
            .setStyle(Paint.Style.FILL)
            .setStrokeWidth(250)
            .setAntiAlias(true)
            .setShadowLayer(30,0,0,bonfire_Colors[12])
            local path =Path()
            local p,len={},0.25
            p=change(len,len)
            path.moveTo(p.x,p.y)
            p=change(2*len,0)
            path.lineTo(p.x,p.y)
            p=change(len,-len)
            path.lineTo(p.x,p.y)
            p=change(0,0)
            path.lineTo(p.x,p.y)
            p=change(-len,len)
            path.lineTo(p.x,p.y)
            p=change(-2*len,0)
            path.lineTo(p.x,p.y)
            p=change(-len,-len)
            path.lineTo(p.x,p.y)
            path.close()
            canvas.drawPath(path, P)




            for n=1,#bonfires do
              local item=bonfires[n]
              local P=Paint()
              .setColor(item.color)
              .setStyle(Paint.Style.FILL)
              .setStrokeWidth(250)
              .setAntiAlias(true)
              .setShadowLayer(30,0,0,item.color)

              --dot(item.x.x,item.x.y,10,P)


              local path =Path()
              local p,len={},0.15
              p=change(item.x.x-len,item.x.y-len)
              path.moveTo(p.x,p.y)
              p=change(item.x.x+len,item.x.y-len)
              path.lineTo(p.x,p.y)
              p=change(item.x.x+len,item.x.y+len)
              path.lineTo(p.x,p.y)
              p=change(item.x.x-len,item.x.y+len)
              path.lineTo(p.x,p.y)
              path.close()
              canvas.drawPath(path, P)


            end



          end
          holder.unlockCanvasAndPost(canvas)
        end
      })
    end,
    surfaceDestroyed = function(holder)
      animation.removeAllUpdateListeners()
      animation.cancel()
    end
  })



  motionEvent=MotionEvent



  surface.onTouch=function(_,v)
    -- print(dump(v))

    --[
    local action=v.action
    if action == MotionEvent.ACTION_DOWN then
      x_b=v.x
      y_b=v.y
      x_t=v.x
      y_t=v.y
      local touch_x=(x_b-ox)/(Lambda*100)
      local touch_y=-(y_b-oy+0)/(Lambda*100)

     elseif action==MotionEvent.ACTION_MOVE then

      x_t=v.x
      y_t=v.y
      ox=ox_new+0.8*(x_t-x_b)--屏幕变化量
      oy=oy_new+0.8*(y_t-y_b)

     elseif action==MotionEvent.ACTION_UP then

      ox_new=ox
      oy_new=oy

     else


    end
    return true
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




