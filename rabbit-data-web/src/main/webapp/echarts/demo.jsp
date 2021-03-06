<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../base.jsp"></jsp:include>
<title>数据可视化demo</title>
<script type="text/javascript">
	//alert("${yu}");
    // Step:3 conifg ECharts's path, link to echarts.js from current page.
    // Step:3 为模块加载器配置echarts的路径，从当前页面链接到echarts.js，定义所需图表路径
    require.config({
        paths:{ 
            'echarts': '<%=request.getContextPath() %>/jslib/echarts',
            'echarts/chart/bar' : '<%=request.getContextPath() %>/jslib/echarts-map',
            'echarts/chart/line': '<%=request.getContextPath() %>/jslib/echarts-map',
            'echarts/chart/map' : '<%=request.getContextPath() %>/jslib/echarts-map'
        }
    });
    
    // Step:4 require echarts and use it in the callback.
    // Step:4 动态加载echarts然后在回调函数中开始使用，注意保持按需加载结构定义图表路径
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line',
            'echarts/chart/map'
        ],
        function (ec) {
            //--- 折柱 ---
            var myChart = ec.init(document.getElementById('main'));
            $.post('<%=request.getContextPath() %>/echartDemo/get',
            	function (result) {
            	myChart.setOption({
                    tooltip : {
                        trigger: 'axis'
                    },
                    legend: {
                        data:[result.msg,'降水量']
                    },
                    toolbox: {
                        show : true,
                        feature : {
                            mark : {show: true},
                            dataView : {show: true, readOnly: false},
                            magicType : {show: true, type: ['line', 'bar']},
                            restore : {show: true},
                            saveAsImage : {show: true}
                        }
                    },
                    calculable : true,
                    xAxis : [
                        {
                            type : 'category',
                            data : ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月']
                        }
                    ],
                    yAxis : [
                        {
                            type : 'value',
                            splitArea : {show : true}
                        }
                    ],
                    series : [
                        {
                            name:result.msg,
                            type:'bar',
                            data:result.obj.data
                        },
                        {
                            name:'降水量',
                            type:'bar',
                            data:[2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3]
                        }
                    ]
                });
            }, 'JSON');
            
            
            // --- 地图 ---
            var myChart2 = ec.init(document.getElementById('mainMap'));
            myChart2.setOption({
                tooltip : {
                    trigger: 'item',
                    formatter: '{b}'
                },
                series : [
                    {
                        name: '中国',
                        type: 'map',
                        mapType: 'china',
                        selectedMode : 'multiple',
                        itemStyle:{
                            normal:{label:{show:true}},
                            emphasis:{label:{show:true}}
                        },
                        data:[
                            {name:'广东',selected:true}
                        ]
                    }
                ]
            });
        }
    );
</script>
</head>
<body>
	<div class="container" style="margin-top:80px; margin-bottom:30px;">
		<!--Step:2 Prepare a dom for ECharts which (must) has size (width & hight)-->
		<!--Step:2 为ECharts准备一个具备大小（宽高）的Dom-->
		<div id="main" style="height:500px;border:1px solid #ccc;padding:10px;"></div>
		<div id="mainMap" style="height:500px;border:1px solid #ccc;padding:10px;"></div>
	</div><!-- /.container -->
</body>
</html>