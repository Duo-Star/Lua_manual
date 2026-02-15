--关于丝滑这件事
--回应4195的求助

--欢迎加入我的QQ群组 663251235
require "import"
import "android.os.*"
import "android.widget.*"
import "android.content.Intent"
import "android.net.Uri"
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
local MaterialTextView = luajava.bindClass "com.google.android.material.textview.MaterialTextView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"


function dp2px(n)
  return n*activity.resources.displayMetrics.scaledDensity+.5
end


function m3c(s)
  return activity.getResources().getColor(android.R.color[s])
end

--Android 12 动态颜色 OR 默认颜色
if Build.VERSION.SDK_INT <31 then
  深色=0xFF546500
  浅色=0xaa546500
  背景色=0xFFFFFCF4
  顶栏颜色=0xFFEEEDDD
  边框颜色=0xFF767769
  文字色=0xFF4C4E41
 else
  背景色=m3c("system_neutral1_10")
  深色=m3c("system_accent1_600")
  浅色=m3c("system_accent1_100")
  文字色=m3c("system_neutral2_700")
  顶栏颜色=m3c("system_neutral2_50")
  边框颜色=m3c("system_neutral2_400")
end




Duo=loadlayout
{
  CoordinatorLayout;
  layout_width=-1;
  layout_height=-1;
  {
    AppBarLayout;
    backgroundColor=背景色;
    id="appBar";
    layout_width=-1;
    layout_height="160dp";
    {
      CollapsingToolbarLayout;
      expandedTitleMarginStart="7%w",
      layout_width=-1;
      layout_height=-1;
      layout_scrollFlags=3;
      backgroundColor=背景色;
      title="关于丝滑这件事";
      tooltipText="title",
      {
        Toolbar;
        id="toolbar",
        backgroundColor=背景色;
        layout_width=-1;
        layout_height="60dp";
      };
    },
  };
  {NestedScrollView,
    backgroundColor=背景色;
    layout_width=-1;
    layout_height=-1;
    layout_behavior="appbar_scrolling_view_behavior";
    { LinearLayout;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {NestedScrollView,
        backgroundColor=背景色;
        layout_width=-1;
        layout_height="90%h";
        {
          LinearLayout;
          layout_width="match_parent";
          id="lay",
          orientation="vertical";
          layout_height="fill";
          { TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="Slider",
            textSize="17sp",
            textColor=深色,
            textStyle="bold",
          },

          { Slider,
            thumbRadius=30,
            layout_gravity="center",
            layout_width="95%w";
            HaloTintList=ColorStateList.valueOf(0xaa44354280),--点击球周围波纹颜色
            ValueTo=100,
            TickActiveTintList=ColorStateList.valueOf(深色),--滑到的刻度颜色
            TrackInactiveTintList=ColorStateList.valueOf(浅色),--未滑到的轨道颜色
            ThumbTintList=ColorStateList.valueOf(深色),--球的颜色
            TrackActiveTintList=ColorStateList.valueOf(深色),--滑过的轨道颜色
            StepSize=0,
            id="slider",
          },

          { CheckBox,
            textColor=文字色,
            layout_marginTop="20dp",
            layout_gravity='center',
            id="box",
            --checked=true,
            text="动画效果",
            ButtonTintList=ColorStateList({{android.R.attr.state_checked},{}},{深色,0xffcccccc}),
          },

          { MaterialCardView,
            layout_height="40dp",
            radius="50dp",
            layout_margin="15dp",
            layout_gravity="center",
            cardBackgroundColor=深色,
            onClick=function()
              setProgress(0,box.checked)
            end,
            { MaterialTextView,
              layout_width="fill",
              layout_height="fill",
              text="   0%   ",
              textSize="13dp",
              textColor="#FFFFFFFF",
              layout_margin="10dp",
              gravity="center",
            },
          },

          { MaterialCardView,
            layout_height="40dp",
            radius="50dp",
            layout_margin="15dp",
            layout_gravity="center",
            cardBackgroundColor=深色,
            onClick=function()
              setProgress(11.4514,box.checked)
            end,
            { MaterialTextView,
              layout_width="fill",
              layout_height="fill",
              text="  11.4514%  ",
              textSize="13dp",
              textColor="#FFFFFFFF",
              layout_margin="10dp",
              gravity="center",
            },
          },

          { MaterialCardView,
            layout_height="40dp",
            radius="50dp",
            layout_margin="15dp",
            layout_gravity="center",
            cardBackgroundColor=深色,
            onClick=function()
              setProgress(77.777,box.checked)
            end,
            { MaterialTextView,
              layout_width="fill",
              layout_height="fill",
              text="  77.777%  ",
              textSize="13dp",
              textColor="#FFFFFFFF",
              layout_margin="10dp",
              gravity="center",
            },
          },

          { TextView,
            layout_marginTop="2dp",
            layout_marginLeft="7%w",
            text="原理：利用了指数衰减模型作为动画，Ticker提供刷新环境。设置进度使用setProgress(进度值,动画效果)",
            textSize="17sp",
            textColor=文字色,
            textStyle="bold",
          },

          { TextView,
            layout_marginTop="40dp",
            layout_marginLeft="7%w",
            text="广告",
            textSize="22sp",
            textColor=深色,
            textStyle="bold",
          },
          {
            MaterialCardView,
            radius="13dp",
            layout_margin="24dp",
            layout_width="fill",
            layout_height="wrap",
            cardElevation=0,
            strokeWidth=dp2px(1),
            strokeColor=0xffBDBDBD,
            {
              LinearLayout,
              orientation="vertical",
              layout_width="fill",
              layout_height="wrap",
              padding="16dp",
              {
                LinearLayout,
                layout_width="fill",
                layout_height="wrap",
                gravity="center",
                {
                  ImageView,
                  layout_width="150dp",
                  layout_height="150dp",
                  padding="16dp",
                  paddingStart="0",
                  colorFilter=primaryc,
                  src="https://i0.hdslb.com/bfs/new_dyn/93db847739fec3e44c5bdabb78af7cb31850079922.png@240w_240h_1c.webp",
                },
                {
                  MaterialTextView,
                  layout_width="fill",
                  paddingEnd="16dp",
                  text=[[GeoMKY
交互式几何工具，几何证明，程序绘图]],
                  textSize="17sp",
                },
              },

              { MaterialCardView,
                layout_marginTop="12dp",
                layout_gravity="end",
                layout_height="40dp",
                radius="50dp",
                cardBackgroundColor=深色,
                onClick=function()
                  activity.startActivity(Intent(Intent.ACTION_VIEW,Uri.parse("mqqapi://card/show_pslcard?src_type=internal&version=1&uin=663251235&card_type=group&source=qrcode")))
                end,
                { MaterialTextView,
                  layout_width="fill",
                  layout_height="fill",
                  text="     前往     ",
                  textSize="13dp",
                  textColor="#FFFFFFFF",
                  layout_margin="10dp",
                  gravity="center",
                },
              },
            },
          },


        }
      }
    }
  }
}
activity.contentView=Duo

slider.addOnChangeListener({
  onValueChange=function(view,value,bool)
    currentProgress=value
  end
})


dt=.005
targetProgress=0
currentProgress=0


function setProgress(p,i)
  if i then
    targetProgress=p
   else
    targetProgress=p
    currentProgress=p
  end
end


tk=Ticker()
tk.Period=dt*1000
tk.onTick=function()
  currentProgress=currentProgress+(targetProgress-currentProgress)*0.05
  slider.setValue(currentProgress)

end

tk.start()

function onDestroy()
  tk.stop()
end




