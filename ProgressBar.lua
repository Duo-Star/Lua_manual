--更新：下载速度计算与时长预测
--ProgressBar合集及拓展玩法
--作者：Duo  QQ：113530014
--更新日志:
--       12.18 主框架与大部分功能
--       12.19 html嵌入
--       12.20 下载速度计算与时长预测




require "import"
import "android.os.*"
import "android.widget.*"
import "androidx.core.widget.NestedScrollView"
import "com.google.android.material.appbar.AppBarLayout"
import "com.google.android.material.appbar.CollapsingToolbarLayout"
import "android.view.*"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"
local RangeSlider = luajava.bindClass "com.google.android.material.slider.RangeSlider"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
local CoordinatorLayout = luajava.bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local Toolbar = luajava.bindClass "androidx.appcompat.widget.Toolbar"
local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
local MaterialButton = luajava.bindClass "com.google.android.material.button.MaterialButton"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"

local ProgressBar = luajava.bindClass "android.widget.ProgressBar"
local PorterDuffColorFilter = luajava.bindClass "android.graphics.PorterDuffColorFilter"
local PorterDuff = luajava.bindClass "android.graphics.PorterDuff"


h=activity.getHeight()--屏幕高
w=activity.getWidth()--屏幕宽

Duo=loadlayout
{ CoordinatorLayout;
  layout_width=-1;
  layout_height=-1;
  { AppBarLayout;
    backgroundColor=0xffFEFBFF;
    id="appBar";
    layout_width=-1;
    layout_height="160dp";
    { CollapsingToolbarLayout;
      expandedTitleMarginStart="7%w",
      layout_width=-1;
      layout_height=-1;
      layout_scrollFlags=3;
      backgroundColor=0xffFEFBFF;
      title="Progress";
      tooltipText="title",
      { Toolbar;
        id="toolbar",
        backgroundColor=0xffFEFBFF;
        layout_width=-1;
        layout_height="60dp";
      };
    },
  };
  {NestedScrollView,
    backgroundColor=0xffFEFBFF;
    layout_width=-1;
    layout_height=-1;
    layout_behavior="appbar_scrolling_view_behavior";
    { LinearLayout;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {NestedScrollView,
        backgroundColor=0xffFEFBFF;
        layout_width=-1;
        --layout_height="";
        { LinearLayout;
          layout_width="fill";
          layout_marginBottom='150dp';
          id="lay",
          orientation=1;
          layout_height="fill";--输入fill可能会出现白条
          { LinearLayout,--线性布局
            orientation='vertical',--方向
            layout_width='fill',--宽度
            layout_height='wrap',--高度
            background='#00FFFFFF',--背景
            {TextView,
              text="ProgressIndicator shows the progress of an undergoing process. It can represent adeterminate or indeterminate process in linear or circular form.\n --from Google",
              textSize="15dp",
              textColor="#444440",
              padding="2.5dp",
              layout_width='80%w',--宽度
              layout_height='wrap',--高度
              layout_margin='10dp';
              layout_gravity="center|left",
            },
            {TextView,
              text="ProgressIndicator显示正在进行的过程的进度。它可以用线性或圆形的形式表示确定或不定的过程。\n--来自谷歌",
              textSize="15dp",
              textColor="#444440",
              padding="2.5dp",
              layout_width='80%w',--宽度
              layout_height='wrap',--高度
              layout_margin='10dp';
              layout_gravity="center|left",
            },
            {MaterialCardView,
              layout_height="150dp",
              layout_width="80%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="圆形旋转加载条",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_margin='10dp';
                  layout_gravity="center",
                },
                { LinearLayout,--线性布局
                  orientation=0,--方向
                  layout_width='fill',--宽度
                  layout_height='fill',--高度
                  { ProgressBar,--进度条控件
                    layout_width="60dp",--布局宽度
                    layout_height="60dp",--布局高度
                    layout_margin='10dp';
                    layout_gravity="center|bottom",--重力属性--顶:top--中:center--左:left--右:right--底:bottom
                    id="进度条1",--控件ID
                    style="?android:attr/progressBarStyleLarge"
                  },
                  {TextView,
                    text="Using the most common and simplest load bar, it is very concise and elegant\n使用最普遍，最简单的加载条，它是十分简洁和优美的",
                    textSize="15dp",
                    textColor="#FF7A7A7A",
                    padding="2.5dp",
                    layout_margin='10dp';
                    layout_gravity="center|right",
                  },
                },
              },
            },
            {MaterialCardView,
              layout_height="250dp",
              layout_width="80%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="我会变色哦",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_margin='10dp';
                  layout_gravity="center",
                },
                { LinearLayout,--线性布局
                  orientation=0,--方向
                  layout_width='fill',--宽度
                  layout_height='fill',--高度
                  { ProgressBar,--进度条控件
                    layout_width="60dp",--布局宽度
                    layout_height="60dp",--布局高度
                    layout_margin='10dp';
                    layout_gravity="center|bottom",--重力属性--顶:top--中:center--左:left--右:right--底:bottom
                    id="进度条2",--控件ID
                    style="?android:attr/progressBarStyleLarge"
                  },
                  {TextView,
                    text="每次旋转会变换颜色(蓝>红>黄>绿)，TA并不在Google原生组件中，由Duo制作。",
                    textSize="15dp",
                    textColor="#FF7A7A7A",
                    padding="2.5dp",
                    layout_margin='10dp';
                    layout_gravity="center|right",
                  },
                },
                { LinearLayout,--线性布局
                  orientation=0,--方向
                  layout_width='fill',--宽度
                  layout_height='fill',--高度
                  { ProgressBar,--进度条控件
                    layout_width="60dp",--布局宽度
                    layout_height="60dp",--布局高度
                    layout_margin='10dp';
                    layout_gravity="center|bottom",--重力属性--顶:top--中:center--左:left--右:right--底:bottom
                    id="进度条2_1",--控件ID
                    style="?android:attr/progressBarStyleLarge"
                  },
                  {TextView,
                    text="每次旋转会随机变换颜色(随机模块由-二次元的智仙 提供。)",
                    textSize="15dp",
                    textColor="#FF7A7A7A",
                    padding="2.5dp",
                    layout_margin='10dp';
                    layout_gravity="center|right",
                  },
                },
              },
            },
            {MaterialCardView,
              layout_height="240dp",
              layout_width="90%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="水平进度条",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_gravity="center",
                },
                {TextView,
                  text="正常的ProgressBar",
                  textSize="15dp",
                  layout_marginTop='20dp';
                  textColor="#FF7A7A7A",
                  padding="2.5dp",
                  layout_gravity="center|left",
                },
                {ProgressBar,
                  id="进度条3",
                  style="?android:attr/progressBarStyleHorizontal";
                  layout_width="match",
                  max=100--最大进度值
                },
                {TextView,
                  text="具有缓冲效果的ProgressBar(by:Duo)",
                  textSize="15dp",
                  textColor="#FF7A7A7A",
                  layout_marginTop='20dp';
                  padding="2.5dp",
                  layout_gravity="center|left",
                },
                {ProgressBar,
                  id="进度条4",
                  style="?android:attr/progressBarStyleHorizontal";
                  layout_width="match",
                  max=10000--最大进度值
                },
                {TextView,
                  text="正在计算...",
                  textSize="15dp",
                  layout_marginTop='5dp';
                  textColor="#FF7A7A7A",
                  padding="2.5dp",
                  layout_gravity="center",
                  id="进度条信息",
                },
                {LinearLayout,
                  layout_width="match",
                  layout_height="70dp",
                  layout_marginBottom='60dp';
                  orientation=0,
                  gravity="right",
                  {MaterialButton,
                    id="b1",--设置id
                    text="-5%",
                    layout_gravity="right",
                    layout_marginRight="15dp",
                    layout_height="45dp",
                    layout_width="65dp",
                  },
                  {MaterialButton,
                    id="b2",--设置id
                    text="66.6%",
                    layout_gravity="left",
                    layout_marginRight="15dp",
                    layout_height="45dp",
                    layout_width="80dp",
                  },
                  {MaterialButton,
                    id="b3",--设置id
                    text="+5%",
                    layout_gravity="right",
                    layout_marginRight="15dp",
                    layout_height="45dp",
                    layout_width="65dp",
                  },
                },
              },
            },
            {MaterialCardView,
              layout_height="150dp",
              layout_width="90%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="Google水平动态加载条A",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_gravity="center",
                },
                {TextView,
                  text="使用两个白色的LinearLayout遮罩绿色的FrameLayout形成加载条图形(by:Duo)",
                  textSize="15dp",
                  textColor="#444440",
                  layout_marginTop='20dp';
                  padding="15dp",
                  layout_gravity="center",
                },
                { FrameLayout,--帧布局
                  layout_width='fill',--宽度
                  layout_height='wrap',--高度
                  background='#FFFFFFFF',--背景
                  { LinearLayout,--线性布局
                    orientation='vertical',--方向
                    layout_width='fill',--宽度
                    layout_height='10',--高度
                    background='#03DAC5',--背景
                    id="Progress2",
                  };
                  { LinearLayout,--线性布局
                    orientation='vertical',--方向
                    layout_width='fill',--宽度
                    layout_height='10',--高度
                    background='#FFFFFFFF',--背景
                    id="Progress1",
                  };
                };
              },
            },

            {MaterialCardView,
              --layout_height="200dp",
              layout_width="90%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="将HTML嵌入Lua也是个不错的选择",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_margin='0dp';
                  layout_gravity="center",
                },
                { LinearLayout,--线性布局
                  orientation=0,--方向
                  layout_width='fill',--宽度
                  layout_height='fill',--高度
                  {
                    LuaWebView;
                    layout_width='140dp';
                    layout_height='140dp';
                    id="webView";
                    layout_margin="15dp",
                  };
                  {TextView,
                    text="在Lua代码中嵌入HTML文本代码，形成加载框\n(很眼熟吧？蓝奏云下载动画)",
                    textSize="15dp",
                    textColor="#FF7A7A7A",
                    padding="2.5dp",
                    layout_margin='10dp';
                    layout_gravity="center|right",
                  },
                },
              },
            },
            {MaterialCardView,
              layout_height="150dp",
              layout_width="90%w",
              layout_gravity="center",
              radius="5dp",
              cardElevation="2dp",
              cardBackgroundColor="#FFFFFFFF",
              layout_margin='10dp';
              onClick=function()
              end,
              { LinearLayout,--线性布局
                orientation='vertical',--方向
                layout_width='fill',--宽度
                layout_height='wrap',--高度
                {TextView,
                  text="Google水平动态加载条B",
                  textSize="20dp",
                  textColor="#444440",
                  padding="2.5dp",
                  layout_gravity="center",
                },
                {TextView,
                  text="Horizontal-Style(终于找到你了)",
                  textSize="15dp",
                  textColor="#444440",
                  layout_marginTop='20dp';
                  padding="15dp",
                  layout_gravity="center",
                },
                {
                  ProgressBar,--进度条控件
                  layout_width="fill",--布局宽度
                  layout_height="20dp",--布局高度
                  indeterminate=true,
                  style="?android:attr/progressBarStyleHorizontal"
                };
              },
            },



          },
        },
      },
    },
  },
}
activity.contentView=Duo

function Progress(x1,x2)--位置函数
  Progress1.setX(-(w-x1*w))
  Progress2.setX(-(w-x2*w))
end
dt=0.003--刷新频率
t=0--初始化累计时间
主频1=Ticker()
主频1.Period=dt*1000
主频1.onTick=function()
  t=t+0.98*dt--累计时间
  Progress((t*0.9)^1.5005201314-1.40114514,t*0.7)--设置动画
end --皮一下(doge

辅助频1=Ticker()
辅助频1.Period=2.3*1000--周期
辅助频1.onTick=function()
  t=0--归零
end

进度条1.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(0xFF00DADA,PorterDuff.Mode.SRC_ATOP))--旋转形进度条颜色
function 变色(w)
  w=w%4
  switch w
   case 1
    duo_color=0xEC394CFF
   case 2
    duo_color=0xFFDA0041
   case 3
    duo_color=0xFFF0D800
   case 0
    duo_color=0xFF49A54C
  end
  进度条2.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(duo_color,PorterDuff.Mode.SRC_ATOP))--旋转形进度条颜色
end
function 随机色()
  --math.randomseed(os.clock()*1000000)
  local r=string.format("%02X",math.random(0,255))
  --math.randomseed(os.clock()*1000000)
  local g=string.format("%02X",math.random(0,255))
  --math.randomseed(os.clock()*1000000)
  local b=string.format("%02X",math.random(0,255))
  进度条2_1.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(tonumber("0xFF"..r..g..b),PorterDuff.Mode.SRC_ATOP))--旋转形进度条颜色
end
变色(1)
n_color=1
主频2=Ticker()
主频2.Period=(1.32)*1000
主频2.onTick=function()
  n_color=n_color+1
  变色(n_color)
  随机色()
end


dt4=0.01
p4=0
mp4=0
b1.onClick=function()
  if mp4<=500 then mp4=0 else mp4=mp4-500 end
  进度条3.incrementProgressBy(-5)
  if 主频4.isRun() then else
    主频4.start()
  end
end
b2.onClick=function()
  mp4=6.66*1000
  进度条3.progress=6.66*10--设置进度值
  if 主频4.isRun() then else
    主频4.start()
  end
end
b3.onClick=function()
  if mp4>=9500 then mp4=10000 else mp4=mp4+500 end
  进度条3.incrementProgressBy(5)
  if 主频4.isRun() then else
    主频4.start()
  end
end

function 计算信息()
  if p4==0 then x0=0 x1=p4*0.01 else x0=x1 x1=p4*0.01 end
  dx=x1-x0
  v=dx/1
  ft=(100-p4*0.01)/v
  if ft>=500 then ft=1/0 end
  if p4*0.01<=99 then
    进度条信息.setText("下载速度"..tostring(math.floor(v)).."%/s\n剩余时长:"..(math.floor(ft*10)*0.1).."s")
   else 进度条信息.setText("下载完成！")
  end
end

function 缓冲效果()
  v=(mp4-p4)*2.5
  p4=p4+dt4*v
  进度条4.progress=p4--设置进度值
end

主频3=Ticker()
主频3.Period=(1)*1000
主频3.onTick=function()
  计算信息()
end

主频4=Ticker()
主频4.Period=(dt4)*1000
主频4.onTick=function()
  缓冲效果()
end

html=[[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Demo</title>
<meta name="viewport" content="width=device-width">

<style type="text/css">   
/* http://meyerweb.com/eric/tools/css/reset/
   v2.0 | 20110126
   License: none (public domain)
*/
/* HTML5 display-role reset for older browsers */
article,
aside,
details,
figcaption,
figure,
footer,
header,
hgroup,
menu,
nav,
section {
  display: block;
}
body {
  line-height: 1;
}
ol,
ul {
  list-style: none;
}
blockquote,
q {
  quotes: none;
}
blockquote:before,
blockquote:after,
q:before,
q:after {
  content: '';
  content: none;
}
table {
  border-collapse: collapse;
  border-spacing: 0;
}
body {
  font-size: 62.5%;
  font-family: 'Lato', sans-serif;
  background: #0dcecb;
  color: #FFF;
}

/* inner */
.inner {
  width: 960px;
  margin:-45px auto 0 auto;
}
.load-container {
  border: 1px solid rgba(255, 255, 255, 0.2);
  width: 240px;
  height: 240px;
  float: left;
  position: relative;
  overflow: hidden;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}
.load-container a:link,
.load-container a:visited {
  position: absolute;
  bottom: 3px;
  font-size: 1.15em;
  text-align: center;
  left: 0;
  right: 0;
  text-decoration: none;
  color: #FFF;
}
.load-container a:link:hover,
.load-container a:visited:hover {
  text-decoration: underline;
}
.loader {
  -webkit-transform: translateZ(0);
  -moz-transform: translateZ(0);
  -ms-transform: translateZ(0);
  -o-transform: translateZ(0);
  transform: translateZ(0);
}
@media (max-width: 960px) {
  .inner {
    width: 480px;
  }
}
@media (max-width: 500px) {
  .inner {
    width: 100%;
  }
  .load-container {
    width: 100%;
  }
}
 </style>

</head>
<body>

<div class="inner">
	
	
	<style type="text/css">    
	.load2 .loader,
.load2 .loader:before,
.load2 .loader:after {
  border-radius: 50%;
}
.load2 .loader:before,
.load2 .loader:after {
  position: absolute;
  content: '';
}
.load2 .loader:before {
  width: 5.2em;
  height: 10.2em;
  background: #0dcecb;
  border-radius: 10.2em 0 0 10.2em;
  top: -0.1em;
  left: -0.1em;
  -webkit-transform-origin: 5.2em 5.1em;
  transform-origin: 5.2em 5.1em;
  -webkit-animation: load2 2s infinite ease 1.5s;
  animation: load2 2s infinite ease 1.5s;
}
.load2 .loader {
  font-size: 11px;
  text-indent: -99999em;
  margin: 5em auto;
  position: relative;
  width: 10em;
  height: 10em;
  box-shadow: inset 0 0 0 1em #FFF;
}
.load2 .loader:after {
  width: 5.2em;
  height: 10.2em;
  background: #0dcecb;
  border-radius: 0 10.2em 10.2em 0;
  top: -0.1em;
  left: 5.1em;
  -webkit-transform-origin: 0px 5.1em;
  transform-origin: 0px 5.1em;
  -webkit-animation: load2 2s infinite ease;
  animation: load2 2s infinite ease;
}
@-webkit-keyframes load2 {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}
@keyframes load2 {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}
	</style>
	<div class="load-container load2">
		<div class="loader">Loading...</div>
	</div>
</div>
</body>
</html>
]];
mimeType="text/html"
enCoding="utf-8"
webView.loadDataWithBaseURL(nil,html,mimeType,enCoding,nil)

主频1.start()
主频2.start()
主频3.start()
辅助频1.start()

function onDestroy()
  主频1.stop()
  辅助频1.stop()
  主频2.stop()
  主频4.stop()
end