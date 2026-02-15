--打砖块
--更新 增加了砖块厚度
--有人说难度低，其实这只是为了演示Nature Math绘图和物理引擎的示例，或者把它当做休闲小游戏😘
--碰到砖块有15%的概率产生新小球，点击小球还可以查看小球的运动信息

--开学前最后一个项目
--好好学习，天天向上

Duo={}
Duo.game=function()
  require "import"
  --import "graph"
  Duo.graph()
  import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
  --graph.backgroundColor=0xFF383838
  graph.lam=130
  graph.o=Vector(w*0.05,h*0.8)
  math.randomseed(os.time())
  paintFill= Paint().setColor(0xFF4E4E4E).setStrokeWidth(5).setStyle(Paint.Style.STROKE)--STROKE


  colors={
    0xff179299,--深青色
    0xff8839ef,--紫色
    0xffdd7878,--橙红
    0xff1e66f5,--深蓝
    0xff6c6f85,--灰色
    --0xffd20f39,--红色
    0xffea76cb,--粉色
  }




  function 砖块() end
  砖块={
    __call=function(_,data)
      return 砖块.new(data)
    end,
    __index = {
      new=function(data)
        local par=Particle({x=data.x})
        par.r=data.r or .4
        par.k=data.k or 1000
        par.n=data.n or 5
        par.isControl=data.isControl or false
        par.paint=data.paint or paint
        par.paintText=Paint().setColor(0xFFFFFFFF).setAntiAlias(true).setTextAlign(Paint.Align.LEFT).setTextSize(40).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)
        return setmetatable(par,砖块)
      end,
      onDraw=function(砖块_,canvas)
        graph.drawRect(canvas,砖块_.x+Vector(砖块_.r,砖块_.r),砖块_.x-Vector(砖块_.r,砖块_.r),砖块_.paint)
        graph.drawText(canvas,""..砖块_.n,砖块_.x,砖块_.paintText)
      end,
      collision=function(砖块_,particle)
        --local F=Vector()
        local isCollision=false
        local x,y=particle.x.x,particle.x.y
        local x0,y0,r=砖块_.x.x,砖块_.x.y,砖块_.r
        local y_down,y_up,x_left,x_right=y0-r,y0+r,x0-r,x0+r
        if x>x_left and x<x_right and y>y_down and y<y_up then
          isCollision=true
          local dx=particle.x - 砖块_.x
          if math.abs(dx.x)>math.abs(dx.y) then--在左右受力
            if dx.x<0 then--在左
              --F.x=-(砖块_.r+dx.x)*砖块_.k
              particle.v.x=-particle.v.x
             else--在右
              --F.x=(砖块_.r-dx.x)*砖块_.k
              particle.v.x=-particle.v.x
            end
           else--在上下
            if dx.y<0 then--在下
              --F.y=-(砖块_.r+dx.y)*砖块_.k
              particle.v.y=-particle.v.y
             else
              --F.y=(砖块_.r-dx.y)*砖块_.k
              particle.v.y=-particle.v.y
            end
          end
        end
        return isCollision
      end,



    }
  }
  setmetatable(砖块, 砖块)





  砖块组={}
  for x=.5,5.5 do
    for y=3.5,9.5 do
      砖块组[#砖块组+1]=砖块({
        x=Vector(x,y),
        paint=Paint().setColor(colors[math.random(1,#colors)]).setStrokeWidth(5).setStyle(Paint.Style.FILL),
        n=math.random(1,5)
      })
    end
  end

  砖块组[#砖块组+1]=砖块({x=Vector(5,10+10),r=10,isControl=true})
  砖块组[#砖块组+1]=砖块({x=Vector(6+10,5),r=10,isControl=true})
  砖块组[#砖块组+1]=砖块({x=Vector(-10,5),r=10,isControl=true})
  砖块组[#砖块组+1]=砖块({x=Vector(0,-.5),r=.5,isControl=true})



  小球组={}
  for i=1,1 do
    小球组[#小球组+1]=Particle({x=Vector(),v=Vector(2,1.2)})
  end


  function main()
    for n=1,#小球组 do
      local A=小球组[n]
      for i=1,#砖块组 do
        local item=砖块组[i]
        if item
          if item:collision(A) and not(item.isControl) then
            if item.n>1
              item.n=item.n-1
             else
              table.remove(砖块组,i)
            end

            if math.random(1,100)<=15 then
              print_("裂变！得到1个小球")
              小球组[#小球组+1]=Particle({x=A.x,v=Vector(math.random(-20,20)/10,math.random(-20,20)/10)})
            end
          end
        end
      end
      A:update()
    end
  end

  function showDialog(标题,内容,Todo)
    local dialog=MaterialAlertDialogBuilder(activity)
    .setTitle(标题)
    .setMessage(内容)
    .setPositiveButton("确定",{onClick=function() Todo() end})
    .show()
  end

  Env.dt=0.02
  timer_=Ticker()
  timer_.Period=Env.dt*1000
  timer_.onTick=function()
    Env.t=Env.t+Env.dt
    main()
    data=小球组
    if #砖块组==4 then
      print_("恭喜通关")
      timer_.stop()
      showDialog("恭喜通关","打完了所有砖块",function() activity.finish() end)
    end
  end
  timer_.start()
  function onDestroy()
    timer_.stop()
  end



  function onDraw(canvas,graph)
    for i=1,#砖块组 do
      local item=砖块组[i]
      item:onDraw(canvas)
    end
    --graph.drawPoint(canvas,A.x,)

  end

  var_a.setValueFrom(0)
  var_a.setValueTo(6)
  var_a.setValue(3)
  var_a.addOnChangeListener({
    onValueChange=function(view,value,bool)
      local a=tonumber(value)
      砖块组[#砖块组].x.x=a
    end
  })
end
Duo.graph=function()
  --[[**
 * @Name: 一个小游戏.lua
 * @Date: 2024-02-15 01:15:18
 * @Description: No special instructions
 *
**]]

  require "import"
  import "android.os.*"
  import "android.app.*"
  import "android.view.*"
  import "android.widget.*"
  import "android.graphics.*"
  import "android.animation.*"
  import "com.bumptech.glide.Glide"
  import "com.google.android.material.dialog.MaterialAlertDialogBuilder"

  --导入nature库，手册没有(
  --import "nature"
  Duo.nature()


  local Slider = luajava.bindClass "com.google.android.material.slider.Slider"
  local MaterialCardView = luajava.bindClass "com.google.android.material.card.MaterialCardView"

  --获取设备屏幕宽高
  h=activity.getHeight()
  w=activity.getWidth()

  --初始化随机数种子
  math.randomseed(os.time())

  --重写print
  print_=function(...)
    txt.setText(txt.text.."\n"..(...))
  end


  graph={
    tps={},
    tps_0={},
    dtps=Vector(),
    o=Vector(w/2,h/2),
    o_0=Vector(w/2,h/2),--
    size=#Vector(w/2,h/2),--屏幕大小
    tpl_0=0,
    tpl=0,
    lam=150,
    lam_0=150,
    tpn=0,
    debugMode=false,
    select={},--被选择的几何对象,内部保存对象的标签


  }




  --Animation
  local animation = ValueAnimator.ofFloat({ 0, 5*math.pi }).setDuration(3000).setRepeatCount(-1).setRepeatMode(2).start()


  --初始化一些笔
  paint = Paint().setColor(0xee5E35B1).setStyle(Paint.Style.STROKE).setStrokeWidth(10).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  paintOut= Paint().setColor(0xFFF6F1ED).setStrokeWidth(10).setStyle(Paint.Style.STROKE).setShadowLayer(30,0,0,0xFFF5EEE2)
  paintOut2= Paint().setColor(0xFFAE4839).setStrokeWidth(10).setStyle(Paint.Style.STROKE).setShadowLayer(30,0,0,0xFFAE4839)
  paintWeb = Paint().setColor(0xFFF6F1ED).setStrokeWidth(10)
  paintFill= Paint().setColor(0xFFF6F1ED).setStrokeWidth(5).setStyle(Paint.Style.FILL).setShadowLayer(30,0,0,0xFFF5EEE2)
  paintControl= Paint().setColor(0xFF5E4B3C).setStrokeWidth(8).setStyle(Paint.Style.STROKE)
  paintText = Paint().setColor(0xFFC2AE8E).setAntiAlias(true).setTextAlign(Paint.Align.LEFT).setTextSize(50).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)
  paintTreasure_1=Paint().setColor(0xFFFCF4C9).setStrokeWidth(10).setStyle(Paint.Style.STROKE).setShadowLayer(30,0,0,0xFFF5EEE2)
  paintTreasure_2=Paint().setColor(0xFFCBBC89).setStrokeWidth(10).setStyle(Paint.Style.FILL).setShadowLayer(30,0,0,0xFFF5EEE2)
  paintTreasure_T = Paint().setColor(0xFFF6F1ED).setAntiAlias(true).setTextAlign(Paint.Align.LEFT).setTextSize(35).setStrokeCap(Paint.Cap.ROUND).setStyle(Paint.Style.FILL).setStrokeWidth(3)
  paintTreasure_3=Paint().setColor(0xFF6AA03B).setStrokeWidth(10).setStyle(Paint.Style.STROKE).setShadowLayer(30,0,0,0xFFF5EEE2)




  paint坐标轴=Paint().setColor(0xAA252525).setStyle(Paint.Style.STROKE).setStrokeWidth(4).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  paint_Red=Paint().setColor(0xFFE60721).setStyle(Paint.Style.STROKE).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  paint_Blue=Paint().setColor(0xFF0066C7).setStyle(Paint.Style.STROKE).setStrokeWidth(10).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  paint_Green=Paint().setColor(0xFF007F24).setStyle(Paint.Style.STROKE).setStrokeWidth(8).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)
  paint_Black=Paint().setColor(0xFF252525).setStyle(Paint.Style.STROKE).setStrokeWidth(5).setAntiAlias(true).setStrokeCap(Paint.Cap.ROUND)




  function showDialog(标题,内容,Todo)
    local dialog=MaterialAlertDialogBuilder(activity)
    .setTitle(标题)
    .setMessage(内容)
    .setPositiveButton("确定",{onClick=function() Todo() end})
    .show()
  end






  --布局表
  local layout =
  { FrameLayout,
    layout_width = 'fill',
    layout_height = 'fill',
    { SurfaceView;
      layout_width = 'fill',
      layout_height = 'fill',
      id = "surface",
    },
    { TextView,
      text="Duo提供技术支持",
      --textColor=0xFFF6F1ED,
      textSize="12dp",
      layout_gravity="bottom",
      id="txt",
    },
    { Button;
      layout_gravity="bottom|right";
      text="reset";
      onClick=function()
        graph.reset()
      end,
    },

    { Button;
      layout_width="220px";
      layout_height="130px";
      layout_gravity="top|left";
      id="btn1";

    },

    { Button;
      layout_width="220px";
      layout_height="130px";
      layout_gravity="top|right";
      id="btn2";
      text="";
    },

    {
      Slider,--滑动条
      layout_marginBottom="50dp",
      layout_gravity="bottom",
      id="var_a",
      ValueFrom=-5,
      Value=0,
      ValueTo=5,
      alpha=0.9,
    },


    {MaterialCardView,
      layout_height="150dp",
      layout_width="220dp",
      radius="3dp",cardElevation=0,
      layout_margin='5dp',strokeColor=0xFFB2B2B2,
      strokeWidth=1.5,cardBackgroundColor=0xFFFFFFff,
      layout_gravity="top|center",
      id="select_card",
      { LinearLayout,
        orientation='vertical',
        layout_width='fill',
        layout_height='fill',
        background='#00FFFFFF',
        {MaterialCardView,
          layout_height="30dp",
          layout_width="220dp",
          radius="0dp",cardElevation=0,
          layout_margin='0dp',
          strokeWidth=0,cardBackgroundColor=0xFFD2E9FF,
          layout_gravity="top|center",
          { TextView,
            text="Duo提供技术支持",
            --textColor=0xFFF6F1ED,
            textSize="16dp",layout_margin='2dp',
            layout_gravity="bottom",
            id="select_card_title",
          },
        },
        {MaterialCardView,
          layout_height="1.5dp",
          layout_width="fill",
          radius="6dp",cardElevation=0,
          layout_margin='0dp',
          strokeWidth=0,cardBackgroundColor=0xFF999999,
          layout_gravity="top|center",
        },
        {MaterialCardView,
          layout_height="fill",
          layout_width="fill",
          radius="6dp",cardElevation=0,
          layout_margin='0dp',
          strokeWidth=0,cardBackgroundColor=0xFFFFFFFF,
          layout_gravity="top|center",
          { TextView,
            text="Duo提供技术支持",
            --textColor=0xFFF6F1ED,
            textSize="12dp",layout_margin='2dp',
            layout_gravity="top",
            id="select_card_txt",
          },
        },

      },
    }

  }
  activity.setContentView(loadlayout(layout))

  select_card_dimiss=function(a)
    if a then
      select_card.alpha=0
     else
      select_card.alpha=1
    end
  end
  select_card_dimiss(true)


  graph.backgroundColor=0xFFffffff

  graph.reset=function()
    graph.lam=150
    graph.o=Vector(w*0.05,h*0.8)
  end

  graph.toSP=function(v)
    return Vector(v.x*graph.lam+graph.o.x,
    v.y*(-graph.lam)+graph.o.y)
  end

  graph.drawPoint=function(canvas,v,p_)
    local p_=p_ or paint
    canvas.drawCircle(v.x*graph.lam+graph.o.x, v.y*(-graph.lam)+graph.o.y, 8, p_)
  end

  graph.drawParticle=function(canvas,particle,p_)
    local p_=p_ or paint
    canvas.drawCircle(particle.x.x*graph.lam+graph.o.x, particle.x.y*(-graph.lam)+graph.o.y, 8, p_)
  end


  canvas__=Canvas

  graph.drawRect=function(canvas,p1,p2,p_)
    local p_=p_ or paint
    canvas.drawRect(p1.x*graph.lam+graph.o.x, p1.y*(-graph.lam)+graph.o.y,
    p2.x*graph.lam+graph.o.x, p2.y*(-graph.lam)+graph.o.y,
    p_)
  end

  graph.drawText=function(canvas,str,p,p_)
    local p_=p_ or paint
    canvas.drawText(str,p.x*graph.lam+graph.o.x, p.y*(-graph.lam)+graph.o.y,p_)
  end





  graph.drawSegment=function(canvas,p0,p1,p_)
    local p_=p_ or paint
    canvas.drawLine(
    p0.x*graph.lam+o.x,
    -p0.y*graph.lam+o.y,
    (p1.x)*graph.lam+o.x,
    -(p1.y)*graph.lam+o.y, p)
  end


  graph.drawLine=function(canvas,l,p_)
    local p_=p_ or paint
    local a=(graph.size/graph.lam)
    canvas.drawLine(
    (l.p.x-a*l.v.x)*graph.lam+o.x,
    -(l.p.y-a*l.v.y)*graph.lam+o.y,
    (l.p.x+a*l.v.x)*graph.lam+o.x,
    -(l.p.y+a*l.v.y)*graph.lam+o.y, p_)
  end

  graph.drawConic0=function(canvas,c,p_)
    local p_=p_ or paint
    local p0=graph.toSP(c:indexPoint(0))
    local p1
    local dx=0.15*(1/graph.lam)
    local path = Path()
    path.moveTo(p0.x,p0.y)
    if dx<=0.05 then dx=0.05 end
    for theta=0,2*pi+dx,dx do
      p1=graph.toSP(c:indexPoint(theta))
      path.lineTo(p1.x,p1.y)
    end
    canvas.drawPath(path,p_)
  end

  graph.drawTriangle=function(canvas,t,p_)
    local p_=p_ or paint
    local path = Path()
    local pa=graph.toSP(t.a)
    path.moveTo(pa.x,pa.y)
    local pb=graph.toSP(t.b)
    path.lineTo(pb.x,pb.y)
    local pc=graph.toSP(t.c)
    path.lineTo(pc.x,pc.y)
    path.close()
    canvas.drawPath(path,p_)
  end


  graph.drawCurve=function(canvas,c,p_)
    local p_=p_ or paint
    local p0=graph.toSP(c:indexPoint(c.range[1]))
    local p1
    local dx=0.15*(1/graph.lam)
    local path = Path()
    path.moveTo(p0.x,p0.y)
    if dx<=0.05 then dx=0.05 end
    for t=c.range[1],c.range[2]+dx,dx do
      p1=graph.toSP(c:indexPoint(t))
      path.lineTo(p1.x,p1.y)
    end
    canvas.drawPath(path,p_)
  end



  data={}

  onDraw=function() end
  graph.onTouch=function() end
  graph.onTouch_ACTION_DOWN=function() end


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
            --设置背景颜色
            canvas.drawColor(graph.backgroundColor)

            o=graph.o
            Lambda=graph.lam

            graph.drawPoint(canvas,Vector())
            graph.drawPoint(canvas,Vector(1))
            graph.drawPoint(canvas,Vector(0,1))
            canvas.drawLine(-o.x+o.x,0+o.y,(w-o.x)+o.x,0+o.y, paint坐标轴)
            canvas.drawLine(0+o.x,-o.y+o.y,0+o.x,(h-o.y)+o.y, paint坐标轴)


            onDraw(canvas,graph)

            --[[
          for n=1,#data do
            local item=data[n]
            local class=getmetatable(item)
            if class == Conic0 then
              graph.drawConic0(canvas,item,paint_Black)
             elseif class == Vector then
              graph.drawPoint(canvas, item, paint_Blue)
             elseif class == Line then
              graph.drawLine(canvas, item, paint_Green)
             elseif class == Curve then
              graph.drawCurve(canvas, item, paint_Red)
             elseif class == Triangle then
              graph.drawTriangle(canvas, item, paint_Red)



            end
          end
]]


            for a, item in pairs(data) do
              local class=getmetatable(item)
              if class == Conic0 then
                graph.drawConic0(canvas,item,item.paint or paint_Black)
               elseif class == Vector then
                graph.drawPoint(canvas, item, item.paint or paint_Blue)
               elseif class == Line then
                graph.drawLine(canvas, item, item.paint or paint_Green)
               elseif class == Curve then
                graph.drawCurve(canvas, item, item.paint or paint_Red)
               elseif class == Triangle then
                graph.drawTriangle(canvas, item, item.paint or paint_Red)
               elseif class == Particle then
                graph.drawParticle(canvas, item, item.paint or paint_Blue)


              end

            end

            if #graph.select==1 then
              local item=data[(graph.select[1])]
              local class=getmetatable(item)
              if class == Particle then
                select_card_dimiss(false)
                local sp=graph.toSP(item.x)--该对象在屏幕上的位置
                select_card.x=sp.x
                select_card.y=sp.y
                select_card_title.setText("质点: "..graph.select[1])
                select_card_txt.setText("m: "..item.m.."\nx: ("..item.x.x..", "..item.x.y..")\nv: ("..item.v.x..", "..item.v.y..")\na: ("..item.a.x..", "..item.a.y..")\nq: "..item.q)
              end
             else
              select_card_dimiss(true)
            end




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


  Env.t=0
  Env.dt=0.02
  timer_=Ticker()
  timer_.Period=Env.dt*1000
  timer_.onTick=function()
    Env.t=Env.t+Env.dt
    main()
  end
  --timer_.start()



  --退出程序后回收Ticker
  function onDestroy()
    timer_.stop()

  end






  --处理触摸事件
  surface.onTouch =function(v, event)
    graph.onTouch(v, event)

    --获取有多少个手指碰到屏幕
    local PointerCount = event.getPointerCount()

    graph.tpn=PointerCount

    --print_(event.getActionMasked())



    --为每个手指记录触摸坐标
    for i = 1, PointerCount do
      if PointerCount==2
        graph.tps[i]=Vector(event.getX(i-1),event.getY(i-1))

       elseif PointerCount==1
        local p=Vector(event.getX(i-1),event.getY(i-1))
        graph.tps[1]=p
        graph.tps[2]=false
      end
    end

    if graph.debugMode print_(""..type(graph.tps[1])) end



    --手指碰到屏幕
    if(event.getActionMasked() == MotionEvent.ACTION_DOWN)
      if graph.debugMode print_("手指碰到屏幕") end
      graph.o_0=graph.o
      graph.tps_0[1]=Vector(event.getX(1-1),event.getY(1-1))
      --触摸点在坐标系中的坐标
      local gtp=Vector((graph.tps_0[1].x-graph.o.x)/graph.lam,-(graph.tps_0[1].y-graph.o.y)/graph.lam)
      --print_(dump(gtp))
      for a, item in pairs(data) do
        local class=getmetatable(item)
        if class == Particle then
          local dx=gtp-item.x
          if (#dx)*graph.lam<50 then--检测被触摸
            graph.select[1]=a--向选择对象表中添加此对象
            --[[
          select_card_dimiss(false)
          local sp=graph.toSP(item.x)--该对象在屏幕上的位置
          select_card.x=sp.x
          select_card.y=sp.y
          select_card_title.setText("质点: "..a)
          select_card_txt.setText("m: "..item.m.."\nx: ("..item.x.x..", "..item.x.y..")\nv: ("..item.v.x..", "..item.v.y..")\na: ("..item.a.x..", "..item.a.y..")\nq: "..item.q)
--]]
          end
        end


      end


      graph.onTouch_ACTION_DOWN(gtp)
     elseif(event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN && PointerCount <= 2)
      --print_("次要手指碰到屏幕")
      --graph.o_0=graph.o
      graph.tps_0[2]=Vector(event.getX(2-1),event.getY(2-1))
      graph.tpl_0 = #(graph.tps[1] - graph.tps[2])
      graph.lam_0 = graph.lam
      --]]
      --手指移动
     elseif(event.getActionMasked() == MotionEvent.ACTION_MOVE)
      graph.select={}
      select_card_dimiss(true)
      --local dtp= 0.5*(graph.tps[1]+graph.tps[2]) - 0.5*(graph.tps_0[1]+graph.tps_0[2])
      local dtp= graph.tps[1]-graph.tps_0[1]

      graph.o = graph.o_0 + dtp*0.8--*Number.BooleanToNumber(not(graph.tps[2]))


      if(PointerCount >= 2)
        --print_("当有两根手指落下就计算缩放")
        --[
        graph.tpl = #(graph.tps[1] - graph.tps[2])
        local dtpl = graph.tpl - graph.tpl_0
        graph.lam=graph.lam_0*(dtpl/graph.tpl_0+1)
        --]]
      end

     elseif(event.getActionMasked() == MotionEvent.ACTION_POINTER_UP)
      --print_("次要手指离开")


      graph.o_0=graph.o

      graph.tps_0[1]=Vector(event.getX(1-1),event.getY(1-1))



     elseif(event.getActionMasked() == MotionEvent.ACTION_UP)
      -- print_("手指离开")




    end


    return true
  end
end
Duo.nature=function()
  --nature


  info={
    author="Duo",
    version=5.02,
    date="2023.6.3",
    info=[[分享_自用数学库，将嵌入Duo Nature,可能存在错误，欢迎大家指出。将持续更新(因为学业原因，更新周期较长为一个月左右)。包括函数，统计，解析几何等，自习课写的程序长达50页,之后将加入线段，向量，三角形，圆锥曲线等几何类型(本来在纸上写好了，每次回来时间不太够，慢慢码吧)。提供互相作用，例如，求公共点，求垂直，平分线，平行线，角分线，等等等等()在Duo Nature环境下，可以直观展示各个几何类型及相互作用]],
    history={
      v1={"2023.3.05","基本初等函数，常数，统计，逻辑与判断"},
      v2={"2023.4.03","点，直线，更普遍的加减乘除"},
      v3={"2023.5.1","点，向量，直线，全部替换为二维和三维通用，新增平面，操作控制台输出，向量运算，空间直线的位置关系初步"},
      v4={"2023.5.25","新增物理环境"},
      v5={"2023.6","重写"},

    },
  }

  Env={
    e=math.exp(1),
    pi=math.pi,
    huge=math.huge,
    inf=math.huge,
    nan=0/0,
    phi=(math.sqrt(5)-1)/2,
    t=0,
    dt=0.01,
    dx=0.001,
    d=10^(-7),
    g=-10,
  }

  e=Env.e
  pi=Env.pi

  --指,对数
  function log(a,b) return math.log10(b)/math.log10(a) end--对数
  function lg(a) return math.log10(a) end--常用对数
  function ln(a) return math.log(a) end--自然对数
  function exp(a) return math.exp(a) end--自然指数函数
  --三角
  function sin(a) return math.sin(a) end--一般
  function cos(a) return math.cos(a) end
  function tan(a) return math.tan(a) end
  function sinh(a) return math.sinh(a) end--双曲
  function cosh(a) return math.cosh(a) end
  function tanh(a) return math.tanh(a) end
  function arcsin(a) return math.asin(a) end--反
  function arccos(a) return math.acos(a) end
  function arctan(a) return math.atan(a) end
  --其它
  function abs(a) return math.abs(a) end
  function floor(a) return math.floor(a) end--向下取整
  function ceil(a) return math.ceil(a) end--向上取整
  function deg(a) return math.deg(a) end--角度转换
  function rad(a) return math.rad(a) end
  function max(...) return math.max(...) end--值
  function min(...) return math.min(...) end
  function mod(a,b) return a%b end
  function atan2(a,b) return math.atan2(a,b) end--坐标转换
  function random(a,b) return math.random(a,b) end--随机
  function sqrt(a) return math.sqrt(a) end
  function sinc(x)--信号分析
    if x==0 then return 1
     else return sin(x)/x
    end
  end
  function sgn(x)--析离符号
    if x>0 return 1
     elseif x==0 return 0
     else return -1
    end
  end
  function key(x)--开关函数
    if x>0 return 1 else return 0 end
  end
  function key0(x)--自然单位阶跃函数
    return (sgn(x)+1)/2
  end
  function key1(x)--经典单位阶跃函数
    if x>=0 return 1 else return 0 end
  end
  function root(x)--根函数
    if x==0 return 1 else return 0 end
  end
  --三角函数互转
  function sin2cos(s,x) return sqrt(1-(sin(s))^2)*sgn(x) end
  function cos2sin(c,y) return sqrt(1-(cos(c))^2)*sgn(y) end
  function sin2tan(s,x) return (sin(s)/sqrt(1-(sin(s))^2))*sgn(x) end
  function cos2tan(c,y) return (sqrt(1-(cos(c))^2)/cos(c))*sgn(y) end
  function tan2sin(t,y) return sqrt(1/(1+(1/(tan(t))^2)))*sgn(y) end
  function tan2cos(t,x) return sqrt(1/(1+((tan(t))^2)))*sgn(x) end
  --三角函数转角
  function sin2w(s,x) return arcsin(s)+(1/2)*(1-sgn(x))*(math.pi-2*arcsin(s)) end
  function cos2w(c,y) return arccos(c)*sgn(y) end
  function tan2w(t,y) return arctan(t)+(math.pi/2)*(1-sgn(y)) end
  --阶乘
  function factorial(n)
    if n == 0 or n == 1 then
      return 1
     else
      return n * factorial(n - 1)
    end
  end




  --#Number 数值类
  Number={
    BooleanToNumber=function(b)
      if b then return 1 else return 0 end
    end,



  }




  --#Equation 方程
  function Equation() end
  Equation={
    solve2x2LinearSystem=function(a1, b1, c1, a2, b2, c2)
      --[[a1 x + b1 y = c1, a2 x + b2 y = c2 ]]
      local D = a1 * b2 - a2 * b1-- 计算行列式D
      if D == 0 then-- 检查行列式是否为零
        return nil,nil, "error: 行列式为零，方程组无解或有无穷多解"
       else-- 计算x和y的值
        local x = (c1 * b2 - c2 * b1) / D
        local y = (a1 * c2 - a2 * c1) / D
        return x, y
      end
    end,
    solveSinForMainRoot=function(a,w,p,c)--计算三角方程的主解 a sin(w t+p)+c=0
      local u=math.asin(-c/a)
      return {(u-p)/w,(math.pi-u-p)/w}
    end,--print(Equation.solveSinForMainRoot(2,3,4,-1)[2])
    solveCosSinForMainRoot=function(u,v,c)--计算三角方程的主解 u cos(t)+v sin(t)+c=0
      local a=math.sqrt(u^2+v^2)*sgn(v)
      local p=math.atan(u/v)
      return Equation.solveSinForMainRoot(a,1,p,c)
    end,--print(Equation.solveCosSinForMainRoot(2,3,1)[2])






  }






  --#Is 判断类
  function Is() end
  Is={
    Oddnumber=function(x)--判断奇数
      if is.integer(x) and not(is.evennumber(x)) then
        return true
       else return false
      end
    end,
    Integer=function(x)--判断整数
      if x==floor(x) then
        return true
       else return false
      end
    end,
    Evennumber=function(x)--判断偶数
      if is.integer(x) and x%2==0 then
        return true
       else return false
      end
    end,
    Zero=function(data)--判断一个: 整数等于零 or 浮点数接近零
      return math.abs(data)<=Env.d
    end,
    Equality=function(a,b)--判断一个: 整数相等 or 浮点数接近
      return Number.isZero(a-b)
    end,
    Vector=function(data)--判断是否为向量
      return getmetatable(data) == Vector
    end,
    Number=function(data)--判断是否为数字
      return type(data)=='number'
    end,
    Table=function(data)--判断是否为数组
      return type(data)=='table'
    end,


  }



  --#Vector 向量
  function Vector() end
  Vector={
    __call=function(_,x,y,z)
      return Vector.new(x,y,z)
    end,
    __add=function(m,n)
      return Vector.add(m,n)
    end,
    __sub=function(m,n)
      return Vector.sub(m,n)
    end,
    __mul=function(m,n)
      if Is.Vector(m) and Is.Vector(n) then
        return Vector.dot(m,n)
       elseif (Is.Number(m) and Is.Vector(n)) then
        return Vector.scale(n,m)
       elseif (Is.Number(n) and Is.Vector(m)) then
        return Vector.scale(m,n)
      end
    end,
    __div=function(m,n)
      return Vector.div(m,n)
    end,
    __len=function(m)
      return Vector.len(m)
    end,
    __unm = function(m)
      return Vector.scale(-1,m)
    end,
    __index={
      new=function(a,b,c)
        return setmetatable({x=a or 0.0,y=b or 0.0,z=c or 0.0 },Vector)
      end,
      new_ang=function(theta,phi,l)
        local theta=theta or 0
        local phi=phi or 0
        local l=l or 1
        local x=cos(theta)*cos(phi)*l
        local y=sin(theta)*cos(phi)*l
        local z=sin(phi)*l
        return setmetatable({x=x,y=y,z=z },Vector)
      end,
      new_ang2=function(theta,l)
        local l=l or 1
        local x=cos(theta)*l
        local y=sin(theta)*l
        local z=0
        return setmetatable({x=x,y=y,z=z },Vector)
      end,
      new_nan=function()
        return Vector(Env.nan,Env.nan,Env.nan)
      end,
      is={
        this=function(data)
          return getmetatable(data) == Vector
        end,
        zero=function(data)
          return data.x==0 and data.y==0 and data.z==0
        end,
        vi=function(data)
          return data.x==1 and data.y==0 and data.z==0
        end,
        vj=function(data)
          return data.x==0 and data.y==1 and data.z==0
        end,
        vk=function(data)
          return data.x==0 and data.y==0 and data.z==1
        end,
        parallel=function(a,b)
          return Vector.is.zero(Vector.cross(a,b))
        end,
        vertical=function(a,b)
          return Is.Zero(Vector.dot(a,b))
        end,
      },
      to={
        Complex=function(data)
          return Complex(data.x, data.y)
        end,
      },
      add=function(m,n)
        return Vector(m.x+n.x, m.y+n.y, m.z+n.z)
      end,
      sub=function(m,n)
        return Vector(m.x-n.x, m.y-n.y, m.z-n.z)
      end,
      div=function(m,n)
        return Vector(m.x/n.x, m.y/n.y, m.z/n.z)
      end,
      dot=function(m,n)--点积
        return m.x*n.x + m.y*n.y + m.z*n.z
      end,
      mul=function(m,n)
        return Vector(m.x*n.x, m.y*n.y, m.z*n.z)
      end,
      scale=function(n,m)--Vector, lambda
        return Vector(m*n.x,m*n.y,m*n.z)
      end,
      len=function(m)
        return math.sqrt(m.x^2 + m.y^2 + m.z^2)
      end,
      pow2=function(m)
        return m.x^2 + m.y^2 + m.z^2
      end,
      angle=function(m,n)
        return math.acos(Vector.dot(m,n)/(Vector.len(m)*Vector.len(n)))
      end,
      clone=function(m)
        return Vector(m.x, m.y, m.z)
      end,
      unit=function(m)
        return Vector.scale(1/Vector.len(m), m)
      end,
      square=function(m)
        return m.x^2 + m.y^2 + m.z^2
      end,
      project=function(m,n)
        return Vector.len(m)*(Vector.dot(m,n)/(Vector.len(m)*Vector.len(n)))*Vector.unit(n)
      end,
      cross = function(v, u)--叉积
        local out = Vector()
        local a, b, c = v.x, v.y, v.z
        out.x = b * u.z - c * u.y
        out.y = c * u.x - a * u.z
        out.z = a * u.y - b * u.x
        return out
      end,
      mid=function(a,b)
        return Vector((a.x+b.x)/2,(a.y+b.y)/2,(a.z+b.z)/2)
      end,
      tp2 = function(p,u,v,a)
        return p + a.x*u + a.y*v
      end,
      tp = function(p,u,v,n,a)
        return p + a.x*u + a.y*v + a.z*n
      end,
      ang2=function(p)
        return math.atan2(p.y,p.x)
      end,
      floor=function(v)
        return Vector(math.floor(v.x),math.floor(v.y),math.floor(v.z))
      end,
      faster=function()--快捷访问
        v_project=Vector.project
        v_cross=Vector.cross v_unit=Vector.unit
        v_sub=Vector.sub v_add=Vector.add
        v_dot=Vector.dot v_len=Vector.len
        v_abs=Vector.len v_scale=Vector.scale
        --中文支持
        转为单位向量=Vector.unit 向量加=Vector.add
        向量减=Vector.sub 向量数乘=Vector.scale
        向量数量积=Vector.dot 向量模=Vector.len
      end,
    }
  }
  setmetatable(Vector, Vector)








  --#Line 直线
  function Line() end
  Line={
    __call=function(_,p,v)
      return Line.new(p,v)
    end,
    __index = {
      new=function(p,v)--新建 直线
        return setmetatable({p=p or Vector(),v=v or Vector(0,1) },Line)
      end,
      newFrom2Point=function(p1,p2)--新建 直线
        return Line(p1,p2-p1)
      end,

      loadTest=function()--加载测试
        return Line(Vector(1),Vector(1,1))
      end,
      indexP=function(l,lam)
        return l.p+l.v:scale(lam)
      end,
      getIntersectPoint2d=function(la,lb)
        if la==nil or lb==nil then return Vector.new_nan()
         else
          local x,y=Equation.solve2x2LinearSystem(
          la.v.x,-lb.v.x,lb.p.x-la.p.x,
          la.v.y,-lb.v.y,lb.p.y-la.p.y)
          if x~=nil return la:indexP(x) else
            return Vector.new_nan()
          end
        end
      end,


    }
  }
  setmetatable(Line, Line)





  --#Plane 平面
  function Plane() end
  Plane={
    __call=function(_,p,u,v)
      return Plane.new(p,u,v)
    end,
    __index = {
      new=function(p,v)--新建 平面
        return setmetatable({p=p or Vector(),u=u or Vector(1),v=v or Vector(0,1) },Plane)
      end,
      loadTest=function()--加载测试
        return Plane(Vector(1),Vector(0,1),Vector(0,0,1))
      end,

    }
  }
  setmetatable(Plane, Plane)





  --#Conic0 封闭形圆锥曲线
  function Conic0() end
  Conic0={
    __call=function(_,p,u,v)
      return Conic0.new(p,u,v)
    end,
    __index = {
      new=function(p,u,v)--新建 椭圆形二次曲线
        return setmetatable({p=p or Vector(),u=u or Vector(1),v=v or Vector(0,1) },Conic0)
      end,
      newCircle2dByDiameter=function(pa,pb)
        local p=pa:mid(pb)
        local u=pa-p
        local v=Vector(-u.y,u.x)
        return Conic0.new(p,u,v)
      end,
      loadTest=function()--加载测试
        return Conic0(Vector(),Vector(2,1),Vector(1,2))
      end,
      indexPoint=function(c,theta)--根据theta索引点
        return c.p + c.u:scale(math.cos(theta)) + c.v:scale(math.sin(theta))
      end,
      getTangentVector=function(c,theta)--根据theta获得切方向向量
        return c.u:scale(-math.sin(theta)) + c.v:scale(math.cos(theta))
      end,
      getTangentLine=function(c,theta)--根据theta获得切线
        return Line(c:indexPoint(theta),c:getTangentVector(theta))
      end,
      getAB=function(c)--计算长短轴(半)
        local a1=c.u:pow2()
        local a2=(c.u:dot(c.v))*2
        local a3=c.v:pow2()
        local b1=0.5*(a1+a3)
        local b2=sqrt( (0.5*(a1-a3))^2 + (0.5*a2)^2 )
        local A=math.sqrt(b1+b2)
        local B=math.sqrt(b1-b2)
        return {A=A,B=B}
      end,
      getThetaOfAB=function(c)
        local a1=c.u:pow2()
        local a2=(c.u:dot(c.v))*2
        local a3=c.v:pow2()
        local b3=math.atan((a1-a3)/a2)
        local result={A={},B={}}
        for k=1,2 do
          result.A[k]=math.pi*(k+0.25)-b3/2
          result.B[k]=math.pi*(k-0.25)-b3/2
        end
        return result
      end,
      getIntersectPointWithLine2d=function(c,l)
        local lams={Env.nan,Env.nan}
        if l.v.x==0 then--排除分母为零的情况
          lams=Equation.solveCosSinForMainRoot(c.u.x, c.v.x, c.p.x-l.p.x)
         else--下面屎山不要动
          lams=Equation.solveCosSinForMainRoot(c.u.y-(c.u.x*l.v.y)/l.v.x,
          c.v.y-(c.v.x*l.v.y)/l.v.x,
          c.p.y-((c.p.x-l.p.x)*l.v.y)/l.v.x-l.p.y)
        end
        return {c:indexPoint(lams[1]),c:indexPoint(lams[2])}
      end,
      getIntersectPointWithConic2d=function(c1,c2)
        local lams={Env.nan,Env.nan}
        lams=Equation.solveCosSinForMainRoot(c1.u.x-c2.u.x,
        c1.v.x-c2.v.x,
        c1.p.x-c2.p.x)
        return {c1:indexPoint(lams[1]),c1:indexPoint(lams[2])}

      end,


    }
  }
  setmetatable(Conic0, Conic0)



  --#Curve 曲线
  function Curve() end
  Curve={
    __call=function(_,func,range)
      return Curve.new(func,range)
    end,
    __index = {
      new=function(f,range)--新建 曲线
        return setmetatable({f=f or function(t) return Vector(t,t^2) end,range=range or {-1,1} },Curve)
      end,
      loadTest=function()--加载测试
        return Curve(function(t) return Vector(t,t^2) end,{-1,1})
      end,
      indexPoint=function(c,t)
        return c.f(t)
      end,


    }
  }
  setmetatable(Curve, Curve)



  --#Triangle 三角形
  function Triangle() end
  Triangle={
    __call=function(_,a,b,c)
      return Triangle.new(a,b,c)
    end,
    __index = {
      new=function(a,b,c)--新建 三角形
        return setmetatable({a=a or Vector(),b=b or Vector(1),c=c or Vector(1,1) },Triangle)
      end,
      loadTest=function()--加载测试
        return nil
      end,



    }
  }
  setmetatable(Triangle, Triangle)


  --#Complex 复数
  function Complex() end
  Complex={
    __call=function(_,x,y) return Complex.new(x,y) end,
    __add=function(m,n) return Complex.add(m,n) end,
    __sub=function(m,n) return Complex.sub(m,n) end,
    __mul=function(m,n) return Complex.mul(m,n) end,
    __div=function(m,n) return Complex.div(m,n) end,
    __len=function(m,n) return Complex.len(m,n) end,
    __unm = function(m) return Complex.mul(m,-1) end,
    __index = {
      new=function(x,y)
        return setmetatable({x=x or 0,y=y or 0 },Complex)
      end,
      is={
        this=function(_,data)
          return getmetatable(data) == Complex
        end,
        zero=function(data)
          return data.x==0 and data.y==0
        end
      },
      add=function(m,n)
        if not(Complex.is.this(m)) and type(m)=="number" then
          m=Complex(m)
        end
        if not(Complex.is.this(n)) and type(n)=="number" then
          n=Complex(n)
        end
        return Complex.new(m.x+n.x,m.y+n.y)
      end,
      sub=function(m,n)
        if not(Complex.is.this(m)) and type(m)=="number" then
          m=Complex(m)
        end
        if not(Complex.is.this(n)) and type(n)=="number" then
          n=Complex(n)
        end
        return Complex.new(m.x-n.x,m.y-n.y)
      end,
      mul=function(m,n)
        if not(Complex.is.this(m)) and type(m)=="number" then
          m=Complex(m)
        end
        if not(Complex.is.this(n)) and type(n)=="number" then
          n=Complex(n)
        end
        return Complex.new(m.x*n.x - m.y*n.y , m.x*n.y + m.y*n.x)
      end,
      div=function(m,n)
        local a,b=m.x,m.y
        local c,d=n.x,n.y
        return Complex.new( (a*c+b*d)/(c^2+d^2), (b*c-a*d)/(c^2+d^2) )
      end,
      len=function(m)
        return math.sqrt(m.x^2+m.y^2)
      end,
      real=function(m)
        return m.x
      end,
      imagine=function(m)
        return m.y
      end,
      Complex_unit=function()
        return Complex(0,1)
      end,
    }
  }
  setmetatable(Complex, Complex)
  i=Complex.Complex_unit()
  Env.i=Complex.Complex_unit()


  --#NVector 高维向量
  function NVector() end
  NVector={
    __call=function(_,data)
      return NVector.new(data)
    end,
    __index = {
      new=function(data)--新建 高维向量
        return setmetatable(data or {1,1,4,5,1,4},NVector)
      end,
      loadTest=function()--加载测试
        return NVector({1,1,4,5,1,4})
      end,
      dot=function(a,b)
        local result=0
        for i=1,math.min(#a,#b)
          result=result+a[i]*b[i]
        end
        return result
      end,
      pow2=function(a)
        local result=0
        for i=1,#a
          result=result+a[i]^2
        end
        return result
      end,
      len=function(a)
        return math.sqrt(a:pow2())
      end,



    }
  }
  setmetatable(NVector, NVector)






  --#Statistics 统计
  function Statistics() end
  Statistics={
    __call=function(_,data)
      return Statistics.new(data)
    end,
    __index = {
      new=function(data)--新建 样本数据
        return setmetatable({data=data,type="Sample"},Statistics)
      end,
      newDistributed=function(data)--新建 分布列
        return setmetatable({data=data,type="Distributed"},Statistics)
      end,
      correlation=function(data)
        --{{1,2},{2,3}}
        local ax,ay,n=0,0,#data
        for i=1,n do
          ax=ax+data[i][1]/n
          ay=ay+data[i][2]/n
        end
        local a,b={},{}
        for i=1,n do
          a[i]=data[i][1]-ax
          b[i]=data[i][2]-ay
        end
        local va,vb=NVector(a),NVector(b)
        return NVector.dot(a,b)/(a:len()*b:len())
      end,
      A=function(n,m)
        return factorial(n)/factorial(n-m)
      end,
      C=function(n,m)
        return Statistics.A(n,m)/factorial(m)
      end,
      sort=function(data)--排序
        local uu=1
        for m=1,#data-1 do
          for n=m+1,#data do
            if data[m]>data[n] then
              local center=data[m]
              data[m]=data[n]
              data[n]=center
            end
          end
        end
        return data
      end,
      reverse=function(data)--倒序
        local to={}
        local m=1
        for n=#data,1,-1 do
          to[m]=data[n]
          m=m+1
        end
        return to
      end,
      exist= function (a,data)--存在
        local num=false
        for n=1,#data do
          if data[n]==a then
            num=n
          end
        end
        return num --返回false或者该元素在集合中排第几个
      end,
      summation=function (data)--求和
        local w=0
        for n=1,#data do w=w+data[n] end
        return w
      end,
      quadrature=function (data)--求积
        local w=1
        for n=1,#data do w=w*data[n] end
        return w
      end,
      disruption= function (data)--打乱
        for n=1,#data do
          m=math.random(1,#data)
          n=math.random(1,#data)
          local center=data[m]
          data[m]=data[n]
          data[n]=center
        end
        return data
      end,
      average= function (data)--平均数
        return List.summation(data)/#data
      end,
      median= function (data)--中位数
        local data=List.sort(data)
        local len=#data
        if is.oddnumber(len) then --print(1+(floor(len/2)))
          return data[1+(floor(len/2))]
         else
          return List.average({data[len/2],data[1+(len/2)]})
        end
      end,
      variance= function (data)--方差
        local center=List.average(data)
        local each_={}
        local num=#data
        for n=1,num do
          each_[n]=((data[n]-center)^2)/num
        end
        return List.summation(each_)
      end,
      standard_deviation=function (data)--标准差
        return math.sqrt(List.variance(data))
      end,
      range=function (data)--极差
        local a=List.sort(data)
        return a[#a]-a[1]
      end,
      rantake=function (data)--任取
        return data[random(1,#data)]
      end,


    }
  }
  setmetatable(Statistics, Statistics)


  --print(Statistics.correlation({{1,5},{2,8},{3,7}}))


  function Particle() end
  Particle={
    __call=function(_,data)
      return Particle.new(data)
    end,
    __index = {
      new=function(data)--新建 质点
        local result={}
        result.m = data.m or 1
        result.q = data.q or 1
        result.x = data.x or Vector()
        result.v = data.v or Vector()
        result.a = data.a or Vector()
        return setmetatable(result,Particle)
      end,
      update=function(particle)--更新物体位置
        particle.v = particle.v:add(particle.a:scale(Env.dt))
        particle.x = particle.x:add(particle.v:scale(Env.dt))
      end,
      getMomentum=function(particle)--获得动量  <向量>
        return particle.v:scale(particle.m)
      end,
      getEnergy=function(particle)--获得动能   <数字>
        return (particle.v:square()):scale(0.5*particle.m)
      end,
      setForce=function(particle,f)--加载力
        particle.a=f:scale(1/particle.m)
      end,
      stop=function(particle)--使物体停止运动
        particle.v=Vector()
      end,
      toUnreal=function(particle)--将物体破坏
        particle.x=Vector.new_nan()
        particle.v=Vector.new_nan()
        particle.a=Vector.new_nan()
      end,
      getForceFromField=function(particle,field)
        return Field.getForce(field, particle)
      end,


    }
  }
  setmetatable(Particle, Particle)


  function Field() end
  Field={
    __call=function(_,data)
      return Field.new(data)
    end,
    __index = {
      None="None",--空白
      Gravity="Gravity",--重力


      new=function(data)--新建 场
        data.type=data.type or Field.None
        return setmetatable(data,Interaction)
      end,
      newGravity=function(data)--重力场 g <Vector>
        return setmetatable({type="Gravity",g=data.g or Vector(0,-9.8)},Field)
      end,
      newFluidResistance=function(data)--流体阻力场 s <Number>
        return setmetatable({type="FluidResistance",s=data.s or 1},Field)
      end,
      newUniformElectric=function(data)--均匀电场 E <Vector>
        return setmetatable({type="UniformElectric",E=data.E or Vector(0,1)},Field)
      end,
      newUniformMagnetic=function(data)--均匀磁场 B <Vector>
        return setmetatable({type="UniformMagnetic",B=data.B or Vector(0,0,1)},Field)
      end,
      getForce=function(field, particle)--计算力
        local F
        if field.type=="none" then
          F=Vector()
         elseif field.type=="Gravity" then
          F=field.g:scale(particle.m)
         elseif field.type=="FluidResistance" then
          local v=particle.v
          F=v:scale(v:len()*field.s)
         elseif field.type=="UniformElectric" then
          F=field.E:scale(particle.q)
         elseif field.type=="UniformMagnetic" then
          F=(particle.v:cross(field.B)):scale(particle.q)
         else
          F=Vector()
        end
        return F
      end


    }
  }
  setmetatable(Field, Field)





  function Interaction() end
  Interaction={
    __call=function(_,data)
      return Interaction.new(data)
    end,
    __index = {
      None="None",--空白
      Gravity="Gravity",--万有引力

      new=function(data)--新建 相互作用
        data.type=data.type or Interaction.None
        return setmetatable(data,Interaction)
      end,


      getForce=function(a, inter, b)
        local F
        if inter.type=="None" then
          F=Vector()
         elseif inter.type=="Gravity" then
          local dx = a.x - b.x
          local len = (dx):len()
          F=dx:scale((inter.G*a.m*b.m)/(len^3))
         else
          F=Vector()
        end
        return F
      end,
    },
  }
  setmetatable(Interaction, Interaction)

end

Duo.game()