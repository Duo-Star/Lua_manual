--cheems, popCat来和你过情人节啦😘

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

local Toolbar = luajava.bindClass "android.widget.Toolbar"
activity.getWindow().statusBarColor=0xFFF2F0E1
activity.getWindow().setNavigationBarColor(0xffffffff)
activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);

init={}

function popCat() end

init.main=function()
  class=init.class()
  popCat=init.popCat()
  duo=
  {
    LinearLayout,
    layout_width="match",
    layout_height="match",
    Orientation=1,
    BackgroundColor="#FFFFFCF3",
    {
      LinearLayout,
      layout_width="match",
      layout_height="60dp",
      --title="popCat",
      BackgroundColor="#FFF2F0E1",
      id="toolbar",
      {TextView,
        textSize="22dp",
        layout_gravity="center|left",
        layout_marginLeft="12dp",
        textColor="#EE171510",
        text="popCat",
        id="title",
      },
    },
    {
      LinearLayout,
      layout_width="fill",
      layout_height="fill",
      gravity="center|top",
      Orientation=1,
      id="root",
      {Space,
        layout_height="20dp",
      },
      {popCat,
        layout_width="123dp",
        layout_height="123dp",
        id="popCat_"
      }
    }
  }
  activity.setContentView(loadlayout(duo))
  popCat_.onClick=function(n)
    title.setText("popCat +"..n)
  end
  print("点我点我😘")
end

function init.class()
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

function init.popCat()
  local Glide = luajava.bindClass "com.bumptech.glide.Glide"
  popCat=class{
    extends=ImageView,
    fields={
      ox=_NIL,
      oy=_NIL,
      mPadding=_NIL,
      onClick=function() end,
      n=0,
      a="https://tc.24ly.cn/down.php/075086db4d63f63281765a5284dafeac.jpg",
      b="https://tc.24ly.cn/down.php/b6b18fb48b31519ba4a4d5302f01abf2.jpg",
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
      end)
      Glide.with(activity).load(view.a).into(view)
      view.onTouch=function(_,event)
        local v = event.getAction()
        if v== MotionEvent.ACTION_UP
          view.getParent().requestDisallowInterceptTouchEvent(false)
          Glide.with(activity).load(view.a).into(view)
         elseif v== MotionEvent.ACTION_DOWN
          local x=event.getX()
          local y=event.getY()
          view.getParent().requestDisallowInterceptTouchEvent(true)
          Glide.with(activity).load(view.b).into(view)
          view.n=view.n+1
          view.onClick(view.n)
         elseif v== MotionEvent.ACTION_MOVE
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
  return popCat
end
init.main()