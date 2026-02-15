--函数积分运算
--作者：Duo  QQ：113530014


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
      title="函数积分运算",
      background="#ffffff"
    },
  },

  {TextInputLayout,
    id="f1",
    layout_height="wrap",
    padding="24dp",

    prefixText="y=",

    layout_width="match",
    hint="定义函数",--设置输入框提示文本
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
    hint="x起始值",--设置输入框提示文本
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
    hint="x终止值",--设置输入框提示文本
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
    hint="步长",--设置输入框提示文本
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
    text="开始积分",
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


举例.onClick=function()
  f2.setText([[math.sin(x)]])
  a2.setText([[0]])
  b2.setText([[3.1416]])
  c2.setText([[0.1]])
end




function 计算(f,a,b,c)


  f=[[
  function 函数(x)--定义函数
    y=]]..f..[[
    return y
  end
]]

  assert(loadstring(f))()



  a=tonumber(a)--积分起始值
  b=tonumber(b)--积分终止值
  c=tonumber(c)--步长

  d=tonumber(a)--游动值初始化
  e=tonumber(0)--面积累加初始化
  n0=tonumber((b-a)//c)--需要计算的小矩形总个数
  n=tonumber(0)--初始化小矩形计数

  while d<=b do
    e=tonumber(e+函数(d)*c)--累加面积
    d=tonumber(d+c)--游动值
    n=tonumber(n+1)--矩形个数加一
    if n==n0 then
      print(e)

    end
  end
end







