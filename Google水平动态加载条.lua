--Google水平动态加载条
--半天找不到，只好自己做一个
--作者:Duo  QQ:113530014

--如果大家有这个东西的原生组件，欢迎你的分享！
require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
h=activity.getHeight()--屏幕高
w=activity.getWidth()--屏幕宽
function 状态栏高度()
  if Build.VERSION.SDK_INT >= 19 then
    resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android")
    return activity.getResources().getDimensionPixelSize(resourceId)
   else
    return 0
  end
end
duo=
{
  LinearLayout,--线性布局
  orientation='vertical',--方向
  layout_width='fill',--宽度
  layout_height='wrap',--高度
  background='#00FFFFFF',--背景
  {
    FrameLayout,--帧布局
    layout_width='fill',--宽度
    layout_height='wrap',--高度
    background='#FFFFFFFF',--背景
    --layout_marginTop=状态栏高度(),
    {
      LinearLayout,--线性布局
      orientation='vertical',--方向
      layout_width='fill',--宽度
      layout_height='10',--高度
      background='#03DAC5',--背景
      id="Progress2",
    };
    {
      LinearLayout,--线性布局
      orientation='vertical',--方向
      layout_width='fill',--宽度
      layout_height='10',--高度
      background='#FFFFFFFF',--背景
      id="Progress1",
    };

  };
}
webView.addView(loadlayout(duo))
--activity.setContentView(loadlayout(duo))
w=w*1.3
function Progress(x1,x2)--位置函数
  Progress1.setX(-(w-x1*w))
  Progress2.setX(-(w-x2*w))
end
dt=0.003--刷新频率
t=0--初始化累计时间
主频=Ticker()
主频.Period=dt*1000
主频.onTick=function()
  t=t+0.98*dt--累计时间
  Progress((t*0.9)^1.5005201314-1.40114514,t*0.7)--设置动画
end --皮一下(doge
主频.start()
辅助频=Ticker()
辅助频.Period=2.3*1000--周期
辅助频.onTick=function()
  t=0--归零
end
辅助频.start()
function onDestroy()
  主频.stop()
  辅助频.stop()
end