package pict_admin.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

import java.net.URL;
import java.security.MessageDigest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.PasswordAuthentication;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import pict_admin.service.AdminService;
import pict_admin.service.AdminVO;
import pict_admin.service.PictService;
import pict_admin.service.PictVO;
import org.apache.commons.codec.binary.Base64;

@Controller
public class pictController {
	PasswordAuthentication pa;
	
	@Resource(name = "pictService")
	private PictService pictService;
	
	@Resource(name = "adminService")
	private AdminService adminService;
	
	
	@RequestMapping(value = "/pict_main.do")
	public String pict_main(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String sessions = (String)request.getSession().getAttribute("id");
		System.out.println(sessions);
		if(sessions == null || sessions == "null") {
			return "redirect:/pict_login.do";
		}
		else {
			String user_id = (String)request.getSession().getAttribute("id");
			if(request.getSession().getAttribute("id") != null) {
				adminVO.setAdminId((String)request.getSession().getAttribute("id"));
				adminVO = adminService.get_user_info(adminVO);
				model.addAttribute("adminVO", adminVO);
			}
		
			return "redirect:/admin/user_list.do";
		
		}
	}
	
	@RequestMapping(value = "/pict_login.do")
	public String login_main(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpServletResponse response) throws Exception {

		String sessions = (String)request.getSession().getAttribute("id");
		if(sessions == null || sessions == "null") {
			return "pict/admin/login";
		}
		else {
			//나중에 여기 계정별로 리다이렉트 분기처리
			return "redirect:/admin/user_list.do";
			
		}
			
	}
	
	@RequestMapping(value = "/login.do")
	public String login(@ModelAttribute("adminVO") AdminVO adminVO, HttpServletRequest request,  ModelMap model) throws Exception {
		//처음 드러와서 세션에 정보있으면 메인으로 보내줘야함
		String inpuId = adminVO.getAdminId();
		String inputPw = adminVO.getAdminPw();
		
		adminVO = adminService.get_user_info(adminVO);

		if (adminVO != null && adminVO.getId() != null && !adminVO.getId().equals("")) {
			String user_id = adminVO.getId();
			String enpassword = encryptPassword(inputPw, inpuId);	//입력비밀번호
			
			if(enpassword.equals(adminVO.getPassword())) {
				request.getSession().setAttribute("id", adminVO.getId());
				request.getSession().setAttribute("name", adminVO.getName());
				request.getSession().setAttribute("depart", adminVO.getDepart());

				String ip = request.getRemoteAddr();
			    DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			    String now = format2.format(Calendar.getInstance().getTime());
			    
			    adminVO.setLast_login_ip(ip);
			    adminVO.setLast_login_date(now);
			    adminService.insert_login_info(adminVO);
			    
			    adminVO.setAdminId(user_id);
			    adminVO = adminService.get_user_info(adminVO);
			    
				return "redirect:/pict_main.do";
				
			}
			else {
				model.addAttribute("message", "입력하신 정보가 일치하지 않습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/pict_login.do");
				return "pict/main/message";
			}
		}
		else {
			model.addAttribute("message", "입력하신 정보가 일치하지 않습니다.");
			model.addAttribute("retType", ":location");
			model.addAttribute("retUrl", "/pict_login.do");
			return "pict/main/message";
		}
	}
	@RequestMapping(value = "/logout.do")
	public String logout(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request,  ModelMap model) throws Exception {
		request.getSession().setAttribute("id", null);
		request.getSession().setAttribute("name", null);
		
		return "redirect:/pict_login.do";
		
	}
	
	@RequestMapping(value = "/main.do")
	public String main(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/main";
	}
	@RequestMapping(value = "/mypage_login.do")
	public String mypage_login(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String sessions = (String)request.getSession().getAttribute("id");	
		
		if(sessions == null || sessions == "null") {
			return "pict/main/mypage_login";
		}
		else {
			//나중에 여기 계정별로 리다이렉트 분기처리
			return "redirect:/mypage.do";
			
		}
	}
	@RequestMapping(value = "/login_action.do")
	public String login_action(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String inpuName = pictVO.getName();
		String inputMobile = pictVO.getMobile();
		
		pictVO = pictService.get_register_person_info(pictVO);

		if (pictVO != null && pictVO.getId() != null && !pictVO.getId().equals("")) {
			String name = pictVO.getName();
			String mobile = pictVO.getMobile();
			
			if(inpuName.equals(name) && inputMobile.equals(mobile)) {
				request.getSession().setAttribute("id", pictVO.getIdx());
				
				return "redirect:/mypage.do";
				
			}
			else {
				model.addAttribute("message", "입력하신 정보가 일치하지 않습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/mypage_login.do");
				return "pict/main/message";
			}
		}
		else {
			model.addAttribute("message", "입력하신 정보가 일치하지 않습니다.");
			model.addAttribute("retType", ":location");
			model.addAttribute("retUrl", "/mypage_login.do");
			return "pict/main/message";
		}
		
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
	@RequestMapping(value = "/admin/user_save.do", method = RequestMethod.POST)
	public String user_save(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, MultipartHttpServletRequest request) throws Exception {
		System.out.println("들어는오나");
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
				obj_param.put("EVENT_IDX", "2417");	//행사코드 고정
				obj_param.put("VISITOR_IDX", pictVO.getFairpath_id());
				
				String bus_info = "";
				bus_info = pictVO.getBus() + "호차 " + pictVO.getSeat();
				
				String gender = "1";
				if(pictVO.getBirthday_1().equals("2") || pictVO.getBirthday_1().equals("4")) gender = "2";
				
				obj_param.put("NAME", pictVO.getName());
				obj_param.put("TEL", pictVO.getMobile());
				obj_param.put("GENDER", gender);
				obj_param.put("INFO9", bus_info);
				obj_param.put("INFO10", pictVO.getBirthday());
				obj_param.put("OPTION_IDX", "5019");

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
				System.out.println(obj);
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
			try {
				URL url = new URL("https://api.fairpass.co.kr/fsApi/VisitorInsert");
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				
				conn.setRequestMethod("POST"); // http 메서드
				conn.setRequestProperty("Content-Type", "application/json"); // header Content-Type 정보
				conn.setRequestProperty("ApiKey", " rioE2lpgWGInf2Gd7XF9cOCDvqXGUzKXYPrqBCW"); // header의 auth 정보
				
				conn.setDoInput(true); // 서버에 전달할 값이 있다면 true
				conn.setDoOutput(true);// 서버에서 받을 값이 있다면 true
				
				JSONObject obj_param = new JSONObject();
				obj_param.put("EVENT_IDX", "2417");	//행사코드 고정
				
				//String bus_info = "";
				//bus_info = pictVO.getBus() + "호차 " + pictVO.getSeat();
				
				String gender = "1";
				if(pictVO.getBirthday_1().equals("2") || pictVO.getBirthday_1().equals("4")) gender = "2";
				obj_param.put("NAME", pictVO.getName());
				obj_param.put("TEL", pictVO.getMobile());
				obj_param.put("GENDER", gender);
				//obj_param.put("INFO9", bus_info);
				obj_param.put("INFO10", pictVO.getBirthday());
				obj_param.put("OPTION_IDX", "5019");
				
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
				System.out.println(obj);
				if(state_code != 0) {
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
		try {
			URL url = new URL("https://api.fairpass.co.kr/fsApi/VisitorDelete");
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			
			conn.setRequestMethod("POST"); // http 메서드
			conn.setRequestProperty("Content-Type", "application/json"); // header Content-Type 정보
			conn.setRequestProperty("ApiKey", " rioE2lpgWGInf2Gd7XF9cOCDvqXGUzKXYPrqBCW"); // header의 auth 정보
			
			conn.setDoInput(true); // 서버에 전달할 값이 있다면 true
			conn.setDoOutput(true);// 서버에서 받을 값이 있다면 true
			
			JSONObject obj_param = new JSONObject();
			obj_param.put("EVENT_IDX", "2417");	//행사코드 고정
			obj_param.put("VISITOR_IDX", pictVO.getFairpath_id());

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
				model.addAttribute("message", "삭제 중 오류가 발생하였습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/user/user_list.do");
				return "pict/main/message";
			}
			else {
				pictService.user_delete(pictVO);
				model.addAttribute("message", "정상적으로 삭제되었습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/admin/user_list.do");
				return "pict/main/message";
			}
		}
		catch(Exception e) {
			System.out.println(e);
			model.addAttribute("message", "삭제 중 오류가 발생하였습니다.");
			model.addAttribute("retType", ":location");
			model.addAttribute("retUrl", "/admin/user_list.do");
			return "pict/main/message";
		}
		
	}

	//버스입장 QR체크 페이지
	@RequestMapping(value = "/admin/intro_bus.do")
	public String intro_bus(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String idx = request.getSession().getAttribute("idx").toString();
		pictVO.setIdx(Integer.parseInt(idx));
		pictVO = pictService.get_person_info(pictVO);
		model.addAttribute("pictVO", pictVO);
		
		return "pict/admin/bus_list";
	}
	@RequestMapping(value = "/qr_insert.do", method= RequestMethod.POST)
	@ResponseBody
	public String user_invest_save(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		
		String idx = param.get("idx").toString();
		pictVO.setIdx(Integer.parseInt(idx));
		
		pictVO = pictService.get_person_info(pictVO);
		
		//이러면 이미 좌석정보 들어온 경우
		if(pictVO != null && pictVO.getBus() != null && pictVO.getSeat() != null) {
			return "already";
		}
		else {
			pictVO = pictService.get_seat_info(pictVO);
			int bus = Integer.parseInt(pictVO.getBus());
			int seat = Integer.parseInt(pictVO.getSeat());
			int target_bus = 0;
			int target_seat = 0;
			
			if(seat == 45) {
				target_bus = bus + 1;
				target_seat = 1;
			}
			else {
				target_bus = bus;
				target_seat = seat + 1;
			}
			pictVO.setIdx(Integer.parseInt(idx));
			pictVO.setBus(target_bus+"");
			pictVO.setSeat(target_seat+"");
			pictService.update_user_bus_info(pictVO);
			
			return target_bus+"@@"+target_seat;
		}
		
	}
	
	//메소드
	public static String encryptPassword(String password, String id) throws Exception {
		if (password == null) return "";
		if (id == null) return ""; // KISA 보안약점 조치 (2018-12-11, 신용호)
		byte[] hashValue = null; // 해쉬값
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.reset();
		md.update(id.getBytes());
		hashValue = md.digest(password.getBytes());
	
		return new String(Base64.encodeBase64(hashValue));
    }

    
}
