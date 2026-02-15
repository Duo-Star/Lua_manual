--DuoTadpoleSlider-蝌蚪滑动条
--可爱捏
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"

init={}

init.main=function()

  class=init.class()

  DuoTadpoleSlider=init.DuoTadpoleSlider()


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
          text="蝌蚪滑动条",
          id="btn",layout_height="60dp",layout_width="fill",
        },

        {
          DuoTadpoleSlider,
          id="slider",
          layout_width="fill",
          layout_height="60dp",
          layout_gravity="center",
          progress=0.2,
          headS=1,

        },

        {
          DuoTadpoleSlider,
          id="slider",
          layout_width="fill",
          layout_height="60dp",
          layout_gravity="center",
          progress=0.5,
          headS=2,

        },

        {
          DuoTadpoleSlider,
          id="slider",
          layout_width="fill",
          layout_height="60dp",
          layout_gravity="center",
          progress=0.8,
          headS=3,

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


init.DuoTadpoleSlider=function()

  require "import"
  import "android.widget.*"
  import "android.view.*"

  SurfaceView = luajava.bindClass "android.view.SurfaceView"
  ValueAnimator = luajava.bindClass "android.animation.ValueAnimator"

  DuoTadpoleSlider=class{
    extends=SurfaceView,
    fields={
      ox=_NIL,
      oy=_NIL,
      mPadding=_NIL,

      P = {},
      pi=math.pi,
      sin=math.sin,
      cos=math.cos,
      floor=math.floor,
      t=0,
      dt=0.01,
      alpha=1,
      theta_ = math.rad(60), --单摆初始角度
      omega_ = 0,
      time=_NIL,
      Lambda=1,

      progress=0.6,
      tailH=0.05,
      tailC=0x998E4D31,
      headC=0xFF8E4D31,
      roadC=0x408E4D31,
      padding_=20,
      headS=3 ,



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
        --view.P.setColor(0xff009688).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)



      end)


      local animation = ValueAnimator.ofFloat({ 1 })
      animation.setDuration(100000)
      animation.setRepeatCount(-1)
      animation.setRepeatMode(1)
      animation.start()



      local holder = view.getHolder()
      holder.addCallback(SurfaceHolder.Callback {
        surfaceChanged = function(holder, format, width, height)
        end,
        surfaceChanged = function(holder)
        end,
        surfaceCreated = function(holder)
          animation.addUpdateListener(ValueAnimator.AnimatorUpdateListener {
            onAnimationUpdate = function(animate)

              local k = animation.getAnimatedValue()
              local canvas
              pcall(function()
                canvas = holder.lockCanvas()
              end)

              if canvas ~= nil then
                view.t=view.t+view.dt
                view.P={}

                view.P.p = Paint()
                .setColor(0xFF8E4D31)
                .setStyle(Paint.Style.FILL)
                .setStrokeWidth(10)
                .setAntiAlias(true)
                .setStrokeCap(Paint.Cap.ROUND)

                view.P.tail = Paint() .setColor(view.tailC) .setStyle(Paint.Style.FILL) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)
                if view.headS==1 then
                  view.P.head = Paint() .setColor(view.headC) .setStyle(Paint.Style.FILL) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)
                 elseif view.headS==2 then
                  view.P.head = Paint() .setColor(view.headC) .setStyle(Paint.Style.STROKE) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)
                 elseif view.headS==3 then
                  view.P.head = Paint() .setColor(view.headC) .setStyle(Paint.Style.FILL) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)
                 else
                  view.P.head = Paint() .setColor(view.headC) .setStyle(Paint.Style.FILL) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)
                end
                view.P.road = Paint() .setColor(view.roadC) .setStyle(Paint.Style.FILL) .setStrokeWidth(10) .setAntiAlias(true) .setStrokeCap(Paint.Cap.ROUND)


                local w,h=view.width,view.height
                local smallerDim=w>h and h or w
                local largestCenteredSquareLeft=(w-smallerDim)/2
                local largestCenteredSquareTop=(h-smallerDim)/2
                local largestCenteredSquareRight=largestCenteredSquareLeft+smallerDim
                local largestCenteredSquareBottom=largestCenteredSquareTop+smallerDim
                view.ox=largestCenteredSquareRight/2+(w-largestCenteredSquareRight)/2
                view.oy=largestCenteredSquareBottom/2+(h-largestCenteredSquareBottom)/2




                canvas.drawColor(0xFFFFF2EC)

                local ox=view.ox
                local oy=view.oy
                local P=view.P
                local paint = view.P.p
                local Lambda=view.Lambda
                local w=view.width
                local progress=view.progress
                local tailH=view.tailH
                local padding_=view.padding_


                local function dot(x,y,p)
                  local p=p or paint
                  return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, 15, p)
                end
                local function circle_(x,y,r,p)
                  local p=p or paint
                  return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r*Lambda*100, p)
                end
                local function line_(x0,y0,x1,y1,p)
                  local p=p or paint
                  canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p)
                end

                --canvas.drawCircle(w*progress,oy,25,P.head)


                if view.headS==1 then
                  canvas.drawCircle(w*progress,oy,25,P.head)
                 elseif view.headS==2 then
                  canvas.drawCircle(w*progress,oy,25,P.head)
                 elseif view.headS==3 then
                  canvas.drawLine(w*progress,oy+20,w*progress,oy-20,P.head)
                  canvas.drawLine(w*progress+3,oy+20,w*progress+3,oy-20,P.head)
                 else
                  canvas.drawCircle(w*progress,oy,25,P.head)
                end


                canvas.drawLine(w*progress,oy,w-padding_,oy,P.road)


                local function fun_(f,x0,x1,p)
                  local p=p or paint
                  local x0=(x0)/(Lambda*100)
                  local x1=(x1-ox)/(Lambda*100)
                  local dx=0.05*(1/Lambda)
                  local p0={x0,f(x0)}
                  local p1=p0
                  for x=x0,x1,dx do
                    local y=f(x)
                    p1={x,y}
                    line_(p0[1],p0[2],p1[1],p1[2],p)
                    p0=p1
                  end
                end

                fun_(function(x) return tailH*math.sin(10*x+10*view.t) end,padding_-ox,progress*w,P.tail)

              end
              pcall(function()
                holder.unlockCanvasAndPost(canvas)
              end)
            end
          })
        end,
        surfaceDestroyed = function(holder)
          animation.removeAllUpdateListeners()
          animation.cancel()
        end
      })


      view.onTouch=function(_,event)
        local v = event.getAction()
        if v== MotionEvent.ACTION_UP
          view.getParent().requestDisallowInterceptTouchEvent(false)
         elseif v== MotionEvent.ACTION_DOWN
          local x=event.getX()
          local y=event.getY()
          view.getParent().requestDisallowInterceptTouchEvent(true)
          --view.progress=x/view.width
          if math.abs(event.getX()-view.progress*view.width)<=100 then
            --view.getParent().requestDisallowInterceptTouchEvent(true)
            view.progress=x/view.width
          end
         elseif v== MotionEvent.ACTION_MOVE
          local x=event.getX()
          local y=event.getY()
          if math.abs(event.getX()-view.progress*view.width)<=100 then
            --view.getParent().requestDisallowInterceptTouchEvent(true)
            view.progress=x/view.width
          end
          --view.progress=x/view.width
        end
        return true
      end
    end,
    methods={
      setPadding=function(view,padding)
        view.mPadding=padding
        return view
      end,
      setProgress=function(view,progress)
        view.progress=progress
      end,
      setHeadS=function(view,headS)
        view.headS=headS
      end,


    },
  }
  return DuoTadpoleSlider

end

init.main()
