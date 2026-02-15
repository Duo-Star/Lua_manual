--二维双星系统
--更新！增加屏幕移动和缩放功能
--物理宇宙环境lua模拟
--作者:Duo  QQ:113530014
--本人高一学生，还没有讲到天体物理，如有不正，敬请指出！
--更新日志:
--       12.9 11h 程序框架编写
--       12.9 15h 宇宙环境优化，像诗一样优美(๑>؂<๑）
--       12.9 17h 增加声音功能(from space)
--       12.10 12h 增加屏幕移动和缩放功能


--###怎么让它们"拉线"？我不会，等待评论区高手###
--***温馨提示:此项目有背景音乐，点击右上角按钮可关闭***
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
pd=e*20
duo=
{ FrameLayout,--线性布局
  --orientation='vertical',--方向
  layout_width='fill',--宽度
  layout_height='fill',--高度
  background='#FF5C2664',--背景颜色或图片路径
  id="背景",
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
      text="Two planets system",
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
    { TextView;--文本控件
      layout_gravity='center';
      textSize='14dp';--文字大小
      text="\n此项目有背景音乐，请注意调节音量",
      style="blod",
      textColor='#FFFDFDFD';--文字颜色
      id="开始文字3",
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
  { LuaWebView;
    layout_width="0";
    layout_height="0";
    id="webview";
  },
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
      task(4000,function()--1000毫秒=1秒
        mediaPlayer.start()
      end)
    end
  end,
}))
--#############变量
--质量
ma=3--星球A质量
mb=7--星球B质量
--力
fx=0--初始化x方向作用力
fy=0--初始化y方向作用力
--距离and位移
x=0--初始化水平距离(默认0，不要改)
y=0
xa=120--初始化星球位置(可以改)
ya=200
xb=-180
yb=-50
--速度
vax=-30--初始化物体a在x方向的速度(可以改)
vay=-290--初始化物体a在y方向的速度
vbx=20
vby=120
--加速度
aax=0--初始化物体a在x方向的加速度
aay=0--初始化物体a在y方向的加速度
abx=0
aby=0
G=6.67*10^6--万有引力常数(为了方便演示改动了此数值,G应的约为6.67*10^-11)
dt=0.01--刷新频率
t=0--初始化累积时间
--###############主程序
function 主程序()
  --计算距离
  x=(xb-xa)
  y=(yb-ya)
  r=math.sqrt(x^2+y^2)
  f=math.sqrt(fx^2+fy^2)
  --相互作用力 f=(G*ma*mb)/(r^2),下面是分解,处理后的公式
  fx=(G*ma*mb*x)/(r^3)
  fy=(G*ma*mb*y)/(r^3)
  --计算加速度 a=f/m
  aax=fx/ma
  aay=fy/ma
  abx=-fx/mb
  aby=-fy/mb
  --累积速度 v=v+a*dt
  vax=vax+aax*dt
  vay=vay+aay*dt
  vbx=vbx+abx*dt
  vby=vby+aby*dt
  --累积位移 x=x+v*dt
  xa=xa+vax*dt
  ya=ya+vay*dt
  xb=xb+vbx*dt
  yb=yb+vby*dt
end
--时间环境配置
主频=Ticker()
主频.Period=dt*1000--刷新时间
主频.onTick=function()
  t=t+dt
  主程序()
  星球a.setX(xa*e+w/2+ex)
  星球a.setY(ya*e+h/2+ey)
  星球b.setX(xb*e+w/2+ex)
  星球b.setY(yb*e+h/2+ey)
  提示.setText("距离大小:"..tostring(r).."\n相互作用力大小:"..tostring(xa).."\nXa:"..tostring(xa).."\nYa:"..tostring(ya).."\nXb:"..tostring(xb).."\nYb:"..tostring(yb))
end
--退出后结束运算
function onDestroy()
  主频.stop()
  print("Stop")
  mediaPlayer.stop()--停止播放
end
--构建路径
path = Path()
function onTouchEvent(v)
  if v.action==0--下笔状态
    path.moveTo(v.x,v.y)--创建路径下笔位置
    x_b=v.x--屏幕移动开始位置
    y_b=v.y
   elseif v.getAction()==MotionEvent.ACTION_UP then--如果是松开事件
    sex=ex--保存屏幕移动位置
    sey=ey
   else
    path.lineTo(v.x, v.y)--更新路径
    x_t=v.x--屏幕移动到的位置
    y_t=v.y
    ex=sex+0.8*(x_t-x_b)--屏幕变化量
    ey=sey+0.8*(y_t-y_b)
  end
end
--延时开始
task(4321,function()--1000毫秒=1秒
  --开始模拟
  print("Start")
  主频.start()
  al2=ObjectAnimator.ofFloat(提示,"alpha",{0,0.5,0.8,1})
  al2.setDuration(4000)
  al2.start()
  al3=ObjectAnimator.ofFloat(星球a,"alpha",{0,0.8,1})
  al3.setDuration(3000)
  al3.start()
  al4=ObjectAnimator.ofFloat(星球b,"alpha",{0,0.8,1})
  al4.setDuration(3000)
  al4.start()
end)
al1=ObjectAnimator.ofFloat(开始文字1,"alpha",{0,1,1,0.6,0})
al1.setDuration(5500)
al1.start()
al5=ObjectAnimator.ofFloat(开始文字2,"alpha",{0,0.5,1,1,0})
al5.setDuration(5500)
al5.start()
al6=ObjectAnimator.ofFloat(开始文字3,"alpha",{0,0,0.7,1,0})
al6.setDuration(5500)
al6.start()
al7=ObjectAnimator.ofFloat(背景,"alpha",{0.3,0.6,0.8,1})
al7.setDuration(1500)
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
          text="双星系统-宇宙环境模拟",
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
          text="利用计算机强大的计算能力，在二维平面内还原双星系统，体验天体物理的美妙。\n更多类似实验见:Duo Nature\nby Duo",
          layout_width="wrap",
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
end
