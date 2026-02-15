--单摆
--作者：Duo  QQ：113530014
--单摆只在摆角较小的情况下做简谐运动，
--直接利用这一规律进行模拟，可以大大减轻我和计算机的负担
--但这样做是不科学的，不负责任的。所以这里使用了欧拉法对二阶常微分方程求数值解

--温馨提示，改改下面的初始化参数更有意思哦~

require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"

h=activity.getHeight()
w=activity.getWidth()

P = Paint();
P.setColor(0xff2196F3)
.setAntiAlias(true)
.setStrokeCap(Paint.Cap.ROUND)
.setStyle(Paint.Style.FILL)
.setStrokeWidth(3)

duo=
{ FrameLayout,
  layout_width='fill',
  layout_height='fill',
  background='#25FAFAFA',
  id="back",
  { TextView,--文本控件
    layout_gravity='left|top',
    textSize='15dp',--文字大小
    text="i",
    style="blod",
    id="info",
  },
}
activity.setContentView(loadlayout(duo))

-- 定义常量
local g = 9.8 --重力加速度
local L = 1.0 --单摆长度
local dt = 0.005 --时间步长
local t=0 --初始化时间
local theta = math.rad(60) --单摆初始角度
local omega = 0 --单摆初始角速度
time=Ticker()
pi=math.pi
sin=math.sin
cos=math.cos
floor=math.floor

function rounding(data)
  return (floor(data*1000)*0.001)
end


function main(theta, omega)
  alpha = -g/L * sin(theta) --角加速度
  omega = omega + alpha * dt --角速度
  theta = theta + omega * dt --角度
  return theta, omega
end

local DrewPanel = LuaDrawable(
function(backg, paint, panel)
  backg.drawCircle(w/2, h/2, 5, P)
  backg.drawLine(w/2, h/2, 380*cos(pi/2-theta)+w/2, 380*sin(pi/2-theta)+h/2, P)
  backg.drawCircle(380*cos(pi/2-theta)+w/2, 380*sin(pi/2-theta)+h/2, 30, P)
  
  
  panel.invalidateSelf()
end)

back.setBackground(DrewPanel)

time.Period=dt*1000
time.onTick=function()--执行
  t=t+dt
  theta, omega = main(theta, omega)
  pathc=Path()
  pathc.moveTo(t,theta)
  pathc.lineTo(t,theta)
  info.setText("t="..rounding(t).."\ntheta="..rounding(theta).."\nomega="..rounding(omega).."\nalpha="..rounding(alpha))
end
time.start()
function onDestroy()--退出时
  time.stop()
  print("stop")
end
