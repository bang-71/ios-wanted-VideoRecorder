# ios-wanted-VideoRecorder
## 팀원: 소현수(쏘롱)

## 역할 분담 및 앱에서 기여한 부분

### 쏘롱
첫번째 화면 구현


## 뷰 구성 정보 및 기능

### 첫번째 페이지 - MainViewController
- 화면 구성
  - TableView를 이용하여 녹화된 영상들을 목록으로 구현
    - 녹화 첫 시작화면을 썸네일로 표시
    - 2개의 열을 가진 가변형 높이의 cell을 가진 레이아웃으로 구성
  
  - ScrollView를 이용하여 Pagination을 구현
    - cell이 화면 마지막도달시 새로운 데이터를 받아오도록 구현
    - PHFetchOptions()옵션중 fetchLimit를 이용하여 한번에 6개의 데이터를 불러들있도록 구현
  - cell 스와이프시 삭제할수 있도록 구현
  - timeString함수로 동영상 duration을 시간형식으로 구현
    
### 프로젝트 후기 및 고찰
    

### 쏘롱
  - 프로젝트 과제 후기
    - 이번프로젝트는 첫번째 화면구성을 맡아 PHAsset의 형식에 대해서 공부를 할수있었다. 
    - Pagination을 구현해보았는데  한가지 아쉬운점이 있다면 스크롤뷰가 마지막셀에 도달햇을때 Indicator가 여러번 호출되어서  한번만 보여주고 싶었지만 이번프로젝트는 시간이 부족하여 구현하지못했는데 따로 공부를 해보야겠다.

