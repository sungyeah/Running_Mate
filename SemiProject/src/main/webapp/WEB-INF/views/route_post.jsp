<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- jquery -->
	<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

	<!-- zag bootstrap -->
    <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="/assets/css/templatemo.css">
    <link rel="stylesheet" href="/assets/css/custom.css">
    <link rel="shortcut icon" type="image/x-icon" href="/assets/img/favicon.ico">
    <link rel="apple-touch-icon" href="/assets/img/apple-icon.png">

    <!-- Load fonts style after rendering the layout styles -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;200;300;400;500;700;900&display=swap">
    <link rel="stylesheet" href="assets/css/fontawesome.min.css">

	<!-- ckeditor5 -->
	<script type="text/javascript" src="${pageContext.request.contextPath }/ckeditor/ckeditor.js"></script>
	<style>
		.ck-editor__editable {
			min-height: 550px;
			min-width: 300px;
		}
		.ck.ck-reset.ck-editor.ck-rounded-corners {
    		width: 45%;
		}
	</style>
	
	<!-- mapbox -->
	<script src="https://api.tiles.mapbox.com/mapbox-gl-js/v2.6.1/mapbox-gl.js"></script>
	<link href="https://api.tiles.mapbox.com/mapbox-gl-js/v2.6.1/mapbox-gl.css" rel="stylesheet"/>
	<script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-draw/v1.0.9/mapbox-gl-draw.js"></script>
	<link rel="stylesheet" href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-draw/v1.0.9/mapbox-gl-draw.css" type="text/css" />
	<script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.4.2/mapbox-gl-geocoder.min.js"></script>
	<link rel="stylesheet" href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.css" type="text/css">
	

</head>
<body>
	<header><%@include file ="header.jsp" %></header>
	<main style="width: 70%; margin: 0 auto; margin-bottom:50px;">
		<div class="row align-items-center py-3">
			<div class="col-md-8 text-black">
        		<h2>나처럼 달려</h2>
            	<p>나만의 러닝 코스를 공유해주세요!</p>
        	</div>
		</div>
		<div>
			<div id="routeboard_info" style="border-bottom: 1px solid gray">
				<img src="/fileview/러닝메이트 (1).png\" style="width:25px; height:25px;">
				<span id="user_id">${route.user_id }</span>
				<c:if test= "${id eq route.user_id }">
					<a href="routeDelete?articleNo=${route.route_articleNo}" onclick="return confirm('정말 게시글을 삭제하시겠습니까?')"><span id="delete" style="float:right;">삭제</span></a>
					<a href="routeModify?articleNo=${route.route_articleNo}"><span id="modify" style="float:right;">수정</span></a><br>
				</c:if>
				<span id="board_time">${route.route_date }</span>
				<span style="float:right;">${route.route_views }</span>&nbsp;<span style="float:right; padding-left:10px;">조회</span>
				<span id="alert" style="float:right; padding-left:10px;">신고</span>
			</div>
			<input type="text" id="route_title" name="route_title" class="form-control mt-1" value="제목" style="disabled{background: #F0F0F0;}"/><br>
			
			<div style="display:inline-block; float:left; "><textarea id="content" name="content" ></textarea></div>
			<div id="map" style="width: 45%; height:500px; margin-bottom:50px; display:inline-block; float:right; "></div>
		</div>
		<div id="likes" style="text-align:center;"><br>
		<c:choose>
			<c:when test="${likes eq true }">
			<img id="like" src="${pageContext.request.contextPath }/images/like.PNG" style="width:50px; " /></c:when>
			<c:when test="${likes eq false }">
			<img id="nolike" src="${pageContext.request.contextPath }/images/nolike.PNG" style="width:50px; " /></c:when>
		</c:choose>
			<br><br><hr>
		</div>
	</main>
	
	<script>
	$(function(){
		console.log(${likes});
		console.log(!${likes});
		
		$("#like").click(function(){
			$.ajax({
				type:"post",
				url:"http://localhost:8090/likes",
				data: {"user_id": $("#user_id").text(), "board_type" : "route", "board_no": ${route.route_articleNo}},
				dataType:"text",
				success:function(data){
					console.log("like " + data);
					if(data===${likes}){
						$("#like").attr("src", "${pageContext.request.contextPath }/images/like.PNG");
					} else if(data===!${likes}){
						$("#like").attr("src", "${pageContext.request.contextPath }/images/nolike.PNG");
					}
				}
			});
		});
		$("#nolike").click(function(){
			$.ajax({
				type:"post",
				url:"http://localhost:8090/likes",
				data: {"user_id": $("#user_id").text(), "board_type" : "route", "board_no": ${route.route_articleNo}},
				dataType:"text",
				success:function(data){
					console.log("nolike " + data);
					if(data===!${likes}){
						$("#nolike").attr("src", "${pageContext.request.contextPath }/images/like.PNG");
					} else if(data===${likes}){
						$("#nolike").attr("src", "${pageContext.request.contextPath }/images/nolike.PNG");
					}
				}
			});
		});
		
	});
	</script>
	
	<script>
		//editor script
		$(function(){
			ClassicEditor.create(document.querySelector("#content"))
    	    .then(editor=>{
    	    	window.editor = editor;
    	    	editor.isReadOnly = true;
    	    	const toolbarElement = editor.ui.view.toolbar.element;
    	    	toolbarElement.style.display = 'none';
        		editor.setData('${route.route_content }');
        	})
	        .catch((error) => {
    	    	console.error(error);
        	});
		});
	</script>	
	<script>	
	//map script
	$(function(){
		var route_center = ${route.route_center };
		mapboxgl.accessToken = 'pk.eyJ1IjoidmhxbHRrZmtkMjQiLCJhIjoiY2wwMDZ3eG92MDA2MzNjcnlpNmEzN3YydCJ9.eu7sOlz2memREpbstyzmjA';
		const map = new mapboxgl.Map({
			container: 'map', // Specify the container ID
		    style: 'mapbox://styles/mapbox/streets-v11', // Specify which map style to use
		    center: [route_center.longitude,route_center.latitude], // Specify the starting position
		    zoom: 14.5, // Specify the starting zoom
		});
		
		var mapinfo = ${route.route_mapinfo};
		if (map.getLayer('route')) {
			map.removeLayer('route');
		}
		if (map.getSource('route')) {
			map.removeSource('route');
		}
		
		const draw = new MapboxDraw({
    		displayControlsDefault: false,
    		defaultMode: 'draw_line_string',
    		styles:[
    			{
    	    		id: 'route',
    	      		type: 'line',
    	      		source: {
    	    	    	type: 'geojson',
    	    	        data: {
    			        	type: 'Feature',
    		          		properties: {},
    	    	      		geometry: mapinfo
    	        		}
    	      		},
    		      	layout: {
    		        	'line-join': 'round',
    		        	'line-cap': 'round'
    		      	},
    	    	  	paint: {
    		    	    'line-color': '#03AA46',
    		        	'line-width': 8,
    			        'line-opacity': 0.8
    			    }
    			}
    		]
    	});
    	map.addControl(draw);
	});
	</script>
	
</body>
</html>