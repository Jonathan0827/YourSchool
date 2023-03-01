function 자료944(자료, 학년, 반) {
	var p,
		k,
		th,
		sb,
		속성 = "",
		원자료,
		일일자료,
		강의실 = "";
	p = "<TABLE  style='width:340px; margin:3px 0px;'>";
	p +=
		"<TR><td class='내용2' style='border:0px; text-align:left;'><input type='button' onClick='ba_NextDisp(-1);' value='◀'></td><TD style='border:0px;' colspan='5' class='내용2'>제 " +
		학년 +
		" 학년 " +
		반 +
		" 반 시간표 </TD><td class='내용2'style='border:0px; text-align:right;'><input type='button' onClick='ba_NextDisp(1);' value='▶'></td></TR>";
	p += 요일출력하기(자료.시작일);
	var 시작일 = new Date(자료.시작일);
	var 제한일 = new Date(자료.열람제한일);
	for (var 교시 = 1; 교시 <= 8; 교시++) {
		p += "<tr><td class='교시'>" + 자료.일과시간[교시 - 1] + "</td>";
		var dt = new Date(자료.시작일);
		dt.setDate(dt.getDate() - 1);
		for (var 요일 = 1; 요일 < 7; 요일++) {
			dt.setDate(dt.getDate() + 1);
			if (dt < 제한일 || 제한일.getFullYear() < 2014 || isNaN(제한일)) {
				원자료 = Q자료(자료.자료481[학년][반][요일][교시]);
				일일자료 = Q자료(자료.자료147[학년][반][요일][교시]);
				if (자료.강의실 == 1) {
					강의실 = 자료.자료245[학년][반][요일][교시];
					if (강의실 > 0) {
						강의실 = "<br>" + 강의실;
					} else {
						강의실 = "";
					}
				}
				th = Math.floor(일일자료 / 100);
				sb = 일일자료 - th * 100;
				if (원자료 == 일일자료) {
					속성 = "내용";
				} else {
					속성 = "변경";
				}
				if (일일자료 > 100) {
					var 성명 = "";
					if (th < 자료.자료446.length) {
						성명 = 자료.자료446[th].substr(0, 2);
					}
					var m2 = 동시그룹코드(자료, 학년, 반, sb, 요일, 교시);
					p +=
						"<td class='" +
						속성 +
						"'>" +
						m2 +
						자료.자료492[sb] +
						"<br>" +
						성명 +
						강의실 +
						"</td>";
				} else {
					p += "<td class='" + 속성 + "'></td>";
				}
			} else {
				p += "<td class='내용'></td>";
			}
		}
		p += "</tr>";
	}
	p += "</table>";
	return p;
}
function 학년시간표출력(자료, 학년, 요일) {
	var n,
		p,
		k,
		th,
		sb,
		속성 = "",
		원자료,
		일일자료,
		강의실 = "";
	var 요일명 = ["일", "월", "화", "수", "목", "금", "토"];
	var 제한일 = new Date(자료.열람제한일);
	var dt = new Date(자료.시작일);
	dt.setDate(dt.getDate() + Number(요일) - 1);
	var 요일2 = 요일명[요일] + "(" + dt.getDate() + "일)";
	if (자료.학급수[학년] <= 2) {
		return "";
	}
	n = 자료.학급수[학년] + 1 - 2;
	var 요일선택 = 요일설정하기(자료, 요일);
	p = "<TABLE  style='margin:3px 0px;'>";
	p +=
		"<TR><td class='내용2'style='border:0px; text-align:left;'>" +
		요일선택 +
		"</td><TD style='border:0px;' colspan='" +
		n +
		"' class='내용2'>제 " +
		학년 +
		" 학년 시간표 " +
		요일2 +
		"</TD><td class='내용2' style='border:0px; text-align:right;'><input type='button' onClick='yo_NextDisp(1);' value='▶'></td></TR>";
	p += 학급출력하기(자료, 학년);
	for (var 교시 = 1; 교시 <= 8; 교시++) {
		p += "<tr><td class='교시'>" + 자료.일과시간[교시 - 1] + "</td>";
		for (var 반 = 1; 반 <= 자료.학급수[학년]; 반++) {
			if (dt < 제한일 || 제한일.getFullYear() < 2014 || isNaN(제한일)) {
				원자료 = Q자료(자료.자료481[학년][반][요일][교시]);
				일일자료 = Q자료(자료.자료147[학년][반][요일][교시]);
				if (Q자료(자료.강의실) == 1) {
					강의실 = Q자료(자료.자료245[학년][반][요일][교시]);
					if (강의실 > 0) {
						강의실 = "<br>" + 강의실;
					} else {
						강의실 = "";
					}
				}
				th = Math.floor(일일자료 / 100);
				sb = 일일자료 - th * 100;
				if (원자료 == 일일자료) {
					속성 = "내용";
				} else {
					속성 = "변경";
				}
				if (일일자료 > 100) {
					var 성명 = "";
					if (th < 자료.자료446.length) {
						성명 = 자료.자료446[th].substr(0, 2);
					}
					var m2 = 동시그룹코드(자료, 학년, 반, sb, 요일, 교시);
					p +=
						"<td class='" +
						속성 +
						"'>" +
						m2 +
						자료.자료492[sb] +
						"<br>" +
						성명 +
						강의실 +
						"</td>";
				} else {
					p += "<td class='" + 속성 + "'></td>";
				}
			} else {
				p += "<td class='내용'></td>";
			}
		}
		p += "</tr>";
	}
	p += "</table>";
	return p;
}
function 동시그룹코드(자료, 학년, 반, 과목, 요일, 교시) {
	var 학급, 학년2, 반2, 과목2, 교사, 과목3, ck, n2;
	if (!Array.isArray(자료.동시그룹)) {
		return "";
	}
	for (var i = 1; i <= 자료.동시그룹[0][0]; i++) {
		for (var j = 1; j <= 자료.동시그룹[i][0]; j++) {
			과목2 = Math.floor(자료.동시그룹[i][j] / 1000);
			학급 = 자료.동시그룹[i][j] - 과목2 * 1000;
			학년2 = Math.floor(학급 / 100);
			반2 = 학급 - 학년2 * 100;
			교사 = Math.floor(자료.자료481[학년2][반2][요일][교시] / 100);
			과목3 = 자료.자료481[학년2][반2][요일][교시] - 교사 * 100;
			if (!(과목2 == 과목3)) {
				ck = 0;
				break;
			}
			if (학년 == 학년2 && 반 == 반2 && 과목 == 과목2) {
				ck = 1;
			}
		}
		if (ck == 1) {
			if (i > 26) {
				n2 = i + 70;
			} else {
				n2 = i + 64;
			}
			return String.fromCharCode(n2) + "_";
		}
	}
	return "";
}
function 학급출력하기(자료, 학년) {
	var p = "<tr><TD class='교시'>교시</td>";
	for (var 반 = 1; 반 <= 자료.학급수[학년]; 반++) {
		p += "<TD class='제목'>" + 반 + "반</td>";
	}
	p += "</TR>";
	return p;
}
function 요일설정하기(자료, 요일2) {
	var 요일 = ["월", "화", "수", "목", "금", "토"],
		선택;
	var dt = new Date(자료.시작일);
	dt.setDate(dt.getDate() - 1);
	var p = "<select id='yo' name='yo' onchange='yo_change()'>";
	p += "<option value='0'>-요일-</option>";
	for (var i = 0; i < 6; i++) {
		dt.setDate(dt.getDate() + 1);
		if (요일2 == i + 1) {
			선택 = "selected";
		} else {
			선택 = "";
		}
		p +=
			"<option value='" +
			(i + 1) +
			"' " +
			선택 +
			">" +
			요일[i] +
			"</option>";
	}
	return p;
}
function Q자료(m) {
	if (m == undefined) {
		return 0;
	} else {
		return m;
	}
}
function yo_change() {
	var 요일 = document.getElementById("yo").value;
	var m = document.getElementById("ba").value;
	var m2 = m.split("-");
	var 학년 = Number(m2[0]);
	$("#hour2").empty().append(학년시간표출력(H시간표, 학년, 요일));
}
function yo_NextDisp(방향) {
	var m = document.getElementById("yo");
	var k = m.selectedIndex + 방향;
	if (k < 1) {
		k = m.length - 1;
	} else {
		if (k == m.length - 1) {
			k = 1;
		}
	}
	m[k].selected = true;
	yo_change();
}
function school_ra(sc) {
	$.ajax({
		url: "./36179?17384l" + sc,
		success: function (data2) {
			var da = data2.substr(0, data2.lastIndexOf("}") + 1);
			H학교명단 = JSON.parse(da);
			학교명단_출력하기(H학교명단.학교검색);
		},
	});
}
function 학급설정하기(학급수, 가상학급수) {
	var p = "<option value=''>-학급-</option>";
	for (var 학년 = 1; 학년 <= 3; 학년++) {
		for (var 반 = 1; 반 <= 학급수[학년] - 가상학급수[학년]; 반++) {
			p +=
				"<option value='" +
				학년 +
				"-" +
				반 +
				"'>" +
				학년 +
				"-" +
				반 +
				"</option>";
		}
	}
	return p;
}
function 일자설정하기(일자들, r) {
	var p = "";
	for (var i = 0; i < 일자들.length; i++) {
		if (r == 일자들[i][0]) {
			p +=
				"<option value='" +
				일자들[i][0] +
				"' selected>" +
				일자들[i][1] +
				"</option>";
		} else {
			p +=
				"<option value='" +
				일자들[i][0] +
				"'>" +
				일자들[i][1] +
				"</option>";
		}
	}
	return p;
}
function 요일출력하기(시작일) {
	var p = "<tr><TD class='교시'>교시</td>";
	var 요일 = ["월", "화", "수", "목", "금", "토"];
	var dt = new Date(시작일);
	dt.setDate(dt.getDate() - 1);
	for (var i = 0; i < 6; i++) {
		dt.setDate(dt.getDate() + 1);
		p += "<TD class='제목'>" + 요일[i] + "(" + dt.getDate() + ")</td>";
	}
	p += "</TR>";
	return p;
}
function 학교명단_출력하기(학교명단) {
	var p = "<tr class='검색'><td>지역</td><td>학교명</td></tr>";
	for (var i = 0; i < 학교명단.length; i++) {
		p +=
			"<tr class='검색'><td>" +
			학교명단[i][1] +
			"</td><td><a href='#' onClick='sc_disp(" +
			학교명단[i][3] +
			")'>" +
			학교명단[i][2] +
			"</a></td></tr>";
	}
	p +=
		"<tr class='검색'><td colspan=2 style='height:30pt;'>일과진행을 사용하는 학교만 시간표를 열람할 수 있습니다.</td></tr>";
	$("#학교명단검색").empty().append(p);
}
function sc_data(sc, sc2, r) {
	var da1 = "0";
	if (storage.sc == sc2 && storage.r == r) {
		da1 = H시간표.자료244;
	}
	var s7 = sc + sc2;
	var sc3 = "./36179?" + btoa(s7 + "_" + da1 + "_" + r);
	$.ajax({
		url: sc3,
		success: function (data) {
			if (data.length < 18) {
				data = {};
				return;
			}
			if (data.lastIndexOf("}") > 0) {
				var da = data.substr(0, data.lastIndexOf("}") + 1);
				H시간표 = JSON.parse(da);
				storage.hour = da;
				storage.r = r;
				storage.Tsc = "";
				if (da.length == 2) {
					$("#hour").empty().append("");
					$("#수정일").text("data no");
				}
			}
			화면구성하기(r);
		},
	});
}
function sc_disp(sc) {
	var scnm = "";
	for (var i = 0; i < H학교명단.학교검색.length; i++) {
		if (H학교명단.학교검색[i][3] == sc) {
			scnm = H학교명단.학교검색[i][2];
			break;
		}
	}
	window.localStorage.scnm = scnm;
	window.localStorage.sc = sc;
	$("#시간표열람").show();
	$("#학교찾기").hide();
	$("#scnm").empty().append(scnm);
	sc_data("73629_", sc, 1);
}
function sc_search() {
	$("#학교찾기").show();
	$("#시간표열람").hide();
}
function sc2_search() {
	var sc = document.getElementById("sc").value;
	if (sc != "") {
		school_ra(sc);
	}
}
function ba_change() {
	var m = document.getElementById("ba").value;
	var m2 = m.split("-");
	var 학년 = Number(m2[0]);
	var 반 = Number(m2[1]);
	storage.ba = m;
	$("#hour").empty().append(자료944(H시간표, 학년, 반));
	var elem = document.getElementById("yo");
	if (elem !== null && elem !== "undefined") {
		var 요일 = document.getElementById("yo").value;
	} else {
		var d = new Date(),
			요일 = d.getDay();
		if (요일 == 0) 요일 = 1;
	}
	학년출력하기(학년, 요일);
}
function 학년출력하기(학년, 요일) {
	var sc = window.localStorage.scnm;
	var ck = sc.indexOf("고등학교");
	var ck2 = sc.lastIndexOf("고") + 1;
	var ck3 = sc.length;
	if ((ck > 0 || ck2 == ck3) && 학년 >= 2) {
		if (요일 < 1) 요일 = 1;
		if (요일 == 6) 요일 = 5;
		$("#hour2").empty().append(학년시간표출력(H시간표, 학년, 요일));
	} else {
		$("#hour2").empty();
	}
}
function ba_NextDisp(방향) {
	var m = document.getElementById("ba");
	var k = m.selectedIndex + 방향;
	if (k < 1) {
		k = m.length - 1;
	} else {
		if (k == m.length - 1) {
			k = 1;
		}
	}
	m[k].selected = true;
	ba_change();
}
function nal_change() {
	var r = document.getElementById("nal").value;
	sc_data("73629_", storage.sc, r);
}
function 화면구성하기(r) {
	var r2;
	var d = new Date();
	var 요일 = d.getDay();
	if (r > 0) {
		r2 = r;
	} else {
		r2 = H시간표.오늘r;
	}
	$("#nal").empty().append(일자설정하기(H시간표.일자자료, r2));
	$("#ba").empty().append(학급설정하기(H시간표.학급수, H시간표.가상학급수));
	var 학년 = 1,
		반 = 1;
	var m = storage.ba.split("-");
	if (m.length == 2) {
		학년 = Number(m[0]);
		반 = Number(m[1]);
		if (학년 <= 0 || 학년 > 3) 학년 = 1;
		if (반 > H시간표.학급수[학년]) 반 = 1;
	}
	var ma = document.getElementById("ba");
	ma.value = 학년 + "-" + 반;
	$("#hour").empty().append(자료944(H시간표, 학년, 반));
	$("#수정일").text("수정일: " + H시간표.자료244);
	학년출력하기(학년, 요일);
}
function logoLoad2() {
	logoLoad("logo");
	logoLoad("logo2");
}
function logoLoad(id) {
	var canvas = document.getElementById(id);
	var ctx = canvas.getContext("2d");
	ctx.beginPath();
	ctx.moveTo(0, 0);
	ctx.lineTo(178, 0);
	ctx.moveTo(0, 0);
	ctx.lineTo(0, 36);
	ctx.quadraticCurveTo(0, 0, 178, 0);
	ctx.fillStyle = "rgb(129,163, 254)";
	ctx.fill();
	ctx.beginPath();
	ctx.moveTo(0, 36);
	ctx.lineTo(178, 36);
	ctx.lineTo(178, 0);
	ctx.moveTo(0, 36);
	ctx.quadraticCurveTo(0, 0, 178, 0);
	ctx.fillStyle = "rgb(213,240, 249)";
	ctx.fill();
	ctx.fillRect(178, 0, 340, 36);
	ctx.font = "16pt 맑은고딕";
	ctx.fillStyle = "rgb(93,143, 254)";
	ctx.fillText("컴시간", 82, 28);
	ctx.strokeStyle = "rgb(93,143, 254)";
	ctx.strokeText("컴시간", 82, 28);
}
