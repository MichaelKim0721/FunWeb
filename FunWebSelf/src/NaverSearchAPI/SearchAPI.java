package NaverSearchAPI;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import java.io.IOException;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//http://localhost:8080/FunWeb/NaverSearchAPI.do?keyword=강남역맛집&startNum=1

@WebServlet("/NaverSearchAPI.do")
public class SearchAPI extends HttpServlet implements Servlet {
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}
	
	private void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//1. 인증 정보 설정
		String clientId = "4gECMcoLKZsztSB7hUdA"; //애플리케이션 클라이언트 아이디
        String clientSecret = "wSfHHYxgTO"; //애플리케이션 클라이언트 시크릿
        
        //2. 검색 조건 설정
        int startNum = 1; //검색 시작 위치
        
        String text = null; //입력하는 검색어가 저장될 변수
        
        try {
        	//검색 시작 위치(startNum)와 검색어(keyword)를 request에서 꺼내옴
        	startNum = Integer.parseInt( request.getParameter("startNum") );
        	String searchText = request.getParameter("keyword");
        	//검색어는 한글 깨짐을 방지하기 위해 UTF-8로 인코딩 후 반환받은 문자열을 저장
        	text = URLEncoder.encode(searchText, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("검색어 인코딩 실패",e);
        }
        
        //3. 요청하는 API URL 조합
        //검색결과 데이터를 JSON데이터로 받기 위한 요청할 API URL주소작성
        //검색어(query=text)는 쿼리 스트링으로 보낼 수 있는데, 여기에 display파라미터와 start파라미터도 추가
        //display파라미터는 한 번에 가져올 검색 결과 갯수로 기본값인 10을 설정
        //start파라미터는 검색 시작 위치로 기본값인 1로 설정
        String apiURL = "https://openapi.naver.com/v1/search/blog?query=" + text + "&display=10&start=" + startNum;    // JSON 결과
        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // XML 결과

        //4. 검색 API 호출
        //클라이언트 아이디와 시크릿을 요청헤더로 전달하여 
        Map<String, String> requestHeaders = new HashMap<>();
        requestHeaders.put("X-Naver-Client-Id", clientId);
        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
        //API 호출
        String responseBody = get(apiURL,requestHeaders);

        //5. 검색된 결과 출력
        System.out.println(responseBody);
        //검색된 결과 데이터들을 서블릿에서 웹브라우저로 출력
        response.setContentType("text/html;charset=utf-8");
        response.getWriter().write(responseBody);;
        
        
	} //doHandle 메소드
	
	//get메소드 (doHandle메소드 안에서 호출되는 메소드)
	private static String get(String apiUrl, Map<String, String> requestHeaders){
	    HttpURLConnection con = connect(apiUrl);
	    try {
	        con.setRequestMethod("GET");
	        for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
	            con.setRequestProperty(header.getKey(), header.getValue());
	        }
	
	
	        int responseCode = con.getResponseCode();
	        if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
	            return readBody(con.getInputStream());
	        } else { // 오류 발생
	            return readBody(con.getErrorStream());
	        }
	    } catch (IOException e) {
	        throw new RuntimeException("API 요청과 응답 실패", e);
	    } finally {
	        con.disconnect();
	    }
	} //get메소드
	
	//get메소드 안에서 호출하는 메소드
	private static HttpURLConnection connect(String apiUrl){
	    try {
	        URL url = new URL(apiUrl);
	        return (HttpURLConnection)url.openConnection();
	    } catch (MalformedURLException e) {
	        throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
	    } catch (IOException e) {
	        throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
	    }
	} //connect메소드
	
	//get메소드 안에서 호출하는 메소드
	private static String readBody(InputStream body){
	    InputStreamReader streamReader = new InputStreamReader(body);
	
	
	    try (BufferedReader lineReader = new BufferedReader(streamReader)) {
	        StringBuilder responseBody = new StringBuilder();
	
	
	        String line;
	        while ((line = lineReader.readLine()) != null) {
	            responseBody.append(line);
	        }
	
	
	        return responseBody.toString();
	    } catch (IOException e) {
	        throw new RuntimeException("API 응답을 읽는 데 실패했습니다.", e);
        }
    } //readBody메소드
	
	

}//서블릿 닫기
