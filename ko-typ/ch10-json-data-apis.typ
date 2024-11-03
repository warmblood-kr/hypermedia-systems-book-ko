#import "lib/definitions.typ": *

== JSON 데이터 API

지금까지 우리는 하이퍼미디어를 사용하여 하이퍼미디어 기반 애플리케이션을 구축하는 데 집중해 왔습니다. 그렇게 하면서 우리는 웹의 고유한 네트워크 아키텍처를 따르고 이를 활용하여, 이 용어의 원래 의미에서 RESTful 시스템을 구축하고 있습니다.

하지만 오늘날 우리가 인정해야 할 것은, 많은 웹 애플리케이션이 종종 이러한 접근법을 사용하여 구축되지 않는다는 것입니다. 대신, 그들은 React와 같은 싱글 페이지 애플리케이션 프론트 엔드 라이브러리를 사용하여 애플리케이션을 구축하고, JSON API를 통해 서버와 상호작용합니다. 이 JSON API는 거의 하이퍼미디어 개념을 사용하지 않습니다. 오히려 JSON API는 단순히 구조화된 도메인 데이터를 클라이언트에 반환하는 _데이터 API_ 경향이 있습니다. 즉, 클라이언트는 데이터를 해석할 수 있어야 합니다: 어떤 엔드포인트가 데이터와 관련이 있는지, 특정 필드를 어떻게 해석해야 하는지 등입니다.

믿거나 말거나, 우리는 _Contact.app_을 위해 API를 만들고 있었습니다.

이것이 혼란스러울 수 있습니다: API? 우리는 방금 HTML을 반환하는 핸들러로 웹 애플리케이션을 만들고 있던 중입니다.

그게 어떻게 API가 되나요?

사실 _Contact.app_은 실제로 API를 제공하고 있습니다. 그것은 하이퍼미디어 클라이언트, 즉 브라우저가 이해하는 _하이퍼미디어_ API일 뿐입니다. 우리는 브라우저가 HTTP를 통해 상호작용할 수 있도록 API를 구축하고 있으며, HTML과 하이퍼미디어의 마법 덕분에 브라우저는 진입점 URL 이외의 하이퍼미디어 API에 대해 아무것도 알 필요가 없습니다: 모든 작업과 표시 정보는 HTML 응답 내에서 독립적으로 제공됩니다.

이렇게 RESTful 웹 애플리케이션을 구축하는 것은 매우 자연스럽고 간단하여, 전혀 API라고 생각하지 않을 수도 있지만, 우리는 이것이 API임을 보장합니다.

=== 하이퍼미디어 API 및 JSON 데이터 API <_hypermedia_apis_json_data_apis>
그래서 우리는 _Contact.app_을 위한 하이퍼미디어 API를 가지고 있습니다. 그럼 _Contact.app_에 데이터 API를 포함해야 할까요?

물론입니다! 하이퍼미디어 API의 존재가 데이터 API를 가질 수 없다는 것을 의미하지는 않습니다. 사실, 이는 전통적인 웹 애플리케이션에서 흔히 발생하는 상황입니다: 사용자가 진입점 URL을 통해 들어가는 "웹 애플리케이션"이 있습니다, 예를 들어 `https://mywebapp.example.com/`. 그리고 또 다른 URL을 통해 접근할 수 있는 별도의 JSON API가 있습니다. 아마도 `https://api.mywebapp.example.com/v1`이 될 것입니다.

이것은 애플리케이션에 대한 하이퍼미디어 인터페이스와 다른 비하이퍼미디어 클라이언트에게 제공하는 데이터 API를 분리하는 합리적인 방법입니다.

하이퍼미디어 API와 함께 데이터 API를 포함하고 싶은 이유는 무엇일까요? 음, _비하이퍼미디어 클라이언트_가 귀하의 애플리케이션과 상호작용하기를 원할 수도 있기 때문입니다.

예를 들어:
- 아마도 Hyperview를 사용하지 않는 모바일 애플리케이션이 있습니다. 그 애플리케이션은 어떻게든 귀하의 서버와 상호작용해야 하며, 기존 HTML API를 사용하는 것은 거의 확실히 부적합할 것입니다! 데이터 API를 통해 시스템에 프로그램 방식으로 접근하고 싶고, JSON이 이에 대한 자연스러운 선택입니다.
- 아마도 정기적으로 시스템과 상호작용해야 하는 자동화 스크립트가 있습니다. 예를 들어, 매일 밤 실행되는 대량 가져오기 작업이 필요하며, 수천 개의 연락처를 가져오거나 동기화해야 합니다. HTML API에 대해 스크립트를 작성할 수 있지만, 불편할 것입니다: 스크립트에서 HTML을 파싱하는 것은 오류가 발생하기 쉽고 지루합니다. 이 사용 사례에 대해 간단한 JSON API를 갖는 것이 더 좋습니다.
- 아마도 귀하의 시스템 데이터와 어떤 식으로든 통합하고자 하는 제3의 클라이언트가 있습니다. 아마도 파트너가 데이터를 매일 밤 동기화하길 원합니다. 대량 가져오기 예제와 마찬가지로, 이것은 HTML 기반 API에겐 좋은 사용 사례가 아니며, 스크립팅에 더 적합한 것을 제공하는 것이 더 의미가 있습니다.

이 모든 사용 사례에 대해 JSON 데이터 API는 말이 됩니다: 각 경우에 API는 하이퍼미디어 클라이언트에 의해 사용되지 않으므로, 하이퍼미디어 API를 HTML 기반으로 제공하는 것이 클라이언트에게 비효율적이고 복잡할 것입니다. 간단한 JSON 데이터 API가 우리가 원하는 것을 충족하며, 항상 그 업무에 맞는 올바른 도구를 사용하는 것을 권장합니다.

#sidebar["뭐라고요!?! HTML를 파싱하길 원하신다고요!?!"][우리가 웹 애플리케이션 구축을 위한 하이퍼미디어 접근 방식을 옹호할 때 온라인 토론에서 종종 겪는 혼란은 사람들이 서버에서 HTML 응답을 파싱한 다음 데이터를 SPA 프레임워크나 모바일 애플리케이션에 덤프해야 한다고 생각하는 것입니다.

이는 물론 어리석은 일입니다.

우리가 의미하는 바는, 클라이언트인 브라우저가 하이퍼미디어 응답 자체를 해석하고 사용자에게 제공하는 하이퍼미디어 API를 사용하는 것을 고려해야 한다는 것입니다. 하이퍼미디어 API는 기존 SPA 접근 방식 위에 간단히 덧붙여져서는 안 됩니다. 효과적으로 소비되기 위해서는 브라우저와 같은 정교한 하이퍼미디어 클라이언트가 필요합니다.

하이퍼미디어를 분리하려고 하는 코드를 작성하고 클라이언트 측 모델에 공급할 데이터처럼 취급하고 있다면, 아마 잘못하고 있는 것입니다.]

==== 하이퍼미디어 API와 데이터 API의 차이 <_differences_between_hypermedia_apis_data_apis>
잠시 우리가 하이퍼미디어 API 외에도 애플리케이션에 대한 데이터 API를 가질 것이라고 가정해 보겠습니다. 이 시점에서 일부 개발자는 왜 두 가지 모두 가져야 하는지 궁금할 수 있습니다. 왜 JSON 데이터 API라는 단일 API를 두고 여러 클라이언트가 이 하나의 API로 통신하지 않도록 해야 합니까?

우리 애플리케이션에 두 종류의 API가 있는 것이 중복이 아니겠습니까?

이것은 합리적인 지적입니다: 필요하다면 웹 애플리케이션에 여러 API를 두는 것을 옹호하며, 예, 이것은 일부 코드의 중복으로 이어질 수 있습니다. 그러나 두 가지 API 유형 모두 각각의 고유한 이점이 있으며, 두 가지 API 유형 모두에 대한 명확한 요구 사항이 있습니다.

이 두 가지 유형의 API를 별도로 지원함으로써 두 가지 유형의 강점을 얻을 수 있으며, 서로 다른 코드 스타일과 인프라 요구 사항을 깔끔하게 분리할 수 있습니다.

JSON API의 필요성과 하이퍼미디어 API의 필요성을 대조해 봅시다:

#align(
  center,
)[#table(
    columns: 2, align: (col, row) => (auto, auto,).at(col), inset: 6pt, [JSON API 필요],
    [하이퍼미디어 API], [시간이 지나도 안정성을 유지해야 합니다: API를 마음대로 변경할 수 없으며, 그렇지 않으면 API를 사용하는 클라이언트가 특정 엔드포인트가 특정 방식으로 작동하기를 기대하며 깨지게 됩니다.], [시간이 지나도 안정성을 유지할 필요가 없습니다: 모든 URL은 HTML 응답을 통해 발견되므로, 하이퍼미디어 API의 형상을 훨씬 더 агрессив하게 변경할 수 있습니다.], [버전 관리가 필요합니다: 첫 번째 점과 관련하여, 주요 변경을 수행할 때, 오래된 API를 사용하는 클라이언트가 계속 작동하도록 API의 버전을 관리해야 합니다.],
    [버전 관리는 문제가 되지 않습니다, 하이퍼미디어 접근 방식의 또 다른 강점입니다.], [비율 제한이 필요합니다: 데이터 API는 종종 귀하의 내부 웹 애플리케이션뿐만 아니라 다른 클라이언트에 의해 사용되므로, 요청은 주로 사용자에 의해 비율 제한되어야 하며, 이는 단일 클라이언트가 시스템을 과부하에 걸리게 하지 않도록 하기 위함입니다.], [비율 제한은 분산 서비스 거부(DDoS) 공격 방지를 넘어서는 것이 그렇게 중요하지 않을 것입니다.], [일반 API여야 합니다: API는 귀하의 웹 애플리케이션뿐만 아니라 _모든_ 클라이언트를 대상으로 하므로, 귀하의 애플리케이션 요구에 의해 주도되는 특수 엔드포인트를 피해야 합니다. 대신 API는 가능한 한 많은 잠재적 클라이언트 요구를 충족시킬 수 있도록 일반적이고 표현력이 있어야 합니다.],
    [API는 귀하의 애플리케이션 요구에 _매우 구체적_일 수 있습니다: 특정 웹 애플리케이션만을 위해 설계되었기 때문에, 하이퍼미디어를 통해 발견되므로, 특정 기능이나 최적화 요구에 대해 매우 조정된 엔드포인트를 추가하고 제거할 수 있습니다.], [이러한 유형의 API의 인증은 일반적으로 토큰 기반이며, 후에 더 자세히 논의할 것입니다.], [인증은 일반적으로 로그인 페이지에서 설정된 세션 Cookie를 통해 관리됩니다.],
  )]

이 두 가지 유형의 API는 서로 다른 강점과 필요가 있으므로, 둘 다 사용하는 것이 합리적입니다. 하이퍼미디어 접근 방식은 귀하의 웹 애플리케이션에 사용할 수 있으며, 애플리케이션의 "형상"에 맞게 API를 전문화할 수 있습니다. 데이터 API 접근 방식은 모바일, 통합 파트너와 같은 다른 비하이퍼미디어 클라이언트를 위해 사용할 수 있습니다.

이 두 API를 분리함으로써 애플리케이션 요구를 충족하기 위해 일반 데이터 API를 지속적으로 변경해야 하는 압력을 줄일 수 있습니다. 귀하의 데이터 API는 새로운 기능이 추가될 때마다 새로운 버전이 요구되는 대신 안정성과 신뢰성을 유지하는 데 집중할 수 있습니다.

이것이 데이터 API와 하이퍼미디어 API를 분리하는 주요 이점입니다.

#sidebar[JSON 데이터 API와 JSON "REST" API][
  #index[REST API]
  불행히도 오늘날 역사적 이유로 인해 우리가 JSON 데이터 API라고 부르는 것들은 종종 업계에서 "REST API"라고 불립니다. 이는 아이러니한 일입니다. 왜냐하면 로이 필딩의 REST의 정의에 대한 합리적인 해석에 따르면, 대다수의 JSON API는 _RESTful_하지 않습니다. 가까운 일도 아닙니다.

  #blockquote(
    attribution: [로이 필딩,
      https:\/\/roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven],
  )[
    HTTP 기반 인터페이스를 REST API라고 부르는 사람들의 수에 매우 실망스럽습니다. 오늘의 예제는 SocialSite REST API입니다. 그것은 RPC입니다. RPC라고 외치고 있습니다. 그것은 너무 많은 결합을 보여주기 때문입니다. 그것은 X 등급을 받아야 합니다.

    하이퍼텍스트가 제약이라는 개념을 분명히 하기 위해 REST 아키텍처 스타일을 위해 무엇이 필요할까요? 다시 말해, 만약 애플리케이션 상태의 엔진(그리고 따라서 API)이 하이퍼텍스트에 의해 구동되지 않는다면, 그것은 RESTful이 아니며 REST API가 아닙니다. 기한입니다. 어딘가에 문제가 있는 매뉴얼이 있나요?
  ]

  "REST API"가 업계에서 "JSON API"를 의미하게 된 이야기는 길고 복잡하며, 이 책의 범위를 넘어선 이야기입니다. 그러나 관심이 있으시다면, 이 책 저자 중 한 명이 쓴 "REST가 REST의 반대를 의미하게 된 이유"라는 에세이를 참고하실 수 있습니다. #link(
    "https://htmx.org/essays/how-did-rest-come-to-mean-the-opposite-of-rest/",
  )[htmx 웹사이트].

  이 책에서는 이러한 JSON API를 설명하기 위해 "데이터 API"라는 용어를 사용하며, 많은 사람들이 업계에서 이러한 API를 "REST API"라고 계속 부를 것임을 인정합니다.
]

=== Contact.app에 JSON 데이터 API 추가하기 <_adding_a_json_data_api_to_contact_app>
좋습니다. 애플리케이션에 JSON 데이터 API를 추가하려면 어떻게 해야 할까요? 하나의 접근 방식은 Ruby on Rails 웹 프레임워크에 의해 대중화된 방법으로, 하이퍼미디어 애플리케이션과 동일한 URL 엔드포인트를 사용하지만 클라이언트가 JSON 표현을 원하는지 HTML 표현을 원하는지 결정하기 위해 HTTP `Accept` 헤더를 사용하는 것입니다. HTTP `Accept` 헤더는 클라이언트가 서버에서 어떤 종류의 다목적 인터넷 메일 확장자(MIME) 유형, 즉 파일 유형을 원하는지를 지정할 수 있게 해줍니다: JSON, HTML, 텍스트 등입니다.

즉, 클라이언트가 모든 연락처의 JSON 표현을 원한다면 다음과 같은 `GET` 요청을 보낼 수 있습니다:

#figure(
  caption: [모든 연락처의 JSON 표현 요청],
)[ ```http
Accept: application/json

GET /contacts
``` ]

이 패턴을 채택하면 `/contacts/`에 대한 요청 핸들러를 업데이트하여 이 헤더를 검사하고, 값에 따라 연락처에 대한 JSON 대신 HTML 표현을 반환하도록 해야 합니다. Ruby on Rails는 이 패턴에 대한 지원이 기본적으로 내장되어 있어, 요청된 MIME 유형에 따라 쉽게 전환할 수 있습니다.

불행히도, 이러한 패턴에 대한 우리의 경험은 그리 좋지 않았습니다. 앞서 설명한 데이터 API와 하이퍼미디어 API 간의 차이를 고려할 때, 이들은 서로 다른 필요성을 가지고 있으며, 종종 매우 다른 "형상"을 갖게 되며, 이를 동일한 URL 세트로 통합하려고 하면 애플리케이션 코드에서 많은 긴장이 발생하게 됩니다.

따라서 두 API의 다양한 필요성과 이러한 API multiplex 관리 경험을 고려하여, 두 API를 분리하고 JSON 데이터 API를 자신의 URL 세트로 분리하는 것이 올바른 선택이라고 생각합니다. 이를 통해 우리는 두 API를 서로 독립적으로 발전시킬 수 있게 되고, 각 API의 고유한 강점에 맞게 개선할 공간을 확보할 수 있습니다.

==== API의 루트 URL 선택하기 <_picking_a_root_url_for_our_api>
JSON 데이터 API 경로를 일반 하이퍼미디어 경로에서 분리할 것이므로, 어디에 두어야 할까요? 여기서 중요한 고려 사항은 우리가 선택하는 패턴과 관계없이 API의 버전을 깔끔하게 관리할 수 있도록 해야 한다는 것입니다.

주위를 살펴보면, 많은 장소에서 `https://api.mywebapp.example.com`과 같은 API에 대한 하위 도메인을 사용하며, 실제로 종종 하위 도메인에 버전을 인코딩합니다:
`https://v1.api.mywebapp.example.com`.

이는 대기업에는 합리적이지만, 우리처럼 modest한 Contact.app에는 과도한 듯합니다. 로컬 개발을 위해 하위 도메인 대신 기존 애플리케이션 내의 하위 경로를 사용할 것입니다:
- `/api`를 데이터 API 기능의 루트로 사용할 것입니다.
- `/api/v1`를 데이터 API 버전 1의 진입점으로 사용할 것입니다.

API 버전을 증가시키기로 결정하면 `/api/v2`로 이동할 수 있습니다.

물론 이 접근 방식이 완벽하지는 않지만, 우리의 간단한 애플리케이션에는 이 방식이 충분히 작동하며, 언젠가는 연락처 애플리케이션이 인터넷을 점령하고 큰 API 개발 팀을 고용할 수 있게 될 때 하위 도메인 접근 방식이나 기타 다양한 방법으로 조정할 수 있습니다. :)

==== 첫 번째 JSON 엔드포인트: 모든 연락처 나열하기

#index[데이터 API][엔드포인트]
#index[JSON][엔드포인트]
첫 번째 데이터 API 엔드포인트를 추가해 보겠습니다. 이 엔드포인트는 `/api/v1/contacts`에 대한 HTTP `GET` 요청을 처리하며, 시스템의 모든 연락처를 JSON 목록으로 반환합니다. 어떤 면에서는 하이퍼미디어 경로 `/contacts`에 대한 초기 코드와 꽤 유사하게 보일 것입니다: 우리는 연락처 데이터베이스에서 모든 연락처를 로드한 후, 어떤 텍스트를 응답으로 렌더링합니다.

우리는 또한 Flask의 멋진 기능을 활용할 것입니다: 핸들러에서 객체를 반환하면 해당 객체가 JSON 응답으로 직렬화(즉, 변환)됩니다. 이를 통해 Flask에서 간단한 JSON API를 만드는 것이 매우 용이해집니다!

#figure(caption: [모든 연락처를 반환하는 JSON 데이터 API])[ ```python
@app.route("/api/v1/contacts", methods=["GET"]) <1>
def json_contacts():
    contacts_set = Contact.all()
    contacts_dicts = [c.__dict__ for c in contacts_set] <2>
    return {"contacts": contacts_dicts} <3>
``` ]
1. JSON API는 `/api`로 시작하는 자체 경로를 사용합니다.
2. 연락처 배열을 간단한 사전(맵) 객체 배열로 변환합니다.
3. 모든 연락처의 `contacts` 속성을 포함하는 사전을 반환합니다.

이 Python 코드는 파이썬 개발자가 아니라면 다소 생소하게 느껴질 수 있지만, 우리가 하는 것은 연락처를 간단한 이름/값 쌍 배열로 변환하고, 그 배열을 `contacts` 속성으로 감싸진 객체로 반환하는 것뿐입니다.
이 객체는 Flask에 의해 자동으로 JSON 응답으로 직렬화됩니다.

이제 이를 설정해 두면, `/api/v1/contacts`에 HTTP `GET` 요청을 보내면 다음과 같은 응답이 표시됩니다:

#figure(caption: [우리 API의 샘플 데이터])[ ```json
{
  "contacts": [
    {
      "email": "carson@example.com",
      "errors": {},
      "first": "Carson",
      "id": 2,
      "last": "Gross",
      "phone": "123-456-7890"
    },
    {
      "email": "joe@example2.com",
      "errors": {},
      "first": "",
      "id": 3,
      "last": "",
      "phone": ""
    },
    ...
  ]
}
``` ]

이처럼 우리는 이제 HTTP 요청을 통해 연락처의 상대적으로 간단한 JSON 표현을 얻을 수 있는 방법을 갖추게 되었습니다. 완벽하진 않지만, 좋은 출발입니다. 기본적인 자동화 스크립트를 작성하기에 충분히 좋습니다. 예를 들어, 이 데이터 API를 사용하여:
- 연락처를 다른 시스템으로 매일 이동하기
- 연락처를 로컬 파일로 백업하기
- 연락처에 대한 이메일 발송 자동화하기

이 작은 JSON 데이터 API는 기존 하이퍼미디어 API로 달성하기에는 더 복잡해지는 많은 자동화 가능성을 열어줍니다.

==== 연락처 추가하기

다음으로 이동할 기능은 새 연락처를 추가하는 기능입니다. 이번에도 우리의 코드는 일반 웹 애플리케이션을 위해 쓴 코드와 몇 가지 면에서 유사할 것입니다. 그러나 여기서는 JSON API와 하이퍼미디어 API가 분명히 발달하는 것을 볼 수 있습니다.

웹 애플리케이션에서는 새 연락처를 만드는 HTML 폼을 호스팅하기 위해 별도의 경로 `/contacts/new`가 필요했습니다. 우리는 일관성을 유지하기 위해 같은 경로에 `POST` 요청을 보내기로 결정했습니다.

JSON API인 경우에는 그러한 경로가 필요하지 않습니다: JSON API는 "그냥 존재"합니다: 새 연락처를 만들기 위한 하이퍼미디어 표현을 제공할 필요가 없습니다. 당신은 단순히 연락처를 만들기 위해 `POST`를 보내야 할 위치를 알고 있을 것입니다 - 아마도 API에 대한 문서화된 설명을 통해 - 그리고 그게 전부입니다.

그래서 우리는 "생성" 핸들러를 "목록" 핸들러와 동일한 경로인 `/api/v1/contacts`에 두고, 오로지 HTTP `POST` 요청에만 응답하도록 설정할 수 있습니다.

여기 코드처럼 상대적으로 간단합니다: `POST` 요청의 정보로 새 연락처를 채워주고, 이를 저장하려고 시도하고, 만약 성공하지 않으면 오류 메시지를 표시합니다. 다음은 코드입니다:

#figure(
  caption: [JSON API로 연락처 추가하기],
)[ ```python
@app.route("/api/v1/contacts", methods=["POST"]) <1>
def json_contacts_new():
    c = Contact(None,
      request.form.get('first_name'),
      request.form.get('last_name'),
      request.form.get('phone'),
      request.form.get('email')) <2>
    if c.save(): <3>
        return c.__dict__
    else:
        return {"errors": c.errors}, 400 <4>
``` ]
1. 이 핸들러는 JSON API를 위한 첫 번째 핸들러와 동일한 경로에 있지만, `POST` 요청을 처리합니다.
2. 요청에 제출된 값을 기반으로 새 연락처를 생성합니다.
3. 연락처를 저장하려고 시도하고, 성공할 경우 JSON 객체로 렌더링합니다.
4. 저장이 성공하지 않으면 오류를 보여주는 객체를 렌더링하고, 응답 코드는 `400 (Bad Request)`입니다.

어떤 측면에서 이것은 웹 애플리케이션의 `contacts_new()` 핸들러와 유사합니다; 우리는 연락처를 생성하고 저장을 시도하고 있습니다. 그러나 다르게도:
- 성공적인 생성 시 리디렉션이 발생하지 않으며, 하이퍼미디어 클라이언트인 브라우저와 관련이 없기 때문입니다.
- 잘못된 요청의 경우, 우리는 단순히 오류 응답 코드인 `400 (Bad Request)`를 반환합니다. 이는 웹 애플리케이션과는 대비되는 모습으로, 우리는 오류 메시지가 포함된 양식을 다시 렌더링합니다.

이러한 차이점들은 시간이 지남에 따라 쌓이고, JSON과 하이퍼미디어 API를 동일한 URL 집합으로 유지하는 아이디어가 점점 덜 매력적이게 만듭니다.

==== 연락처 세부 정보 보기 <_viewing_contact_details>
다음으로, JSON API 클라이언트가 단일 연락처의 세부 정보를 다운로드할 수 있도록 만들겠습니다. 우리는 당연히 이 기능에 HTTP `GET`을 사용할 것이며, 일반 웹 애플리케이션에서 설정한 규칙을 따르며 경로를 `/api/v1/contacts/<contact id>`로 설정할 것입니다. 예를 들어, ID가 `42`인 연락처의 세부 정보를 보려면 `/api/v1/contacts/42`에 대해 HTTP `GET`을 전송하면 됩니다.

이 코드는 상당히 간단합니다:

#figure(caption: [JSON으로 연락처 세부 사항 가져오기])[ ```python
@app.route("/api/v1/contacts/<contact_id>", methods=["GET"]) <1>
def json_contacts_view(contact_id=0):
    contact = Contact.find(contact_id) <2>
    return contact.__dict__ <3>
``` ]
1. 연락처 세부정보를 보기 위한 경로에 새로운 `GET` 경로를 추가합니다.
2. 경로를 통해 전달된 ID로 연락처를 조회합니다.
3. 연락처를 딕셔너리로 변환하여 JSON 응답으로 렌더링합니다.

복잡하지 않습니다: 우리는 경로를 통해 제공된 ID로 연락처를 찾고 있습니다. 그런 다음 이를 JSON으로 렌더링합니다. 이 코드의 단순함을 감상해야 합니다!

이제 연락처 업데이트 및 삭제 기능을 추가해 보겠습니다.

==== 연락처 업데이트 및 삭제하기 <_updating_deleting_contacts>
연락처 생성 API 엔드포인트와 마찬가지로, 이 경우에도 제공할 HTML UI가 없으므로 동일한 경로인 `/api/v1/contacts/<contact id>`를 재사용할 수 있습니다. 우리는 연락처 업데이트에는 `PUT` HTTP 메서드를 사용하고, 삭제에는 `DELETE` 메서드를 사용할 것입니다.

업데이트 코드는 생성 핸들러와 거의 동일하게 보일 것이며, 새 연락처를 생성하는 대신 ID로 연락처를 조회하고 해당 필드를 업데이트합니다. 이 점에서 우리는 생성 핸들러와 세부 정보 보기 핸들러의 코드를 결합하고 있는 것입니다.

#figure(
  caption: [JSON API로 연락처 업데이트하기],
)[ ```python
@app.route("/api/v1/contacts/<contact_id>", methods=["PUT"]) <1>
def json_contacts_edit(contact_id):
    c = Contact.find(contact_id) <2>
    c.update(
        request.form['first_name'],
        request.form['last_name'],
        request.form['phone'],
        request.form['email']) <3>
    if c.save(): <4>
        return c.__dict__
    else:
        return {"errors": c.errors}, 400
``` ]
1. 특정 연락처의 URL에서 `PUT` 요청을 처리합니다.
2. 경로를 통해 전달된 ID로 연락처를 조회합니다.
3. 요청에 포함된 값으로 연락처의 데이터를 업데이트합니다.
4. 이 시점부터 로직은 `json_contacts_create()` 핸들러와 동일합니다.

Flask의 내장 기능 덕분에 다시 간단하게 구현할 수 있습니다.

이제 연락처 삭제를 살펴보겠습니다. 이 또한 더욱 간단한데, 업데이트 핸들러와 마찬가지로 ID로 연락처를 찾고, 그 다음 삭제하면 됩니다. 그 시점에서 성공 여부를 나타내는 간단한 JSON 객체를 반환할 수 있습니다.

#figure(caption: [JSON API로 연락처 삭제하기])[ ```python
@app.route("/api/v1/contacts/<contact_id>", methods=["DELETE"]) <1>
def json_contacts_delete(contact_id=0):
    contact = Contact.find(contact_id)
    contact.delete() <2>
    return jsonify({"success": True}) <3>
``` ]
1. 특정 연락처의 URL에서 `DELETE` 요청을 처리합니다.
2. 연락처를 조회하고, 그에 대해 `delete()` 메서드를 호출합니다.
3. 연락처가 성공적으로 삭제되었다는 단순한 JSON 객체를 반환합니다.

이제 우리는 일반 웹 애플리케이션과 함께 독립적으로 발전할 수 있는 간단한 JSON 데이터 API를 갖추었습니다.

==== 추가 데이터 API 고려 사항 <_additional_data_api_considerations>
이제, 생산 준비가 완료된 JSON API를 만들기 위해서는 보다 많은 작업을 해야 합니다. 최소한 추가해야 할 요소들은:
- 비율 제한: 모든 공개 데이터 API에 중요하며 악의적인 클라이언트를 방지하기 위해 필수적입니다.
- 인증 메커니즘: (우리는 웹 애플리케이션에도 이를 설정하지 않았습니다!)
- 연락처 데이터의 페이지네이션 지원.
- 누군가 존재하지 않는 연락처 ID로 요청을 보낼 경우 `404 (Not Found)` 응답을 적절히 렌더링하는 것과 같은 여러 작은 항목.

이러한 주제들은 이 책의 범위를 넘어가지만, 우리는 인증에 특별히 집중하여 하이퍼미디어 API와 JSON API 간의 차이를 보여주고자 합니다. 애플리케이션을 안전하게 보호하기 위해 우리는 _인증_을 추가해야 하며, 이는 요청의 출처를 결정하는 방법이며, _인가_는 요청을 수행할 권리가 있는지를 판단하는 것입니다.

여기서는 인가를 잠시 제쳐두고 인증만 고려하겠습니다.

===== 웹 애플리케이션의 인증

#index[authentication]
HTML 웹 애플리케이션 세계에서 인증은 전통적으로 사용자에게 사용자 이름(종종 이메일)과 비밀번호를 요청하는 로그인 페이지를 통해 이루어졌습니다. 이 비밀번호는 사용자 확인을 위해 (해시된) 비밀번호의 데이터베이스와 비교됩니다. 비밀번호가 올바르면 _세션 쿠키_가 설정되어 사용자가 누구인지 표시합니다. 이 쿠키는 사용자가 웹 애플리케이션에 대해 보내는 모든 요청과 함께 전송되어, 애플리케이션이 특정 요청을 수행하는 사용자가 누구인지 알 수 있도록 합니다.

#sidebar[HTTP 쿠키][
  #index[HTTP][cookies]
  HTTP 쿠키는 HTTP의 다소 이상한 기능입니다. 어떤 면에서는 상태가 없는 것을 유지하는 목표를 위반하게 되며, 이는 RESTful 아키텍처의 주요 구성 요소입니다: 서버가 종종 사용자에 의해 수행된 마지막 작업에 대한 상태를 유지하는 캐시와 같은 "측면"에서 상태를 보존하기 위해 세션 쿠키를 사용합니다.
]

그럼에도 불구하고 쿠키는 매우 유용하다는 것이 입증되었으며, 사람들은 이러한 측면에 대해 크게 불만을 제기하지 않습니다 (우리는 여기에서 다른 옵션이 무엇인지 알 수 없습니다!) 웹 개발에서 상대적으로 바람직한 실용주의의 흥미로운 예입니다.

표준 웹 애플리케이션 인증 방식과 비교할 때, JSON API는 일반적으로 어떤 형태의 _토큰 기반_ 인증을 사용합니다: 인증 토큰은 OAuth와 같은 메커니즘을 통해 설정되며, 이후 이 인증 토큰은 클라이언트가 보내는 각 요청과 함께, 종종 HTTP 헤더로 전달됩니다.

높은 수준에서 이 과정은 일반 웹 애플리케이션 인증에서 발생하는 일과 유사합니다: 어떤 식으로든 토큰이 설정되고 그 이후 모든 요청의 일부로 포함됩니다. 하지만 실제로는 메커니즘이 매우 다르게 진행됩니다:
- 쿠키는 HTTP 사양의 일부이며 HTTP 서버에 의해 쉽게 _설정_될 수 있습니다.
- 이에 반해, JSON 인증 토큰은 종종 OAuth와 같은 정교한 교환 메커니즘이 필요합니다.

인증을 설정하는 이러한 상이한 메커니즘은 우리의 JSON 및 하이퍼미디어 API를 분리해야 할 또 다른 좋은 이유입니다.

==== 우리의 두 API의 "형상" <_the_shape_of_our_two_apis>
우리가 API를 구축할 때, 우리는 많은 경우 JSON API가 하이퍼미디어 API보다 필요한 엔드포인트가 적다는 것을 알게 되었습니다: 예를 들어, 연락처를 만드는 하이퍼미디어 표현을 제공하기 위해 `/contacts/new` 핸들러가 필요하지 않았습니다.

하이퍼미디어 API에서 고려해야 할 또 다른 측면은 우리가 성능 향상을 이루었다는 것입니다: 총 연락처 수를 별도의 엔드포인트로 분리하고, 애플리케이션의 인식된 성능을 개선하기 위해 "지연 로드" 패턴을 구현했습니다.

이제 하이퍼미디어 API와 JSON API가 동일한 경로를 공유한다면, 이 API를 JSON 엔드포인트로 게시하고 싶을까요?

아마도, 하지만 아닐 수도 있습니다. 이것은 웹 애플리케이션을 위해 매우 구체적인 필요였으며, JSON API 사용자의 요청이 없다면 JSON 소비자에게 포함시키는 것이 합리적이지 않습니다.

그럼 만약 어떤 기적적인 이유로 `Contact.count()`와 관련된 성능 문제가 사라진다면 어떻게 될까요? 
하이퍼미디어 기반 애플리케이션에서는 이전 코드로 간단히 revert하고 요청에 `contacts`를 직접 포함시킬 수 있습니다. `contacts/count` 엔드포인트 및 모든 관련 로직을 제거할 수 있습니다. 하이퍼미디어의 균일한 인터페이스 덕분에 시스템은 여전히 잘 작동할 것입니다.

하지만 만약 JSON API와 하이퍼미디어 API를 연결하고 `/contacts/count`를 JSON API에 대한 지원되는 엔드포인트로 게시했다면? 이 경우, 우리는 엔드포인트를 단순히 제거할 수 없게 됩니다: (비하이퍼미디어) 클라이언트가 그것을 신뢰하고 있을 수 있기 때문입니다.

다시 한번, 하이퍼미디어 접근 방식의 유연성을 보여주며, JSON API를 하이퍼미디어 API에서 분리하면 그 유연성을 최대한 활용할 수 있음을 알 수 있습니다.

==== 모델-뷰-컨트롤러(MVC) 패러다임 <_the_model_view_controller_mvc_paradigm>
우리가 JSON API에 대한 핸들러들을 구축하면서 주목할 만한 점은, 이들이 상대적으로 간단하고 규칙적이라는 것입니다. 데이터 업데이트 등의 대부분의 어려운 작업은 연락처 모델 내에서 수행됩니다: 핸들러는 HTTP 요청과 모델 사이의 간단한 연결 역할을 합니다.

이는 초기 웹에서 아주 인기를 끈 모델-뷰-컨트롤러(MVC) 패러다임의 이상적인 컨트롤러를 의미합니다: 컨트롤러는 "얇아야" 하며, 모델이 시스템의 대부분의 로직을 포함해야 합니다.

#sidebar[모델-뷰-컨트롤러 패턴][
  #index[모델-뷰-컨트롤러(MVC)]
  모델-뷰-컨트롤러 디자인 패턴은 소프트웨어 개발의 고전적인 아키텍처 패턴이며, 초기 웹 개발에 큰 영향을 미쳤습니다. 이는 더 이상 웹 개발이 프론트엔드와 백엔드로 분리되어 강하게 강조되지는 않지만, 대부분의 웹 개발자는 여전히 이 개념에 익숙합니다.

  전통적으로 MVC 패턴은 웹 개발에서 다음과 같이 매핑되었습니다:

  - 모델 - 특정 도메인에 대해 애플리케이션이 설계된 모든 로직과 규칙을 구현하는 "도메인" 클래스의 모음. 모델은 일반적으로 클라이언트에게 HTML "표현"으로 제공되는 "리소스"를 제공합니다.

  - 뷰 - 일반적으로 뷰는 어떤 형태의 클라이언트 측 템플릿 시스템이었으며, 특정 모델 인스턴스에 대해 위에서 언급한 HTML 표현을 렌더링합니다.

  - 컨트롤러 - 컨트롤러의 작업은 HTTP 요청을 수신하여 이를 모델에 대한 합리적인 요청으로 변환하고, 해당 요청을 적절한 모델 객체로 전달하는 것입니다. 그런 다음 클라이언트에게 HTML 표현을 HTTP 응답으로 전달합니다.
]

얇은 컨트롤러는 JSON 및 하이퍼미디어 API를 분리하기 쉽게 해 줍니다. 왜냐하면 모든 중요 로직이 두 API에서 공유되는 도메인 모델 내에서 관리되기 때문입니다. 이를 통해 두 API를 독립적으로 발전시키면서도 서로의 로직을 동기화할 수 있습니다.

적절하게 구축된 "얇은" 컨트롤러와 "두꺼운" 모델을 가지고, 두 개의 별도 API를 동기화되고 독립적으로 발전시키는 것은 그렇게 어렵거나 미친 것처럼 보이지 않습니다.

#html-note[#indexed[마이크로포맷]][
#link("https://microformats.org/")[마이크로포맷]은 HTML에서 기계 판독 가능한 구조화된 데이터를 삽입하는 표준입니다. 이는 특정 요소를 추출할 정보를 포함하는 것으로 표시하기 위해 클래스를 사용하며, 이름, URL, 사진과 같은 보편적인 속성을 가져오는 데 필요한 관례를 가지고 있습니다. 객체의 HTML 표현에 이러한 클래스를 추가함으로써, 우리는 해당 객체에 대한 속성을 HTML에서 복원할 수 있도록 허용합니다. 예를 들어, 다음과 같은 간단한 HTML:

#figure(
```html
<a class="h-card" href="https://john.example">
  <img src="john.jpg" alt=""> John Doe
</a>
```)

마이크로포맷 파서에 의해 다음과 같은 JSON 유사 구조로 파싱될 수 있습니다:

#figure(
```json
{
  "type": ["h-card"],
  "properties": {
    "name": ["John Doe"],
    "photo": ["john.jpg"],
    "url": ["https://john.example"]
  }
}
```)

다양한 속성과 중첩 객체를 사용하여 기계 판독 가능한 방식으로 연락처에 대한 모든 정보를 마크업할 수 있습니다.

앞서 설명한 대로 인간과 기계 간의 상호작용을 위해 동일한 메커니즘을 사용하는 것은 좋은 아이디어가 아닙니다. 인간에게 노출되는 인터페이스와 기계에 노출되는 인터페이스는 서로에 의해 제한될 수 있습니다. 도메인 특정 데이터를 사용자와 개발자에게 노출하려면 JSON API가 훌륭한 옵션입니다.

그러나 마이크로포맷은 훨씬 더 쉽게 채택할 수 있습니다. 웹사이트가 JSON API를 구현해야 한다는 프로토콜이나 표준은 높은 기술 장벽을 갖습니다. 이에 비해, 마이크로포맷은 몇 개의 클래스를 추가하는 것으로 웹사이트를 쉽게 확장할 수 있습니다. Open Graph와 같은 다른 HTML 내장 데이터 형식 또한 비슷하게 채택하기 쉽습니다. 이러한 이유로, 마이크로포맷은 #link("https://indieweb.org")[인디웹]과 같은 웹사이트 간 시스템에 유용하게 사용됩니다.
]
