--遗传算法训练ai
--作者：Duo  QQ：113530014
--持续完善中，欢迎反馈交流


Nature={}
Nature.qq=663251235



--////////////////////////////////////////////////////
--// 背景                                            //
--// 这是一个阴暗的楼道，两头封闭，一头有一个小屋，另一头是由 //
--// 美味的奶酪堆积成的山。一只小老鼠出生在小屋里，寻找奶酪吃 //
--// 然而，在享受美味的同时，他还要注意警报！如果警报响起，楼 //
--// 道内将会释放毒气，降低他的生命值。此时他必须尽快回到小屋 //
--// 内，在小屋里，他将休息并且变异。变异内容包括奔饭速度和逃 //
--// 跑速度。如果警报解除，他将再次去寻找食物。这样的小老鼠有 //
pn=15--只，他们将发生怎样的故事呢？快来试试吧!             //
--////////////////////////////////////////////////////

--提示:
--1.单击悬浮按钮，改变警告状态
--2.可以开启管理员模式↓自动定时改变警告状态
管理员模式=false
--3.注意观察几轮后的小鼠速度，与小数剩余个数


require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
h=activity.getHeight()--屏幕高
w=activity.getWidth()--屏幕宽
Duo=
{
  FrameLayout,
  --orientation='vertical',
  layout_width='fill',
  layout_height='fill',
  background='#00FFFFFF',
  id="root",
  { MaterialCardView,
    radius="0dp",
    layout_width=0.2*w,
    layout_height="fill",
    cardElevation=0,
    cardBackgroundColor="#E8F5E9",
  },
  { MaterialCardView,
    radius="0dp",
    layout_width=0.2*w,
    layout_height="fill",
    layout_gravity="right",
    cardElevation=0,
    cardBackgroundColor="#FFF8E1",
  },
  { MaterialCardView,
    radius="0dp",
    layout_width=0.8*w,
    layout_height="fill",
    layout_gravity="right",
    cardElevation=0,
    cardBackgroundColor="#FFEBEE",
    visibility=(View.INVISIBLE),
    id="danger",
  },
}
--this.uiManager.getFragment(0).view.addView(loadlayout(Duo))
webView.addView(loadlayout(Duo))
--activity.setContentView(loadlayout(Duo))

data={}--创建数据总表
for n=1,pn do--创建十个数据
  data[n]={x=0,ev=0.1,rv=-0.1,l=123}--十个数据中，单个数据的形态
  --当前位置，奔饭速度，逃跑速度，等级
end

-- 房间               食物区
--{___}_____________######
--0  0.2           0.8    1

function isvar()--变异
  math.randomseed=os.time()
  v_r=math.random(0,100)
  if v_r<=20 then isv=true else isv=false end
  return isv
end

function var()--变异程度[-0.1,0.1]
  math.randomseed=os.time()
  c_r=math.random(-100,100)
  return c_r/1000
end

y=0
for n=1,pn do
  root.addView(loadlayout(
  {LinearLayout,
    orientation=1,
    id="c"..n,
    Y=y,
    { MaterialCardView,
      elevation="0",
      radius="20dp",
      layout_width="50",
      layout_height="50",
      cardElevation=0,
      cardBackgroundColor="#43A047",
    },
    {
      TextView;
      text="",
      id="t"..n,
    },
  }
  ))
  y=y+h*(1/pn)
end


ise=true--开饭啦！

function change_danger()--改变危险状态
  ise=not(ise)
  switch ise
   case true danger.setVisibility(View.INVISIBLE)
   case false danger.setVisibility(View.VISIBLE)
  end
end

function onFloatingActionButtonClick(v)
  change_danger()
end


管理员=Ticker()
管理员.Period=15*1000
管理员.onTick=function()--执行事件
  change_danger()
end

if 管理员模式 then
  管理员.start()--自动管理
end

dt=0.05 t=0
主频=Ticker()
主频.Period=dt*1000
主频.onTick=function()--执行事件
  t=t+dt
  switch ise--是否为开饭时间？
   case true
    for n=1,pn do
      if data[n].x<0.05 or data[n].x>0.95 then
        data[n].x=data[n].x+dt*(0.5-data[n].x)*0.3--归位趋势，防止越出屏幕
       else
        data[n].x=data[n].x+dt*data[n].ev--累加速度
      end
      if data[n].x>=0.8 then data[n].l=data[n].l+2 end--吃饭吃饭
      if data[n].x<=0.2 then data[n].l=data[n].l-1 end--开饭了还不吃饭，不是傻子嘛。。给你扣分
    end
   case false--傻孩子，赶紧跑吧！
    for n=1,pn do
      if data[n].x<0.05 or data[n].x>0.95 then
        data[n].x=data[n].x+dt*(0.5-data[n].x)*0.3--归位趋势，防止越出屏幕
       else
        data[n].x=data[n].x+dt*data[n].rv--累积速度
      end
      if data[n].x>=0.2 then--这孩子还在外面呢
        data[n].l=data[n].l-1--毒气！！
       else--他进来了
        if data[n].l<500 then--非优秀基因去变异
          if isvar() then--是否变异奔饭速度
            data[n].ev=data[n].ev+var()
          end
          if isvar() then--是否变异逃跑速度
            data[n].rv=data[n].rv+var()*0.15
          end
        end
      end
    end
  end
  for n=1,pn do
    assert(loadstring("c"..n..".setX("..data[n].x*w..")"))()--更新显示位置
    assert(loadstring("t"..n..".setText(tostring("..data[n].l.."))"))()--显示下标
    if data[n].l<0 then--去死吧！坏基因
      assert(loadstring("c"..n..".setVisibility(View.INVISIBLE)"))()
    end
  end
end

主频.start()

function onDestroy()--退出时执行
  主频.stop()
  管理员.stop()
end
