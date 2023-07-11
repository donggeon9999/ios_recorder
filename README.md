# ios_recorder
## ios audio recorder 

- https://github.com/AshvinGudaliya/AudioRecorder 해당 프로젝트를 참조하여 수정하였음

- the simplest audio recording API in iOS 인 AVAudioRecorder를 이용.
(https://developer.apple.com/documentation/avfaudio/avaudiorecorder)

- Source 파일의 AGAudioRecorder class의 setupRecorder() 함수에서 해당 recorder의 setting 값을 직접 변경하여 실험(16000 Sample Rate, 4 channel) 
 ![스크린샷 2023-07-11 오후 2 04 03](https://github.com/donggeon9999/ios_recorder/assets/75352014/57fa15d7-dbef-4c0b-9e6f-9c0b95065064)


- 실시간 각 채널 별 음성 변화 값을 좌측 상단에 progress bar 로 표현하고자 했으나 아직 구현 x

## 실행 방법
- ready to record를 누르면 녹음 시작. 하지만 초기 실행시 바로 녹음이 되지 않는 경우 발생 -> 해당 경우 reset을 누르고 다시 record 시작하면 정상 작동
- ready to record를 누르면 Recording으로 text가 바뀌는 데 해당 버튼을 다시 누르면 녹음 종료 -> 이후 파일 공유 창 생성

- 녹음 이후 ready to play 버튼을 누르면 녹음된 음성 청취 가능
- Reset button 눌렀을 시 초기화
  
## 초기화면
![IMG_5C70600C9F84-1](https://github.com/donggeon9999/ios_recorder/assets/75352014/508dc833-8d5c-4576-aab7-d49792c16e3c)

## 녹음중

![IMG_A2E057F45045-1](https://github.com/donggeon9999/ios_recorder/assets/75352014/dc45f84c-620c-439d-a3c8-409b3b9088a9)


## 녹음 종료 후 파일 전송

![IMG_6EBBFFD0D170-1](https://github.com/donggeon9999/ios_recorder/assets/75352014/f4c41215-62c4-4432-a47f-d77061e3df50)



## 녹음 파일 분석 결과

<img width="1434" alt="스크린샷 2023-07-11 오후 1 58 31" src="https://github.com/donggeon9999/ios_recorder/assets/75352014/f0dd325d-c543-4af7-a4f5-d4a60547d0f4">


4-channel mic로 실험한 결과로 4-channel 각각 오디오가 들어온 것을 확인할 수 있음



