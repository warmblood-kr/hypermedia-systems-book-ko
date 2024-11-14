#import "lib/definitions.typ": *

== 결론

우리는 하이퍼미디어가 "구식" 기술이거나 "문서", 즉 링크와 텍스트, 이미지만을 위한 기술이 아닌, 실제로 _애플리케이션_을 구축하기 위한 강력한 기술이라고 여러분을 설득했기를 바랍니다. 이 책에서 여러분은 하이퍼미디어를 핵심 애플리케이션 기술로 사용하여 htmx를 활용한 웹 및 Hyperview를 사용한 모바일 애플리케이션 모두에 대해 정교한 사용자 인터페이스를 구축하는 방법을 보았습니다.

많은 웹 개발자들은 "일반" HTML의 링크와 양식을 덜 세련된 시대의 지나간 도구로 봅니다. 어느 정도 그들은 맞습니다: 초기 웹에는 확실한 사용성 문제가 있었습니다. 그러나 이제 HTML의 핵심 한계를 해결하는 JavaScript 라이브러리가 생겼습니다.

예를 들어, htmx는 우리가 다음과 같은 작업을 할 수 있게 해 주었습니다:
- 어떤 요소라도 HTTP 요청을 발행할 수 있게 하기
- 어떤 이벤트라도 HTTP 이벤트를 트리거할 수 있게 하기
- 사용 가능한 모든 HTTP 메서드 유형 사용하기
- DOM의 어떤 요소도 교체 대상으로 삼기

이를 통해 우리는 연락처 앱에 대해 많은 개발자들이 상당량의 클라이언트 측 JavaScript가 필요할 것이라고 가정할 사용자 인터페이스를 구축할 수 있었고, 하이퍼미디어 개념을 사용하여 이를 실현했습니다.

하이퍼미디어 주도 애플리케이션 접근 방식이 모든 애플리케이션에 적합한 것은 아닙니다. 그러나많은 애플리케이션에 대해 하이퍼미디어의 증가된 유연성과 단순성은 큰 이점이 될 수 있습니다. 여러분의 애플리케이션이 이 접근 방식의 이점을 누리지 못하더라도, 이 접근 방식의 장점과 단점, 그리고 여러분이 사용하는 접근 방식과 어떻게 다른지를 _이해_하는 것이 가치가 있습니다. 초기 웹은 역사상 어떤 분산 시스템보다도 더 빨리 성장했으며, 웹 개발자들은 그 성장을 가능케 한 기본 기술의 힘을 활용하는 방법을 알아야 합니다.

=== 잠시 멈추고 반성하기 <_pausing_and_reflecting>
JavaScript 커뮤니티와, 그에 따라 웹 개발 커뮤니티는 유명하게 혼란스러운 곳으로, 매달, 때로는 매주 새로운 프레임워크와 기술이 등장합니다. 최신 기술을 따라가는 것은 힘들 수 있으며, 동시에 우리가 그 기술을 _따라가지 못하면_ 경력에서 뒤쳐질 것이라는 두려움이 있습니다.

이 두려움은 근거 없는 것이 아닙니다: 기술에 특화된 선택을 잘못하여 경력이 소진된 senior 소프트웨어 엔지니어들이 많이 존재합니다. 웹 개발 세계는 젊으며, 많은 기업들이 "업데이트하지 않은" 나이 많은 개발자보다 젊은 개발자를 선호합니다.

우리는 이러한 산업의 현실을 미화해서는 안 됩니다. 반면, 이러한 현실들이 만들어내는 단점을 무시해서도 안 됩니다. 이는 모두가 "새로운 새로운" 것, 즉 모든 것을 뒤바꿀 최신 기술을 찾는 고압적인 환경을 만듭니다. 이는 여러분의 기술이 모든 것을 바꿀 것이라고 _주장_해야 하는 압박을 만듭니다. 이는 _단순성_보다 _복잡성_을 선호하게 만듭니다. 사람들은 "이것이 너무 복잡한가?"라는 질문을 하는 것을 두려워합니다. 왜냐하면 그것은 "내가 이것을 이해할 만큼 똑똑하지 않다"는 것처럼 들리기 때문입니다.

소프트웨어 산업은, 특히 웹 개발에서, 기존 기술을 이해하고 그 위에서 또는 그 안에서 구축하기보다는 혁신으로 치우치는 경향이 있습니다. 우리는 설립된 아이디어보다는 새로운 천재적 해결책을 찾기 위해 앞을 바라보는 경향이 있습니다. 이는 이해할 수 있습니다: 기술 세계는 필연적으로 미래 지향적인 산업입니다.

그러나 반대로 --- 로이 필딩의 REST 공식화를 보았듯이 --- 초기 웹 설계자들 중 일부는 간과된 훌륭한 아이디어를 가지고 있었습니다. 우리는 하이퍼미디어가 "새로운 새로운" 아이디어로 들어왔다가 사라진 것을 본 세대입니다. REST와 같은 강력한 아이디어가 산업에 의해 이렇게 간단히 버려지는 모습을 보는 것은 다소 충격적이었습니다. 다행히도 이러한 개념은 여전히 그 자리에 있으며, 재발견되고 재충전되기를 기다리고 있습니다. 웹의 초기 RESTful 아키텍처는 새로운 시각으로 바라보았을 때, 오늘날의 웹 개발자가 직면하고 있는 많은 문제를 다룰 수 있습니다.

어쩌면 마크 트웨인의 조언을 따르듯이, 잠시 멈추고 반성할 때인 것 같습니다. 어쩌면 몇 분간 조용히 시간을 가지고"새로운 새로운" 것의 끊임없는 소용돌이를제쳐두고, 웹이 어디에서 왔는지 다시 한 번 되돌아보고 배우는 것이 좋을 것입니다.

아마도 이제 하이퍼미디어에 기회를 줄 때입니다.