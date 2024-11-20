# Hypermedia Systems 한글 번역

[Hypermedia Systems 책](https://github.com/bigskysoftware/hypermedia-systems-book)의 한글 번역본입니다.

원래 저작물은 Creative Commons BY-NC-SA에 의해 배포됩니다. 따라서 이 번역본도 CC-BY-NC-SA에 의해 배포됩니다.

* 현재 번역 상태는, 초벌 번역 수준이기 때문에 지속적으로 번역 업데이트가 될 것입니다.
* 또한, 번역 과정에서 포맷팅이 어긋난 부분들도 있어서, 지속적으로 업데이트가 될 것입니다.
* 지속적 빌드를 통해서 PDF를 만들어내고 있습니다. [Releases](https://github.com/warmblood-kr/hypermedia-systems-book-ko/releases/) 메뉴에서 최신 릴리즈 PDF를 다운로드 받으시면 됩니다.


## TODO

* GPT로 초벌 번역을 진행한 터라, 사람이 한번 검수를 해야 합니다.
* 포맷팅이 깨진 부분들이 있습니다.
* 아직 웹사이트로는 빌드를 하지 못하고 있습니다. 웹사이트도 빌드되도록 작업이 필요합니다.
* 어느 정도 번역이 안정화되어서 빈번하게 수정하는 단계가 지나면, release 기능을 통해서 쉽게 결과물을 볼 수 있도록 하면 좋겠습니다.

업스트림에서 계속 내용 추가/변경이 이루어질 것이기 때문에, 업스트림의 변경사항을 이 저장소에 지속적으로 가져와야 하고, 그때 충돌(conflict)이 없게 하기 위해서, 가급적 한글 컨텐츠가 원문 컨텐츠를 간섭하지 않도록 작업했습니다. 이를테면, 기존의 영문 원문 파일을 그대로 수정하는 대신에, `translations/ko-kr` 디렉토리를 만들어서 그곳에서 작업을 진행했습니다.
