--Duo Helper
--增加功能:一文,音乐,日历等
--作者：Duo  QQ：113530014
--更新：11.11大框架功能添加
--     11.12现在Duo能与人类交流聊天了
--     11.13优化细节
--     11.17全新升级，AI更名为"小彤"(大家猜猜她是谁(^-^))
--     11.20本人使用平板电脑编写，在手机上界面可能会有较大误差，现已修复界面漏洞
--     11.26不主动联系你的人工智能不是好人工智能，加入自动聊天功能
--     12.4优化自动回复
--     1.17增加功能:一文,音乐,日历等
--     2024.2.5更新api


require "import"
import "java.io.*"
import "android.os.*"
import "android.app.*"
import "android.view.*"
import "android.widget.*"
import "android.text.Html"
import "android.content.Context"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.View_*"
import "android.media.*"
import "android.view.*"
import "android.content.*"
import "java.io.*"
import "java.util.*"
import "android.content.Context"
import "android.provider.*"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.drawable.ColorDrawable"
import "androidx.cardview.widget.CardView"
import "android.widget.PopupMenu"
import "androidx.appcompat.widget.PopupMenu"
import "android.app.AlertDialog"

import "android.graphics.Paint"

--在此感谢→机不可失 提供的输入法不影响EditText视线方案
--activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)
local uiManager=this.uiManager
local themeConfig=uiManager.themeConfig
local colors=themeConfig.getColors()
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"
local SwitchMaterial = luajava.bindClass "com.google.android.material.switchmaterial.SwitchMaterial"
local MaterialCheckBox = luajava.bindClass "com.google.android.material.checkbox.MaterialCheckBox"
local ShapeableImageView = luajava.bindClass "com.google.android.material.imageview.ShapeableImageView"
function 复制文本(内容) import "android.content.Context" activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(内容)) end

大框架={
  LinearLayout,
  orientation="vertical";
  layout_width="fill",
  layout_height="fill",
  layout_weiget="1",
  background="#ffffffff",
  id="background",
  fitsSystemWindows=true;--防止输入法影响视图
  {
    LinearLayout;
    layout_width="fill",
    background="#ffffffff";
    {
      CircleImageView,
      layout_width="45dp",
      layout_height="45dp",
      src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
    };
    {
      TextView,
      text="Duo Helper";
      gravity="left|center";
      layout_width="fill";
      layout_height="45dp";
      layout_marginTop="0dp";
      textSize="20";
      layout_left="1";
      layout_marginLeft="2%w";
      backgroundColor="#FFffffff";
      textColor="#FF655478";
      layout_marginBottom="0dp";
      id="tittle"
    };
  };

  {
    LinearLayout,
    layout_width="fill",
    layout_height="fill",
    layout_weight="1dp",
    orientation="vertical",
    --backgroundColor="#FFF2F3F5";
    {
      ScrollView,
      id="scrollView",
      layout_width="fill",
      layout_height="fill",
      backgroundColor="#FFF2F3F5";

      {
        LinearLayout,
        paddingTop="15dp",
        paddingLeft="15dp",
        paddingRight="15dp",
        layout_width="fill",
        layout_height="fill",
        background="#FFF2F3F5",
        orientation="vertical",
        id="lt",
      },
    },
  },
  {
    LinearLayout,
    layout_width="fill",
    layout_height="65dp",
    orientation="horizontal",
    background='#FFF2F3F5';
    {
      LinearLayout;
      layout_width="fill";
      {
        CardView;
        layout_margin="10dp";
        layout_height="43dp";
        layout_width="fill";
        radius='6dp';--卡片圆角
        {
          EditText;
          id="edit";
          layout_marginLeft='10dp';--布局左距
          background="#FFFFFFFF";
          layout_gravity="center";
          gravity="left";
          textSize="16sp",--文本大小
          --  imeOptions="actionSearch";--设置键盘右下角操作
          id="发送内容",
          singleLine="true";
          Hint="你好，我是小彤…";
          layout_width="fill";
        };
        {
          Button;
          background="#FF10B124";
          layout_height="48dp";
          layout_gravity="center|right";
          textColor="#FFFFFFFF";
          layout_width="70dp";
          text="发送";
          id="sousuo";
          onClick="发送",
        };
        {
          LuaWebView;--浏览器控件
          layout_width='0';--宽度
          layout_height='0';--高度
          id="webView",
        };
      },
    };
  };
}


activity.setContentView(loadlayout(大框架))
--↑fa1
--this.uiManager.getFragment(0).view.addView(loadlayout(大框架))
--↑fa2
begain=
{
  LinearLayout,--线性布局
  orientation='vertical',--方向
  layout_width='fill',--宽度
  layout_height='wrap',--高度
  background='#FFF2F3F5',--背景颜色或图片路径
  {
    CardView;--卡片控件
    layout_gravity='center';--重力
    layout_height='20dp';--高度
    CardBackgroundColor='#FF707070';--颜色
    layout_marginBottom='10dp';
    radius='5dp';--圆角
    {
      TextView;--文本控件
      gravity='center';--重力
      --左:left 右:right 中:center 顶:top 底:bottom
      layout_width='fill';--宽度
      layout_height='fill';--高度
      textColor='#FFFFFFFF';--文字颜色
      text=("  "..os.date("%H")..":"..os.date("%M")..' 你添加了小彤现在可以开始聊天了  ');--显示文字
      textSize='14dp';--文字大小
    };
  };
}
lt.addView(loadlayout(begain))

function system_help()
  system_help_lay=
  {
    LinearLayout,--线性布局
    orientation='vertical',--方向
    layout_width='fill',--宽度
    layout_height='wrap',--高度
    background='#FFF2F3F5',--背景颜色或图片路径
    {
      CardView;--卡片控件
      layout_gravity='center';--重力
      layout_height='20dp';--高度
      --layout_width="match";
      CardBackgroundColor='#FF707070';--颜色
      layout_marginBottom='10dp';
      radius='5dp';--圆角
      {
        LinearLayout,--线性布局
        orientation=0,--方向
        layout_width='fill',--宽度
        layout_height='wrap',--高度
        {
          TextView;--文本控件
          gravity='center';--重力
          layout_width='fill';--宽度
          layout_height='fill';--高度
          textColor='#FFFFFFFF';--文字颜色
          text="不会和她聊天？",
          textSize='14dp';--文字大小
          paddingLeft="10dp",
        };
        {
          TextView;--文本控件
          gravity='center';--重力
          layout_width='fill';--宽度
          layout_height='fill';--高度
          textColor='#64B5F6';--文字颜色
          text="聊天宝典",
          textSize='14dp';--文字大小
          paddingRight="10dp",
          id="system_help_last_id",
          onClick=function()
            Ai_txt(ai_help_t)
          end,
        };
      },
    };
  }
  lt.addView(loadlayout(system_help_lay))
  system_help_last_id.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG)
end



function Ai_txt(str)
  RobotLayout=
  { LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {MaterialCardView,
      layout_width="45dp",
      layout_height="45dp",
      tooltipText="小彤",
      radius="50dp",
      cardElevation=0,
      onClick=function()
      end,
      { CircleImageView,
        id="systemtouxiang",
        layout_width="fill",
        layout_gravity="center";
        layout_height="fill",
        src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      };
    },
    { LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      layout_marginLeft="10dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="wrap",
        radius="10dp",
        cardElevation=0,
        cardBackgroundColor="#FFFFFFFF",
        onClick=function()
          --复制文本(xt_t.text)
          --print("复制成功")
        end,
        id="Ai_txt_card",
        {TextView,
          text=str;
          gravity="left|center";
          textSize="15dp",
          textStyle="bold",
          padding="13dp",
          id="xt_t",
          textColor="#FF5B5B5B",
          --textIsSelectable=true,--长按复制
        },
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  Ai_txt_card.onLongClick=function()
    复制文本(xt_t.text)
    print("复制成功")
    return true--防止触发点击事件
  end
  xt_t.setText(str)
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end

--Ai_music(str)




function Me_txt(str)--*************************用户
  MeLayout=
  { LinearLayout,
    layout_width="fill",
    gravity="top|right";
    orientation="horizontal",
    {
      LinearLayout,
      gravity="right";
      orientation="horizontal",
      layout_width="70%w",
      {MaterialCardView,
        layout_height="wrap",
        layout_width="wrap",
        radius="10dp",
        cardElevation=0,
        cardBackgroundColor="#FF10B124",
        layout_marginBottom="20dp";
        onClick=function()

        end,
        id="Me_txt_card",
        {TextView,
          text=str;
          gravity="left|center";
          textSize="15dp",
          textStyle="bold",
          padding="13dp",
          textColor=colors.colorPrimary,
          --textIsSelectable=true,--长按复制
        },
      },
    };
    { CircleImageView,
      id="usertouxiang",
      layout_width="45dp",
      layout_height="45dp",
      src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="Duo",
      layout_marginLeft="10dp";
    };
  }
  lt.addView(loadlayout(MeLayout))
  Me_txt_card.onLongClick=function()
    --复制文本(xt_t.text)
    --print("复制成功")
    return true--防止触发点击事件
  end
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end

-------------#####################################



function Ai_web(str)
  RobotLayout=
  {
    LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {
      CircleImageView,
      id="systemtouxiang",
      layout_width="40dp",
      layout_height="45dp",
      src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      --src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="小彤",
      layout_marginRight="10dp";
    };
    {
      LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="wrap",
        radius="10dp",
        cardElevation=0,
        --cardBackgroundColor=colors.colorAccent,
        onClick=function()
        end,
        {
          LuaWebView;--浏览器控件
          layout_width='fill';--宽度
          layout_height='80%w';--高度
          layout_margin="15dp";
          id="浏览器",
        };
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  浏览器.loadUrl(str)
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end


function Ai_date(str)
  RobotLayout=
  {
    LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {
      CircleImageView,
      id="systemtouxiang",
      layout_width="45dp",
      layout_height="45dp",
      src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      --src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="小彤",
      layout_marginRight="10dp";
    };
    {
      LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="70%w",
        radius="10dp",
        cardElevation=0,
        --cardBackgroundColor=colors.colorAccent,
        onClick=function()
        end,
        { LinearLayout,--线性布局
          orientation='vertical',--方向
          layout_width='70%w',--宽度
          layout_height='wrap',--高度
          {
            DatePicker,--日期选择器
            layout_width="70%w",
            layout_height="wrap",
          },
          {TextView,
            text="";
            gravity="left|center";
            textSize="15dp",
            textStyle="bold",
            padding="13dp",
            id="xt_t",
            textColor="#FF5B5B5B",
            textIsSelectable=true,--长按复制
          },
        },
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  Http.get("https://xiaoapi.cn/API/lt_xiaoai.php?type=json&msg="..发送内容.text,function(链接状态,网页源码)
    if 链接状态==200 then
      if string.find(网页源码,"小爱")~=nil then 网页源码=string.gsub(网页源码,"小爱","小彤") end
      if string.find(网页源码,"小米")~=nil then 网页源码=string.gsub(网页源码,"小米","Duo") end
      xt_t.setText (网页源码:match([["txt": "(.-)",]]))
     else
      xt_t.setText ("额，这样我怎么回答你…")
    end
  end)
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end



function Ai_story()
  RobotLayout=
  {
    LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {
      CircleImageView,
      id="systemtouxiang",
      layout_width="45dp",
      layout_height="45dp",
      src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      --src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="小彤",
      layout_marginRight="10dp";
    };
    {
      LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="80%w",
        radius="10dp",
        cardElevation=0,
        --cardBackgroundColor=colors.colorAccent,
        onClick=function()
        end,
        { LinearLayout,--线性布局
          orientation='vertical',--方向
          layout_width='80%w',--宽度
          layout_height='wrap',--高度
          {TextView,
            text="";
            layout_gravity="center";
            textSize="20dp",
            textStyle="bold",
            padding="13dp",
            id="xt_story_title",
            textColor="#FF5B5B5B",
          },
          {TextView,
            text="";
            gravity="left|center";
            textSize="15dp",
            padding="13dp",
            id="xt_story",
            textIsSelectable=true,--长按复制
          },
        },
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  url="https://meiriyiwen.com/random/iphone"
  Http.get(url,nil,"UTF-8",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      xt_story_title_t=content:match("%ph2%sclass%p%particleTitle%p%p%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s(.-)%p%ph2%p")
      xt_story_t=string.gsub(string.gsub(string.gsub(content:match("%pdiv%sclass%p%particleContent%p%p%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s(.-)%p%pdiv%p"),"%pp%p",""),"%p%pp%p",""),"%p","")
      --设置文字
      xt_story_title.setText(xt_story_title_t)
      xt_story.setText(xt_story_t)
     else
      xt_story.text="获取内容失败"..code
    end
  end)
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end



function Ai_wl(str)
  RobotLayout=
  {
    LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {
      CircleImageView,
      id="systemtouxiang",
      layout_width="45dp",
      layout_height="45dp",
      src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      --src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="小彤",
      layout_marginRight="10dp";
    };
    {
      LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="80%w",
        radius="10dp",
        cardElevation=0,
        --cardBackgroundColor=colors.colorAccent,
        onClick=function()
        end,
        { LinearLayout,--线性布局
          orientation='vertical',--方向
          layout_width='80%w',--宽度
          layout_height='wrap',--高度
          id="wl_l",
          {TextView,
            text="",
            gravity="left|center";
            textSize="15dp",
            textStyle="bold",
            padding="13dp",
            id="xt_t",
            textColor="#FF5B5B5B",
          },


        },
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  wl_r=math.random(1,4)
  switch wl_r
   case 1
    wl_l.addView(loadlayout({Slider}))
    xt_t.setText("无聊的话送你一个滑动条，滑动试试")
   case 2
    wl_l.addView(loadlayout({MaterialCheckBox}))
    xt_t.setText("无聊的话送你一个复选框")
   case 3
    wl_l.addView(loadlayout({SwitchMaterial}))
    xt_t.setText("无聊的话送你一个可爱的小开关")
   case 4
    wl_l.addView(loadlayout({ProgressBar}))
    xt_t.setText("无聊的话送你一个进度条，看着它，一会就不无聊了")
  end
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
end


function Ai_music(str)
  play_i=false--默认暂停播放
  RobotLayout=
  {
    LinearLayout,
    layout_width="85%w",
    layout_height="fill",
    orientation="horizontal",
    {
      CircleImageView,
      id="systemtouxiang",
      layout_width="45dp",
      layout_height="45dp",
      src="https://ss0.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3250396690,2919604218&fm=253&gp=0.jpg";
      --src="https://ncstatic.clewm.net/rsrc/2022/1111/21/df3aad15b7df8ab15b6daaeb6de4e3a2.png?x-oss-process=image/resize,w_270/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1";
      tooltipText="小彤",
      layout_marginRight="10dp";
    };
    {
      LinearLayout,
      id="system";
      layout_width="wrap",
      layout_height="-2",
      orientation="horizontal",
      layout_marginBottom="20dp";
      {MaterialCardView,
        layout_height="wrap",
        layout_width="80%w",
        radius="10dp",
        cardElevation=0,
        --cardBackgroundColor=colors.colorAccent,
        --onClick=function()
        ---end,
        {
          LinearLayout;
          --Focusable=true,
          gravity="center";
          --FocusableInTouchMode=true,
          id="bg",
          {
            LinearLayout,
            layout_height="wrap_content",
            layout_width="70%w",
            orientation=1,
            {TextView,
              text="Duo Music";
              layout_gravity="center";
              textSize="15dp",
              textStyle="bold",
              padding="13dp",
              id="mu_t",
              textColor="#FF5B5B5B",
            },
            {
              LinearLayout,
              layout_height="match",
              layout_width="fill",
              orientation="horizontal",
              gravity="center|bottom",
              layout_margin="10dp",
              layout_gravity="center",

              {MaterialCardView,
                layout_height="70dp",
                layout_width="70dp",
                radius="50dp",
                cardElevation=0,
                layout_margin="5dp",
                layout_gravity="center",
                --cardBackgroundColor="#5090CAF9",
                onClick=function()
                  上一曲()
                end,
                {
                  ShapeableImageView;--圆形图片
                  src='img/to_left.png';--图片路径
                  layout_gravity="center",
                  layout_width='40dp';--布局宽度
                  layout_height='40dp';--布局高度
                  alpha=0.7,
                },
              },
              {MaterialCardView,
                layout_height="70dp",
                layout_width="70dp",
                radius="50dp",
                cardElevation=0,
                layout_margin="5dp",
                layout_gravity="center",
                cardBackgroundColor="#5090CAF9",
                id="cen",
                onClick=function()
                  play_i=not(play_i)
                  switch play_i
                   case true play_img.setImageBitmap(loadbitmap("img/pause.png"))
                   case false play_img.setImageBitmap(loadbitmap("img/play.png"))
                  end
                  on_pause()
                end,
                {
                  ShapeableImageView;--圆形图片
                  src='img/play.png';--图片路径
                  layout_gravity="center",
                  layout_width='35dp';--布局宽度
                  layout_height='35dp';--布局高度
                  id="play_img",
                  alpha=0.7,
                },
              },
              {MaterialCardView,
                layout_height="70dp",
                layout_width="70dp",
                radius="50dp",
                cardElevation=0,
                layout_margin="5dp",
                layout_gravity="center",
                --cardBackgroundColor="#5090CAF9",
                onClick=function()
                  下一曲()
                end,
                {
                  ShapeableImageView;--圆形图片
                  src='img/to_right.png';--图片路径
                  layout_gravity="center",
                  layout_width='40dp';--布局宽度
                  layout_height='40dp';--布局高度
                  alpha=0.7,
                },
              },

            },
            {
              RelativeLayout,
              layout_width="fill_parent",
              layout_height="fill_parent",
              layout_margin="7dp",
              gravity="top|bottom",
              --  orientation="vertical",
              {
                LinearLayout,
                layout_height="wrap_content",
                layout_width="match_parent",
                orientation="vertical",
                id="mainLinearLayout1",
                gravity="bottom|center",
                layout_alignParentBottom=true,
                {
                  LinearLayout,
                  layout_height="wrap_content",
                  layout_width="match_parent",
                  orientation="horizontal",
                  -- layout_below="mainImageView1",
                  id="mainLinearLayout2",
                  gravity="center|bottom",
                  layout_marginBottom="10dp",
                  {
                    TextView,
                    layout_height="wrap_content",
                    text="00:00",
                    id="tv_startTime",
                    layout_width="wrap_content"
                  },
                  {
                    SeekBar,
                    layout_height="wrap_content",
                    --style="progressBarStyleHorizontal",
                    layout_width="wrap_content",
                    id="mainProgressBar1",
                    id="pb_time",
                    layout_weight="1.0"
                  },
                  {
                    TextView,
                    layout_height="wrap_content",
                    text="00:00",
                    id="tv_endTime",
                    layout_width="wrap_content"
                  },
                },
              },
            },
          },
        };
      },
    };
  }
  lt.addView(loadlayout(RobotLayout))
  scrollView.fullScroll(ScrollView.FOCUS_DOWN);
  local arr=nil
  local pd--扫描进度条变量,定义在这容易操作
  local mp=MediaPlayer()
  local t=nil
  local isPlay=false
  local curPlay=nil --当前正在播放的mp3的路径
  local listpath="/storage/emulated/0/Duo Music/歌单.txt"
  local tf=File(listpath)
  local dur--歌曲长度
  local cur--播放当前位置
  local min,sec=0,0--分和秒
  local curIdx=0--当前播放的mp3在列表中的索引

  --播放音乐，不异步可控
  --@mp MediaPlayer对象
  --@path 歌曲完整路径
  function play(mp,path)
    mp.reset()
    mp.setDataSource(path)
    mp.prepare()
    mp.start()
  end

  --异步调用代码块，获取文件夹下的所有mp3文件。并存在arr中
  local _getList=[[
require "import"
import "java.io.*"
local path,arr=...
local name,t

function _get(path)
  local f=File(path)
  local l=f.listFiles()
  for i=0,#l-1 do
    t=l[i]
    name= t.getName()
    if t.isFile() and string.find(string.lower(name),"%.mp3$") and t.length()>1024*1024*0.3 then --歌曲大于0m才添加
      arr.add(t)
    end
    if t.isFile() and string.find(string.lower(name),"%.m4a$") and t.length()>1024*1024*0.3 then --歌曲大于2m才添加
      arr.add(t)
    end
    if t.isFile() and string.find(string.lower(name),"%.wav$") and t.length()>1024*1024*0.3 then --歌曲大于2m才添加
      arr.add(t)
    end
    if t.isFile() and string.find(string.lower(name),"%.wma$") and t.length()>1024*1024*0.3 then --歌曲大于2m才添加
      arr.add(t)
    end
    if t.isFile() and string.find(string.lower(name),"%.mp4$") and t.length()>1024*1024*0.3 then --歌曲大于2m才添加
      arr.add(t)
    end
    if t.isDirectory() then
      _get(t.toString())
    end
  end --for
end --_get
_get(path)--重要......
]]

  --获取某文件夹下所有mp3文件。并存在arr中
  function getList(path)
    arr=ArrayList()
    task( _getList,path,arr,getListFinish)
  end
  --回调函数，获取某文件夹下所有mp3文件完成时被调用
  function getListFinish()
    writeFile("/storage/emulated/0/Duo Music/歌单.txt",arr)
    pd.cancel()
  end
  --写入文件
  --@path  文件完整路径
  --@list    ArrayList
  function writeFile(path,list)
    local fw=FileWriter(path)
    local bw=BufferedWriter(fw)
    for i=0,list.size()-1
      do
      str=list.get(i).toString()
      bw.write(str,0,utf8.len(str))
      bw.newLine()
    end
    bw.flush()
    bw.close()
  end
  --读文件
  --path 完整路径
  --return ArrayList
  function readFile(path)
    local al=ArrayList()
    local fr=FileReader(path)
    local br=BufferedReader(fr)
    local ch=0
    while(br.read()~=-1 )
      do
      al.add(br.readLine())
    end
    br.close()
    return al
  end

  --显示歌曲列表
  --@path 列表文件路径
  --@mediaplayer
  function showList(path,mp)
    local al= readFile(path)
    arr=al
    local names={}
    local paths={}
    for i=0,al.size()-1 do
      table.insert(paths,al.get(i))
      table.insert(names,File(al.get(i)).getName())
    end
    local ad= AlertDialog.Builder(activity)
    ad.setTitle("歌曲列表")
    ad.setItems(String(names)
    ,DialogInterface.OnClickListener{
      onClick=function(dialog,which)
        curPlay=paths[which+1]
        curIdx=which
        play(mp,curPlay)
        local tt=string.gsub(names[which+1],".mp3$","")--偷懒一下
        mu_t.setText(tt)
      end
    })
    ad.setNegativeButton( "取消", nil)
    ad.setNeutralButton("扫描",{onClick=function() showEditDialog("输入路径以重新扫描.") end})
    ad= ad.create()
    local window = ad.getWindow()
    local lp = window.getAttributes()
    lp.alpha = 1.0
    window.setAttributes(lp)
    ad.show()
  end
  function showProcessBar(text)
    pd = ProgressDialog
    .show(activity, nil, text)
    pd.setCancelable(false)
  end
  function showEditDialog(msg)
    local edit=EditText(activity)
    edit.setText("/storage/emulated/0/Duo Music/")
    local dl =AlertDialog.Builder(activity)
    dl.setTitle(msg)
    dl.setView(edit)
    dl.setPositiveButton("确定",
    DialogInterface.OnClickListener{
      onClick=function(dialog,which)
        showProcessBar("扫描中…")
        getList(edit.getText().toString())
      end
    })
    dl.show()
  end
  if tf.exists()==false then--文件列表不存在
    showEditDialog("初始化扫描音乐路径")
   else
    arr= readFile(listpath)
  end
  function updateTime(m,s)
    if m<10 then m="0"..m end
    if s<10 then s="0"..s end
    tv_startTime.setText(m..":"..s)
    pb_time.setProgress(mp.getCurrentPosition())
  end
  function _run(m,s)
    function run()
      s=s+1
      if(s==60) then
        m=m+1
        s=0
      end
      call("updateTime",m,s)
    end
  end
  function 上一曲()
    on_pre(v)
  end
  function on_pre(v)
    if(curIdx>0) then
      curIdx=curIdx-1
      play(mp,arr.get(curIdx))
      local tt=string.gsub(File(arr.get(curIdx)).getName(),".mp3$","")--偷懒一下
      mu_t.setText(tt)
    end
  end
  function 下一曲()
    on_next(v)
  end
  function on_next(v)
    if(curIdx<arr.size()-1) then
      if curIdx==0 and not mp.isPlaying() then
        curIdx=curIdx+1
        play(mp,arr.get(curIdx))
        local tt=string.gsub(File(arr.get(curIdx)).getName(),".mp3$","")--偷懒一下
        mu_t.setText(tt)
       else
        curIdx=curIdx+1
        play(mp,arr.get(curIdx))
        local tt=string.gsub(File(arr.get(curIdx)).getName(),".mp3$","")--偷懒一下
        mu_t.setText(tt)
      end
    end
  end
  mp.setOnCompletionListener(MediaPlayer.OnCompletionListener{
    onCompletion=function(mper)
      --print("歌曲播放结束")
      pb_time.setProgress(mp.getCurrentPosition())
      t.Enabled=false
      t.stop()
      t=nil
      on_next(v)
    end
  })
  function formatTime(time)
    local min,sec=0,0
    sec=math.floor(time/1000)
    if(sec>60) then
      min=math.floor(sec/60)
      sec=math.floor(sec%60)
    end
    if min<10 then min="0"..min end
    if sec<10 then sec="0"..sec end
    return min..":"..sec
  end
  --时间设置
  function setTime(time)
    local min,sec=0,0
    sec=math.floor(time/1000)
    if(sec>60) then
      min=math.floor(sec/60)
      sec=math.floor(sec%60)
    end
    return min,sec
  end
  --歌曲开始播放
  mp.setOnPreparedListener(MediaPlayer.OnPreparedListener{
    onPrepared=function(mper)
      dur=mper.getDuration()--获取歌曲的时长
      play_i=true
      play_img.setImageBitmap(loadbitmap("img/pause.png"))
      pb_time.setMax(dur)
      local tt=formatTime(dur)
      tv_startTime.setText("00:00")
      tv_endTime.setText(tt)
      min,sec=0,0
      if t~=nil then --计时器不为空就停止
        t.Enabled=false
        t.stop()
        t=nil
      end
      --歌曲开始播放又计时
      t=timer(_run,0,1000,min,sec)
      t.Enabled=true
    end
  })
  function 暂停()
    on_pause(v)
  end
  --按下暂停时发生
  function on_pause(v)
    if(mp.isPlaying()) then
      mp.pause()
      if(t~=nil) then
        t.Enabled=false
      end
     else
      if(t~=nil) then--如果为空那就是播放完了的情况
        mp.start()
        t.Enabled=true
      end
    end
  end
  cen.onLongClick=function()--长按事件
    showList(listpath,mp)
  end;
  function onKeyDown(code,event)
    if (code== KeyEvent.KEYCODE_BACK)then
      --并不会发生什么...
      if t~=nil then
        t.stop()
      end
      mp.stop()
      mp.release()--释放资源
    end
  end
  pb_time.setOnSeekBarChangeListener(
  SeekBar.OnSeekBarChangeListener{
    onStopTrackingTouch=function(bar)
      if mp.isPlaying() then
        local cur=bar.getProgress()
        local tt=formatTime(cur)
        min,sec=setTime(cur)
        tv_startTime.setText(tt)
        mp.seekTo(cur)
        if t~=nil then --计时器不为空就停止
          t.Enabled=false
          t.stop()
          t=nil
        end
        --重新计时
        t=timer(_run,0,1000,min,sec)
        t.Enabled=true
      end
    end
  })
end

function to(str)
  return str
end

function 获取网页文字(src)
  import"cjson"
  web=src
  webView.loadUrl(web)--加载网页
  webView.setWebViewClient{
    onPageFinished=function(view,url)
      task(1000,function()--1000毫秒=1秒
        webView.evaluateJavascript("_=()=>document.body.innerText;_()",{
          onReceiveValue=function(content)
            content=cjson.decode(content)
            if content==nil then print("错误:273") else
              to(content)--:match("(.-)")
              Ai_txt(content)
            end
          end,
        })
      end)
    end,
  }
end






function 延时回复(d)
  task(800,function()--1000毫秒=1秒
    Ai_txt(d)
  end)
end

ai_help_t=([[我是小彤，你的小助手。
 你可以对我说: 
1.  今天是几号
2.  www.google.cn (输入网址以浏览)
3.  打开钉钉
4.  我想听歌
5.  讲个故事
6.  好无聊
tips:不必严格按照此示例

你也可以跟我说:
1.  石家庄天气
2.  百科向心加速度
3.  搜索蔡徐坤
4.  打开手电&关闭手电
5.  do.print("Hello world")

不过，我更喜欢与人类聊天呢，
那样可以长很多见识！]])


function 发送()
  Me_txt(tostring(发送内容.getText()))

  if 发送内容.text=='' then
    Ai_txt([[我不太明白你的意思，输入"帮助"查看语法。]])

   elseif String(发送内容.text).startsWith("打开") then
    if String(发送内容.text).endsWith("微信") then 打开程序("com.tencent.mm")
     elseif String(发送内容.text).endsWith("QQ") then 打开程序("com.tencent.mobileqq")
     elseif String(发送内容.text).endsWith("微信扫一扫") then 微信扫一扫()
     elseif String(发送内容.text).endsWith("手电") then 手电(1)
     else 启动应用((发送内容.text):match("打开(.+)"))
    end
    Ai_txt('收到！已打开')
   elseif 发送内容.text=='关闭手电' then
    手电(0)
    Ai_txt([[收到！已关闭]])
   elseif String(发送内容.text).startsWith("搜索")
    Ai_web("https://m.baidu.com/s?from=1022282z&word="..(发送内容.text):match("搜索(.+)"))
   elseif String(发送内容.text).startsWith("浏览")
    Ai_web((发送内容.text):match("浏览(.+)"))--加载网页
   elseif String(发送内容.text).startsWith("百科")
    获取网页文字("https://baike.baidu.com/item/"..(发送内容.text):match("百科(.+)"))--加载网页
   elseif String(发送内容.text).startsWith("http") or String(发送内容.text).startsWith("www.") or String(发送内容.text).endsWith(".com") or String(发送内容.text).endsWith(".cn") or String(发送内容.text).endsWith(".org") or String(发送内容.text).endsWith(".xyz") or String(发送内容.text).endsWith(".top") or String(发送内容.text).endsWith(".html") then
    Ai_web(发送内容.text)
   elseif tostring(发送内容.text):find("日期")~=nil or tostring(发送内容.text):find("几号")~=nil or tostring(发送内容.text):find("什么日子")~=nil then
    Ai_date()
   elseif tostring(发送内容.text):find("音乐")~=nil or tostring(发送内容.text):find("听歌")~=nil then
    Ai_music(str)
   elseif tostring(发送内容.text):find("无聊")~=nil then
    Ai_wl()
   elseif tostring(发送内容.text):find("讲故事")~=nil or tostring(发送内容.text):find("讲个故事")~=nil then
    Ai_story()
   elseif String(发送内容.text).startsWith("do.") then
    assert(loadstring((发送内容.text):match("do.(.+)")))()
   elseif 发送内容.text=='帮助' then



   elseif 发送内容.text=='你好' then
    xiaoxi=[[你好呀！我是小彤]]
    延时回复(xiaoxi)



   elseif 发送内容.text=='别来无恙啊，' then
    xiaoxi=[[挺好，你呢]]
    延时回复(xiaoxi)

   elseif 发送内容.text=='清空聊天记录' then
    activity.finish()
    activity.startFusionActivity("a")--手册里不支持

   else
   --[[
    Http.get("https://xiaoapi.cn/API/lt_xiaoai.php?type=json&msg="..发送内容.text,function(链接状态,网页源码)
      ]]
      Http.get("http://api.qingyunke.com/api.php?key=free&appid=0&msg="..发送内容.text,function(链接状态,网页源码)

      if 链接状态==200 then
        if string.find(网页源码,"小爱")~=nil then 网页源码=string.gsub(网页源码,"小爱","小彤") end
        if string.find(网页源码,"小米")~=nil then 网页源码=string.gsub(网页源码,"小米","Duo") end
        Ai_txt(网页源码:match([[content":"(.-)"}]]))
       else
        Ai_txt ("额，这样我怎么回答你…")
      end
    end)


  end
  发送内容.setText("")--清空输入框
end

发送内容.setText("")



function 联网()
  Http.get("https://xiaoapi.cn/API/lt_xiaoai.php?type=json&msg="..发送内容.text,function(链接状态,网页源码)
    if 链接状态==200 then
      if string.find(网页源码,"小爱")~=nil then 网页源码=string.gsub(网页源码,"小爱","小彤") end
      if string.find(网页源码,"小米")~=nil then 网页源码=string.gsub(网页源码,"小米","Duo") end
      return (网页源码:match([["txt": "(.-)",]]))
     else
      return ("额，这样我怎么回答你…")
    end
  end)
end


function 打开程序(packageName)
  import "android.content.Intent"
  import "android.content.pm.PackageManager"
  manager = activity.getPackageManager()
  open = manager.getLaunchIntentForPackage(packageName)
  this.startActivity(open)
end

function 启动应用(名称)
  for jdpuk in each(this.packageManager.getInstalledApplications(0))do
    if 名称==this.packageManager.getApplicationLabel(jdpuk)then
      this.startActivity(this.packageManager.getLaunchIntentForPackage(jdpuk.packageName))
      return
    end
  end
end

function 微信扫一扫()
  import "android.content.Intent"
  import "android.content.ComponentName"
  intent = Intent()
  intent.setComponent(ComponentName("com.tencent.mm","com.tencent.mm.ui.LauncherUI"))
  intent.putExtra("LauncherUI.From.Scaner.Shortcut",true)
  intent.setFlags(335544320)
  intent.setAction("android.intent.action.VIEW")
  activity.startActivity(intent)
end

function 手电(b)
  if b==1 then
    local CameraManager=this.getSystemService(Context.CAMERA_SERVICE)
    CameraManager.setTorchMode("0",true)
   else
    local CameraManager=this.getSystemService(Context.CAMERA_SERVICE)
    CameraManager.setTorchMode("0",false)
  end
end

function 天气(e)
  if e==nil then e="石家庄" end
  Http.get("https://api.ooomn.com/api/weather?city="..e,nil,function(a,b)--手动定位
    --Http.get("https://api.ooomn.com/api/weather?city=",nil,function(a,b)--自动定位
    if a==200 then
      地点=b:match('"city": "(.-)",')
      天气状态=b:match('"wea": "(.-)",')
      风向=b:match('"win": "(.-)",')
      风向等级=b:match('"win_speed": "(.-)",')
      实时温度=b:match('"tem": "(.-)",')
      最高温度=b:match('"tem_day": "(.-)",')
      最低温度=b:match('"tem_night": "(.-)",')
      xiaoxi=("报告：\n"..地点.."今天："..天气状态.."，\n"..风向..风向等级.."，"..最低温度.."~"..最高温度.."\n现在"..实时温度)
      Ai_txt(1)
    end
  end)
end

延时回复("你好，我是小彤")
--xiaoxilist={"你好，我是小彤","试试对我说:打开微信","试试对我说:北京天气","试试对我说:搜索lua","试试对我说:do.print('你好')","试试对我说:浏览http://www.google.cn","我是小彤,Duo的小助手,将来会在Duo Nature、Duo Music、Duo Star...上与大家见面","这么好的开发者，赶紧去关注啊"}
task(1200,function()
  --延时回复(xiaoxilist[math.random(1,#xiaoxilist)])
  system_help()
end)