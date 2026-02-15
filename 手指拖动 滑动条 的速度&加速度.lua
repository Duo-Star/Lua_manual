--快来测测手指的速度&加速度
--极限，导数思想在编程中的应用
--作者：Duo  QQ：113530014
--#####  谁能教我如何把它们图像也画出来，谢谢   #####
require "import"
import "android.os.*"
import "android.widget.*"
import "com.google.android.material.slider.LabelFormatter"
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
Duo=loadlayout
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
      title="滑动条的滑动速度";
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
          layout_height="fill";--输入fill可能会出现白条
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
            text="快来滑动吧！",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
          },
          {Slider,--滑动条
            thumbRadius=40,
            layout_gravity="center",
            layout_width="95%w";
            HaloTintList=ColorStateList.valueOf(0xaa44354280),--点击球周围波纹颜色
            ValueTo=100,--最大值
            TickActiveTintList=ColorStateList.valueOf(0xffFEFBFF),--滑到的刻度颜色
            TickInactiveTintList=ColorStateList.valueOf(0xff354280),--未滑到的刻度颜色
            TrackInactiveTintList=ColorStateList.valueOf(0x33354280),--未滑到的轨道颜色
            ThumbTintList=ColorStateList.valueOf(0xff354280),--球的颜色
            TrackActiveTintList=ColorStateList.valueOf(0xdd354280),--滑过的轨道颜色
            StepSize=0,--设置刻度间隔
            id="主条",
          },
          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
            id="速度"
          },
          {TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="",
            textSize="17sp",
            textColor=0xff354280,
            textStyle="bold",
            id="加速度"
          },
        }
      }
    }
  }
}
activity.contentView=Duo
--触摸事件
主条.addOnSliderTouchListener({
  onStartTrackingTouch=function(view)
    --"开始触摸"
    开始()
  end,
  onStopTrackingTouch=function(view)
    --"停止触摸"
  end
})
--改变事件
主条.addOnChangeListener({
  onValueChange=function(view1,value1,bool1)
    x=tonumber(value1)
  end
})
刷新.addOnChangeListener({--改变事件
  onValueChange=function(view2,value2,bool2)
    ds=(tonumber(value2))*1000
  end
})
function 开始()
  if ds==nil or ds==0 then
    速度.setText("请设置刷新间隔！")
    print("请设置刷新间隔！")
   else
    task(ds,function()--1000毫秒=1秒
      --print("延时事件")
      --print()
      计算()
    end)
  end
end
n=0
--ds=0.2
function 计算()
  if ds==0 then
    print("你干嘛~")
   else
    if n==0 then
      x0=0
      x1=x
     else
      x0=x1
      x1=x
    end
    v=tostring((((x1)-(x0))/ds)*1000)
    --print(v)
    速度.setText("速度："..v)
    计算加速度()
    n=n+1
    开始()
  end
end
function 计算加速度()
  if n==0 then
    v0=0
    v1=v
   else
    v0=v1
    v1=v
  end
  a=tostring((((v1)-(v0))/ds)*100)
  --print(v)
  加速度.setText("加速度："..a)
end
