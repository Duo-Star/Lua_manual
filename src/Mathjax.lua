--通过HTML浏览器展示数学公式
--作者：Duo  QQ：113530014

require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

layout_table={
  LinearLayout,
  layout_width="fill",
  layout_height="fill",
  background="#1565C0",
  orientation="vertical",
  {
    LuaWebView;
    layout_width='fill';
    layout_height='fill';
    id='webView';
  };
}

activity.setContentView(loadlayout(layout_table))


html=[[
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>MathJax example</title>
  <script id="MathJax-script" async
          src="https://cdn.jsdelivr.net/npm/mathjax@3.0.1/es5/tex-mml-chtml.js" >
  </script>
</head>
<body>
<p>
  When \(a \ne 0\), there are two solutions to \(ax^2 + bx + c = 0\) and they are
  \[x = {-b \pm \sqrt{b^2-4ac} \over 2a}.\]
  \[\vec{a}={{\omega}^2 \over r}.\]
  \[sigma = \sqrt{ \frac{1}{N} \sum_{i=1}^N (x_i -\mu)^2}.\]
  \[cos(\theta+\phi)=\cos(\theta)\cos(\phi)−\sin(\theta)\sin(\phi).\]
  \[\vec{\nabla} \times \vec{F} = \left( \frac{\partial F_z}{\partial y} - \frac{\partial F_y}{\partial z} \right) \mathbf{i} + \left( \frac{\partial F_x}{\partial z} - \frac{\partial F_z}{\partial x} \right) \mathbf{j} + \left( \frac{\partial F_y}{\partial x} - \frac{\partial F_x}{\partial y} \right) \mathbf{k}.\]
\[\]
\[Advertisement:\]
Duo Nature is a good mathematical software!
</p>
</body>
</html>]]

--webView.loadUrl("file://"..activity.getLuaDir().."/mathview.html")--加载网页

mimeType="text/html"
enCoding="utf-8"
webView.loadDataWithBaseURL(nil,html,mimeType,enCoding,nil)
webView.getSettings().setJavaScriptEnabled(true);
webView.setLayerType(View.LAYER_TYPE_HARDWARE,nil);
webView.getSettings().setSupportZoom(true);