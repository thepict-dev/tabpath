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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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
			Date now = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String formatedNow = formatter.format(now);
			System.out.println(formatedNow);
			
			//여기 날짜 체크해서 10/7일만 mypage.do 보내고 / 이외에는 mypage_tap.do로 보내
			if(formatedNow.equals("2024-10-07")) {
				return "redirect:/mypage.do";
			}
			else {
				return "redirect:/mypage_tap.do";
			}
			
		}
	}
	@RequestMapping(value = "/login_action.do")
	public String login_action(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String inpuName = pictVO.getName();
		String inputMobile = pictVO.getMobile();
		
		pictVO = pictService.get_register_person_info(pictVO);

		if (pictVO != null) {
			String name = pictVO.getName();
			String mobile = pictVO.getMobile();
			
			if(inpuName.equals(name) && inputMobile.equals(mobile)) {
				request.getSession().setAttribute("idx", pictVO.getIdx());
				
				Date now = new Date();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				String formatedNow = formatter.format(now);
				System.out.println(formatedNow);
				
				//여기 날짜 체크해서 10/7일만 mypage.do 보내고 / 이외에는 mypage_tap.do로 보내
				if(formatedNow.equals("2024-10-07")) {
					return "redirect:/mypage.do";
				}
				else {
					return "redirect:/mypage_tap.do";
				}
				
				
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
	public String mypage(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String idx = request.getSession().getAttribute("idx").toString();
		pictVO.setIdx(Integer.parseInt(idx));
		pictVO = pictService.get_person_info(pictVO);
		model.addAttribute("pictVO", pictVO);
		
		return "pict/main/mypage";
	}
	@RequestMapping(value = "/mypage_tap.do")
	public String mypage_tap(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		String idx = request.getSession().getAttribute("idx").toString();
		pictVO.setIdx(Integer.parseInt(idx));
		pictVO = pictService.get_person_info(pictVO);
		model.addAttribute("pictVO", pictVO);
		
		return "pict/main/mypage_tap";
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

	@RequestMapping(value = "/apply.do")
	public String apply(@ModelAttribute("searchVO") AdminVO adminVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		return "pict/main/apply";
	}
	
	@RequestMapping(value = "/register_cancel.do")
	public String register_cancel(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		pictService.register_cancel(pictVO);
		request.getSession().setAttribute("idx", null);
		model.addAttribute("message", "참가등록이 취소되었습니다.");
		model.addAttribute("retType", ":location");
		model.addAttribute("retUrl", "/");
		return "pict/main/message";
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

	//사전등록 완료
	@RequestMapping(value = "/register_save.do", method= RequestMethod.POST)
	public String register_save(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		try {
			String name = param.get("name").toString();
			String mobile = param.get("mobile").toString();
			String sms_rand = param.get("sms_rand").toString();

			String boarding = param.get("boarding").toString();
			String location = param.get("location").toString();
			
			pictVO.setName(name);
			pictVO.setMobile(mobile);
			
			pictVO = pictService.sms_select(pictVO);
			
			
			if(pictVO.getSms_rand().equals(sms_rand)){
				pictVO.setBoarding(boarding);
				pictVO.setLocation(location);
				pictService.sms_update(pictVO);
				
				String msg = "가보고 싶은 두타연 : 금강산 가는 옛길 걷기 참가자 모집 행사에 참가확정 되었습니다.\n마이페이지 URL : https://www.tabpath.co.kr/mypage_login.do";
				System.out.println(msg);
				System.out.println(mobile);
				model.addAttribute("msg", msg);
				model.addAttribute("mobile", mobile);
				model.addAttribute("retType", ":none");
				model.addAttribute("retUrl", "/");
				return "pict/main/message_sms";
				
			}
			else {
				System.out.println("여기가 안되는데");
				model.addAttribute("message", "인증번호가 올바르지 않습니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/");
				return "pict/main/message_alert";
				
				
			}
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
			model.addAttribute("message", "인증번호가 올바르지 않습니다.");
			model.addAttribute("retType", ":location");
			model.addAttribute("retUrl", "/");
			return "pict/main/message_alert";
		}
		
		
	}
	//버스입장 QR체크 페이지
	@RequestMapping(value = "/admin/intro_bus.do")
	public String intro_bus(@ModelAttribute("searchVO") PictVO pictVO, HttpServletRequest request, ModelMap model, HttpSession session, RedirectAttributes rttr) throws Exception {
		
		
		return "pict/admin/tappass";
	}
	@RequestMapping(value = "/qr_insert.do", method= RequestMethod.POST)
	@ResponseBody
	public HashMap<String, Object> user_invest_save(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();	
		String idx = param.get("idx").toString();
		pictVO.setIdx(Integer.parseInt(idx));
		
		pictVO = pictService.get_person_info(pictVO);
		
		//이러면 이미 좌석정보 들어온 경우
		if(pictVO != null && pictVO.getBus() != null && pictVO.getSeat() != null && !pictVO.getBus().equals("") && !pictVO.getSeat().equals("")) {
			pictVO.setIdx(Integer.parseInt(idx));
			pictVO = pictService.get_person_info(pictVO);
			
			map.put("text", "already");
			map.put("rst", pictVO);
			return map;
		}
		else {
			pictVO = pictService.get_seat_info(pictVO);
			String busString = pictVO.getBus();
			int bus;
			if (busString == null || busString.trim().isEmpty()) {
			    // 공란인 경우 기본값 설정 (예: 0)
			    bus = 0; 
			} else {
				bus = Integer.parseInt(busString);
			}
			
			String busString2 = pictVO.getSeat();
			int seat;
			if (busString2 == null || busString2.trim().isEmpty()) {
			    // 공란인 경우 기본값 설정 (예: 0)
				seat = 0; 
			} else {
				seat = Integer.parseInt(busString2);
			}
			
			int target_bus = 0;
			int target_seat = 0;
			
			if(bus == 0) {
				bus = 1;
			}
			
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
			
			pictVO.setIdx(Integer.parseInt(idx));
			pictVO = pictService.get_person_info(pictVO);
			
			map.put("text", "success");
			map.put("rst", pictVO);
			return map;
		}
		
	}
	
	//문자발송
	@RequestMapping(value = "/sms_number.do", method= RequestMethod.POST)
	public String sms_number(@ModelAttribute("searchVO") PictVO pictVO, ModelMap model, HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		
		try {
			Random random = new Random();
	        int verify_num = 100000 + random.nextInt(900000);
			
			String name = param.get("name").toString();
			pictVO.setName(name);
			
			String mobile = param.get("mobile").toString();
			pictVO.setMobile(mobile);
			
			String gender = param.get("gender").toString();
			String sex = "";
			if(gender.equals("1") || gender.equals("3")) sex = "1";
			if(gender.equals("2") || gender.equals("4")) sex = "2";
		
			String birth = param.get("birth").toString();
			pictVO.setBirthday(birth);
			
			pictVO = pictService.sms_select(pictVO);
			System.out.println("널이 탔잖아 근데 왜 ");
			if(pictVO != null) {
				System.out.println("이미등롞ㄲㄲㄲㄲㄲㄲㄲㄲㄲ");
				model.addAttribute("message", "이미 등록된 회원입니다.");
				model.addAttribute("retType", ":location");
				model.addAttribute("retUrl", "/");
				return "pict/main/message_alert";
			}
			else {
				URL url = new URL("https://api.fairpass.co.kr/fsApi/VisitorInsert");
				HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				
				conn.setRequestMethod("POST"); // http 메서드
				conn.setRequestProperty("Content-Type", "application/json"); // header Content-Type 정보
				conn.setRequestProperty("ApiKey", " rioE2lpgWGInf2Gd7XF9cOCDvqXGUzKXYPrqBCW"); // header의 auth 정보
				
				conn.setDoInput(true); // 서버에 전달할 값이 있다면 true
				conn.setDoOutput(true);// 서버에서 받을 값이 있다면 true
				
				JSONObject obj_param = new JSONObject();
				obj_param.put("EVENT_IDX", "2417");	//행사코드 고정

				
				obj_param.put("NAME", name);
				obj_param.put("TEL", mobile);
				obj_param.put("GENDER", sex);
				obj_param.put("INFO10", birth);
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
				if(state_code != 0) {
					model.addAttribute("message", "인증에 오류가 발생하였습니다.");
					model.addAttribute("retType", ":location");
					model.addAttribute("retUrl", "/");
					return "pict/main/message_alert";
				}
				else {
					if(pictVO == null) {
						pictVO = new PictVO();
					}
					pictVO.setFairpath_id(obj.getInt("VISITOR_IDX")+"");
					pictVO.setName(name);
					pictVO.setMobile(mobile);
					pictVO.setBirthday(birth);
					pictVO.setBirthday_1(sex);
					pictVO.setSms_rand(verify_num+"");
					pictService.user_insert(pictVO);
					
					String msg = "귀하의 인증번호는 " + verify_num + " 입니다.\n인증번호를 입력하시고 참가등록을 진행해주세요.";
					model.addAttribute("msg", msg);
					model.addAttribute("mobile", mobile);
					model.addAttribute("retType", ":none");
					model.addAttribute("retUrl", "/");
					return "pict/main/message_sms";
					
				}
			}
		}
		catch(Exception e) {
			System.out.println("오류ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ");
			System.out.println(e.getMessage());
			e.printStackTrace();
			model.addAttribute("message", "오류가 발생하였습니다.");
			model.addAttribute("retType", ":location");
			model.addAttribute("retUrl", "/");
			return "pict/main/message_alert";
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
