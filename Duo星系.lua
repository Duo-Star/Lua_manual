-- 创建一个星系
-- 你也可以创建，只需要修改一下星星们的参数
-- @author Duo

-- 代码码完真不容易，有兴趣的小伙伴请加入我们: 663251235
require "import"

init={}

init.main=function()
  d3.bgc=0xEE2B0244
  d3.planec=0x251E88E5
  d3.zhou=0xFFFFEE58
  initP()

  Env.dt=0.015
  Env.g=-9.8
  k=10000
  q=-0.0

  stars={}

  stars[1]=object({
    x=vector(0,0,0),
    v=vector(0,0,0),
    m=100
  })

  stars[2]=object({
    x=vector(3,0,0),
    v=vector(0,10,-0.1),
    m=1
  })
  stars[3]=object({
    x=vector(5,0,0),
    v=vector(0,10,0),
    m=1
  })
  stars[4]=object({
    x=vector(4,0,0),
    v=vector(0,-10,0),
    m=1
  })

  stars[5]=object({
    x=vector(angle(1.7,-0.5),2),
    v=vector(0,-15,0),
    m=1
  })

  stars[6]=object({
    x=vector(angle(0.7,0.5),7),
    v=vector(0,-5,0),
    m=1
  })

  stars[7]=object({
    x=vector(angle(0,0.5),7),
    v=vector(angle(0,2.5),10),
    m=1
  })



  g_=gravitation({G=1.2})

  function item(A,B)
    local f=force(B, g_, A)
    A.a = (1/A.m) * f
    --object.update(A)
  end

  function main()
    for m=1,#stars do
      for n=1,#stars do
        if m~=n then
          local f=force(stars[n], g_, stars[m])
          stars[m].a =stars[m].a+ (1/stars[m].m) * f


        end
      end
      object.update(stars[m])
      stars[m].a=vector()
      if m==1 then
        Data[m]=geo(to.point(stars[m].x),{tag="A",width=25,color=0xeeFFFEFE,sun={true,16,0,0,0xFFFFEE58}})
       else
        Data[m]=geo(to.point(stars[m].x),{tag="A",width=12,color=0xeeFFFEFE,sun={true,16,0,0,0xFFFFEE58}})
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
  end
end


init.d3=function()

  d3={}

  d3.onDraw=function() end



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



  --全局绘图参数
  h=activity.getHeight()
  w=activity.getWidth()
  ox=w/2
  oy=h/2
  ox_new=ox
  oy_new=oy
  Lambda=1
  x_b=ox
  y_b=oy
  touch_x=0
  touch_y=0
  a=5.24
  b=0.3
  d3.bgc=0xffffffff
  d3.zhouc=0xff616161
  d3.planec=0x301E88E5
  len=5
  vi=vector(1,0,0)
  vj=vector(0,1,0)
  vk=vector(0,0,1)
  vs={vector(1,0,0),vector(0,1,0),vector(0,0,1)}

  function initP()
    paint = Paint().setColor(0xff616161).setStyle(Paint.Style.STROKE).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
    paint_zhou = Paint().setColor(d3.zhouc).setStyle(Paint.Style.STROKE).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
    paint_plane = Paint().setColor(d3.planec).setStyle(Paint.Style.FILL).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  end
  initP()

  --动画插值器
  animation = ValueAnimator.ofFloat({ 0, 2*pi })
  animation.setDuration(20000)
  animation.setRepeatCount(-1)
  animation.setRepeatMode(1)
  animation.start()



  function geo(data, info)
    info=info or {}
    info.color=info.color or 0xff616161
    info.width=info.width or 10
    info.alpha=info.alpha or 1
    info.tag=info.tag or "tag:#"..os.time()
    info.sun=info.sun or {false,20,0,0,0xFFFF6400}
    return {data,info}
  end

  var_a.setValue(a)
  var_b.setValue(b)
  var_a.addOnChangeListener({--滑动监听事件,"a"为滑动条id
    onValueChange=function(view,value,bool)
      a=tonumber(value)--获取到当前滑动值--在下一行编写执行事件
    end
  })
  var_b.addOnChangeListener({--滑动监听事件,"a"为滑动条id
    onValueChange=function(view,value,bool)
      b=tonumber(value)--获取到当前滑动值--在下一行编写执行事件
    end
  })




  O=point()
  A=point(0,1)
  B=point(1,0)



  Data={
    geo(O),
    geo(A),
    geo(B),

  }

  --print(dump(vs))



  function addData(a)
    Data[#Data+1]=a
  end

  function setData(a)
    Data=a
  end

  function cleanData()
    Data={}
  end

  function addDatas(a)
    for n=1,#a do
      addData(a[n])
    end
  end


  function coordinate222(x,y,z)
    local v=vector(x,y,z)
    local vv=v:change(P_,A_)
    return vector(vv.x*Lambda*100+ox, vv.y*(-1)*Lambda*100+oy)
  end


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

          data=Data

          P_=vector()
          A_=angle(a+k,b)

          if canvas ~= nil then
            canvas.drawColor(d3.bgc)
            function dot(x,y,p)
              local p=p or paint
              return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, 5, p)
            end
            function circle_(x,y,r,p)
              local p=p or paint
              return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r*Lambda*100, p)
            end
            function line_(x0,y0,x1,y1,p)
              local p=p or paint
              canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p)
            end



            --画坐标轴
            for n=1,#vs do
              local zhou_=vs[n]:change(P_,A_)
              line_(-zhou_.x*0.8,-zhou_.y*0.8,zhou_.x*5,zhou_.y*5,paint_zhou)
            end
            --画平面
            local path =Path()
            local v_
            v_=vector(len,len)
            path.moveTo( v_:change(P_,A_).x*Lambda*100+ox, v_:change(P_,A_).y*(-1)*Lambda*100+oy )
            v_=vector(len,-len)
            path.lineTo( v_:change(P_,A_).x*Lambda*100+ox, v_:change(P_,A_).y*(-1)*Lambda*100+oy )
            v_=vector(-len,-len)
            path.lineTo( v_:change(P_,A_).x*Lambda*100+ox, v_:change(P_,A_).y*(-1)*Lambda*100+oy )
            v_=vector(-len,len)
            path.lineTo( v_:change(P_,A_).x*Lambda*100+ox, v_:change(P_,A_).y*(-1)*Lambda*100+oy )
            path.close()
            canvas.drawPath(path, paint_plane)
            --回调
            d3.onDraw()

            for n=1,#data do
              local data_=data[n]
              type_= get.type(data_[1])
              if type_=="point" then
                local v=coordinate222(data_[1].x,data_[1].y,data_[1].z)
                local p= newPaint(data_[2])
                canvas.drawPoint(v.x, v.y, p)
                --p.setStrokeWidth(2)
                --canvas.drawText(data_[2].tag,10+v.x,10+v.y,p)
               elseif type_=="line" then

               else
              end
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
    local action=v.action
    if action == MotionEvent.ACTION_DOWN then
      x_b=v.x
      y_b=v.y
      x_t=v.x
      y_t=v.y
      touch_x=(x_b-ox)/(Lambda*100)
      touch_y=-(y_b-oy+0)/(Lambda*100)

     elseif action==MotionEvent.ACTION_MOVE then
      touch_x=(v.x-ox)/(Lambda*100)
      touch_y=-(v.y-oy+0)/(Lambda*100)
      x_t=v.x
      y_t=v.y
      ox=ox_new+0.8*(x_t-x_b)--屏幕变化量
      oy=oy_new+0.8*(y_t-y_b)




     elseif action==MotionEvent.ACTION_UP then
      ox_new=ox
      oy_new=oy

     else
      --我也不知道该干啥
    end
    return true
  end
end

init.good=function()

  require "import"
  import "android.os.*"
  import "android.app.*"
  import "android.view.*"
  import "android.widget.*"
  import "android.graphics.*"
  import "android.animation.*"
  import "android.graphics.*"


  Toolbar = luajava.bindClass "androidx.appcompat.widget.Toolbar"
  MaterialButton = luajava.bindClass "com.google.android.material.button.MaterialButton"
  TextInputLayout = luajava.bindClass "com.google.android.material.textfield.TextInputLayout"
  TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
  AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
  ImageView = luajava.bindClass "android.widget.ImageView"
  MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
  RecyclerView = luajava.bindClass "androidx.recyclerview.widget.RecyclerView"
  StaggeredGridLayoutManager = luajava.bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"
  Snackbar = luajava.bindClass "com.google.android.material.snackbar.Snackbar"
  BottomSheetDialog = luajava.bindClass "com.google.android.material.bottomsheet.BottomSheetDialog"
  LayoutTransition = luajava.bindClass "android.animation.LayoutTransition"
  Slider = luajava.bindClass "com.google.android.material.slider.Slider"
  MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
  MaterialButton = luajava.bindClass "com.google.android.material.button.MaterialButton"
  ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
  AlertDialog = luajava.bindClass "android.app.AlertDialog"
  MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
  RecyclerView = luajava.bindClass "androidx.recyclerview.widget.RecyclerView"






  activity.SupportActionBar.hide()




  import "com.google.android.material.card.MaterialCardView"
  import "com.google.android.material.button.MaterialButton"

  PopupMenu = luajava.bindClass "android.widget.PopupMenu"





  function print(_)--救救孩子
    if (toast != nil)then
      toast.cancel();
    end
    local _=tostring(_)
    local Toast = luajava.bindClass "android.widget.Toast"
    toast=Toast.makeText(activity,"#",Toast.LENGTH_SHORT).setView(loadlayout({ LinearLayout, { TextView, background="#cc000000", textSize="15sp", TextColor="#ffeeeeee", gravity="center",padding="10dp", text="".._ }})).setGravity(Gravity.BOTTOM,0,120).show()
  end


end


init.nature=function()

  --Nature


  --Lua原生数学库
  math=require "math"

  --Nature
  nature={}

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


  --环境
  Env={

    --自然常数
    e=math.exp(1),

    --圆周率
    pi=math.pi,

    --无穷
    huge=math.huge,
    inf=math.huge,

    --黄金分割率
    phi=(math.sqrt(5)-1)/2,

    --常用未知变量
    x="x",

    --虚数单位，之后会重新定义
    i="i",

    --物理环境时间
    t=0,

    --物理环境时间微分
    dt=0.001,

    --用于积分，求导
    dx=0.001,

    --用于判断浮点数相等
    d=10^(-7),

    --物理环境重力加速度
    g=-9.8,
  }


  --常用常量
  e=Env.e
  pi=Env.pi
  huge=Env.huge
  inf=Env.inf
  phi=Env.phi
  x=Env.x
  i=Env.i


  --纯粹为了让编辑器高亮
  function point() end
  function vecline() end
  function angle() end
  function line() end
  function points() end
  function circle() end
  function vector() end
  function conic() end
  function geometry() end
  function linese() end
  function plane() end

  --好东西
  --debug.setmetatable(521,{__index=math})


  --导入数值运算
  --require "Nature/Numerical"
  --这里是数值运算部分，使用lua原生浮点数
  --同时定义了一些用于数值运算的数学函数
  --并且使用元表制作了复数运算工具，它支持元方法


  --转移lua.math原生函数
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

  --自定义函数
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

  function atan2(y,x)--输出范围 [-π,+π]
    return math.atan2(y,x)
  end

  function p2w(x,y)--输出范围 [0,2π)
    if y>=0 then
      return arccos(x/sqrt(x^2+y^2))
     else
      return arccos(-x/sqrt(x^2+y^2))+pi
    end
  end


  function duo_nature(x)--logo
    return (sin(e^(2)*x))/(e^(2)*x)
  end

  function factorial(x)--阶乘
    local x=floor(x)
    local w=1
    for n=1,x do
      w=w*n
    end
    return w
  end

  function ADD(a,b)--逻辑和
    if get.type(a)=="boolean" and get.type(b)=="boolean" then
      return a or b
     elseif get.type(a)=="number" and get.type(b)=="number" then
      return sgn(a+b)
    end
  end

  function MUL(a,b)--逻辑乘
    if get.type(a)=="boolean" and get.type(b)=="boolean" then
      return a and b
     elseif get.type(a)=="number" and get.type(b)=="number" then
      return sgn(a*b)
    end
  end

  function UNM(a)--逻辑反
    if get.type(a)=="boolean" and get.type(b)=="boolean" then
      return not(a)
     elseif get.type(a)=="number" and get.type(b)=="number" then
      return sgn((-1)*a)
    end
  end

  function Greater(x,a)
    return key(x-a)
  end

  大于=Greater

  function 等于(x,a)
    return root(x-a)
  end

  function 小于(x,a)--同时满足不大于也不等于
    return MUL(UNM(大于(x,a)),UNM(等于(x,a)))
  end
  function 大于等于(x,a)--满足大于或等于
    return ADD(大于(x,a),等于(x,a))
  end

  function 小于等于(x,a)--不满足大于
    return UNM(大于(x,a))
  end

  function 不等于(x,a)
    return UNM(等于(x,a))
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

  function 取位数字(x,s)
    local a=floor(x*(1/s))
    return a-(floor(0.1*a))*10
  end

  function 保留小数(x,s,i)--(<number 数值>,<number 精确位数>,<number 是否四舍五入>) 例如: print(保留小数(3.1415926,0.0001,1))
    return floor(x*(1/s))*s+大于等于(取位数字(x,s*0.1),5)*s*i
  end

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

  --重新定义常量
  i=complex.complex_unit()
  Env.i=complex.complex_unit()

  function derivative(f,x0)--数值导数
    return (f(x0+Env.dx)-f(x0))/Env.dx
  end

  function func(a)--建立函数
    return a
  end

  --解方程
  solve={}

  --解三阶线性方程
  solve.linear3=function( A, B, C )
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



  --导入几何
  --require "Nature/Geometry"
  --这里是神圣几何学
  --[[

   神圣几何学（Sacred Geometry）是以几何形状为符号传递神圣智慧的艺术。
   神圣几何学这种艺术形式已经流传了许多世纪，几乎已经成为了亲密者之间或者行家里手之间秘密的语言。人们认为神圣几何学已经超越了人的思想，成为了对神圣事物的接近。
   这种神圣的语言已经使用了数千年，希腊哲学家和数学家们就特别喜欢它。著名的有柏拉图和毕达哥拉斯。柏拉图的对话录《提缪斯》（The Timaeus）就是关于神圣几何学的论文。他对神秘的亚特兰蒂斯岛的描述看起来也应用的神圣几何学的符号。古希腊人确实曾通过描述所谓“柏拉图固体”的价值和特性，定义了它们与神和天堂的关系。

@Desmos:
        We’re excited about this tool for three reasons.
        First, Geometry is such a beautiful and universal subject. It starts with simple tools – just lines and circles – which, in combination, can be used to construct incredibly intricate and complicated things. Across all of mathematics, and much of science, geometric interpretations help things “make sense.”
        Second, by building on top of the math engine of our graphing calculator, this new Geometry Tool gives power well beyond what the previous tool could. You can compute, plot on a coordinate plane, use sliders and lists, and even leverage advanced features like custom colors and actions, all integrated into the constructive geometry world.
        Finally, this tool is the first major release of Desmos Studio PBC, and perfectly encapsulates why we formed this entity.
翻译:
        首先，几何是一门美丽而又普遍的学科。它从简单的工具开始--仅仅是线和圆--结合起来，可以用来构建难以置信的复杂和复杂的事物。在所有的数学和许多科学中，几何解释帮助事物“变得有意义”。
        其次，通过建立在我们的图形计算器的数学引擎之上，这个新的几何工具提供的力量远远超过了以前的工具。您可以计算、在坐标平面上打印、使用滑块和列表，甚至可以利用高级功能(如自定义颜色和动作)，所有这些都集成到构造几何世界中。
        最后，此工具是Desmos Studio PBC的第一个主要版本，完美地封装了我们创建此实体的原因。


--### 建系大法 ###
--### 纪念碑谷 ###
--### 解析几何 ###
--### 面向对象 ###
--### 向量万岁 ###



--]]





  --几何
  geometry={}


  --这哥仨用来获取 点&向量的三个维度
  function X(data) return data.x end
  function Y(data) return data.y end
  function Z(data) return data.z end


  --建造一个点

  point={
    __call=function(_,x,y,z)
      return point.new(x,y,z)
    end,
    __add=function(m,n)--点的等效向量加
      return point.add(m,n)
    end,
    __sub=function(m,n)
      return point.sub(m,n)
    end,
    __len=function(m)
      return vector.len(m)
    end,
    __mul=function(m,n)
      if is.point(m) and is.point(n) then
        return point.dot(m,n)
       elseif (is.number(m) and is.point(n)) then
        return point.scale(m,n)
       elseif (is.number(n) and is.point(m)) then
        return point.scale(n,m)
      end
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
        end,
      },
      to={
        vector=function(data)--将一个点转换成向量
          return vector(data.x, data.y ,data.z)
        end,
        complex=function(data)--将一个点转换成复数
          return complex(data.x, data.y)
        end,
      },
      len=function(m)
        return math.sqrt(m.x^2 + m.y^2 +m.z^2)
      end,
      add=function(m,n)
        return point(m.x+n.x, m.y+n.y, m.z+n.z)
      end,
      sub=function(m,n)
        return point(m.x-n.x, m.y-n.y, m.z-n.z)
      end,
      scale=function(m,n)
        return point(m*n.x,m*n.y,m*n.z)
      end,
      dot=function(m,n)--"点积"
        return m.x*n.x + m.y*n.y + m.z*n.z
      end,
      distance=function(m,n)
        return math.sqrt((m.x-n.x)^2 + (m.y-n.y)^2 + (m.z-n.z)^2)
      end,
    }
  }
  setmetatable(point, point)



  points={--点组
    __call=function(_,a)
      return points.new(a)
    end,
    __len=function(m)
      return table.size(m)
    end,
    __index={
      new=function(a)--新建点组
        return setmetatable(a or {}, points)
      end,
      is={
        this=function(data)
          return getmetatable(data) == points
        end,
      },
    }
  }
  setmetatable(points, points)




  --建造一个方向角
  angle={
    __call=function(_,x,y)
      return angle.new(x,y)
    end,
    __index={
      new=function(a,b)
        local a=a or 0
        local b=b or 0
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




  --建造一个向量
  --这里最高支持三维向量并向下兼容
  --向量提供广泛的元方法，使得调用非常方便
  --向量用于几何运算，物理环境
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
        d2=function(data)
          return data.z==0
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
      roll=function(v,u,w)
        if not(w) then
          local v=v
          local w=u
          local u=vector(0,0,1)
          return v * cos(w) + u:cross(v) * sin(w) + ((u*v)*u)*(1-cos(w))
         else
          return v * cos(w) + u:cross(v) * sin(w) + ((u*v)*u)*(1-cos(w))
        end
      end,
      change=function(A,p,ang)--空间坐标转平面坐标
        --< vector 目标向量>, <vector 观察者位矢>, <angle 视线向角>
        local px, py, pz, new_x, new_y
        local a,b = ang.theta,ang.phi
        local sa,sb =sin(a),sin(b)
        local ca,cb =cos(a),cos(b)
        px=vector(ca,sa,0)
        py=vector(-sa*cb,ca*cb,sb)
        pz=vector(sa*sb,-ca*sb,cb)
        new_x=vector.dot(A-p,px)
        new_y=vector.dot(A-p,pz)
        return vector(new_x,new_y)
      end,




    }
  }
  setmetatable(vector, vector)


  --快捷访问
  v_project=vector.project
  v_cross= vector.cross
  v_scale=vector.scale
  v_unit= vector.unit
  v_sub= vector.sub
  v_add=vector.add
  v_dot=vector.dot
  v_len=vector.len
  v_abs=vector.len
  v_=vector
  v3=vector
  --中文支持
  向量=vector
  转为单位向量=vector.unit
  向量加=vector.add
  向量减=vector.sub
  向量数乘=vector.scale
  向量数量积=vector.dot
  向量模=vector.len



  --建造一条直线
  line={
    __call=function(_,a,b)
      return line.new(a,b)
    end,
    __index={
      new=function(a,b)
        if is.vector(a) or is.point(a) and is.vector(b) then -- p + λ*v
          return setmetatable({ p=a, v=b },line)
         elseif is.point(a) and is.point(b) then--两点确定一条直线
          local p=point.to.vector(a)
          local v=point.to.vector(point.sub(b,a))
          return setmetatable({ p=p, v=v },line)
        end
      end,
      unit=function(data)--直线单位方向向量
        return vector.unit(data.v)
      end,
      is={
        this=function(data)
          return getmetatable(data) == line
        end,
        d2=function(data)
          return data.z==0
        end,
        d3=function(data)
          return data.z~=0
        end,
      },
      x2lam=function(l,x) -- x-> lambda
        local lambda_=(x-l.p.x)/l.v.x
        return lambda_
      end,
      y2lam=function(l,y) -- y-> lambda
        local lambda_=(y-l.p.y)/l.v.y
        return lambda_
      end,
      z2lam=function(l,z) -- z-> lambda
        local lambda_=(z-l.p.z)/l.v.z
        return lambda_
      end,
      lam2p=function(l,lam)
        return l.p + lam * l.v
      end,
      x2p=function(l,x)
        return line.lam2p(l,l:x2lam(x))
      end,
      y2p=function(l,y)
        return line.lam2p(l,l:y2lam(y))
      end,
      z2p=function(l,z)
        return line.lam2p(l,l:z2lam(z))
      end,





    },
  }
  setmetatable(line, line)
  矩=line
  直线=line

  --建造一个圆
  circle={
    __call=function(_,a,b)
      return circle.new(a,b)
    end,
    __len=function(m)
      return perimeter(m)
    end,
    __index={
      new=function(a,b)-- 点 半径
        if get.type(a)=="point" and get.type(b)=="number" then
          return setmetatable({p=a, r=b},circle)
         elseif get.type(a)=="point" and get.type(b)=="point" then
          return setmetatable({p=a, r=a:distance(b)},circle)
        end
      end,
      is={
        this=function(data)
          return getmetatable(data) == circle
        end,
        unit=function(data)
          return data.r==1
        end,
      },
      getP=function(data)
        return data.p
      end,
      getR=function(data)
        return data.r
      end,
      area=function(data)--计算圆的面积
        return math.pi*data.r^2
      end,
      perimeter=function(data)--计算圆的周长
        return 2*math.pi*data.r
      end,
      x2ps=function(c,x)
        local i=c.r^2-x^2
        if i>=0 then
          local y1=sqrt(c.r^2-x^2)+c.p.y
          local y1=-sqrt(c.r^2-x^2)+c.p.y
          return points({point(x,y1),point(x,y2)})
         else
          points()
        end
      end,
    },
  }
  setmetatable(circle, circle)
  规=circle
  圆=circle
  圆周=circle



  conic={
    __call=function(_,a,b,c,d,e,f)--圆锥曲线
      return conic.new(a,b,c,d,e,f)
    end,
    __index={
      new=function(a,b,c,d,e,f)
        local a = a or 1
        local b = b or 1
        local c = c or 1
        local d = d or 1
        local e = e or 1
        local f = f or 1
        return setmetatable({ a=a, b=b, c=c, d=d, e=e, f=f},conic)
      end,
      is={
        this=function(data)
          return getmetatable(data) == conic
        end,
      },
    },
  }
  setmetatable(conic, conic)
  圆锥曲线=conic






  vecline={--有向线段
    __call=function(_,a,b)
      return vecline.new(a,b)
    end,
    __len=function(m)
      return vecline.len(m)
    end,
    __index={
      new=function(a,b)-- 起始点, 向量
        if get.type(a)=="point" and get.type(b)=="vector" then
          return setmetatable({p=a, v=b},vecline)
         elseif get.type(a)=="point" and get.type(b)=="point" then
          return setmetatable({p=a, v=vector(b.x-a.x, b.y-a.y, b.z-a.z)},vecline)
        end
      end,
      is={
        this=function(data)
          return getmetatable(data) == vecline
        end,
        unit=function(data)
          return #data.v==1
        end,
      },
      getP=function(data)
        return data.p
      end,
      getV=function(data)
        return data.v
      end,
      len=function(data)
        return vector.len(data.v)
      end,
    },
  }
  setmetatable(vecline, vecline)
  有向线段=vecline



  linese={--线段
    __call=function(_,a,b)
      return linese.new(a,b)
    end,
    __len=function(m)
      return linese.len(m)
    end,
    __index={
      new=function(a,b)-- 起始点, 向量
        if get.type(a)=="point" and get.type(b)=="vector" then
          return setmetatable({p=a, v=b},linese)
         elseif get.type(a)=="point" and get.type(b)=="point" then
          return setmetatable({p=a, v=vector(b.x-a.x, b.y-a.y, b.z-a.z)},linese)
        end
      end,
      is={
        this=function(data)
          return getmetatable(data) == linese
        end,
        unit=function(data)
          return #data.v==1
        end,
      },
      getP=function(data)
        return data.p
      end,
      getV=function(data)
        return data.v
      end,
      len=function(data)
        return vector.len(data.v)
      end,
    },
  }
  setmetatable(linese, linese)




  plane={--平面
    __call=function(_,a,b,c,d)
      return plane.new(a,b,c,d)
    end,
    __index={
      new=function(a,b,c,d)
        if a and b and c and d then--直接传入四个参数
          return setmetatable({a=a,b=b,c=c,d=d},plane)
         elseif a and b and c and not(d) then--传入三个点
          local data=solve.linear3(
          {a.x,a.y,a.z,1},
          {b.x,b.y,b.z,1},
          {c.x,c.y,c.z,1}
          )
          if data[1]==math.huge then
            local data=solve.linear3(
            {a.x,a.y,a.z,0},
            {b.x,b.y,b.z,0},
            {c.x,c.y,c.z,0}
            )
            return setmetatable({a=data[1],b=data[2],c=data[3],d=0},plane)
           else
            return setmetatable({a=data[1],b=data[2],c=data[3],d=1},plane)
          end
        end
      end,
      is={
        this=function(data)
          return getmetatable(data) == plane
        end,
      },
      getV=function(data)
        return vector(data.a, data.b, data.c)
      end,
      len=function(data)
        return data.d
      end,
    },
  }
  setmetatable(plane, plane)



  --收纳
  geometry.point = point
  geometry.vector = vector
  geometry.line = line
  geometry.vecline = vecline
  geometry.circle = circle
  geometry.conic = conic
  geometry.points = points
  geometry.angle = angle
  geometry.linese = linese
  geometry.plane = plane

  --新建一些构造方法类
  geometry.middle = {}
  geometry.parallel = {}
  geometry.vertical = {}


  --获得中点
  geometry.middle.point = function(a,b)
    if a~=nil and b==nil then--(<linese>)
      return vector.to.point( a.p + 0.5 * a.v )
     else--(<point>,<point>)
      return 0.5*(a+b)
    end
  end


  --获得角平分线(<vecline>,<vecline>)
  geometry.middle.line = function(a,b)
    return line( a.p, a.v + b.v )
  end


  --过一点且平行于另外一条直线的直线(<point>,<line>)
  geometry.parallel.point=function(a,b)
    return line(a,b.v)
  end


  --过一点且垂直于另外一条直线的直线(限制.2d)(<point>,<line>)
  geometry.vertical.line=function(a,b)
    return line(a,b.v:roll(pi/2))
  end


  --构造中垂线(限制.2d)--(<linese>)
  geometry.perpendicularBisector=function(a)
    return geometry.vertical.line(a.p + 0.5 * a.v, a)
  end




  --导入判断库
  --require "Nature/Is"
  --这里是判断部分
  function is() end--编辑器高亮
  is={
    __index={
      --稍后重新定义
      compute=nil,--判断是否为cas计算函数
      sym=nil,--判断是否为代数
      operator=nil,
      constant=nil,
      cas=nil,
      --================================================
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
      angle=function(data)--判断是否为向角
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
      circle=function(data)
        return type(data)=='table'
      end,




    }
  }
  setmetatable(is, is)



  --导入获得库
  --require "Nature/Get"
  --这里是获取部分
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
           case circle return 'circle'
           case conic return 'conic'
           case vecline return 'vecline'
           case line return "line"
           case linese return "linese"




          end
        end
      end,
    }
  }
  setmetatable(get, get)
  --print(get.type(1))




  --导入转换库
  --require "Nature/To"
  to={
    vector=function(a)
      return vector(a.x,a.y,a.z)
    end,
    point=function(a)
      return point(a.x,a.y,a.z)
    end,


  }


  --导入符号
  --require "Nature/CAS"
  --这里是符号运算
  --[[
计算机代数系统（英语：computer algebra system，缩写作：CAS）
符号计算又称计算机代数，通俗地说就是用计算机推导数学公式，如对表达式进行因式分解、化简、微分、积分、解代数方程、求解常微分方程等。
中文名
符号计算
常见符号分类
（语文、数学、物理、化学）符号
计算方法
计算机、科学计算器、手算等等
重点
函数计算与微积分运算

是进行符号运算的软件。这种系统的要件是数学表示式的符号运算。
以下是几种典型的符号运算：
表示式的简化
对表示式求值
表示式的变形：展开、积、幂次、部分分式表法、将三角函数表为指数函数等等。
对单变元或多变元的微分。
带条件或不带条件的整体优化。
部分或完整的因式分解。
求解线性方程组或一些非线性方程式。
某类微分方程或差分方程的符号解。
求某些函数的极限值。
一些函数的定积分或不定基分，包括多变元的情形。
泰勒展开式、罗朗展开式与Puiseux展开式
某些函数的无穷级数展开式。
对某些级数求和。
矩阵运算。
数学式的显示，通常借着TeX之类的系统达成。


马丁纽斯·韦尔特曼（Martinus J. G. Veltman） 是这个领域的先驱，他首先考虑了在高能物理中的应用。他在1963年设计的第一个程序叫Schoonship（荷兰文，意指“干净的船”）。

最早受到欢迎的系统是Reduce、Derive与Macsyma，现在仍然可获取。Macsyma的一个GNU通用公共许可证发行的版本叫作Maxima，现在仍有维护。市场的龙头为Maple与Mathematica，两者被数学家、科学家及工程师们广泛采用，此外还有MuPAD与MathCad。

另有一些系统着眼于特定的应用领域，这些系统通常在学院中被设计、发展及维护，例如交换代数系统Macaulay 2或数论系统PARI/GP。




--]]

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
  --保存计算符的数组
  Operator={
    Add_,Sub_,Mul_,Div_,
    Sec_,Log_,
    Sin_,Cos_,Tan_
  }
  --判断是否为cas计算符常量
  is.operator=function(data)
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





  --导入统计学
  --require "Nature/Statistics"
  --统计学
  --[[
统计学是通过搜索、整理、分析、描述数据等手段，以达到推断所测对象的本质，甚至预测对象未来的一门综合性科学。统计学用到了大量的数学及其它学科的专业知识，其应用范围几乎覆盖了社会科学和自然科学的各个领域。[1]
中文名 统计学
外文名 Statistics
学科门类 一级学科
学科特点 应用广泛
主要分支 社会统计学、数理统计学[2]  

--]]


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



  --导入物理学
  --require "Nature/Physics"
  --物理学
  --让我们用微分方程开启对自然的探索
  --成为"造物主"
  --[[
微分方程是数学的一个重要分支，广泛应用于物理、工程、经济等多个领域，
用于描述众多的实际现象和问题。它们分为许多不同的类型，每种类型都有自己独特的性质和解法。
理解这些分类可以帮助我们更好地理解微分方程的性质，从而更有效地求解微分方程。
微分方程有常微分方程和偏微分方程。偏微分方程描述了多维问题，它们通常比较复杂。

当我们凝视深邃的夜空，憧憬星辰大海的奥秘时，不禁感叹自然界的美妙。在这美丽的宇宙中，存在着一种强大的数学工具，帮助我们揭示物质、能量与时间的秘密——它就是偏微分方程。
偏微分方程（PDE）的基础概念源于古代数学家对自然界现象的观察和思考。随着时间的推移，这种数学方法得以完善并发展，逐渐成为科学家们探索世界奥秘的钥匙。在物理、化学、生物学、工程和经济等领域，偏微分方程已经成为了一种强有力的模型和预测工具。
偏微分方程之美，不仅体现在其强大的应用领域，更显现于方程本身的艺术造诣。在这些方程中，未知函数与多个自变量及其偏导数相互交织，构成了一幅精妙绝伦的画卷。如同一位舞者，在宇宙的舞台上，跟随着自然规律的节奏，优雅地翩翩起舞。
偏微分方程的类型繁多，从线性到非线性，从一阶到高阶，从椭圆型到抛物型再到双曲型，其多样性令人叹为观止。就像大自然中繁星点点，各有各的光彩，这些方程亦如此。在研究过程中，科学家们不断挖掘它们的内在联系，试图找到一种普遍的方法来解决这些方程，就如同寻找一把解开宇宙之谜的金钥匙。
解偏微分方程的过程充满了挑战与惊喜。有时，我们需要借助解析方法，如分离变量法、格林函数法等，将复杂问题简化，一步步揭示其内在规律。而有时，数值方法如有限差分法、有限元法等成为我们征服这些方程的利器。在解决方程的过程中，我们仿佛是一位勇敢的探险家，跋山涉水，不畏艰险，最终揭示出自然界中那些隐藏已久的秘密。
偏微分方程，如同一首部诗篇，既富有科学的严谨，又充满了艺术的气息。它们赋予了科学家们智慧之光，引领着我们探寻自然界的无穷奥妙。在这些方程的指引下，我们逐渐领悟到宇宙的和谐之美，洞察到生命的奇迹与价值。
在未来的探索中，偏微分方程将继续发挥其独特的魅力，帮助人类解决更多关乎生存与发展的重要问题。在应对气候变化、治疗疾病、优化经济系统等诸多领域，偏微分方程都将发挥不可或缺的作用。它们如同指南针，引导我们在科学的海洋中航行，探寻更广阔的领域和更深奥的知识。
然而，偏微分方程也存在着它的局限性。在面对复杂的现实问题时，我们往往难以找到精确的解。然而，这正是科学发展的原动力所在。这些未解之谜，激发着科学家们不断求索，探寻更为普适、有效的解决方法。在这个过程中，偏微分方程将与其他数学领域及新兴科技紧密结合，共同开创更为美好的未来。
偏微分方程作为一种神奇的数学工具，已经深入到了我们生活的方方面面。在欣赏它们的美学价值的同时，我们更应认识到它们在解决实际问题中的巨大作用。让我们继续跟随偏微分方程的步伐，共同探索这个美妙的宇宙，揭示它那永恒的韵律与和谐。


--]]

  --计算机物理环境

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
      distance=function(m,n)
        return math.sqrt((m.x.x-n.x.x)^2 + (m.x.y-n.x.y)^2 + (m.x.z-n.x.z)^2)
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






  --Sun
  --require "Nature/Sun"


  local a="f(x)=x"
  local b="duo=1"
  local c="duo"


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


  保留小数位数=0.000000001
  是否四舍五入=1





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
    is=is
  }
  --]]


end
init.d3lay=function()
  require "import"
  import "android.widget.*"
  import "android.view.*"



  dino_img="https://ncstatic.clewm.net/rsrc/2023/0105/12/5267d95941264ffe2204ab3fe043d2a2.png?x-oss-process=image/resize,w_108/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1"
  duo_img="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1"
  open_img="https://ncstatic.clewm.net/rsrc/2022/1215/20/fcd88a63114c522e38d799ee38cc18ff.png?x-oss-process=image/resize,w_48/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1"
  plus_img="https://tc.24ly.cn/down.php/78593efb1313303afa02a6ceb4cc8047.png"
  minus_img="https://tc.24ly.cn/down.php/56490eefc2c7b76a96d13bdf55520365.png"
  shapes_img="https://tc.24ly.cn/down.php/84a99dcde1f760fcd56eb8c8a3bcb0dc.png"
  chart_img="https://tc.24ly.cn/down.php/cb2ec43ab94df90cbea555a4e6670738.png"


  function DuoAppBar()
    layout={ LinearLayout,
      orientation="0",
      layout_height="50dp",
      layout_width="fill",
      backgroundColor=0xDD388E3C,
      { FrameLayout,
        layout_width='fill',
        layout_height='fill',
        { TextView,
          layout_gravity='center|left',
          textSize='20dp',
          textColor=0xFFFAFAFA,
          layout_margin='10dp',
          id="tips",
          text="Nature-Chart",
          style="blod",
        },
        { LinearLayout,
          orientation="0",
          layout_height="50dp",
          layout_width="fill",
          gravity="center|right",
          {MaterialCardView,
            layout_width='35dp',
            layout_height='35dp',
            CardBackgroundColor=0,
            radius="30dp",strokeColor=0,strokeWidth=0,
            cardElevation="0dp",
            layout_margin='5dp';
            onClick=function()
              --e=e+0.3
            end,
            { ImageView,
              layout_width='25dp',
              layout_height='25dp',
              layout_gravity='center',
              src=plus_img,
              layout_margin='3dp',
            };
          },
          {MaterialCardView,
            layout_width='35dp',
            layout_height='35dp',
            CardBackgroundColor=0,
            radius="30dp",strokeColor=0,strokeWidth=0,
            cardElevation="0dp",
            layout_margin='5dp';
            onClick=function()
              --e=e-0.3
            end,
            { ImageView,
              layout_width='25dp',
              layout_height='25dp',
              layout_gravity='center',
              src=minus_img,
              layout_margin='3dp',
            };
          },
          {MaterialCardView,
            layout_width='35dp',
            layout_height='35dp',
            CardBackgroundColor=0,
            radius="30dp",strokeColor=0,strokeWidth=0,
            cardElevation="0dp",
            layout_margin='5dp';
            onClick=function()
            end,
            { ImageView,
              layout_width='25dp',
              layout_height='25dp',
              layout_gravity='center',
              src=chart_img,
              layout_margin='3dp',
            };
          },

        },

      },
    }
    return layout
  end



  duo=
  {
    LinearLayout,
    layout_width="fill",
    layout_height="fill",
    orientation='vertical';
    DuoAppBar(),
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
        LinearLayout,
        layout_width="fill",
        --layout_height="fill",
        orientation='vertical';
        layout_gravity='center|bottom',
        { TextView,
          textSize='12dp',
          id="tips",
          text="Duo提供技术支持",
          style="blod",
        },
        {
          Slider,--滑动条
          id="var_a",
          Value=5,
          ValueTo=6,
        },
        {
          Slider,--滑动条
          id="var_b",
          Value=0.5,
          ValueTo=6,
        },
      },
    }
  }
  activity.setContentView(loadlayout(duo))

  activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xDD388E3C)


end

init.good()
init.nature()
init.d3lay()
init.d3()
init.main()

