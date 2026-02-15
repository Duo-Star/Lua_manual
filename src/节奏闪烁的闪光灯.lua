--节奏闪烁的闪光灯
--更新，自定义闪烁模式
--作者：Duo  QQ:113530014


--SOS 的闪烁模式(遇见丧尸不要慌，沉着冷静地打开代码手册，运行本条目)(doge
w={0,1,0,1,0,1,0,0,1,1,0,1,1,0,1,1,0,0,1,0,1,0,1,0}
dt=500--闪烁间隔

浏览框架=
{ LinearLayout,--线性布局
  orientation='vertical',--方向
  { Button;--按钮控件
    text='开始';--显示文字
    textSize='10dp';--文字大小
    id="开始";
  };
  { Button;--按钮控件
    text='停止';--显示文字
    textSize='10dp';--文字大小
    id="停止";
  };
};
webView.addView(loadlayout(浏览框架))

a=1
主频=Ticker()
主频.Period=dt--时间间隔
主频.onTick=function()
  a=a+1
  d(w[a])
end

开始.onClick=function()
  主频.start()
  print("~start")
end
停止.onClick=function()
  主频.stop()
  local CameraManager=this.getSystemService(Context.CAMERA_SERVICE)
  CameraManager.setTorchMode("0",false)
end

--退出后结束
function onDestroy()
  主频.stop()
  print("Stop")
end

function d(a)
  if a==1 then
    local CameraManager=this.getSystemService(Context.CAMERA_SERVICE)
    CameraManager.setTorchMode("0",true)
    --print("开")
   elseif a==0 then
    local CameraManager=this.getSystemService(Context.CAMERA_SERVICE)
    CameraManager.setTorchMode("0",false)
    --print("关")
  end
end