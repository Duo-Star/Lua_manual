--SwingView-开摆视图
--或许可以作为ProgressBar
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"

init={}

init.main=function()

  class=init.class()
  SwingView=init.SwingView()

  layout={
    LinearLayout,
    orientation="vertical",
    layout_width="fill",
    layout_height="fill",
    gravity="center",
    {
      ScrollView,
      id="scrollView",
      layout_width="fill",
      layout_height="fill",
      {LinearLayout,
        orientation="vertical",
        layout_width="fill",
        layout_height="fill",
        {
          Button,
          text="SwingView",
          id="btn",layout_height="20%h",layout_width="90%w",
          layout_gravity="center",
        },


        {
          SwingView,
          layout_width="400dp",
          layout_height="200dp",
          padding="24dp",
          layout_gravity="center",
        },



        {
          Button,
          text="再来几个",
          id="btn",
          layout_gravity="center",
        },


        {
          SwingView,
          layout_width="400dp",
          layout_height="200dp",
          padding="24dp",
          layout_gravity="center",
        },

        {
          SwingView,
          layout_width="400dp",
          layout_height="200dp",
          padding="24dp",
          layout_gravity="center",
        },

        {
          SwingView,
          layout_width="400dp",
          layout_height="200dp",
          padding="24dp",
          layout_gravity="center",
        },

      },
    },
  }


  activity.setContentView(loadlayout(layout))

end


init.class=function()
  _NIL={}
  function class(config)
    local cls=config.extends or Object
    local name=config.name
    return setmetatable(config.static or {},{
      __call=function(t,...)
        local args={...}
        local constructor=function(super,...)
          if table.size(args)==1 and type(args[1])=="table" and luajava.instanceof(args[1][1],cls) then
            super=function(...)
              return args[1][1]
            end
          end
          return (config.constructor or function(super,...)
            return super(...)
          end)(super,...)
        end
        local fields={}
        if config.fields then
          for k,v in pairs(config.fields) do
            fields[k]=v
          end
        end
        local methods=config.methods or {}
        local overrides=config.overrides or {}
        local obj=constructor(cls,...) or cls(...)
        local oldmt,mt=getmetatable(obj),{}
        for k,v in pairs(oldmt) do mt[k]=v end
        local ___tostring=mt.__tostring
        local function index(self,key,hasParam,...)
          debug.setmetatable(self,oldmt)
          local r
          if hasParam then
            r=self[key](...)
           else
            r=self[key]
          end
          debug.setmetatable(self,mt)
          return type(r)=="function" and function(...)
            return index(self,key,true,...)
          end or r
        end
        mt.__index=function(self,key)
          if fields[key]~=nil then
            if fields[key]==_NIL then return end
            return fields[key]
          end
          if overrides[key] then
            return function(...)
              return overrides[key](self,index(self,key),...)
            end
          end
          if methods[key] then
            return function(...)
              return methods[key](self,...)
            end
          end
          return index(self,key)
        end
        mt.__newindex=function(self,key,val)
          if fields[key]~=nil then
            if val==nil then val=_NIL end
            fields[key]=val
            return
          end
          debug.setmetatable(self,oldmt)[key]=val
          debug.setmetatable(self,mt)
        end
        mt.__tostring=function(self)
          local s=___tostring(self)
          s=s:match("(@.+)") or s:match("({.+})")
          return (name or tostring(cls):sub(7))..s
        end
        mt.__type=function(self)
          return "userdata"
        end
        debug.setmetatable(obj,mt)
        if config.init then config.init(obj) end
        return obj
      end,
      __index=function(t,key)
        return cls[key]
      end,
      __tostring=function(t)
        return name and "class "..name or tostring(cls)
      end,
      __type=function(t)
        return tostring(t)
      end
    })
  end

  return class
end


init.SwingView=function()

  SurfaceView = luajava.bindClass "android.view.SurfaceView"
  ValueAnimator = luajava.bindClass "android.animation.ValueAnimator"

  SwingView=class{
    extends=SurfaceView,
    fields={
      ox=_NIL,
      oy=_NIL,
      mPadding=_NIL,
      theta=0,
      P = Paint(),
      ticker=Ticker(),
      pi=math.pi,
      sin=math.sin,
      cos=math.cos,
      floor=math.floor,
      t=0,
      dt=0.02,
      g = 9.8,
      L = 1.0,
      alpha_= 0,
      theta_ = math.rad(60), --单摆初始角度
      omega_ = 0, --单摆初始角速度
      time=_NIL,

    },
    init=function(view)
      local padding
      if Build.VERSION.SDK_INT>=17 then
        local all=view.getPaddingLeft()+view.getPaddingRight()+view.getPaddingBottom()+view.getPaddingTop()+view.getPaddingEnd()+view.getPaddingStart()
        padding=all/6
       else
        padding=(view.getPaddingLeft()+view.getPaddingRight()+view.getPaddingBottom()+view.getPaddingTop())/4
      end
      view.setPadding(padding)
      view.post(function()
        local w,h=view.width,view.height
        local smallerDim=w>h and h or w
        local largestCenteredSquareLeft=(w-smallerDim)/2
        local largestCenteredSquareTop=(h-smallerDim)/2
        local largestCenteredSquareRight=largestCenteredSquareLeft+smallerDim
        local largestCenteredSquareBottom=largestCenteredSquareTop+smallerDim
        view.ox=largestCenteredSquareRight/2+(w-largestCenteredSquareRight)/2
        view.oy=largestCenteredSquareBottom/2+(h-largestCenteredSquareBottom)/2
        view.P.setColor(0xff009688).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)
      end)
      view.time=Ticker()
      view.time.Period=view.dt*1000
      view.time.start()
      local holder = view.getHolder()
      holder.addCallback(SurfaceHolder.Callback {
        surfaceChanged = function(holder, format, width, height)
        end,
        surfaceChanged = function(holder)
        end,
        surfaceCreated = function(holder)
          view.time.onTick=function()--执行
            pcall(function()
              local canvas = holder.lockCanvas()
              view.t=view.t+view.dt
              view.alpha_ = -view.g/view.L * view.sin(view.theta_) --角加速度
              view.omega_ = view.omega_ + view.alpha_ * view.dt --角速度
              view.theta_ = view.theta_ + view.omega_ * view.dt --角度
              canvas.drawColor(0xffffffff)
              canvas.drawCircle(view.ox, 10, 5, view.P)
              canvas.drawLine(view.ox, 10, 380*view.cos(view.pi/2-view.theta_)+view.ox, 380*view.sin(view.pi/2-view.theta_)+10, view.P)
              view.P.setShadowLayer(10,0,0,0xaa004D40)
              canvas.drawCircle(380*view.cos(view.pi/2-view.theta_)+view.ox, 380*view.sin(view.pi/2-view.theta_)+10, 30, view.P)
              view.P.clearShadowLayer()
              holder.unlockCanvasAndPost(canvas)
            end)
          end
        end,
        surfaceDestroyed = function(holder)
          view.time.stop()
        end
      })
      view.onTouch=function(_,event)
        switch event.getAction()
         case MotionEvent.ACTION_UP
          --view.getParent().requestDisallowInterceptTouchEvent(false)
         case MotionEvent.ACTION_DOWN
          local x=event.getX()
          local y=event.getY()
          --view.getParent().requestDisallowInterceptTouchEvent(true)
         case MotionEvent.ACTION_MOVE
          local x=event.getX()
          local y=event.getY()
        end
        return true
      end
    end,
    methods={
      setPadding=function(view,padding)
        view.mPadding=padding
        return view
      end,
    },
  }
  return SwingView

end

init.main()
