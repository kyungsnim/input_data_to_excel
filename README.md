# 조지형 국어학원 과제관리 앱 요구사항 및 진척도

## 1. 최초 요구사항
### - 로그인 화면 구성 (수험번호/비밀번호 로그인)
### - 과제 일정 캘린더 탭
### - 회원가입 후 관리자가 승인해줘야 정상 이용 가능토록 구현해야 함

## 2. Todo list (kyungsnim)
### - 과제제출 로직
#### - 제출된답 있나? (YES) 답안 삭제후 다시 풀도록 팝업 / (NO) 풀기 시작
#### - 문제 풀다가 나가려고 할 때 '지금 나가시면 답안이 저장되지 않습니다.' 팝업
### - 과제 제출했는데 다시 해당과제 들어가려고 할 때 어떻게 할건가?
### - 엑셀 일괄 업로드 기능 넣을 것인지?
### - 과제 생성하면 알아서 모든 학생들 빈칸으로 만들어줘야 하나?
### - 몇 차수에 제출했는지 엑셀에 저장되어야 할듯....

## 3. Complete list
### ======================== 2020.02.02 ========================
### - 로그인 화면 구성 (수험번호/비밀번호 로그인)
### - 과제 일정 캘린더 탭
### - 과제 클릭 후 문제 푸는 화면
### - 내 정보 (학년 등) 수정 화면
### - 문항 체크할 때 색깔 표시
### - 캘린더로 과제 일정 보여주기
### - 과제 추가
### - 자동 로그인 기능 / 로그아웃
### - 전체적으로 사용 안하는 소스 정리
### - 과제 풀기 화면 UI 일부 변경 (답 체크시 blueAccent색상, 안푼문제 있는지 red 색상으로 체크)
### - 홈화면에서 뒤로가기 버튼 (안드로이드) 눌렀을 때 동작하도록
### - 회원가입 후 관리자가 승인해줘야 정상 이용 가능토록 구현해야 함
### - 회원가입시 공란으로 회원가입하면 막아야 함
### - 정보 수정 (학년만)
### - (관리자모드) 해당 과제클릭 > 전송 클릭시 Storage 저장 또는 이메일 전송(csv 파일첨부)
### - (관리자모드) 최초가입자 승인해주기
### - 일요일 인식 못하는 문제 해결
### - iPad용 글씨크기, 수험번호 저장 위치 등 조정
### - 앱 아이콘, 스플래쉬 스크린 설정
### - 로그인/회원가입 글씨체 조금 키움
### - 답안 제출시 몇 차수 기간에 제출했는지 추가
### - 관리자가 자료 추출시 제출차수도 같이 나오게끔 추가

## 4. 협의 필요 사항
### - 엑셀로 변환된 자료의 샘플이 필요
### - 과제별로 학생들 자료를 일괄로 엑셀다운 받는데 이메일로 보내는게 나을지 클라우드DB에 저장하는게 나을지?(후자 선호)

# 앱 기능 소개 : 학생들이 수업 후 과제를 풀게 되는데 이 답안을 앱으로 입력하여 모든 문제에 대한 입력내용을 엑셀로 클라우드DB에 저장하는 앱

# 사용자(학생)
## - 학원의 학생이 로그인한다. (최초 회원가입시 관리자가 승인을 해줘야 정상 이용 가능)
### -> 관리자 승인 : 내정보 > 가입승인 > 해당 사용자(학생) 승인버튼 클릭
## - 사용자(학생)는 과제목록 중 본인이 들은 수업에 해당하는 과제를 클릭한다.
## - 과제는 최대 50문제 이내 5지선다형 문제이며 문제집은 본인들이 별도로 가지고 있다.
## - 사용자(학생)는 각자 문제를 푼 후 제출 버튼을 클릭해 제출한다.

# 관리자 기능
## - 과제 제출기간(1,2,3차)이 끝나면 관리자는 해당 과제를 클릭해 전송 버튼을 누른다.
## - 해당 과제를 제출한 모든 학생들의 답인이 엑셀(.csv)로 변환되어 클라우드DB에 저장된다.

# Test ID
## - 사용자 : 112233 (pw: 112233)
## - 관리자 : 111111 (pw: 222222)
## -> ID규칙은 6자리 숫자임