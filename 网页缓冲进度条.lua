--网页缓冲进度条
--原生webView进度条卡爆了，浏览网页，必须要优雅！ ##重构:进度监听+数据缓冲处理
--作者:Duo  QQ:113530014
require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
local AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION) activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0x0)
duo=loadlayout
{ LinearLayout;
  layout_height="fill";
  layout_width="fill";
  orientation="vertical";
  { AppBarLayout,
    layout_width="fill",
    {LinearLayout,
      layout_width="fill",
      layout_height="fill",
      orientation=1,
      backgroundColor="#FFFFFFFF";
      { MaterialTextView,
        text="缓冲加载进度条by Duo",
        textStyle="bold",
        paddingBottom="5dp",
        paddingTop="10dp",
        paddingLeft="10dp",
        textSize="19sp",
      },
      { ProgressBar;
        layout_width="fill",
        paddingBottom="-6.5dp",
        style="?android:attr/progressBarStyleHorizontal",
        id="p2",
        max=10000,
      };
    },
  },
  { LuaWebView;
    id="webView";
    layout_height="fill";
    layout_width="match";
    layout_marginBottom='-20%w';
    { ProgressBar;
      id="p1";
      layout_height="0";
      layout_width="0";
    };
  };
};
activity.setContentView(duo)
webView.setProgressBar(p1)
webView.loadUrl("http://qr61.cn/oA1YZf/q9UnaCT")
webView.getSettings().setSupportZoom(true)
webView.getSettings().setLoadWithOverviewMode(true)
webView.getSettings().setDisplayZoomControls(false)
webView.getSettings().setLoadsImagesAutomatically(true)
webView.getSettings().setUseWideViewPort(true)
webView.getSettings().setJavaScriptEnabled(true)
function alpha(w)
  switch w
   case 0
    local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
    al=ObjectAnimator.ofFloat(p2,"alpha",{1,0})
    al.setDuration(1000)
    al.start()
   case 1
    local ObjectAnimator = luajava.bindClass "android.animation.ObjectAnimator"
    al=ObjectAnimator.ofFloat(p2,"alpha",{0,1})
    al.setDuration(500)
    al.start()
  end
end
dt=0.01
t=0
P=0
n=0
主频=Ticker()
主频.Period=dt*1000
主频.onTick=function()
  t=t+dt
  p=(webView.getProgress())*100
  if p>=6000 then
    p=10000
    if n==0 and P>9000 then alpha(0) n=n+1 end
  end
  v=(p-P)*5 P=P+dt*v p2.progress=P--灵魂所在
end
主频.start()
function onDestroy() 主频.stop() end
webView.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    alpha(1)
  end,
  onPageStarted=function(view,url,favicon)
    n=0
  end,
}
--100行，完美收官