
require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

import "com.google.android.material.snackbar.Snackbar"
import "com.google.android.material.card.MaterialCardView"
import "com.google.android.material.appbar.AppBarLayout"
import "android.graphics.Color"
import "android.graphics.Typeface"

activity.uiManager.appBarLayout.setTargetElevation(0)


local Slider = luajava.bindClass "com.google.android.material.slider.Slider"


duo=
{
  LinearLayout,
  layout_width="match",
  layout_height="match",
  Orientation=1,
  {
    Toolbar,
    layout_width="match",
    layout_height="wrap",
    title="波波波波波",
  },
  {
    LinearLayout,
    layout_width="fill",
    layout_height="fill",
    gravity="center",
   -- rotation="-90";
    Orientation=1,
    id="root",
  }
}
activity.setContentView(loadlayout(duo))


for n=1,15 do
  root.addView(loadlayout({
    Slider,--滑动条
    layout_width="250dp",
    layout_height="10dp",
    padding="-1dp",
    -- layout_gravity="left|center",
    id="slider_"..n,
    ValueFrom=-1000,
    Value=0,
    ValueTo=1000,
  }))

end



Env={}
Env.dt=0.01
Env.t=0
floor=math.floor
sin=math.sin


timer_=Ticker()
timer_.Period=Env.dt*1000
timer_.onTick=function()--执行事件
  Env.t=Env.t-Env.dt
  slider_1.setValue(floor(sin(Env.t)*1000))
  slider_2.setValue(floor(sin(Env.t+0.5)*1000))
  slider_3.setValue(floor(sin(Env.t+1)*1000))
  slider_4.setValue(floor(sin(Env.t+1.5)*1000))
  slider_5.setValue(floor(sin(Env.t+2)*1000))
  slider_6.setValue(floor(sin(Env.t+2.5)*1000))
  slider_7.setValue(floor(sin(Env.t+3)*1000))
  slider_8.setValue(floor(sin(Env.t+3.5)*1000))
  slider_9.setValue(floor(sin(Env.t+4)*1000))
  slider_10.setValue(floor(sin(Env.t+4.5)*1000))
  slider_11.setValue(floor(sin(Env.t+5)*1000))
  slider_12.setValue(floor(sin(Env.t+5.5)*1000))
  slider_13.setValue(floor(sin(Env.t+6)*1000))
  slider_14.setValue(floor(sin(Env.t+6.5)*1000))
  slider_15.setValue(floor(sin(Env.t+7)*1000))
end
timer_.start()
function onDestroy()--退出时执行
  timer_.stop()
end
