# flutter_load_database_demo

A new Flutter project.

참고 링크
https://firebase.google.com/docs/storage/web/download-files?hl=ko

import 'package:firebase_storage/firebase_storage.dart';

### 이미지 로드 과정
1. Firestorage.instance로 객체 생성
2. 저장소 위치(gs로시작) 또는 url(액세스 토큰 클릭 시 http로시작하는 주소 나옴) 파악.
3. 위에 주소를 가지고 refFromUrl() 또는 ref().child() 둘 중 하나로 레퍼런스 생성(파이어스토리지는 이 레퍼런스를 통해야만 데이터에 접근 가능)
4. 레퍼런스에 getData() 적용. getData의 반환값은 Uint8List. Uint8List객체가 생성됨.
5. 이렇게 생성된 객체를 return하면 밑에 builder에서 snapshot으로 받는듯?
5. 객체가 생성되었다 = 메모리에 올라가있다. 그래서 Image.memmory()함수로 이미지 띄우는듯.

### 발생한 오류
1. ClientException: XMLHttpRequest error., 
firestore의 CORS설정에 의해 발생한 오류. 상단 링크를 통해 해결 가능.<br>
구체적인 스텝<br>
cors 구성 항목에서 본문에 보이는 링크를 타고 들어간다.<br>
링크를 타고 들어가면 설치 안내가 나오는데, 설치하지말고 상단바의 터미널에 들어간다.<br>
에디터를 오픈하면 새 탭에 cloud shell editor가 나올 것이다.<br>
명령쉘에 edit cors.json 입력<br>
첫 링크에서 보이는 json코드를 입력<br>
저장 후 gsutil cors set cors.json 스토리지링크(gs로시작함)<br>
이미지 접근됨<br>