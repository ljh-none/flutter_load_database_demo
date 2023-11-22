# flutter_load_database_demo

A new Flutter project.

참고 링크
https://firebase.google.com/docs/storage/web/download-files?hl=ko

import 'package:firebase_storage/firebase_storage.dart';

### 발생한 오류
1. ClientException: XMLHttpRequest error., 
firestore의 CORS설정에 의해 발생한 오류. 상단 링크를 통해 해결 가능.
구체적인 스텝
cors 구성 항목에서 본문에 보이는 링크를 타고 들어간다.
링크를 타고 들어가면 설치 안내가 나오는데, 설치하지말고 상단바의 터미널에 들어간다.
에디터를 오픈하면 새 탭에 cloud shell editor가 나올 것이다.
명령쉘에 edit cors.json 입력
첫 링크에서 보이는 json코드를 입력
저장 후 gsutil cors set cors.json 스토리지링크(gs로시작함)
이미지 접근됨