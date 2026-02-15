--作者：Duo  QQ:113530014
--使用请保留作者信息。代码冰冷，愿人有情

--谷歌翻译倒下了，国产翻译顶上去！！
--本教程利用小米翻译https://translator.ai.xiaomi.com进行翻译

import"android.content.pm.ActivityInfo"
activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR)
--设置按钮动画
function 水珠动画(view,time)
  import "android.animation.ObjectAnimator"
  ObjectAnimator().ofFloat(view,"scaleX",{1.1,.9,1,.9,1}).setDuration(time).start()
  ObjectAnimator().ofFloat(view,"scaleY",{1.1,.9,1,.9,1}).setDuration(time).start()
end
--获取状态栏和导航栏高度
function getStatusBarHeight()--函数
  local resources=activity.getResources();
  local resourceId=resources.getIdentifier("status_bar_height","dimen","android");
  local height=resources.getDimensionPixelSize(resourceId);
  return height;
end
--正文内容开始
duo=
{
  LinearLayout;--线性控件
  orientation="vertical";--布局方向
  layout_height="fill";--布局宽度
  layout_width="fill";--布局宽度
  BackgroundColor="#FFFFFF";--背景颜色
  {
    ImageView,
    layout_height="wrap_content",
    layout_width="wrap_content",
    --id="",
    -- src="back",
    layout_margin="15dp",
    --layout_centerHorizontal=true,
    --layout_centerVertical=true
  },
  {
    TextView;--文本控件
    gravity='top';--重力
    --左:left 右:right 中:center 顶:top 底:bottom
    layout_width='fill';--宽度
    layout_height='100';--高度
    textColor='0xff1e8ae8';--文字颜色
    text='Translate';--显示文字
    textSize='25dp';--文字大小
    --textIsSelectable=true--长按复制
    layout_marginLeft=(50);--左距
  };
  {
    LinearLayout;
    orientation="vertical";
    layout_width="fill";
    {
      LinearLayout,--线性布局

      orientation="vertical",--布局方向
      layout_width="fill",--布局宽度
      layout_height="wrap",--布局高度
      background="#ffffffff",--布局背景
      elevation="1dp",--阴影层次
    },--线性布局 结束
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {
        LinearLayout;
        layout_height="0dp";
        gravity="top";
        orientation="vertical";
        layout_width="fill";
      };
      {
        LinearLayout;
        layout_width="fill";
        {
          CardView;
          layout_margin="20dp";
          layout_height="48dp";
          layout_width="fill";
          radius='8dp';--卡片圆角
          {
            EditText;
            id="edit";
            layout_marginLeft='10dp';--布局左距
            background="#FFFFFFFF";
            layout_gravity="center";
            gravity="left";
            textSize="16sp",--文本大小
            --  imeOptions="actionSearch";--设置键盘右下角操作
            singleLine="true";
            Hint="输入翻译内容...";
            layout_width="fill";
          };
          {
            Button;
            background="#FFFFFFFF";
            layout_height="48dp";
            layout_gravity="right";
            textColor="#FF000000";
            layout_width="70dp";
            text="翻译";
            id="sousuo";
            onClick=function()
              水珠动画(sousuo,150)
              if edit.text=="" then
                print("请输入翻译内容")
               else
                print("正在翻译中…")
                翻译()
              end
            end,
          };
        };
      };
    };
    {
      LinearLayout;
      orientation="vertical";
      layout_height="fill";
      layout_width="fill";
      {
        ListView,
        id="列表",
        layout_height="-1",
        layout_width="-1",
        DividerHeight=1;
        BackgroundColor="#FFFFFFFF";

      },
    };
    {
      CardView;--卡片控件
      layout_margin='8dp';--边距
      layout_gravity='center';--重力
      --左:left 右:right 中:center 顶:top 底:bottom
      elevation='5dp';--阴影
      layout_width='fill';--宽度
      layout_height='125%w';--高度
      CardBackgroundColor='#ffffffff';--颜色
      radius='8dp';--圆角
      {
        LuaWebView;--浏览器控件
        layout_width='fill';--宽度
        layout_height='fill';--高度
        id="哈哈"
      };
    };
  };
};
activity.setContentView(loadlayout(duo))
function 翻译()
  text=(edit.Text)--翻译的内容
  网址=("https://translator.ai.xiaomi.com/?text="..text)
  哈哈.loadUrl(网址)
end