--Chrome Dino
--作者：Duo  QQ：113530014

require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"


function Dino()
  import "android.graphics.*"
  import "com.bumptech.glide.Glide"
  --#所需变量
  local h=activity.getHeight()
  local w=activity.getWidth()
  local floor=math.floor
  local ox=w/3
  local oy=h/2
  local Lambda=1
  local die=false
  local tip=""
  local map={}
  local dino={m=10,x=0,y=0,vx=400,vy=0}
  local Env={g=-3000,dt=0.01}
  local black_P = Paint().setColor(0xee424242).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(8)
  local text_P = Paint().setColor(0xFF111111).setAntiAlias(true).setTextAlign(Paint.Align.LEFT).setTextSize(50).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)
  --#随机生成地图
  for x=500,10000,400 do
    map[#map+1]={x+math.random(0,10)*20,80}
  end
  --#布局
  local layout=
  { FrameLayout,
    layout_width='fill',
    layout_height='fill',
    id="back",
  }
  --#让恐龙跳起来
  function jump()
    if not(dino.y>=1) then dino.vy=900 dino.y=1 end
  end
  --#重置
  function reset()
    ox=w/2
    oy=h/2
    die=false
    map={}
    tip=""
    dino={m=10,x=0,y=0,vx=400,vy=0}
    Env={g=-2500,dt=0.01}
    for x=500,16000,400 do
      map[#map+1]={x+math.random(0,10)*20,80}
    end
  end
  --#初始化
  function init()
    Timer_=Ticker()
    Timer_.Period=Env.dt*1000
    Timer_.onTick=function()--执行
      ox=ox-dino.vx*Env.dt
      dino.vy=(dino.vy+(Env.g)*Env.dt)
      dino.x=dino.x+dino.vx*Env.dt
      dino.y=dino.y+dino.vy*Env.dt
      if dino.y<=0 then dino.vy=0 dino.y=0 end
      for n=1,#map do
        if math.abs(dino.x-map[n][1])<=25 then
          if dino.y<=50 then
            if not(die) then
              --activity.finish()
              --[[
              AlertDialog.Builder(this)
              .setTitle("Game Over")
              .setMessage("")
              .setPositiveButton("",{onClick=function(v) end})
              .show()
              --]]
              tip="You die , tap screen to continue ~"
              Timer_.stop()
              print("Score: "..floor(dino.x/100).."m")
            end
            die=true
          end
        end
      end
    end
    function onDestroy()
      Timer_.stop()
    end
  end
  init()
  --#触摸屏幕
  function onTouchEvent(v)
    if v.action==0 then
      if die then
        reset()
        init()
        Timer_.start()
       else
        jump()
      end
    end
  end
  --#绘图
  task(function()
    local cute_dino="https://ncstatic.clewm.net/rsrc/2023/0105/12/5267d95941264ffe2204ab3fe043d2a2.png?x-oss-process=image/resize,w_108/format,gif/sharpen,100/quality,Q_80/interlace,1/auto-orient,1"
    local tree="https://tc.24ly.cn/down.php/ca8cc2e60454d9082ee281ad38d176c0.png"
    local function load_bitmap(src)
      return Glide.with(activity).asBitmap().load(src).submit().get()
    end
    local tree_bitmap=load_bitmap(tree)
    local dino_bitmap=load_bitmap(cute_dino)
    return tree_bitmap,dino_bitmap
  end,
  function(tree_bitmap, dino_bitmap)
    local DrewPanel = LuaDrawable(
    function(canvas, paint, panel)
      canvas.drawText("Score: "..floor(dino.x/100).."m", 90, 100, text_P)
      canvas.drawText(tip,w/2-321,h/2+100,text_P)
      canvas.drawCircle(0*Lambda+ox,0*Lambda+oy,10,black_P)
      for i=1,#map do
        canvas.drawBitmap(tree_bitmap,map[i][1]*Lambda+ox-30,0*Lambda+oy-80,black_P)
      end
      canvas.drawBitmap(dino_bitmap,dino.x*Lambda+ox-45,-dino.y*Lambda+oy-120,black_P)
      canvas.drawLine(-ox+ox,0+oy,(w-ox)+ox,0+oy, black_P)
      panel.invalidateSelf()
    end)
    back.setBackground(DrewPanel)
    Timer_.start()
  end)
  return layout
end
activity.setContentView(loadlayout(Dino()))