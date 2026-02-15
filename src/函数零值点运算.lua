--函数零值点运算
--作者：Duo  QQ：113530014
--人教版高一数学课本P146，习题

require "import"
import "android.widget.*"
import "com.google.android.material.textfield.*"
import "androidx.appcompat.widget.Toolbar"
import "com.google.android.material.button.MaterialButton"
import "com.google.android.material.appbar.AppBarLayout"
import "android.graphics.Color"
import "android.content.Intent"
import "android.net.Uri"
import "android.content.Context"
import "android.app.ProgressDialog"



local view_table=
{LinearLayout,
  layout_width="match",
  layout_height="match",
  orientation=1,
  {
    AppBarLayout,
    layout_width="match",
    layout_height="wrap",
    {
      Toolbar,
      layout_width="match",
      layout_height="wrap",
      --subTitle="",
      title="二分法求函数零点",
      background="#ffffff"
    },
  },

  {TextInputLayout,
    id="f1",
    layout_height="wrap",
    padding="24dp",

    prefixText="y=",

    layout_width="match",
    hint="定义函数f",--设置输入框提示文本
    {TextInputEditText,
      id="f2",
      layout_height="wrap",
      layout_width="match",
      singleLine="true",
      --inputType="number",
    },

  },

  {TextInputLayout,
    id="a1",
    layout_height="wrap",
    padding="24dp",

    prefixText="x=",

    layout_width="match",
    hint="x起始值a",--设置输入框提示文本
    {TextInputEditText,
      id="a2",
      layout_height="wrap",
      layout_width="match",
      singleLine="true",
      --inputType="number",
    },
  },

  {TextInputLayout,
    id="b1",
    layout_height="wrap",
    padding="24dp",

    prefixText="x=",

    layout_width="match",
    hint="x终止值b",--设置输入框提示文本
    {TextInputEditText,
      id="b2",
      layout_height="wrap",
      layout_width="match",
      singleLine="true",
      --inputType="number",
    },
  },
  {TextInputLayout,
    id="c1",
    layout_height="wrap",
    padding="24dp",

    prefixText="Δx=",

    layout_width="match",
    hint="精确度w",--设置输入框提示文本
    {TextInputEditText,
      id="c2",
      layout_height="wrap",
      layout_width="match",
      singleLine="true",
      --inputType="number",
    },
  },
  {MaterialButton,
    id="计算",--设置id
    text="开始计算",
    layout_gravity="right",
    layout_marginRight="24dp",
  },
  {MaterialButton,
    id="举例",--设置id
    text="举个例子",
    layout_gravity="right",
    layout_marginRight="24dp",
  },

}

activity.setContentView(loadlayout(view_table))
activity.window.statusBarColor=Color.parseColor("#ffffff")




--设置点击事件
计算.onClick=function()

  if f2.Text==nil then
   else
    计算(f2.Text,a2.Text,b2.Text,c2.Text)

  end
end

e=tonumber(2.718281828459045)

举例.onClick=function()
  n=math.random(0,4)
  --print(n)
  if n==0 then
    f2.setText([[2^x+3*x-7]])
    a2.setText([[1]])
    b2.setText([[2]])
    c2.setText([[0.1]])
   elseif n==1
    f2.setText([[x^3+1.1*x^2+0.9*x-1.4]])
    a2.setText([[0]])
    b2.setText([[1]])
    c2.setText([[0.1]])
   elseif n==2
    f2.setText([[-math.log10(x)-x+3]])
    a2.setText([[2]])
    b2.setText([[3]])
    c2.setText([[0.1]])
   elseif n==3
    f2.setText([[((math.log10(x))/(math.log10(e)))+2*x-6]])
    a2.setText([[2]])
    b2.setText([[3]])
    c2.setText([[0.1]])
    elseif n==4
    f2.setText([[math.sin(x)]])
    a2.setText([[3]])
    b2.setText([[4]])
    c2.setText([[0.01]])
  end
end



function 计算(fu,a,b,c)
  fu=[[
  function f(x)--定义函数
    y=]]..fu..[[
    return y
  end
]]
  assert(loadstring(fu))()

  --[[function f(x)
  y=tonumber((2^x)+3*x-7)
  return y
end]]

  w=tonumber(c)
  a=tonumber(a)
  b=tonumber(b)

  function 判断()
    if math.abs(a-b)<w then
      输出(a)
     else
      主体()
    end
  end

  function 输出(a)
    print("x="..a)
  end

  function 主体()
    c=tonumber((a+b)/2)
    if f(a)*f(c)<0 then
      b=c
      判断()
     elseif f(a)*f(c)>0 then
      a=c
      判断()
     elseif f(a)*f(c)==0 then
      a=c
      输出(a)
    end
  end
  主体()
end
