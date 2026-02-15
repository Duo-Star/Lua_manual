--一个美丽的东西



require "import"
import "android.os.*"
import "android.app.*"
import "android.view.*"
import "android.widget.*"
import "android.graphics.*"
import "android.animation.*"

--import "nature"

h=activity.getHeight()
w=activity.getWidth()

pi=math.pi
sqrt=math.sqrt
math.randomseed(os.time())

local ox=w/2
local oy=h/2
ox_new=ox
oy_new=oy
Lambda=2

flist={
  function(x) return 25*math.sin(25*x) + 150 + 25*x end,
  function(x) return 10*math.sin(12*x)+150 end,
  function(x) return 8*x end,
  function(x) x=x-pi/2 return (math.exp(math.cos(x))-2*math.cos(4*x)+(math.sin(x/15))^2)*150 end,
  function(x) return 100*math.sin(2.5*x) end,


}



f=flist[math.random(1,#flist)]


--f=flist[5]

local animation = ValueAnimator.ofFloat({ 0, 5*math.pi })
animation.setDuration(3000)
animation.setRepeatCount(-1)
animation.setRepeatMode(2)
animation.start()



local layout =
{
  LinearLayout,
  orientation = 'vertical',
  layout_width = 'fill',
  layout_height = 'fill',
  {
    SurfaceView;
    layout_width = 'fill',
    layout_height = 'fill',
    id = "surface",
  };
};
activity.setContentView(loadlayout(layout))





local holder = surface.getHolder()
holder.addCallback(SurfaceHolder.Callback {
  surfaceChanged = function(holder, format, width, height)
  end,
  surfaceCreated = function(holder)
    animation.addUpdateListener(ValueAnimator.AnimatorUpdateListener {
      onAnimationUpdate = function(animate)
        local k = animate.getAnimatedValue()


        local canvas = holder.lockCanvas()
        if canvas ~= nil then
          canvas.drawColor(0xffffffff)

          local paint = Paint()
          paint.setColor(0xee5E35B1)
          paint.setStyle(Paint.Style.STROKE)
          paint.setStrokeWidth(10)
          paint.setAntiAlias(true)
          paint.setStrokeCap(Paint.Cap.ROUND)


          local paintwww = Paint()
          paintwww.setColor(0xFFCBCBCB)
          paintwww.setStyle(Paint.Style.STROKE)
          paintwww.setStrokeWidth(3)
          paintwww.setAntiAlias(true)
          paintwww.setStrokeCap(Paint.Cap.ROUND)


          --local ox = canvas.getWidth() / 2 --x
          --local oy = canvas.getHeight() / 2 --y
          --local Lambda = 150

          local path = Path()
          path.moveTo(Lambda*f(0)*math.cos(0)+ox,-Lambda*f(0)*math.sin(0)+oy)
          for angle = 0, k, 0.01 do
            local r = f(angle)
            local x = Lambda*r*math.cos(angle)+ox
            local y = -Lambda*r*math.sin(angle)+oy
            path.lineTo(x,y)
          end

          for aa=0,2*pi,pi/6 do
            local len=sqrt(4*oy^2+4*ox^2)*0.5
            canvas.drawLine(len*math.cos(aa)*Lambda+ox,-len*math.sin(aa)*Lambda+oy,-len*math.cos(aa)*Lambda+ox,len*math.sin(aa)*Lambda+oy, paintwww)
          end

          canvas.drawPath(path,paint)
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


function onTouchEvent(v)
  if v.action==1 then
    if (x_t-x_b)^2+(y_t-y_b)^2<=10 then
      print("点击:("..x_b..","..y_b..")")
    end
  end
  if v.action==0 then --落笔位置
    x_b=v.x
    y_b=v.y
    x_t=v.x
    y_t=v.y
   elseif v.getAction()==MotionEvent.ACTION_UP then--如果是松开事件
    --保存屏幕移动位置
    ox_new=ox
    oy_new=oy
   else
    --屏幕移动到的位置
    x_t=v.x
    y_t=v.y
    ox=ox_new+0.8*(x_t-x_b)--屏幕变化量
    oy=oy_new+0.8*(y_t-y_b)
    --info.setText("ox:"..floor(ox).."\noy:"..floor(oy))
  end
end
