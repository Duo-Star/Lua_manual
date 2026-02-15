--River by Duo
--简洁的本地音乐播放器，开源项目
--这是内置的音乐下载与探索页面
local QQ=465146942
--可以在这里获得测试版本

require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Toolbar = luajava.bindClass "androidx.appcompat.widget.Toolbar"
local MaterialButton = luajava.bindClass "com.google.android.material.button.MaterialButton"
local TextInputLayout = luajava.bindClass "com.google.android.material.textfield.TextInputLayout"
local TextInputEditText = luajava.bindClass "com.google.android.material.textfield.TextInputEditText"
local AppBarLayout = luajava.bindClass "com.google.android.material.appbar.AppBarLayout"
local ImageView = luajava.bindClass "android.widget.ImageView"
local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"
local RecyclerView = luajava.bindClass "androidx.recyclerview.widget.RecyclerView"
local StaggeredGridLayoutManager = luajava.bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"
local Snackbar = luajava.bindClass "com.google.android.material.snackbar.Snackbar"
local BottomSheetDialog = luajava.bindClass "com.google.android.material.bottomsheet.BottomSheetDialog"
local LayoutTransition = luajava.bindClass "android.animation.LayoutTransition"
local Slider = luajava.bindClass "com.google.android.material.slider.Slider"
local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
local MaterialButton = luajava.bindClass "com.google.android.material.button.MaterialButton"
local ColorStateList = luajava.bindClass "android.content.res.ColorStateList"


import "android.content.Context"
import "android.net.Uri"
import "android.app.DownloadManager"

MDC_R=import "com.google.android.material.R"


function Copy(内容)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(内容))
end


function Snack(str)
  local parent=rootLay
  local duration=Snackbar.LENGTH_SHORT
  Snackbar.make(parent,str, duration)
  --.setActionTextColor(Color.parseColor("#0D47A1"))
  --.setAction("OK",{onClick=function() print("OK") end})
  .show()
end

function 状态栏高度()
  if Build.VERSION.SDK_INT >= 19 then
    local resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android")
    return activity.getResources().getDimensionPixelSize(resourceId)
   else
    return 0
  end
end

mediaPlayer = MediaPlayer()
ticker_=Ticker()


duo=
{ LinearLayout,
  layout_width="match",
  layout_height="match",
  Orientation=1,
  id="rootLay",
  { AppBarLayout;
    backgroundColor="#FFEAEFFB",
    layout_width=-1;
    layout_height="60dp";
    layout_marginTop=状态栏高度(),
    { LinearLayout,
      layout_width="fill",
      layout_height="fill",
      --orientation=0,
      --backgroundColor=backgroundc;
      { MaterialCardView,
        strokeWidth="0",
        strokeColor=0,
        layout_height="50dp",
        layout_width="40%w",
        radius="0dp",
        cardElevation="0dp",
        layout_margin='5dp';
        cardBackgroundColor="0",
        { TextView,
          textSize="20dp",
          layout_gravity="center|left";
          layout_margin='10dp',
          text="Music Explore",
          textColor="#212121",
        }
      },
      {
        MaterialCardView;
        layout_weight=0.5,
        layout_margin="5dp";
        layout_height="43dp";
        layout_width="fill";
        layout_gravity="center";
        --cardBackgroundColor="0",
        radius='5dp',
        cardElevation="0dp",
        {EditText,
          id="edit",
          padding="12dp";
          textSize=16,
          layout_width="fill",
          singleLine="true";
          Hint="Search";
        },
      };
      {MaterialCardView,
        layout_height="40dp",
        strokeWidth="0",
        strokeColor=0,
        layout_width="40dp",
        radius="30dp",
        cardElevation="0dp",
        layout_gravity="center|right";
        layout_margin='5dp';
        cardBackgroundColor="0",
        onClick=function()
          if tostring(edit.getText())~="" then
            adapter.clear()
            搜索歌曲(tostring(edit.getText()))
            progress.setVisibility(0)
           else
            Snack("你好像没有输入内容")
            progress.setVisibility(8)
          end
        end,
        {
          ImageView;
          src="https://tc.24ly.cn/view.php/27f891970c05ebc304ede135515afbf5.png",
          layout_width="25dp",
          layout_height="25dp",
          layout_margin='2dp';
          layout_gravity="center";
        };
      },
    },
  },
  { LinearLayout,
    layout_width="fill",
    layout_height="fill",
    gravity="top",
    --BackgroundColor="#FFEAEFFB",
    Orientation=1,
    layoutTransition=LayoutTransition()
    .enableTransitionType(LayoutTransition.CHANGING),
    {
      ProgressBar,--进度条控件
      layout_width="fill",--布局宽度
      layout_height="20dp",--布局高度
      indeterminate=true,
      layout_marginTop='-8dp',
      id="progress",
      style="?android:attr/progressBarStyleHorizontal"
    },
    { RecyclerView,
      id='recycler_view',
      layout_width="match",
      layout_height="match",
    }

  }
}
activity.setContentView(loadlayout(duo))


list_item={ LinearLayout;
  layout_height="wrap";
  layout_width="fill";
  orientation="horizontal";
  { MaterialCardView,
    id="card",
    layout_margin="3dp",
    layout_width="match",
    layout_height="wrap",
    cardElevation="0dp",
    radius="5dp",
    clickable=false,
    { LinearLayout;
      layout_height="wrap";
      layout_width="fill";
      orientation=0;
      { ImageView;
        id="image";
        src="https://tc.24ly.cn/view.php/22ce9ece8f9bd02d94b0c5582ad29861.png",
        layout_height="50dp";
        layout_width="50dp";
        padding="5dp";
        layout_gravity="center";
        clickable=false,
      };
      { LinearLayout;
        layout_width="-1";
        orientation="vertical";
        { TextView;
          id="name";
          textSize="20dp",
          textColor="#ee424242",
          paddingTop="10dp";
          layout_width="-1";
          gravity="center|left";
        };
        { TextView;
          id="info";
          padding="5dp";
          layout_width="-1";
          gravity="top";
        };
      };
    }
  }
}
local list_data={}

progress.setVisibility(8)

recycler_view.layoutManager=StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL)
adapter=LuaRecyclerAdapter(activity,list_data,list_item)
adapter.onItemClick = function(adapter, itemView, view, position)
  print(dump(list_data[position+1]))
  --Copy(list_data[position+1].image)
  local id=list_data[position+1].id
  local name=list_data[position+1].name
  local url="http://music.163.com/song/media/outer/url?id="..id..".mp3"
  --Download(url,"River",name..".mp3")
  more(list_data[position+1])
end
adapter.clickViewId="card"
recycler_view.adapter=adapter


function search(keyword,props,callback)
  local cjson,Http=require"cjson",luajava.bindClass "com.androlua.Http"
  local url,data="http://music.163.com/api/search/get/web",{s=keyword,type="1"}
  if props table.foreach(props,lambda k,v=>data[k]=v) end
  Http.post(url,data,lambda code,data do
  if (code==200) then
    local t={}
    local data=cjson.decode(data)
    for _,data in pairs(data.result.songs)
      table.insert(t,{
        data.artists[1].name,
        data.name,
        data.album.artist.img1v1Url,
        tointeger(data.id)
      })
    end when callback callback(t)
  end
end)
end


function 搜索歌曲(str)
  search(str,{limit="100"},function(data)
    --获取单曲信息（作者,歌曲名,封面图,歌曲id）
    for i=1,#data do
      local author,name,img,id=table.unpack(data[i])
      adapter.add{
        name=name,
        --image=img,
        info=author,
        id=id
      }
    end
    progress.setVisibility(8)
  end)
end



function Download(url_, path_, name_)
  local url_=url_ or "https://cdn-icons-png.flaticon.com/128/2991/2991148.png"
  local path_=path_ or "Android"
  local name_=name_ or "Google.png"
  downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE);
  url=Uri.parse(tostring(url_));
  request=DownloadManager.Request(url);
  request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
  request.setDestinationInExternalPublicDir(path_,name_);
  request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  downloadManager.enqueue(request);
end

--Download("https://cdn-icons-png.flaticon.com/128/2991/2991148.png")



function more(data)
  local id=data.id
  local name=data.name
  local info=data.info
  local url="http://music.163.com/song/media/outer/url?id="..id..".mp3"
  local musicurl=url


  DialogLay=
  {FrameLayout,
    layout_width="match",
    layout_height="wrap",
    {
      ImageView,
      layout_width="match",
      layout_height="match",
      id="img",
      layout_gravity="center",
      scaleType="centerCrop",
    },
    {
      LinearLayout,
      layout_width="match",
      layout_height="wrap",
      Orientation=1,
      layout_margin="10dp",
      layout_gravity="center",
      layoutTransition=LayoutTransition()
      .enableTransitionType(LayoutTransition.CHANGING),
      {
        TextView,
        id="lyricc",
        text="",
        Visibility=8,
        textSize="40dp",
        textStyle="bold",
        textColor="#000000",
        layout_gravity="left",
      },
      {
        TextView,
        id="songname",
        text=name,
        layout_marginTop="20dp",
        textColor="#212121",
        textSize="25dp",
      },
      {
        TextView,
        id="author",
        text=info,
        textColor="#212121",
        layout_marginBottom="20dp",
        textSize="13dp",
      },
      {Slider,
        layout_width="match";
        id="slider",
        HaloTintList=ColorStateList.valueOf(0xaa44354280),--点击球周围波纹颜色
        TickActiveTintList=ColorStateList.valueOf(0xffFEFBFF),--滑到的刻度颜色
        TickInactiveTintList=ColorStateList.valueOf(0xff354280),--未滑到的刻度颜色
        TrackInactiveTintList=ColorStateList.valueOf(0x33354280),--未滑到的轨道颜色
        ThumbTintList=ColorStateList.valueOf(0xff3F51B5),--球的颜色
        TrackActiveTintList=ColorStateList.valueOf(0xaa3F51B5),--滑过的轨道颜色
      },
      {
        FrameLayout,
        layout_width="fill",
        layout_height="50dp",
        layout_margin="10dp",
        layoutTransition=LayoutTransition().enableTransitionType(LayoutTransition.CHANGING),
        {MaterialButton,
          text="PLAY",
          BackgroundColor="#3F51B5",
          layout_gravity="left",
          id="play",
        },
        {MaterialButton,
          text="DOWN",
          BackgroundColor="#3F51B5",
          layout_gravity="right",
          id="down",
        },
      },
    },
  }
  Dialog = BottomSheetDialog(activity);
  Dialog.setContentView(loadlayout(DialogLay));
  Dialog.show()

  task(500,function()
    slider.value=0
    mediaPlayer.reset()--初始化参数
    --设置播放资源
    mediaPlayer.setDataSource(musicurl)
    mediaPlayer.prepare()--开始缓冲资源
    --是否循环播放该资源
    mediaPlayer.setLooping(false)--循环播放 --单次播放则改为 false
    mediaPlayer.setOnPreparedListener(MediaPlayer.OnPreparedListener{
      onPrepared=function(mediaPlayer)
        slider.setEnabled(true)
        local videoduration=mediaPlayer.Duration
        slider.setValue(mediaPlayer.getDuration())
        slider.setValueTo(videoduration)
        slider.addOnSliderTouchListener({--触摸事件
          onStopTrackingTouch=function(view)
            mediaPlayer.seekTo(view.value)
          end
        })
        slider.value=0
      end
    })
  end)

  play.onClick=function()
    if mediaPlayer.isPlaying() then
      mediaPlayer.pause()
      play.setText("play")
     else
      mediaPlayer.start()
      play.setText("pause")
    end
  end

  down.onClick=function()
    Download(url,"Music",name..".mp3")
    Snack("下载: /storage/emulated/0/Music/"..name..".mp3")
  end

end


ticker_=Ticker()
ticker_.Period=1000
ticker_.onTick=function()
  if mediaPlayer and mediaPlayer.isPlaying() then
    slider.value=mediaPlayer.getCurrentPosition()
  end
end
ticker_.start()


function onKeyDown(code)
  if code == 4 then
    if ticker_.isRun() then
      ticker_.stop()
    end
    mediaPlayer.stop()
    mediaPlayer.release()
  end
end
