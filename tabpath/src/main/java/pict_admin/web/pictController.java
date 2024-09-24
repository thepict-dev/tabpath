package pict_admin.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

import java.net.URL;
import java.util.List;

import javax.annotation.Resource;
import javax.mail.PasswordAuthentication;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pict_admin.service.AdminService;
import pict_admin.service.AdminVO;
import pict_admin.service.PictService;
import pict_admin.service.PictVO;

@Controller
public class pictController {
	PasswordAuthentication pa;
	
	@Resource(name = "pictService")
	private PictService pictService;
	
	@Resource(name = "adminService")
	private AdminService adminService;
	
	
	@RequestMapping(value = "/main.do")
	public String main(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/main";
	}
	@RequestMapping(value = "/mypage_login.do")
	public String mypage_login(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/mypage_login";
	}
	@RequestMapping(value = "/login_action.do")
	public String login_action(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/mypage_login";
	}
	@RequestMapping(value = "/mypage.do")
	public String mypage(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/mypage";
	}
	
	@RequestMapping(value = "/admin/bus_list.do")
	public String bus_list(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String userAgent = request.getHeader("user-agent");
		boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*"); 
		if (mobile1 || mobile2) {
		    //여기 모바일일 경우
			model.addAttribute("intype", "mobile");
		}
		else {
			model.addAttribute("intype", "pc");
		}
		List<?> board_list = pictService.bus_list(pictVO);
		model.addAttribute("resultList", board_list);
		model.addAttribute("pictVO", pictVO);
		
		return "pict/admin/bus_list";
	}
	
	@RequestMapping(value = "/admin/user_list.do")
	public String user_list(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String userAgent = request.getHeader("user-agent");
		boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*"); 
		if (mobile1 || mobile2) {
		    //여기 모바일일 경우
			model.addAttribute("intype", "mobile");
		}
		else {
			model.addAttribute("intype", "pc");
		}
		List<?> board_list = pictService.user_list(pictVO);
		model.addAttribute("resultList", board_list);
		model.addAttribute("pictVO", pictVO);
		
		return "pict/admin/user_list";
	}
	@RequestMapping(value = "/admin/user_register.do")
	public String user_register(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request) throws Exception {
		if(pictVO.getIdx() != 0) {
			//수정
			pictVO = pictService.user_list_one(pictVO);
			pictVO.setSaveType("update");
			
		}
		else {
			pictVO.setSaveType("insert");
		}
		
		model.addAttribute("pictVO", pictVO);
		return "pict/admin/user_register";
	}
	
	@RequestMapping(value = "/admin/user_save.do")
	public String user_save(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request) throws Exception {
		if(pictVO.getSaveType() != null && pictVO.getSaveType().equals("update")) {
			
			try {
				URL url = new URL("https://api.fairpass.co.kr/fsApi/VisitorUpdate");
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				
				conn.setRequestMethod("POST"); // http 메서드
				conn.setRequestProperty("Content-Type", "application/json"); // header Content-Type 정보
				conn.setRequestProperty("ApiKey", " rioE2lpgWGInf2Gd7XF9cOCDvqXGUzKXYPrqBCW"); // header의 auth 정보
				
				conn.setDoInput(true); // 서버에 전달할 값이 있다면 true
				conn.setDoOutput(true);// 서버에서 받을 값이 있다면 true
				
				JSONObject obj_param = new JSONObject();
				obj_param.put("EVENT_IDX", "5017");	//행사코드 고정
				obj_param.put("VISITOR_IDX", pictVO.getFairpath_id());
				
				String bus_info = "";
				bus_info = pictVO.getBus() + "호차 " + pictVO.getSeat();
				
				obj_param.put("INFO9", bus_info);
				obj_param.put("NAME", pictVO.getName());
				obj_param.put("TEL", pictVO.getMobile());
				obj_param.put("GENDER", pictVO.getGender());
				obj_param.put("BIRTHDAY", pictVO.getBirthday());

				//서버에 데이터 전달
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				bw.write(obj_param.toString()); // 버퍼에 담기
				bw.flush(); // 버퍼에 담긴 데이터 전달
				bw.close();
				
				// 서버로부터 데이터 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				StringBuilder sb = new StringBuilder();
				String line = null;
				
				while((line = br.readLine()) != null) { // 읽을 수 있을 때 까지 반복
					sb.append(line);
				}
				JSONObject obj = new JSONObject(sb.toString()); // json으로 변경 (역직렬화)
				int state_code = obj.getInt("resultCode");
				if(state_code != 0) {
					model.addAttribute("message", "저장 중 오류가 발생하였습니다.");
					model.addAttribute("retType", ":location");
					model.addAttribute("retUrl", "/admin/user_list.do");
					return "pict/main/message";
				}
				else {
					
					pictService.user_update(pictVO);
					model.addAttribute("message", "정상적으로 수정되었습니다.");
					model.addAttribute("retType", ":location");
					model.addAttribute("retUrl", "/admin/user_list.do");
					return "pict/main/message";
				}
			}
			catch(Exception e) {
				System.out.println(e);
				model.addAttribute("message", "저장 중 오류가 발생하였습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/admin/user_list.do");
				return "pict/main/message";
			}
			
			
			
		}
		else {
			System.out.println("1111111111111111111");
			try {
				System.out.println("222222222222222");
				URL url = new URL("https://api.fairpass.co.kr/fsApi/VisitorInsert");
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				
				conn.setRequestMethod("POST"); // http 메서드
				conn.setRequestProperty("Content-Type", "application/json"); // header Content-Type 정보
				conn.setRequestProperty("ApiKey", " rioE2lpgWGInf2Gd7XF9cOCDvqXGUzKXYPrqBCW"); // header의 auth 정보
				
				conn.setDoInput(true); // 서버에 전달할 값이 있다면 true
				conn.setDoOutput(true);// 서버에서 받을 값이 있다면 true
				
				JSONObject obj_param = new JSONObject();
				obj_param.put("EVENT_IDX", "5017");	//행사코드 고정
				
				String bus_info = "";
				bus_info = pictVO.getBus() + "호차 " + pictVO.getSeat();
				
				obj_param.put("INFO9", bus_info);
				obj_param.put("NAME", pictVO.getName());
				obj_param.put("TEL", pictVO.getMobile());
				obj_param.put("GENDER", pictVO.getGender());
				obj_param.put("BIRTHDAY", pictVO.getBirthday());
				obj_param.put("OPTION_IDX", "1645");
				System.out.println("33333333333333333");
				
				//서버에 데이터 전달
				BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				bw.write(obj_param.toString()); // 버퍼에 담기
				bw.flush(); // 버퍼에 담긴 데이터 전달
				bw.close();
				
				// 서버로부터 데이터 읽어오기
				BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				StringBuilder sb = new StringBuilder();
				String line = null;
				
				while((line = br.readLine()) != null) { // 읽을 수 있을 때 까지 반복
					sb.append(line);
				}
				JSONObject obj = new JSONObject(sb.toString()); // json으로 변경 (역직렬화)
				int state_code = obj.getInt("resultCode");
				if(state_code != 0) {
					System.out.println(obj);
					model.addAttribute("message", "저장 중 오류가 발생하였습니다.");
					model.addAttribute("retType", ":location");
					model.addAttribute("retUrl", "/admin/user_list.do");
					return "pict/main/message";
				}
				else {
					pictVO.setFairpath_id(obj.getInt("VISITOR_IDX")+"");
					pictService.user_insert(pictVO);
					model.addAttribute("message", "정상적으로 저장되었습니다.");
					model.addAttribute("retType", ":location");
					model.addAttribute("retUrl", "/admin/user_list.do");
					return "pict/main/message";
				}
			}
			catch(Exception e) {
				System.out.println(e);
				model.addAttribute("message", "저장 중 오류가 발생하였습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/admin/user_list.do");
				return "pict/main/message";
			}
		}
		
	}
	
	@RequestMapping(value = "/admin/user_delete.do")
	public String user_delete(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request) throws Exception {
		String userAgent = request.getHeader("user-agent");
		boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*"); 
		if (mobile1 || mobile2) {
		    //여기 모바일일 경우
			model.addAttribute("intype", "mobile");
		}
		else {
			model.addAttribute("intype", "pc");
		}
		pictService.user_delete(pictVO);
		
		model.addAttribute("message", "정상적으로 삭제되었습니다.");
		model.addAttribute("retType", ":location");
		model.addAttribute("retUrl", "/admin/user_list.do");
		return "pict/main/message";
		
	}


    
}
