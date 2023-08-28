<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	//전체 URL 요청 주소 중에서 
	//컨텍스트패스 /Funweb 주소만 문자열로 반환
	
	//컨텍스트 주소 얻기	
	String path = request.getContextPath();
%>	

<footer>
	<hr>
	<div id="copy">All contents Copyright 2011 FunWeb 2011 FunWeb 
		Inc. all rights reserved<br>
		Contact mail:funweb@funwebbiz.com Tel +82 64 123 4315
		Fax +82 64 123 4321
	</div>
	<div id="social"><img src="<%=path%>/images/facebook.gif" width="33" 
	height="33" alt="Facebook">
		<img src="<%=path%>/images/twitter.gif" width="34" height="34"
	alt="Twitter"></div>
</footer>