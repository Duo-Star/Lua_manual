--Android 12 Clock by Duo

require "import"
import "android.os.*"
import "android.app.*"
import "android.view.*"
import "android.widget.*"
import "android.graphics.*"
import "android.animation.*"
import "android.graphics.*"
Env={}
Env.t=0
Env.dt=1
clock={s=0,m=0,h=0}


local paint = Paint()
.setColor(0xff616161)
.setStyle(Paint.Style.STROKE)
.setStrokeWidth(5)
.setAntiAlias(true)
.setStrokeCap(Paint.Cap.ROUND)

function main()
  clock.s=os.date("%S")
  clock.m=os.date("%M")
  clock.h=os.date("%H")
  --print(os.date("%Y-%m-%d%H:%M:%S"))
end

timer_=Ticker()
timer_.Period=Env.dt*1000
timer_.onTick=function()
  Env.t=Env.t+Env.dt
  main()
end
timer_.start()
main()
function onDestroy() timer_.stop() end
local h,w = activity.getHeight(),activity.getWidth()
local ox,oy=w/2,h/2
local Lambda=2
animation = ValueAnimator.ofFloat({ 0, 1 })
animation.setDuration(3000)
animation.setRepeatCount(-1)
animation.setRepeatMode(2)
animation.start()
animation2 = ValueAnimator.ofFloat({ -5, 0 })
.setDuration(1500)
.setRepeatCount(0)
.setRepeatMode(2)
.start()


local layout = {
  FrameLayout,
  layout_width = 'fill',
  layout_height = 'fill',
  {
    SurfaceView;
    layout_width = 'fill',
    layout_height = 'fill',
    id = "surface",
    alpha=1,
  }
}
activity.setContentView(loadlayout(layout))
local holder = surface.getHolder()
holder.addCallback(SurfaceHolder.Callback {
  surfaceChanged = function(holder, format, width, height)
  end,
  surfaceChanged = function(holder)
  end,
  surfaceCreated = function(holder)
    animation.addUpdateListener(ValueAnimator.AnimatorUpdateListener {
      onAnimationUpdate = function(animate)
        local k = animation2.getAnimatedValue()
        local canvas = holder.lockCanvas()
        if canvas ~= nil then
          canvas.drawColor(0xFF3A5067)
          paint=Paint()
          .setColor(0xFFFCF9E8)
          .setStyle(Paint.Style.FILL)
          .setStrokeWidth(250)
          .setAntiAlias(true)

          cPaint=Paint()
          .setColor(0xFFEEF0FF)
          .setStyle(Paint.Style.FILL)
          .setStrokeWidth(250)
          .setAntiAlias(true)


          sPaint=Paint()
          .setColor(0xFF8E6B89)
          .setStyle(Paint.Style.FILL)
          .setStrokeWidth(250)
          .setAntiAlias(true)

          mPaint=Paint()
          .setColor(0xFF6574AD)
          .setStyle(Paint.Style.FILL)
          .setStrokeWidth(60)
          .setAntiAlias(true)
          .setStrokeCap(Paint.Cap.ROUND)

          hPaint=Paint()
          .setColor(0xFF414659)
          .setStyle(Paint.Style.FILL)
          .setStrokeWidth(60)
          .setAntiAlias(true)
          .setStrokeCap(Paint.Cap.ROUND)



          function dot(x,y,r,p)
            local p=p or paint
            local r=r or 5
            return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r, p)
          end
          function circle_(x,y,r,p)
            local p=p or paint
            return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r*Lambda*100, p)
          end
          function line_(x0,y0,x1,y1,p)
            local p=p or paint
            canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p)
          end

          function change(x,y)
            return {x=x*Lambda*100+ox, y=-y*Lambda*100+oy}
          end


          local path = Path()
          local f=function(x) return (5+k)*math.sin(12*x+math.pi/2+k)+150 end
          path.moveTo(Lambda*f(0)*math.cos(0)+ox,-Lambda*f(0)*math.sin(0)+oy)

          for angle = 0, 2*math.pi, 0.03 do
            local r = f(angle)
            local x = Lambda*r*math.cos(angle)+ox
            local y = -Lambda*r*math.sin(angle)+oy
            path.lineTo(x,y)
          end
          canvas.drawPath(path,cPaint)

          dot(1.2*math.cos(clock.s*(2*math.pi/60)-math.pi/2),-1.2*math.sin(clock.s*(2*math.pi/60)-math.pi/2),30+15*k,sPaint)
          line_(0,0,(0.6+0.1*k)*math.cos(clock.h*(2*math.pi/12)-math.pi/2),-(0.6+0.1*k)*math.sin(clock.h*(2*math.pi/12)-math.pi/2),hPaint)
          line_(0,0,(0.85+0.1*k)*math.cos(clock.m*(2*math.pi/60)-math.pi/2),-(0.85+0.1*k)*math.sin(clock.m*(2*math.pi/60)-math.pi/2),mPaint)


        end
        holder.unlockCanvasAndPost(canvas)
      end
    })
  end,
  surfaceDestroyed = function(holder)
    animation.removeAllUpdateListeners()
    animation.cancel()
  end
})


--屎山60行↓
--[[
--Android 12 Clock by Duo

require "import"
import { "android.os.*", "android.app.*", "android.view.*", "android.widget.*", "android.graphics.*", "android.animation.*", "android.graphics.*"}
local Env={t=0,dt=1} local clock={s=0,m=0,h=0} local h,w = activity.getHeight(),activity.getWidth() local ox,oy,Lambda=w/2,h/2,2
local paint = Paint().setColor(0xff616161).setStyle(Paint.Style.STROKE).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
local function main() clock.s=os.date("%S") clock.m=os.date("%M") clock.h=os.date("%H") end
local timer_=Ticker() timer_.Period=(Env.dt*1000) timer_.onTick=function() Env.t=Env.t+Env.dt main() end timer_.start() main() function onDestroy() timer_.stop() end
local animation = ValueAnimator.ofFloat({ 0, 1 }).setDuration(3000).setRepeatCount(-1).setRepeatMode(2).start()
local animation2 = ValueAnimator.ofFloat({ -5, 0 }).setDuration(1500).setRepeatCount(0).setRepeatMode(2).start()
activity.setContentView(loadlayout({ SurfaceView, layout_width = 'fill', layout_height = 'fill', id = "surface"}))
local holder = surface.getHolder()
holder.addCallback(SurfaceHolder.Callback {
  surfaceChanged = function(holder, format, width, height) end,
  surfaceChanged = function(holder) end,
  surfaceCreated = function(holder)
    animation.addUpdateListener(ValueAnimator.AnimatorUpdateListener {
      onAnimationUpdate = function(animate)
        local k = animation2.getAnimatedValue()
        local canvas = holder.lockCanvas()
        if canvas ~= nil then
          canvas.drawColor(0xFF3A5067)
          local paint=Paint().setColor(0xFFFCF9E8).setStyle(Paint.Style.FILL).setStrokeWidth(250).setAntiAlias(true)
          local cPaint=Paint().setColor(0xFFEEF0FF).setStyle(Paint.Style.FILL).setStrokeWidth(250).setAntiAlias(true)
          local sPaint=Paint().setColor(0xFF8E6B89).setStyle(Paint.Style.FILL).setStrokeWidth(250).setAntiAlias(true)
          local mPaint=Paint().setColor(0xFF6574AD).setStyle(Paint.Style.FILL).setStrokeWidth(60).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
          local hPaint=Paint().setColor(0xFF414659).setStyle(Paint.Style.FILL).setStrokeWidth(60).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
          local function dot(x,y,r,p) local p=p or paint local r=r or 5 return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r, p) end
          local function circle_(x,y,r,p) local p=p or paint return canvas.drawCircle(x*Lambda*100+ox, -y*Lambda*100+oy, r*Lambda*100, p) end
          local function line_(x0,y0,x1,y1,p) local p=p or paint return canvas.drawLine(x0*Lambda*100+ox,-y0*Lambda*100+oy,x1*Lambda*100+ox,-y1*Lambda*100+oy, p) end
          local path = Path()
          local f=function(x) return (5+k)*math.sin(12*x+math.pi/2+k)+150 end
          path.moveTo(Lambda*f(0)*math.cos(0)+ox,-Lambda*f(0)*math.sin(0)+oy)
          for angle = 0, 2*math.pi, 0.03 do
            local r = f(angle)
            local x = Lambda*r*math.cos(angle)+ox
            local y = -Lambda*r*math.sin(angle)+oy
            path.lineTo(x,y)
          end
          canvas.drawPath(path,cPaint)
          dot(1.2*math.cos(clock.s*(2*math.pi/60)-math.pi/2),-1.2*math.sin(clock.s*(2*math.pi/60)-math.pi/2),30+15*k,sPaint)
          line_(0,0,(0.6+0.1*k)*math.cos(clock.h*(2*math.pi/12)-math.pi/2),-(0.6+0.1*k)*math.sin(clock.h*(2*math.pi/12)-math.pi/2),hPaint)
          line_(0,0,(0.85+0.1*k)*math.cos(clock.m*(2*math.pi/60)-math.pi/2),-(0.85+0.1*k)*math.sin(clock.m*(2*math.pi/60)-math.pi/2),mPaint)
        end
        holder.unlockCanvasAndPost(canvas)
      end
    })
  end,
  surfaceDestroyed = function(holder)
    animation.removeAllUpdateListeners()
    animation.cancel()
  end
})
]]