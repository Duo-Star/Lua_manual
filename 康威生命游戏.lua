--康威生命游戏
--本工程非原创，意在与大家分享
--百度词条-康威生命游戏
--https://baike.baidu.com/item/%E5%BA%B7%E5%A8%81%E7%94%9F%E5%91%BD%E6%B8%B8%E6%88%8F/22668799

require "import"
import "android.widget.AbsoluteLayout"
import "android.widget.Button"
import "android.graphics.PorterDuff"
import "android.widget.LinearLayout"
import "android.graphics.Paint"
import "android.widget.TextView"


lcv=AbsoluteLayout(activity)
bt=Button(activity)
mstv=TextView(activity)
bt2=Button(activity)
speed=200
pa=Paint()
pa2=Paint()
gccont=0
gcclickTimes=10
--程序主动触发GC器的帧数

dataTable={--初始化生命位置
  {0,0,0,0,0,0,0},
  {0,0,0,1,0,0,0},
  {0,0,0,1,0,0,0},
  {0,0,0,1,0,1,0},
  {0,1,1,1,0,0,0},
  {0,1,0,0,0,0,0},
  {0,0,0,0,0,0,0}
}

GridSize=50


lcv.addView(bt)
lcv.addView(bt2)
lcv.addView(mstv)
mstv.setText(speed.."ms/每回合")
bt.setX(0)
bt2.setX((activity.getWidth()/2)+10)
bt.setY(activity.getHeight()-200)
bt2.setY(activity.getHeight()-200)
bt.getLayoutParams().height=150
bt.getLayoutParams().width=math.modf(activity.getWidth()/2)-10
bt2.getLayoutParams().height=150
bt2.getLayoutParams().width=math.modf(activity.getWidth()/2)
bt.setText("减速")
bt2.setText("加速")
bt.setBackgroundColor(0xFFFFFFFFF)
bt2.setBackgroundColor(0xFFFFFFFFF)
pa.setColor(0xFF000000)
pa2.setStrokeWidth(5)
pa2.setColor(0xFFAAAAAA)


bt.onClick=function()
  speed=speed+1
  mstv.setText(speed.."ms/每回合")
  ti.Period=speed
end

bt2.onClick=function()
  speed=speed-1
  mstv.setText(speed.."ms/每回合")
  ti.Period=speed
end

lcv.setBackground(
LuaDrawable(function(ca)
  local vs

  for k=1,#dataTable
    for k2=1,#dataTable[k]
      vs=dataTable[k][k2]

      if vs==1
        ca.drawRect((k2-1)*GridSize,(k-1)*GridSize,k2*GridSize,k*GridSize,pa);
       else

      end

    end
  end

  for i=1,#dataTable[1]
    ca.drawLine(i*GridSize,0,i*GridSize,#dataTable*GridSize,pa2);
  end

  for i=1,math.modf(activity.getWidth()/GridSize)
    ca.drawLine(i*GridSize,0,i*GridSize,activity.getHeight(),pa2);
  end

  for i=1,math.modf(activity.getHeight()/GridSize)
    ca.drawLine(0,i*GridSize,activity.getWidth(),i*GridSize,pa2);
  end

  for i=1,#dataTable
    ca.drawLine(0,i*GridSize,activity.getWidth(),i*GridSize,pa2);
  end



  --一次此执行即为一帧。
end
))


ti=Ticker()
ti.Period=speed
ti.onTick=function()
  gccont=gccont+1
  dataTable=RefreshGame(dataTable)
  lcv.invalidate()

  if gccont==gcclickTimes
    collectgarbage("collect")
    gccont=0
  end

end
ti.start()


activity.setContentView(lcv)

function onDestroy()
  activity.finish()
  ti.stop()
end



function RefreshGame(dataTable)
  local val
  local copytable={}

  for k=1,#dataTable

    copytable[k]={}
    for k2=1,#dataTable[k]
      copytable[k][k2]=dataTable[k][k2]
    end
  end




  for k=1,#dataTable
    for k2=1,#dataTable[k]
      val=(dataTable[k-1]or{})[k2] or 0
      val=val+((dataTable[k-1]or{})[k2-1] or 0)
      val=val+((dataTable[k-1]or{})[k2+1] or 0)
      val=val+((dataTable[k+1]or{})[k2] or 0)
      val=val+((dataTable[k+1]or{})[k2-1] or 0)
      val=val+((dataTable[k+1]or{})[k2+1] or 0)
      val=val+(dataTable[k][k2-1] or 0)
      val=val+(dataTable[k][k2+1] or 0)


      if val==3
        copytable[k][k2]=1
      end

      if val>3
        copytable[k][k2]=0
      end

      if val<2
        copytable[k][k2]=0
      end

    end
  end


  return copytable
end



