--坐标系
--作者：Duo  QQ：113530014


require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
--import "nature"
--真可惜，手册里导入不了nature

h=activity.getHeight()
w=activity.getWidth()

black_P = Paint();
black_P.setColor(0xbb424242)
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

red_P = Paint();
red_P.setColor(0xffF44336)
.setAntiAlias(true)
.setStrokeCap(Paint.Cap.ROUND)
.setStyle(Paint.Style.STROKE)
.setStrokeWidth(6)


e=1

duo=
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
}
activity.setContentView(loadlayout(duo))

local ox=w/2
local oy=h/2
ox_new=ox
oy_new=oy
Lambda=1
floor=math.floor
abs=math.abs

dt=0.005
t=0
主频=Ticker()
主频.Period=dt*1000
主频.onTick=function()--执行事件
  t=t+dt
  v_Lambda=(e-Lambda)*15
  Lambda=Lambda+v_Lambda*dt
end
主频.start()
function onDestroy()--退出时执行
  主频.stop()
end






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



--A=point(500,600)

local DrewPanel = LuaDrawable(
function(canvas, paint, panel)

  function dot(x,y,p)
    if p==nil then
      p=blue_P
    end
    return canvas.drawCircle(x*Lambda+ox, y*Lambda+oy, 4, p)
  end
  function circle_(x,y,r,p)
    if p==nil then
      p=green_P
    end
    return canvas.drawCircle(x*Lambda+ox, y*Lambda+oy, r*Lambda, green_P)
  end
  function line_(x0,y0,x1,y1)
    canvas.drawLine(x0*Lambda+ox,y0*Lambda+oy,x1*Lambda+ox,y1*Lambda+oy, black_P)
  end

  -- canvas.drawColor(0x50BBDEFB)--设置背景颜色
  canvas.drawOval(-100*Lambda+ox,-700*Lambda+oy,300*Lambda+ox,-900*Lambda+oy,green_P)
  -- canvas.drawText("ssss",500,500,black_P)



  for x=-5,5,0.01 do
    y=2/(x^2+1)*math.cos(3*x)
    dot(100*x,-100*y,red_P)
  end


  line_(300,0,0,-400)
  circle_(300,-400,250)
  dot(300,-400)
  dot(300,0)
  dot(0,-400)


--[[
  path=Path()
  path.moveTo(700*Lambda+ox,-600*Lambda+oy)
  path.lineTo(800*Lambda+ox,-700*Lambda+oy)
  path.lineTo(800*Lambda+ox,-800*Lambda+oy)
  path.lineTo(700*Lambda+ox,-700*Lambda+oy)
  canvas.drawPath(path,black_P)
--]]


  canvas.drawLine(-ox+ox,0+oy,(w-ox)+ox,0+oy, black_P)
  canvas.drawLine(0+ox,-oy+oy,0+ox,(h-oy)+oy, black_P)
  dot(0,0,blue_P)
  for x=0,w-ox,100 do
    dot(x,0,black_P)
  end
  for x=0,ox,100 do
    dot(-x,0,black_P)
  end
  for y=0,oy,100 do
    dot(0,-y,black_P)
  end
  for y=0,h-oy,100 do
    dot(0,y,black_P)
  end
  panel.invalidateSelf()
end)

back.setBackground(DrewPanel)

