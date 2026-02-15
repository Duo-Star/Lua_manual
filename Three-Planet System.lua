--三体来了！
--更新！增加星球标签ABC
--物理宇宙环境lua模拟
--作者:Duo  QQ:113530014
--本人高一学生，还没有讲到天体物理，如有不正，敬请指出！
--更新日志:
--        某一天:增加屏幕移动和缩放功能
--        2022.12.28:增加星球标签ABC
--        2023.4.23:优化细节


--Duo Nature发布：--可在Duo Nature坐标系内运行三体
--下载请至:http://qr61.cn/oA1YZf/q9UnaCT
--QQ群：663251235
--[[
现在支持
1.描点
2.绘制线段
3.绘制函数
4.绘制轨迹
5.插入按钮
6.插入滑动条
7.插入文本

%通过编程，可以配置时间环境，物理模型，仿真实验模拟
%我们提供按钮，滑动条等交互方式，可操作性增强
%开源社区正在构建，目前使用兔小巢社区
%加入我们，探索自然！
]]

require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.media.MediaPlayer"
import "android.graphics.Path"
import "android.graphics.Typeface"
import "android.app.AlertDialog"
local WebViewClient = luajava.bindClass "android.webkit.WebViewClient"
local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local ColorDrawable = luajava.bindClass "android.graphics.drawable.ColorDrawable"
local Paint = luajava.bindClass "android.graphics.Paint"
local LuaDrawable = luajava.bindClass "com.androlua.LuaDrawable"
--隐藏状态栏
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
--获取屏幕参数
h=activity.getHeight()--屏幕高
w=activity.getWidth()--屏幕宽
mp=0--音乐播放计数
e=1--屏幕缩放
ex=0--屏幕x平移
ey=0--屏幕y平移
sex=0--保存屏幕移动位置x
sey=0--保存屏幕移动位置y
pd=e*20--星球直径
fp=0--选择要绘制轨迹的星球(0 or 1 or 2 or 3)
duo=
{ FrameLayout,--线性布局
  --orientation='vertical',--方向
  layout_width='fill',--宽度
  layout_height='fill',--高度
  background='#FF2B0244',--背景颜色或图片路径
  id="背景",
  { FrameLayout,--线性布局
    --orientation='vertical',--方向
    layout_width='fill',--宽度
    layout_height='fill',--高度
    background='#FF2B0244',--背景颜色或图片路径
    id="画布背景",
    { TextView;--文本控件
      gravity='left';--重力
      textSize='14dp';--文字大小
      textColor='#FFFDFDFD';--文字颜色
      style="blod",
      id="提示",
      textIsSelectable=true--长按复制
    };
    {MaterialCardView,
      layout_height="40dp",
      layout_width="40dp",
      radius="30dp",
      layout_margin="15dp",
      cardElevation="2",
      layout_gravity='top|right';
      cardBackgroundColor="#FF7E6086",
      id="声音",--设置id
      onClick=function()
        if mp=="0" then mediaPlayer.start() end
        if mediaPlayer.isPlaying() then mediaPlayer.pause() print("暂停播放") else mediaPlayer.start() print("继续播放") end
        mp=mp+1
      end,
      { ImageView;--图片控件
        src='https://ncstatic.clewm.net/rsrc/2022/1209/17/bbd4e7957722add648f4c6dce5069920.png?x-oss-process=image/resize,w_192/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1';--图片路径
        layout_width='fill';--宽度
        layout_height='fill';--高度
        layout_margin="9dp",
        layout_gravity='center';--重力
        --scaleType='fitXY';--图片显示类型
      };
    },
    {
      LinearLayout,--线性布局
      orientation='vertical',--方向
      layout_width='fill',--宽度
      layout_height='wrap',--高度
      background='#00FFFFFF',--背景颜色或图片路径
      layout_gravity='bottom|right';
      {MaterialCardView,
        layout_height="40dp",
        layout_width="40dp",
        radius="30dp",
        layout_margin="15dp",
        cardElevation="2",
        layout_gravity='bottom|right';
        cardBackgroundColor="#FF7E6086",
        onClick=function()
          e=e*1.3
          pd=e*20
          星球缩放(星球a,e)
          星球缩放(星球b,e)
          星球缩放(星球c,e)
        end,
        { TextView;--文本控件
          layout_gravity='center';
          textSize='35dp';--文字大小
          text="+",
          style="blod",
          textColor='#FFFDFDFD';--文字颜色
        };
      },

      {MaterialCardView,
        layout_height="40dp",
        layout_width="40dp",
        radius="30dp",
        layout_margin="15dp",
        cardElevation="2",
        layout_gravity='bottom|right';
        cardBackgroundColor="#FF7E6086",
        layout_marginTop='-5dp',
        onClick=function()
          e=e*0.8
          pd=e*20
          星球缩放(星球a,e)
          星球缩放(星球b,e)
          星球缩放(星球c,e)
        end,
        { TextView;--文本控件
          layout_gravity='center';
          textSize='35dp';--文字大小
          text="-",
          style="blod",
          textColor='#FFFDFDFD';--文字颜色
        };
      },
    },
    {MaterialCardView,
      layout_height="40dp",
      layout_width="40dp",
      radius="30dp",
      layout_margin="15dp",
      cardElevation="2",
      layout_gravity='bottom|left';
      cardBackgroundColor="#FF7E6086",
      layout_marginTop='-5dp',
      onClick=function()
        about()
      end,
      { TextView;--文本控件
        layout_gravity='center';
        textSize='30dp';--文字大小
        text="i",
        style="blod",
        textColor='#FFFDFDFD';--文字颜色
      };
    },
    {
      LinearLayout,--线性布局
      orientation='vertical',--方向
      layout_width='fill',--宽度
      layout_height='wrap',--高度
      layout_gravity='center';
      background='#00FFFFFF',--背景颜色或图片路径
      { TextView;--文本控件
        layout_gravity='center';
        textSize='30dp';--文字大小
        text="Three-Planet System",
        style="blod",
        textColor='#FFFDFDFD';--文字颜色
        id="开始文字1",
      };
      { TextView;--文本控件
        layout_gravity='center';
        textSize='20dp';--文字大小
        text="by Duo",
        style="blod",
        textColor='#FFFDFDFD';--文字颜色
        id="开始文字2",
      };
    },
    {MaterialCardView,
      layout_height=pd,
      layout_width=pd,
      radius="30dp",
      cardElevation="2",
      cardBackgroundColor="#FFFEFEFE",
      id="星球a",--设置id
      onClick=function()
      end,
    },
    {MaterialCardView,
      layout_height=pd,
      layout_width=pd,
      radius="30dp",
      cardElevation="2",
      cardBackgroundColor="#FFFEFEFE",
      id="星球b",--设置id
      onClick=function()
      end,
    },
    {MaterialCardView,
      layout_height=pd,
      layout_width=pd,
      radius="30dp",
      cardElevation="2",
      cardBackgroundColor="#FFFEFEFE",
      id="星球c",--设置id
      onClick=function()
      end,
    },
    { TextView;--文本控件  
      textSize='13dp';--文字大小
      text="A",
      style="blod",
      textColor='#FFFDFDFD';--文字颜色
      id="at",
    };
    { TextView;--文本控件  
      textSize='13dp';--文字大小
      text="B",
      style="blod",
      textColor='#FFFDFDFD';--文字颜色
      id="bt",
    };
    { TextView;--文本控件  
      textSize='13dp';--文字大小
      text="C",
      style="blod",
      textColor='#FFFDFDFD';--文字颜色
      id="ct",
    };
    { LuaWebView;
      layout_width="0";
      layout_height="0";
      id="webview";
    },
  };
};
--this.uiManager.getFragment(0).view.addView(loadlayout(duo))
activity.setContentView(loadlayout(duo))
--背景音乐配置
webview.loadUrl("https://604511.ma3you.cn/articles/A0npeDO/")
webview.setWebViewClient(luajava.override(WebViewClient,{
  onLoadResource=function(superCall,view,url)
    if url:find(".mp3") then
      mediaPlayer = MediaPlayer()
      mediaPlayer.reset()
      mediaPlayer.setDataSource(url)
      mediaPlayer.prepare()
      mediaPlayer.setLooping(true)
      task(400,function()--1000毫秒=1秒
        mediaPlayer.start()
      end)
    end
  end,
}))
--构建路径
path1 = Path()
function onTouchEvent(v)
  if v.action==0--下笔状态
    path1.moveTo(v.x,v.y)--创建路径下笔位置
    x_b=v.x--屏幕移动开始位置
    y_b=v.y
   elseif v.getAction()==MotionEvent.ACTION_UP then--如果是松开事件
    sex=ex--保存屏幕移动位置
    sey=ey
   else
    path1.lineTo(v.x, v.y)--更新路径
    x_t=v.x--屏幕移动到的位置
    y_t=v.y
    ex=sex+0.8*(x_t-x_b)--屏幕变化量
    ey=sey+0.8*(y_t-y_b)
  end
end
function 星球缩放(view,to)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(view,"scaleX",{1.3*to,to}).setDuration(1).start()
  ObjectAnimator().ofFloat(view,"scaleY",{1.3*to,to}).setDuration(1).start()
end
patha = Path()--构建路径
patha.close()
直线画笔=Paint()--构建画笔
直线画笔.setColor(0xFF0000FF)--画笔颜色
直线画笔.setStyle(直线画笔.Style.STROKE)--设置画笔画出来的是线
直线画笔.setStrokeCap(直线画笔.StrokeCap.SQUARE)--优化圆角
直线画笔.setStrokeJoin(直线画笔.StrokeJoin.ROUND)--优化画线转折处的圆弧效果,
直线画笔.setStrokeWidth(5)--画笔宽度
直线画笔.setDither(true)--渲染优化
直线画笔.setAntiAlias(true)--渲染优化
pathb = Path()--构建路径
pathb.close()
直线画笔=Paint()--构建画笔
直线画笔.setColor(0xFF00FF00)--画笔颜色
直线画笔.setStyle(直线画笔.Style.STROKE)--设置画笔画出来的是线
直线画笔.setStrokeCap(直线画笔.StrokeCap.SQUARE)--优化圆角
直线画笔.setStrokeJoin(直线画笔.StrokeJoin.ROUND)--优化画线转折处的圆弧效果,
直线画笔.setStrokeWidth(5)--画笔宽度
直线画笔.setDither(true)--渲染优化
直线画笔.setAntiAlias(true)--渲染优化
pathc = Path()--构建路径
pathc.close()
直线画笔=Paint()--构建画笔
直线画笔.setColor(0xFFFF0000)--画笔颜色
直线画笔.setStyle(直线画笔.Style.STROKE)--设置画笔画出来的是线
直线画笔.setStrokeCap(直线画笔.StrokeCap.SQUARE)--优化圆角
直线画笔.setStrokeJoin(直线画笔.StrokeJoin.ROUND)--优化画线转折处的圆弧效果,
直线画笔.setStrokeWidth(5)--画笔宽度
直线画笔.setDither(true)--渲染优化
直线画笔.setAntiAlias(true)--渲染优化
--#############变量
--质量
ma=10--星球A质量
mb=20
mc=3
--力
fac=0--星球AC之间作用力
fab=0
fbc=0
facx=0--星球AC之间水平作用力
fabx=0
fbcx=0
facy=0--星球AC之间竖直作用力
faby=0
fbcy=0
--距离and位移
xac=0--初始化水平距离
xab=0
xbc=0
yac=0--初始化竖直距离
yab=0
ybc=0

xa=-200--初始化星球位置
ya=-200
xb=0
yb=-.1
xc=100
yc=200
--速度
vax=-100--初始化物体a在x方向的速度(可以改)
vay=100--初始化物体a在y方向的速度
vbx=50
vby=0
vcx=-50
vcy=100
--加速度
aax=0--初始化物体a在x方向的加速度
aay=0
abx=0
aby=0
acx=0
acy=10
--其他数值
G=6.67*10^4.8--万有引力常数(为了方便演示改动了此数值,G应的约为6.67*10^-11)
dt=0.01--刷新频率
t=0--初始化累积时间
--###############主程序
function 主程序()
  --计算距离
  xac=xc-xa
  xbc=xc-xb
  xab=xb-xa
  yac=yc-ya
  ybc=yc-yb
  yab=yb-ya
  rac=math.sqrt(xac^2+yac^2)
  rbc=math.sqrt(xbc^2+ybc^2)
  rab=math.sqrt(xab^2+yab^2)
  --相互作用力 f=(G*ma*mb)/(r^2),下面是分解,处理后的公式
  fac=(G*ma*mc)/(rac^2)--星球AC之间作用力
  fbc=(G*mb*mc)/(rbc^2)
  fab=(G*ma*mb)/(rab^2)
  facx=fac*(xac/rac)--星球AC之间x方向作用力
  fbcx=fbc*(xbc/rbc)
  fabx=fab*(xab/rab)
  facy=fac*(yac/rac)
  fbcy=fbc*(ybc/rbc)
  faby=fab*(yab/rab)
  fax=fabx+facx--星球a受到水平方向作用合力
  fbx=fabx+fbcx
  fcx=facx+fbcx
  fay=faby+facy
  fby=faby+fbcy
  fcy=facy+fbcy
  --计算加速度 a=f/m
  aax=fax/ma
  aay=fay/ma
  abx=fbx/mb
  aby=fby/mb
  acx=fcx/mc
  acy=fcy/mc
  --累积速度 v=v+a*dt
  vax=vax+aax*dt
  vay=vay+aay*dt
  vbx=vbx-abx*dt
  vby=vby-aby*dt
  vcx=vcx-acx*dt
  vcy=vcy-acy*dt
  --累积位移 x=x+v*dt
  xa=xa+vax*dt
  ya=ya+vay*dt
  xb=xb+vbx*dt
  yb=yb+vby*dt
  xc=xc+vcx*dt
  yc=yc+vcy*dt
end
--时间环境配置
主频=Ticker()
主频.Period=dt*1000--刷新时间
主频.onTick=function()
  t=t+dt
  主程序()
  星球a.setX(xa*e+w/2+ex)
  星球a.setY(ya*e+h/2+ey)
  at.setX(xa*e+w/2+ex)
  at.setY(ya*e+h/2+ey+pd)
  星球b.setX(xb*e+w/2+ex)
  星球b.setY(yb*e+h/2+ey)
  bt.setX(xb*e+w/2+ex)
  bt.setY(yb*e+h/2+ey+pd)
  星球c.setX(xc*e+w/2+ex)
  星球c.setY(yc*e+h/2+ey)
  ct.setX(xc*e+w/2+ex)
  ct.setY(yc*e+h/2+ey+pd)
  --path.moveTo(0,0)
  switch fp
   case 1
    patha.moveTo(xa*e+w/2+ex+pd/2,ya*e+h/2+ey+pd/2)
    patha.lineTo(xa*e+w/2+ex+pd/2,ya*e+h/2+ey+pd/2)--触摸屏幕更新路径
    画布背景.setBackground(LuaDrawable(function(画布,画笔)
      画布.drawPath(patha,直线画笔)
    end))
   case 2
    pathb.moveTo(xb*e+w/2+ex+pd/2,yb*e+h/2+ey+pd/2)
    pathb.lineTo(xb*e+w/2+ex+pd/2,yb*e+h/2+ey+pd/2)--触摸屏幕更新路径
    画布背景.setBackground(LuaDrawable(function(画布,画笔)
      画布.drawPath(pathb,直线画笔)
    end))
   case 3
    pathc.moveTo(xc*e+w/2+ex+pd/2,yc*e+h/2+ey+pd/2)
    pathc.lineTo(xc*e+w/2+ex+pd/2,yc*e+h/2+ey+pd/2)--触摸屏幕更新路径
    画布背景.setBackground(LuaDrawable(function(画布,画笔)
      画布.drawPath(pathc,直线画笔)
    end))
  end
  提示.setText("A:("..tostring(xa)..","..tostring(ya)..")\nB:("..tostring(xb)..","..tostring(yb)..")\nC:("..tostring(xb)..","..tostring(yb)..")")
end
--退出后结束运算
function onDestroy()
  主频.stop()
  print("Stop")
  mediaPlayer.stop()--停止播放
end

--延时开始
task(50,function()--1000毫秒=1秒
  --开始模拟
  print("Start")
  主频.start()
  al2=ObjectAnimator.ofFloat(提示,"alpha",{0,0.5,0.8,1})
  al2.setDuration(4000)
  al2.start()
  al3=ObjectAnimator.ofFloat(星球a,"alpha",{0,0.4,1})
  al3.setDuration(3000)
  al3.start()
  al4=ObjectAnimator.ofFloat(星球b,"alpha",{0,0.5,1})
  al4.setDuration(3000)
  al4.start()
  al6=ObjectAnimator.ofFloat(星球c,"alpha",{0,0.6,1})
  al6.setDuration(3000)
  al6.start()
  al6=ObjectAnimator.ofFloat(at,"alpha",{0,0.6,1})
  al6.setDuration(3000)
  al6.start()
  al6=ObjectAnimator.ofFloat(bt,"alpha",{0,0.6,1})
  al6.setDuration(3000)
  al6.start()
  al6=ObjectAnimator.ofFloat(ct,"alpha",{0,0.6,1})
  al6.setDuration(3000)
  al6.start()
end)
al1=ObjectAnimator.ofFloat(开始文字1,"alpha",{0,1,1,0.6,0})
al1.setDuration(50)
al1.start()
al5=ObjectAnimator.ofFloat(开始文字2,"alpha",{0,0.5,1,1,0})
al5.setDuration(50)
al5.start()
al7=ObjectAnimator.ofFloat(背景,"alpha",{0.3,0.6,0.8,1})
al7.setDuration(10)
al7.start()


function about()
  zipper={ LinearLayout,--线性布局
    orientation='0',--方向
    layout_width='fill',--宽度
    layout_height='wrap',--高度
    background='#00FFFFFF',--背景颜色或图片路径
    padding="12dp",
    { MaterialCardView;--卡片控件
      layout_width='fill',--宽度
      layout_height='wrap',--高度
      layout_gravity='bottom',
      CardBackgroundColor="#FF4C4CD1",
      radius='10dp';--圆角
      cardElevation=0,
      {LinearLayout,
        layout_width='fill',--宽度
        layout_height='match',--高度
        orientation=1,
        BackgroundColor="#FFC188BB",
        {FrameLayout,
          layout_width='fill',--宽度
          layout_height='match',--高度
          BackgroundColor="#FFC188BB",
          layout_marginTop="15dp",
          { MaterialCardView;--卡片控件
            layout_width='70dp',--宽度
            layout_height='70dp',--高度
            layout_gravity='center',
            radius='10dp';--圆角
            cardElevation=0,
            {ImageView,
              src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1",
              layout_width='fill',--宽度
              layout_height='fill',--高度
              layout_gravity='center',
            },
          },
        },
        {TextView,
          text="三体系统-宇宙环境模拟",
          layout_marginTop="15dp",
          textSize="23dp",
          layout_gravity="center",
          textStyle="bold",
          textColor='#FFFDFDFD';
        },
        {TextView,
          layout_margin="24dp",
          layout_height="wrap",
          textColor='#FFFDFDFD';
          text="",
          layout_width="wrap",
          id="txt",
        },
        {MaterialCardView,
          layout_height="wrap";
          layout_width="wrap";
          layout_margin="5dp",
          cardElevation="0dp",--卡片阴影强度
          radius="20dp",--卡片圆角幅度
          CardBackgroundColor="#FFC188BB",
          onClick=function()
            aboutduo.dismiss()--对话框消失
          end,
          { LinearLayout,
            orientation=0,
            layout_width="fill",
            {TextView,
              text="  关闭  ",
              textStyle="bold",
              layout_margin="10dp",
              textColor="#FFFFFFFF",
            },
          },
        },
      },
    },
  }
  aboutduo=AlertDialog.Builder(this)
  aboutduo.setView(loadlayout(zipper))
  --xxx.setCancelable(false)
  aboutduo=aboutduo.show()
  aboutduo.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))
  import "android.text.Html"
  import "android.text.method.LinkMovementMethod"
  html=[[利用计算机强大的计算能力，在二维平面内还原三体系统，体验天体物理的美妙。更多类似实验见:<a href='http://qr61.cn/oA1YZf/q9UnaCT' target="_blank" >Duo Nature</a>]]
  txt.setText(Html.fromHtml(html))
  txt.setMovementMethod(LinkMovementMethod.getInstance())
end
