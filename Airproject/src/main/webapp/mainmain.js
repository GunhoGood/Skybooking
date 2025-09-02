// ============== Main.jsp 수정된 JavaScript ==============

// 오늘 날짜 설정
const today = new Date().toISOString().split('T')[0];
document.getElementById('departureDate').min = today;
document.getElementById('returnDate').min = today;

// 기본 출발일 설정 (오늘로부터 7일 후)
const defaultDate = new Date();
defaultDate.setDate(defaultDate.getDate() + 7);
document.getElementById('departureDate').value = defaultDate.toISOString().split('T')[0];

// 기본 귀국일 설정 (출발일로부터 7일 후)
const defaultReturnDate = new Date();
defaultReturnDate.setDate(defaultReturnDate.getDate() + 14);
document.getElementById('returnDate').value = defaultReturnDate.toISOString().split('T')[0];

// 여행 타입 탭 전환
document.querySelectorAll('.trip-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        // 모든 탭에서 active 클래스 제거
        document.querySelectorAll('.trip-tab').forEach(t => t.classList.remove('active'));
        // 클릭된 탭에 active 클래스 추가
        this.classList.add('active');
        
        const tripType = this.dataset.type;
        document.getElementById('hiddenTripType').value = tripType;
        
        // 편도/다구간 선택 시 귀국일 필드 비활성화
        const returnDateGroup = document.getElementById('returnDateGroup');
        const returnDateInput = document.getElementById('returnDate');
        
        if (tripType === 'oneway' || tripType === 'multi') {
            returnDateGroup.classList.add('disabled');
            returnDateInput.required = false;
            returnDateGroup.style.opacity = '0.5';
            returnDateInput.disabled = true;
        } else {
            returnDateGroup.classList.remove('disabled');
            returnDateInput.required = true;
            returnDateGroup.style.opacity = '1';
            returnDateInput.disabled = false;
        }
    });
});

// 출발지/도착지 교체 버튼
document.querySelector('.swap-button').addEventListener('click', function() {
    const departure = document.getElementById('departureCity');
    const arrival = document.getElementById('arrivalCity');
    
    const temp = departure.value;
    departure.value = arrival.value;
    arrival.value = temp;
});

// 출발일 변경 시 귀국일 최소값 설정
document.getElementById('departureDate').addEventListener('change', function() {
    const departureDate = this.value;
    const returnDateInput = document.getElementById('returnDate');
    returnDateInput.min = departureDate;
    
    // 귀국일이 출발일보다 이전이면 초기화
    if (returnDateInput.value && returnDateInput.value < departureDate) {
        const newReturnDate = new Date(departureDate);
        newReturnDate.setDate(newReturnDate.getDate() + 7);
        returnDateInput.value = newReturnDate.toISOString().split('T')[0];
    }
});

// 승객 수 변경 시 승객 선택 드롭다운 업데이트
function updatePassengerSelect() {
    const adults = parseInt(document.getElementById('adultCount').value) || 0;
    const children = parseInt(document.getElementById('childCount').value) || 0;
    const infants = parseInt(document.getElementById('infantCount').value) || 0;
    
    const passengerSelect = document.getElementById('passengerSelect');
    passengerSelect.value = `${adults}-${children}-${infants}`;
}

// 승객 선택 드롭다운 변경 시 개별 필드 업데이트
document.getElementById('passengerSelect').addEventListener('change', function() {
    const [adults, children, infants] = this.value.split('-').map(Number);
    
    document.getElementById('adultCount').value = adults;
    document.getElementById('childCount').value = children;
    document.getElementById('infantCount').value = infants;
});

// 개별 승객 수 필드 변경 시 드롭다운 업데이트
['adultCount', 'childCount', 'infantCount'].forEach(id => {
    document.getElementById(id).addEventListener('change', updatePassengerSelect);
});

// 승객 수 유효성 검사
function validatePassengerCount() {
    const adults = parseInt(document.getElementById('adultCount').value) || 0;
    const children = parseInt(document.getElementById('childCount').value) || 0;
    const infants = parseInt(document.getElementById('infantCount').value) || 0;
    
    const totalPassengers = adults + children + infants;
    
    if (totalPassengers > 9) {
        alert('총 승객 수는 9명을 초과할 수 없습니다.');
        return false;
    }
    
    if (infants > adults) {
        alert('유아 수는 성인 수를 초과할 수 없습니다.');
        return false;
    }
    
    if (adults === 0) {
        alert('성인 승객이 최소 1명 이상이어야 합니다.');
        return false;
    }
    
    return true;
}

// 폼 제출 전 유효성 검사 (메인 이벤트)
document.getElementById('flightSearchForm').addEventListener('submit', function(e) {
    console.log('폼 제출 시작'); // 디버깅용
    
    // 유효성 검사
    if (!validatePassengerCount()) {
        e.preventDefault();
        return false;
    }
    
    // 필수 필드 확인
    const departure = document.getElementById('departureCity').value;
    const arrival = document.getElementById('arrivalCity').value;
    const departureDate = document.getElementById('departureDate').value;
    
    if (!departure || !arrival || !departureDate) {
        e.preventDefault();
        alert('출발지, 도착지, 출발일을 모두 선택해주세요.');
        return false;
    }
    
    // 출발지와 도착지가 같은지 확인
    if (departure === arrival) {
        e.preventDefault();
        alert('출발지와 도착지가 같을 수 없습니다.');
        return false;
    }
    
    console.log('유효성 검사 통과, 폼 제출 진행'); // 디버깅용
    // 이 지점에서 폼이 자동으로 제출됩니다.
});

// 목적지 카드 클릭 (검색 폼 자동 입력)
document.querySelectorAll('.destination-card').forEach(card => {
    card.addEventListener('click', function() {
        const destinationName = this.querySelector('.destination-name').textContent;
        
        // 목적지에 따라 도착지 자동 설정
        const arrivalSelect = document.getElementById('arrivalCity');
        if (destinationName.includes('도쿄')) {
            arrivalSelect.value = 'NRT';
        } else if (destinationName.includes('파리')) {
            arrivalSelect.value = 'CDG';
        } else if (destinationName.includes('뉴욕')) {
            arrivalSelect.value = 'JFK';
        } else if (destinationName.includes('방콕')) {
            arrivalSelect.value = 'BKK';
        } else if (destinationName.includes('런던')) {
            arrivalSelect.value = 'LHR';
        }
        
        // 출발지를 서울로 자동 설정
        document.getElementById('departureCity').value = 'ICN';
        
        // 검색 폼 영역으로 스크롤
        document.querySelector('.search-container').scrollIntoView({ 
            behavior: 'smooth' 
        });
    });
});

// 스크롤 버튼 기능
const scrollBtn = document.getElementById("scrollTopBtn");

window.addEventListener("scroll", () => {
    if (window.scrollY > 300) {
        scrollBtn.style.display = "block";
    } else {
        scrollBtn.style.display = "none";
    }
});

scrollBtn.addEventListener("click", () => {
    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });
});

