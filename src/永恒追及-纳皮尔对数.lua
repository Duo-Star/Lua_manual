--更新: 修正错误

--数学可视化
--纳皮尔对数为缓冲视图(如:slider,progressbar)提供了一个很好的方案
--作者：Duo  QQ：113530014
--欢迎大家在评论区讨论与指出错误


require "import"
import "android.os.*"
import "android.widget.*"
import "com.google.android.material.slider.LabelFormatter"
import "com.google.android.material.slider.Slider"
import "com.google.android.material.slider.Slider"
import "android.content.res.ColorStateList"
import "android.widget.LinearLayout"
import "com.google.android.material.appbar.CollapsingToolbarLayout"
import "android.view.WindowManager"
import "com.google.android.material.slider.RangeSlider"
import "androidx.core.widget.NestedScrollView"
import "com.android.cglib.dx.rop.cst.CstArray$List"
import "java.util.List"
import "com.google.android.material.appbar.AppBarLayout"
import "androidx.appcompat.widget.Toolbar"
import "android.widget.Toolbar"
import "android.view.View"
import "android.widget.ProgressBar"
import "com.google.android.material.card.MaterialCardView"
import "android.widget.TextView"
import "androidx.coordinatorlayout.widget.CoordinatorLayout"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"
local RangeSlider = luajava.bindClass "com.google.android.material.slider.RangeSlider"
import "android.view.*"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"
local CoordinatorLayout = luajava.bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
import "androidx.core.widget.NestedScrollView"
import "com.google.android.material.appbar.AppBarLayout"
import "com.google.android.material.appbar.CollapsingToolbarLayout"
local Toolbar = luajava.bindClass "androidx.appcompat.widget.Toolbar"
import "com.google.android.material.slider.*"
local List = luajava.bindClass "java.util.List"
window = activity.getWindow()
window.setStatusBarColor(0xffFEFBFF)
window.setNavigationBarColor(0xffFEFBFF)
window.getDecorView().setSystemUiVisibility( View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
铎=loadlayout
{
  CoordinatorLayout;
  layout_width=-1;
  layout_height=-1;

  {
    AppBarLayout;
    backgroundColor=0xffFEFBFF;
    id="appBar";
    layout_width=-1;
    layout_height="160dp";

    {
      CollapsingToolbarLayout;
      expandedTitleMarginStart="7%w",
      layout_width=-1;
      layout_height=-1;
      layout_scrollFlags=3;
      backgroundColor=0xffFEFBFF;
      title="纳皮尔对数";
      tooltipText="title",
      {
        Toolbar;
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
        layout_height="90%h";

        {
          LinearLayout;
          layout_width="match_parent";
          id="lay",
          orientation="vertical";
          layout_height="fill";
          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
            id="题目"
          },
          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="刷新间隔(s)",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
          },
          {Slider,
            layout_gravity="center",
            layout_width="90%w";
            HaloTintList=ColorStateList.valueOf(0xaa44354280),--点击球周围波纹颜色
            ValueTo=0.5,
            --value=0.2,--当前值
            TickActiveTintList=ColorStateList.valueOf(0xffFEFBFF),--滑到的刻度颜色
            TickInactiveTintList=ColorStateList.valueOf(0xff354280),--未滑到的刻度颜色
            TrackInactiveTintList=ColorStateList.valueOf(0x33354280),--未滑到的轨道颜色
            ThumbTintList=ColorStateList.valueOf(0xff354280),--球的颜色
            TrackActiveTintList=ColorStateList.valueOf(0xdd354280),--滑过的轨道颜色
            StepSize=0.01,
            id="刷新",
          },

          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="长度为1的线段",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
          },
          {ProgressBar,
            id="进度条",
            style="?android:attr/progressBarStyleHorizontal";
            layout_width="match",
            --Visibility=8,
            paddingTop="20dp",
            max=10000 --最大进度值
          },
          {TextView,
            text="A - B",
            textSize="18dp",
            textStyle="bold",
          },

          {MaterialCardView,
            layout_height="wrap",
            layout_width="wrap",
            layout_margin="5dp",
            radius="5dp",
            cardElevation="3dp",
            cardBackgroundColor="#FF7485FF",
            id="启动",
            {TextView,
              text="    启动    ",
              textSize="15dp",
              textStyle="bold",
              padding="13dp",
              textColor="#FFFFFFFF",
              id="启动的字"
            },
          },

          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
            id="提示"
          },
          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
            id="解答"
          },
          {
            LinearLayout;
            layout_width="fill";
            orientation=0;
            BackgroundColor=0x0,
            layout_height="fill";
            {
              ImageView;--图片控件
              src='https://s1.ax1x.com/2022/11/09/xzq7h6.jpg';--图片路径
              layout_width='50%w';--宽度
              layout_height='60%w';--高度
              --scaleType='fitXY';--图片显示类型
            };
            {
              LuaWebView;
              layout_width='50%w';
              layout_height='60%w';
              id="webView";
            };
          },
          {
            LinearLayout;
            layout_width="fill";
            orientation=0;
            BackgroundColor=0x0,
            layout_height="fill";

            {TextView,
              text="    web    ",
              textSize="15dp",
              textStyle="bold",
              padding="17dp",
              layout_gravity="center|left",
              --textColor="#FFFFFFFF",
              id="txt"
            },
            {TextView,
              layout_marginTop="2dp",
              layout_marginLeft="7%w",
              text="作者：Duo  QQ：113530014\n欢迎大家指出问题共同进步！",
              textSize="17sp",
              layout_gravity="center|right",
              textColor=0xff354280,
              textStyle="bold",

            },
          },
        }
      }
    }
  }
}
activity.contentView=铎

import "android.text.Html"
import "android.text.method.LinkMovementMethod"
html=[[在Duo Nature上运行:<a href='http://qr61.cn/oA1YZf/q9UnaCT' target="_blank" >Duo Nature</a> <p></p> Desmos绘图<a href='https://www.desmos.com/calculator/4jphpb3wtb' target="_blank" >Desmos</a>]]
txt.setText(Html.fromHtml(html))
txt.setMovementMethod(LinkMovementMethod.getInstance())

html=[[<iframe src="https://www.desmos.com/calculator/cfra42myal?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>]];
mimeType="text/html"
enCoding="utf-8"
webView.loadDataWithBaseURL(nil,html,mimeType,enCoding,nil)
webView.getSettings().setJavaScriptEnabled(true);
webView.setLayerType(View.LAYER_TYPE_HARDWARE,nil);
webView.getSettings().setSupportZoom(true);
webView.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    --Url即将跳转
    task(20,function() webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut() end)

  end,
  onPageStarted=function(view,url,favicon)
    --网页即将加载
    task(20,function() webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut()webView.zoomOut() end)
  end,
}

刷新.addOnChangeListener({--改变事件
  onValueChange=function(view2,value2,bool2)
    ds=(tonumber(value2))*1000
  end
})
n=1
启动.onClick=function()
  if ds==nil then
    提示.setText("请设置刷新间隔")
   else
    if n%2==0
      then
      i=0
      启动的字.setText("   启动   ")
     else
      i=1
      开始()
      启动的字.setText("   暂停   ")
    end
    n=n+1
  end
end
function 开始()
  if i==0 then
   else
    task(ds,function()--1000毫秒=1秒
      --print("延时事件")
      --print()
      计算()
    end)
  end
end
x=0
t=0
function 计算()
  if ds==0 then
    print("你干嘛~")
   else
    v=10000-x
    t=t+ds*0.001
    进度条.incrementProgressBy(v*ds*0.001)
    x=x+v*ds*0.001
    提示.setText("时间："..t.."\n质点总位移："..(x*0.0001).."\n质点瞬时速度："..(v*0.0001))
    if x>9999.999 then
      i=0
      x=0
      v=0
      n=1
      启动的字.setText("   启动   ")
      进度条.progress=0--设置进度值
      提示.setText("")
      开始()
     else
      开始()
    end
  end
end
题目.setText("有一质点P，从A运动到B。P点的任意时刻速度大小等于P点未经过的距离。即V(P)=PB.\n\n这是一个十分有趣的问题，当P向右运动，PB趋于0，那么V(P)也就趋于0，P点将不断向0减速，位移向1增加，而PB永不重合。\n\n我们利用编程将其可视化，设置刷新间隔然后启动运算，你将看到它的模拟情景：\n")
解答.setText("\n\n事实上，x(P)=1-(1/e)^t 其中e为自然常数\n皮纳尔对数中，线段AB长度为10^7 ，下面是推导过程")
