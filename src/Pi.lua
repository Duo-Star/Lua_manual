--Pi
--新增算法

Get_Pi={}

Get_Pi[1]=function()
  --偷懒
  local pi=math.pi
  return {"MATH.PI",pi}
end

Get_Pi[2]=function()
  --反三角函数
  local pi=math.acos(-1)
  return {"反三角函数",pi}
end

Get_Pi[3]=function()
  --割圆术
  local n=10000
  local pi=(n/2)*math.sin(math.rad(360/n))
  return {"割圆术",pi}
end

Get_Pi[4]=function()
  --对着半圆求积分*2
  local integral=0
  local dx=0.001
  local f=function(x)
    return math.sqrt(1-x^2)
  end
  for x=-1,1,dx do
    integral=integral+f(x)*dx
  end
  return {"积分",2*integral}
end

Get_Pi[5]=function()
  --【我宣布，这个世界上最有趣的数学公式是：sinc-哔哩哔哩】
  --https://b23.tv/pjmvjyd
  function sinc(x)
    if x==0 then return 1
     else
      return math.sin(x)/x
    end
  end
  local sum=0
  for x=-1000,1000 do
    sum=sum+sinc(x)
  end
  return {"SINC",sum}
end


Get_Pi[6]=function()
  --蒙特卡洛
  all_n=1000000
  in_n=0
  for n=1,all_n do
    x=math.random(-5000000,5000000)/10000000
    y=math.random(-5000000,5000000)/10000000
    r=math.sqrt(x^2+y^2)
    if r<=0.5 then in_n=in_n+1 end
  end
  local pi=(4*in_n/all_n)*1.0000000001
  return {"蒙特卡洛",pi}
end

Get_Pi[7]=function()
  local sum=0
  for n=1,500000 do
    local item=-(-1)^(n)*(4/(2*n-1))
    sum=sum+item
  end
  return {"莱布尼茨公式",sum}
end

Get_Pi[8]=function()
  local sum=0
  function factorial(x)--阶乘
    local w=1
    for n=1,x do
      w=w*n
    end
    return w
  end
  for n=1,20 do
    local item=(factorial(4*n)/(factorial(n)^4))*((26390*n+1103)/396^(4*n))
    sum=sum+item
  end
  local pi=1/(sum*((2*math.sqrt(2))/(99^2)))
  return {"拉马努金(现存在问题)",pi}
end

Get_Pi[9]=function()
  local integral=0
  local dx=0.001
  local f=function(x)
    return math.exp(1)^(-x^2)
  end
  for x=-1000,1000,dx do
    integral=integral+f(x)*dx
  end
  return {"正态分布",2*integral}
end


Get_Pi[10] = function()--感谢北极づ莜蓝
  local integral = 0
  for x = -1000 , 1000, 0.001 do
    integral = integral + math.exp(- x ^ 2) * 0.001
  end
  return {"高斯积分", integral ^ 2}
end


Get_Pi[11] = function()--感谢北极づ莜蓝
  local result = math.sin(math.rad(1/5555555))
  return {"5555555", result * 10000}
end

Get_Pi[11] = function()
  local result=2
  for n=1,500 do
    result=result*(function(n)
      local c=(((-1)^(n)+1)/(2))
      local d=(((-1)^(n+1)+1)/(2))
      return c*((n)/(n+1))+d*((n+1)/(n))
    end)(n)
  end
  return {"分式展开",result}
end



Duo=loadlayout
{ LinearLayout, orientation="vertical", layout_width='fill', layout_height='fill',
  {TextView, text="操作控制台输出", textSize="20dp", textStyle="bold", padding="2dp", layout_gravity="center|top" },
  { HorizontalScrollView, layout_width='fill', layout_height='wrap',
    { ScrollView, id="scrollView", layout_width="fill", layout_height="fill", backgroundColor="#ffffffff";
      { LinearLayout, orientation="vertical", layout_width='fill', layout_height='fill', background='#00FFFFFF', id="broad",
        {TextView, text="Out[1]: Hello (๑>؂<๑）",textColor="#01579B", textSize="23dp", textStyle="bold", padding="2dp", layout_gravity="top|left", id="dna_see" },
      },
    },
  },
}
activity.contentView=Duo

local see_n=1
function see(data)
  see_n=see_n+1
  data=data..""
  broad.addView(loadlayout(
  { LinearLayout, orientation='vertical',
    {TextView, text="Out["..see_n.."]: "..data, textColor="#01579B", textSize="23dp", textStyle="bold",padding="2dp",layout_gravity="top|left"}
  }))
end

--
function init()
  for n=1,#Get_Pi do
    local t0=os.clock()
    local data=Get_Pi[n]()
    local t1=os.clock()
    local dt=t1-t0
    see(data[2].."  ("..data[1].."  耗时:"..dt.."s)")
  end
end

task(5,init)
