<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>달력</title>
<script src="LunarCalendar.js" ></script>
<script type="text/javascript">
	var today = new Date();
	
	function setToday(year, month) {
		today = new Date(year, month-1, 1);
	}
	
	//today에 Date 객체를 넣어줌 ex)5일
	function prevCalendar() {
		today = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate()); //month를 조정해 해당 월을 변경함
		buildCalendar();
	}
	
	function nextCalendar() {
		today = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate()); //month를 조정해 해당 월을 변경함
		buildCalendar();
	}
	
	function buildCalendar() {
		var nMonth = new Date(today.getFullYear(), today.getMonth(), 1); //이번 달의 첫째 날
		var lastDate = new Date(today.getFullYear(), today.getMonth() + 1, 0); //이번 달의 마지막 날
		var tblCalendar = document.getElementById('calendar'); //달력 만들 테이블
		var tblCalendarYM = document.getElementById('calendarYM'); //yyyy년 mm월 출력할 곳
		
		tblCalendarYM.innerHTML = today.getFullYear() + "년 " + (today.getMonth() + 1) + "월"; //yyyy년 mm월 출력
		
		var year = today.getFullYear();
		var lastYear = 0;
		
		//year와 lastYear가 동일할 경우 setLunaToSolar를 계산하지 않음
		var isSame = false;
		if (year == lastYear){
			isSame = true;
		}
		
		var solarHolidays = ["0101", "0301", "0505", "0606", "0717", "0815", "1003", "1009", "1225"]; //양력 휴일
		var LunaHolidays = ["0101", "0102", "0408", "0814", "0815", "0816"]; //음력휴일, 설 전날 포함
		var alterNativeHolidays = []; //임시공휴일, 대체공휴일. (yyyyMMdd)
		var setLunaToSolar = []; //당년도의 음력을 양력으로
		
		var workDay = 0;
		var cnt = nMonth.getDay();
		
		//setLunaToSolar
		////////////////////////////////////////////////////////////////////////////////
		if(!isSame){ //당년도의 음력휴일 양력으로 변환
			for(i=0; i<LunaHolidays.length; i++){
				var solar = Resut(year + "" + LunaHolidays[i]);
				
				if(i == 0){
					//var cDate = new Date;
					var cMonth = solar.substring(0, 2);
					var cDay = solar.substring(2, 4);
					var cDate = new Date(parseInt(cMonth) + "/" + parseInt(cDay) + "/" + year); 
					cDate.setDate(cDate.getDate() - 1); //하루전
					
					/*
					cDate.setMonth(parseInt(cMonth-1)); //월 설정
					cDate.setDate(parseInt(cDay)); //일 설정
					//cDate.setDate(-1); //하루 전 날
					
					//var sdate = cDate.setDate(cDate.getDate() - 1);
					*/
					
					var sm = (cDate.getMonth() + 1);
					if(sm < 10){
						sm = "0" + sm;
						var sd = (cDate.getDate());
					}
					
					if(sd < 10){
						sd = "0" + sd;
					}
					
					sDate = sm + "" + sd;
					setLunaToSolar.push(sDate);
				}
				setLunaToSolar.push(solar);
			}
			lastYear = today.getFullYear();
		}
		
		var year1 = today.getFullYear();
		var month1 = (today.getMonth() + 1);
		
		//console.log(dayWeek);
		
		if((today.getMonth() + 1) < 10){
			month1 = "0" + (today.getMonth() + 1);
		}
		
		var list = [];
		
		for(i=0; i<solarHolidays.length; i++){ //양력휴일
			if(solarHolidays[i].substring(0,2) == month1){
				list.push(solarHolidays[i].substring(2,4)); //휴일이 있을 경우 list에 넣음
			}
		}
		
		for(i=0; i<setLunaToSolar.length; i++){ //음력휴일
			if(setLunaToSolar[i].substring(0,2) == month1){
				list.push(setLunaToSolar[i].substring(2,4)); //휴일이 있을 경우 list에 넣음
			}
		}
		
		for(i=0; i<alterNativeHolidays.length; i++){ //임시공휴일
			if(alterNativeHolidays[i].substring(0,4) == year){ //공휴년도가 해당 년도와 일치할 경우
				if(alterNativeHolidays[i].substring(4,6) == month1){ //공휴 년도가 해당 월과 일치할 경우
					list.push(alterNativeHolidays[i].substring(6,8)); //휴일이 있을 경우 list에 넣음
				}
			}
		}
		
		// 기존 테이블에 뿌려진 줄, 칸 삭제
		while (tblCalendar.rows.length > 2) {
			tblCalendar.deleteRow(tblCalendar.rows.length - 1);
		}
		
		var row = null;
		row = tblCalendar.insertRow();
		var cnt = 0;
		
		// 1일이 시작되는 칸을 맞추어 줌
		for (i=0; i<nMonth.getDay(); i++) {
			cell = row.insertCell();
			cnt = cnt + 1;
		}
		
		// 달력 출력
		for (i=1; i<=lastDate.getDate(); i++) { // 1일부터 마지막 일까지
			var pass = false;
			var isHoliday = false;
			cell = row.insertCell();
		
			if(list.length > 0){ //휴일이 있을 경우
				for(j=0; j<list.length; j++){
					if(list[j] == i){
						pass = true;
						isHoliday = true;
						break;
					}
				}
			}
			
			if(!pass){
				if(cnt % 7 == 6){
					isHoliday = true;
				}
				
				if(cnt % 7 == 0){
					isHoliday = true;
				}
			}
		
			cnt = cnt + 1;
			if (cnt%7 == 0)       // 1주일이 7일 이므로
				row = calendar.insertRow();   //줄 추가
		}
	}
</script>
</head>
<body>
	<table id="calendar">
		<tr>
			<td><label onclick="prevCalendar()"></label></td>
			<td colspan="5" align="center" id="calendarYM">yyyy년 m월</td>
			<td><label onclick="nextCalendar()">></label></td>
		</tr>
		<tr>
			<td align="center">일</td>
			<td align="center">월</td>
			<td align="center">화</td>
			<td align="center">수</td>
			<td align="center">목</td>
			<td align="center">금</td>
			<td align="center">토</td>
		</tr>
	</table>
	<script type="text/javascript">
		buildCalendar();
	</script>
</body>
</html>