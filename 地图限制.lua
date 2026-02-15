--参考了贪吃蛇SurfaceView😉
--作者：Duo  QQ：113530014
--持续完善中，欢迎反馈交流


import 'android.graphics.*'
layout={
  LinearLayout;
  orientation='vertical';
  layout_width='fill';
  layout_height='fill';
  gravity='center';
  {
    SurfaceView;
    id="sureface";
    layout_width='80%w';
    layout_height='80%w';
    background="#804CAF50",
  };
  {
    FrameLayout;
    {
      Button;
      text="↑";
      onClick="up";
      layout_gravity="center";
    };
    layout_width="fill";
  };
  {
    FrameLayout;
    {
      LinearLayout;
      {
        Button;
        text="←";
        onClick="left";
      };
      {
        Button;
        text="↓";
        onClick="down";
      };
      {
        Button;
        text="→";
        onClick="right";
      };
      layout_gravity="center";
    };
    layout_width="fill";
  };
};

activity.setContentView(loadlayout(layout))

map={
  {1,1,1,1,1,1,1,1},
  {0,0,1,0,0,0,1,1},
  {1,0,1,0,1,0,1,1},
  {1,0,0,0,1,0,1,1},
  {1,1,1,1,1,0,0,1},
  {1,0,0,0,0,0,1,1},
  {1,0,0,0,1,1,1,1},
  {1,1,1,0,0,1,1,1}
}--地图数组

duo={1,2}--移动方块的位置

local W=activity.Width*0.8
local H=activity.Height*0.8
local bmp=Bitmap.createBitmap(W,H,Bitmap.Config.RGB_565)
local g=Canvas(bmp)
local pen=Paint()
l=#map
local w=W/l


function tick()
  g=holder.lockCanvas()
  --如果画布尚未创建
  if not g then
    return
  end
  g.drawColor(0xffffffff)

  function p(X,Y)--绘制方法
    _Rect=Rect((X-1)*w,(Y-1)*w,(X)*w-1,(Y)*w-1)
    g.drawRect(_Rect,pen)
    g.drawLine(0,W,W,W,pen)
  end

  for n=1,#map do--循环绘制地图
    for m=1,#map[1] do
      if map[m][n]==1 then
        p(n,m)
      end
    end
  end

  p(duo[1],duo[2])--绘制移动方块

  holder.unlockCanvasAndPost(ca)
end

function up()
  if map[duo[2]-1][duo[1]]==1 then else--限制移动
    duo[2]=duo[2]-1
    tick()
  end
end

function down()
  if map[duo[2]+1][duo[1]]==1 then else
    duo[2]=duo[2]+1
    tick()
  end
end

function left()
  if map[duo[2]][duo[1]-1]==1 then else
    duo[1]=duo[1]-1
    tick()
  end
end

function right()
  if map[duo[2]][duo[1]+1]==1 then else
    duo[1]=duo[1]+1
    tick()
  end
end



callback=SurfaceHolder.Callback{
  surfaceChanged=function(holder,format,width,height)
  end,
  surfaceCreated=function(holder)
    ca=holder.lockCanvas()

    holder.unlockCanvasAndPost(ca)
  end,
  surfaceDestroyed=function(holder)
  end
}
holder=sureface.getHolder()
holder.addCallback(callback)



function onStart()
  --主频.Enabled=true
end

function onStop()
  --主频.Enabled=false
end

task(10,function()
  tick()
end)
