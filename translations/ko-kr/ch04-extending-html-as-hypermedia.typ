#import "lib/definitions.typ": *

== HTML의 하이퍼미디어 확장

이전 장에서는 연락처를 관리하기 위한 간단한 웹 1.0 스타일 하이퍼미디어 애플리케이션을 소개했습니다. 우리의 애플리케이션은 연락처에 대한 일반적인 CRUD 작업과 연락처 검색을 위한 간단한 메커니즘을 지원했습니다. 이 애플리케이션은 오로지 폼과 앵커 태그만을 사용하여 구축되었으며, 이는 서버와 상호작용하는 데 사용되는 전통적인 하이퍼미디어 컨트롤입니다. 애플리케이션은 HTTP를 통해 서버와 하이퍼미디어(HTML)를 교환하며, `GET` 및 `POST` HTTP 요청을 보내고 응답으로 전체 HTML 문서를 받습니다.

기본적인 웹 애플리케이션이지만, 확실히 하이퍼미디어 주도 애플리케이션입니다. 그것은 강력하며 웹의 네이티브 기술을 활용하고, 이해하기 쉽습니다.

이 애플리케이션의 마음에 들지 않는 부분이 무엇일까요?

불행히도, 우리의 애플리케이션에는 웹 1.0 스타일 애플리케이션에 공통적으로 발생하는 몇 가지 문제가 있습니다:
- 사용자 경험 관점에서: 애플리케이션의 페이지를 이동하거나 연락처를 생성, 업데이트 또는 삭제할 때 눈에 띄는 새로 고침이 발생합니다. 이는 모든 사용자 상호작용(링크 클릭 또는 폼 제출)이 전체 페이지 새로 고침을 필요로 하며, 각 작업 후 처리해야 할 새로운 HTML 문서가 필요하기 때문입니다.
- 기술적인 관점에서 모든 업데이트는 `POST` HTTP 메서드로 수행됩니다. 이는 `PUT` 및 `DELETE`와 같은 더 논리적인 작업과 HTTP 요청 유형이 존재하고, 우리가 구현한 일부 작업에 더 적합함에도 불구하고 발생합니다. 결국 자원을 삭제하고 싶다면 HTTP `DELETE` 요청을 사용하는 것이 더 합리적이지 않을까요? 아이러니하게도, 순수 HTML을 사용하면서 우리는 HTML을 위해 특별히 설계된 HTTP의 전체 표현력을 활용할 수 없습니다.

특히 첫 번째 사항은 우리와 같은 웹 1.0 스타일 애플리케이션에서 주목할 만하며, 이는 JavaScript 기반의 더 정교한 단일 페이지 애플리케이션(SPA)과 비교할 때 "투박함"이라는 평판을 주는 원인입니다.

우리는 단일 페이지 애플리케이션 프레임워크를 채택하여 이 문제를 해결하고 서버 측을 업데이트하여 JSON 기반 응답을 제공할 수 있습니다. 단일 페이지 애플리케이션은 웹 페이지를 새로 고침하지 않고 업데이트함으로써 웹 1.0 애플리케이션의 투박함을 없애줍니다. 이들은 전체 페이지를 교체(재렌더링)할 필요 없이 기존 페이지의 문서 객체 모델(DOM)의 일부를 변형할 수 있습니다.

#sidebar[DOM][
  #index[Document Object Model (DOM)]
  DOM은 브라우저가 HTML을 처리할 때 생성하는 내부 모델로, HTML의 태그 및 기타 콘텐츠에 대한 "노드" 트리를 형성합니다. DOM은 하이퍼미디어 없이 페이지의 노드를 직접 업데이트하는 JavaScript API를 제공합니다. 이 API를 사용하면 JavaScript 코드가 새로운 콘텐츠를 삽입하거나 기존 콘텐츠를 제거 또는 업데이트할 수 있으며, 이는 정상적인 브라우저 요청 메커니즘의 사용을 전혀 필요로 하지 않습니다.
]

SPA에는 몇 가지 다른 스타일이 있지만, 1장에서는 오늘날 가장 일반적인 접근 방식이 DOM을 JavaScript 모델에 연결한 후, React나 Vue와 같은 SPA 프레임워크가 JavaScript 모델이 업데이트될 때 DOM을 _반응적으로_ 업데이트하도록 허용하는 것이라고 언급했습니다. 즉, 브라우저 메모리에 로컬로 저장된 JavaScript 객체에 변경을 가하면 웹 페이지가 "마법처럼" 상태를 변경 사항으로 업데이트합니다.

이 스타일의 애플리케이션에서 서버와의 통신은 일반적으로 JSON 데이터 API를 통해 이루어지며, 애플리케이션은 더 나은 사용자 경험을 제공하기 위해 하이퍼미디어의 장점을 포기합니다.

오늘날 많은 웹 개발자들은 이러한 웹 1.0 스타일 애플리케이션의 "구형" 느낌 때문에 하이퍼미디어 접근 방식을 고려하지 않기도 합니다.

이제 언급된 두 번째 기술적 문제는 다소 지루하게 느껴질 수 있으며, 우리는 REST와 주어진 작업에 적합한 HTTP 작업에 대한 대화가 매우 지루해질 수 있다는 것을 인정합니다. 하지만, 순수 HTML을 사용할 때 HTTP의 모든 기능을 사용할 수 없다는 것이 이상합니다!

이상하게 느껴지지 않나요?

=== 하이퍼링크를 자세히 살펴보면 <_a_close_look_at_a_hyperlink>
흥미롭게도 우리는 애플리케이션의 상호작용성을 향상하고 위의 두 가지 문제를 _단일 페이지 애플리케이션 접근 방식에 의존하지 않고_ 해결할 수 있습니다. 이를 위해 우리는 하이퍼미디어 지향 JavaScript 라이브러리인 #link("https://htmx.org")[htmx]를 사용할 수 있습니다. 이 책의 저자들은 htmx를 하이퍼미디어로서 HTML을 확장하고 앞서 언급한 구형 HTML 애플리케이션의 문제를 해결하기 위해 특별히 구축했습니다(그리고 몇 가지 다른 문제도 포함하여).

htmx를 통해 웹 1.0 스타일 애플리케이션의 UX를 개선할 수 있는 방법에 들어가기 전에, 1장에서 하이퍼링크/앵커 태그를 다시 살펴봅시다. 하이퍼링크는 _하이퍼미디어 컨트롤_로 알려져 있으며, 상호작용에 대한 정보를 직접적으로 그리고 완전하게 인코딩하여 서버와의 상호작용을 설명하는 메커니즘입니다.

다시 간단한 #indexed[앵커 태그]를 고려해보면, 브라우저에 의해 해석될 때 이 책의 웹사이트에 대한 #indexed[하이퍼링크]를 생성합니다:

#figure(caption: [단순한 하이퍼링크, 다시 방문하다],
```html
<a href="https://hypermedia.systems/">
  Hypermedia Systems
</a>
```)

이 링크에서 정확히 어떤 일이 발생하는지 분석해보겠습니다:
- 브라우저는 "Hypermedia Systems"라는 텍스트를 화면에 렌더링하며, 클릭할 수 있다는 것을 나타내는 장식으로 보여집니다.
- 그런 다음, 사용자가 텍스트를 클릭하면…​
- 브라우저는 `https://hypermedia.systems`에 HTTP `GET` 요청을 발행합니다…​
- 브라우저는 HTTP 응답의 HTML 본문을 브라우저 창에 로드하게 되어 현재 문서를 대체합니다.

따라서 단순한 하이퍼미디어 링크에는 네 가지 측면이 있으며, 마지막 세 가지 측면은 하이퍼링크를 "일반" 텍스트와 구별하는 메커니즘을 제공합니다. 그리고 결국 이것이 하이퍼미디어 컨트롤을 만듭니다.

이제 하이퍼링크의 마지막 세 가지 측면을 _일반화_할 수 있는 방법에 대해 생각해 봅시다.

==== 왜 앵커와 폼만 있을까요? <_why_only_anchors_forms>
고려해보면: 앵커 태그(및 폼)를 특별하게 만드는 것은 무엇인가요?

왜 다른 요소들도 HTTP 요청을 발행할 수 없나요?

예를 들어, `button` 요소가 HTTP 요청을 발행할 수 없어야 하는 이유는 무엇인가요? 예를 들어, 연락처 삭제를 기능하려면 버튼 주위에 폼 태그를 감싸야 하는 것은 임의적인 것처럼 보입니다.

어쩌면: 다른 요소들도 HTTP 요청을 발행해야 할 것입니다. 어쩌면 다른 요소들도 스스로 하이퍼미디어 컨트롤으로 작용해야 할 것입니다.

이것이 하이퍼미디어로서 HTML을 일반화할 수 있는 첫 번째 기회입니다.

#important[기회 1][
  HTML은 _모든_ 요소가 서버에 요청을 발행하고 하이퍼미디어 컨트롤로 작용할 수 있도록 확장될 수 있습니다.
]

==== 왜 클릭 및 제출 이벤트만 있을까요? <_why_only_click_submit_events>
다음으로, 링크에서 서버에 요청을 발생시키는 이벤트를 고려해보면: 클릭 이벤트입니다.

#index[이벤트][click]
#index[이벤트][submit]
자, 클릭(앵커의 경우)이나 제출(폼의 경우)하는 것의 특별한 점은 무엇일까요? 결국 이들은 DOM에서 발생하는 많은, 많은 이벤트 중 두 가지에 불과합니다. 마우스 다운 또는 키 업, 블러와 같은 이벤트는 모두 HTTP 요청을 발행하기 위해 사용할 수 있는 이벤트입니다.

이러한 다른 이벤트들도 요청을 발행할 수 있어야 하지 않을까요?

이것은 HTML의 표현력을 확장할 두 번째 기회를 제공합니다:

#important[기회 2][
  HTML은 _모든_ 이벤트 --- 하이퍼링크의 경우처럼 클릭만이 아니라 --- HTTP 요청을 발생시키도록 확장될 수 있습니다.
]

==== 왜 오직 GET 및 POST만 있나요? <_why_only_get_post>

#index[HTTP 메서드]
조금 더 기술적인 사고를 진행하면, 앞서 언급한 문제에 도달하게 됩니다: 순수 HTML은 HTTP의 `GET` 및 `POST` 작업에만 접근할 수 있게 해줍니다.

HTTP는 하이퍼텍스트 전송 프로토콜의 약자인데, 명시적으로 설계된 형식인 HTML은 다섯 가지 개발자 대면 요청 유형 중 두 가지만 지원합니다. 나머지 세 가지인 `DELETE`, `PUT` 및 `PATCH`에 접근하려면 JavaScript를 사용하여 AJAX 요청을 해야 합니다.

이 서로 다른 HTTP 요청 유형이 무엇을 나타내기 위해 설계되었는지 다시 살펴보겠습니다:
- `GET`은 URL에서 자원의 표현을 "가져오는" 것에 해당합니다: 이는 순수하게 읽기 작업으로, 자원을 변형하지 않습니다.
- `POST`는 주어진 자원에 엔터티(또는 데이터)를 제출하며, 종종 자원을 생성하거나 변형하여 상태 변화를 유발합니다.
- `PUT`은 주어진 자원에 대한 업데이트 또는 교체를 위해 엔터티(또는 데이터)를 제출하며, 다시 상태 변화를 일으킬 가능성이 큽니다.
- `PATCH`는 `PUT`과 유사하지만 부분 업데이트 및 상태 변화를 암시하며, 엔터티의 전체 교체가 아닌 경우를 처리합니다.
- `DELETE`는 주어진 자원을 삭제합니다.

이러한 작업은 2장에서 논의한 CRUD 작업과 매우 밀접하게 연관됩니다. HTML이 다섯 가지 중 두 가지에만 접근을 허용함으로써 HTTP의 전체 장점을 활용하는 우리의 능력을 제한합니다.

이것은 HTML의 표현력을 확장할 세 번째 기회를 제공합니다:

#important[기회 3][
HTML은 누락된 세 가지 HTTP 메서드인 `PUT`, `PATCH` 및 `DELETE`에 대한 접근을 허용하도록 확장될 수 있습니다.
]

==== 왜 화면 전체를 교체해야만 하나요? <_why_only_replace_the_entire_screen>

#index[transclusion]
#index[DOM][부분 업데이트]
마지막 관찰로, 하이퍼링크의 마지막 측면을 고려해보면: 사용자가 클릭할 때 전체 화면을 교체합니다.

이 기술적 세부 사항은 웹 1.0 애플리케이션에서 사용자 경험이 저조한 주요 원인입니다. 전체 페이지 새로 고침은 스타일이 적용되지 않은 콘텐츠의 깜박임을 유발할 수 있으며, 콘텐츠가 초기 형태에서 스타일이 적용된 최종 형태로 전환될 때 화면에서 "튀어" 나올 수 있습니다. 또한 사용자의 스크롤 상태를 망가뜨려 페이지 상단으로 스크롤되게 하거나, 포커스를 잃어버리게 하는 등의 문제가 발생합니다.

하지만, 사실 생각해보면 하이퍼미디어 교환이 _전체_ 문서를 대체해야 한다는 규칙은 없습니다.

이것은 HTML을 일반화할 네 번째이자 마지막, 그리고 아마도 가장 중요한 기회를 제공합니다:

#important[기회 4][
  HTML은 요청에 대한 응답이 현재 문서의 _일부_ 요소를 대체할 수 있도록 확장될 수 있으며, 전체 문서를 대체할 필요가 없습니다.
]

이것은 사실 하이퍼미디어의 매우 오래된 개념입니다. 1980년 Ted Nelson의 저서 "Literary Machines"에서 _transclusion_이라는 용어를 만들어 이 개념을 포착했습니다: 하이퍼미디어 참조를 통해 존재하는 문서에 콘텐츠를 포함하는 방식입니다. 만약 HTML이 이러한 스타일의 "동적 전송"을 지원한다면, 하이퍼미디어 주도 애플리케이션은 오직 일부 DOM만이 사용자의 상호작용 또는 네트워크 요청에 의해 업데이트되는 단일 페이지 애플리케이션처럼 작동할 수 있습니다.

=== Htmx를 통한 하이퍼미디어로서 HTML 확장 <_extending_html_as_a_hypermedia_with_htmx>
이 네 가지 기회는 HTML을 현재의 능력 이상으로 확장할 수 있는 방법을 제시하지만, 이는 웹의 하이퍼미디어 모델 내에서 _전적으로_ 이루어집니다. HTML, HTTP, 브라우저와 같은 기본적인 사항들은 극적으로 변경되지 않을 것입니다. 오히려 HTML 내에 이미 존재하는 _기존 기능_의 이러한 일반화는 우리가 HTML을 사용하여 _더 많은_ 작업을 수행할 수 있게 해줄 것입니다.

#index[htmx][about]
Htmx는 바로 이러한 방식으로 HTML을 확장하는 JavaScript 라이브러리이며, 이 책의 다음 장들에서 초점이 될 것입니다. 다시 말해, htmx는 하이퍼미디어 지향 접근 방식을 취하는 유일한 JavaScript 라이브러리는 아니지만(다른 훌륭한 예로는
#link("https://unpoly.com")[Unpoly]와
#link("https://hotwire.dev")[Hotwire]가 있지만), 하이퍼미디어로서 HTML을 확장하는 데 있어 가장 순수한 목표를 지니고 있습니다.

==== Htmx 설치 및 사용하기 <_installing_and_using_htmx>
실용적인 "시작하기" 관점에서 htmx는 아주 간단하고 종속성이 없는 독립형 JavaScript 라이브러리입니다. 웹 애플리케이션에 추가하기 위해서는 단순히 `head` 요소에 `script` 태그를 포함시키기만 하면 됩니다.

#index[htmx][installing]
이 간단한 설치 모델 덕분에 공용 CDN과 같은 도구를 사용하여 라이브러리를 설치할 수 있습니다.

아래는 인기 있는 #link("https://unpkg.com")[unpkg] 콘텐츠 배달 네트워크(CDN)를 사용하여 `1.9.2` 버전의 라이브러리를 설치한 예입니다. 우리는 전달된 JavaScript 콘텐츠가 우리가 기대하는 내용과 일치하는지 확인하기 위해 무결성 해시를 사용합니다. 이 SHA는 htmx 웹사이트에서 찾을 수 있습니다.

또한, 스크립트를 `crossorigin="anonymous"`로 표시하여 CDN에 자격 증명이 전송되지 않도록 합니다.

#figure(caption: [htmx 설치],
```html
<head>
<script src="https://unpkg.com/htmx.org@1.9.2"
  integrity="sha384-L6OqL9pRWyyFU3+/bjdSri+iIphTN/
    bvYyM37tICVyOJkWZLpP2vGn6VUEXgzg6h"
  crossorigin="anonymous"></script>
</head>
```)

현대 JavaScript 개발, 복잡한 빌드 시스템 및 대량의 의존성에 익숙하다면, htmx의 설치가 그저 이것으로 끝나서 즐거운 놀라움이 될 수 있습니다.

이는 단순히 스크립트 태그를 포함하고 모든 것이 "그냥 작동"할 수 있었던 초기 웹의 정신을 띱니다.

CDN을 사용하고 싶지 않은 경우, htmx를 로컬 시스템에 다운로드하여 스크립트 태그를 정적 자산을 보관하는 위치로 조정할 수 있습니다. 또는 의존성을 자동으로 설치하는 빌드 시스템이 있을 수도 있습니다. 이 경우 라이브러리의 Node Package Manager(npm) 이름인 `htmx.org`를 사용하여 보통의 방법으로 설치할 수 있습니다.

htmx가 설치된 후에는 즉시 사용을 시작할 수 있습니다.

==== JavaScript 필요 없음…​ <_no_javascript_required>
그리고 여기서 htmx의 흥미로운 부분에 도달합니다: htmx는 htmx의 사용자에게 실제로 JavaScript를 작성할 필요가 없습니다.

#index[htmx][attributes]
대신, 여러분은 HTML의 요소에 직접 배치된 _속성_을 사용하여 더 동적 행동을 유도합니다. Htmx는 하이퍼미디어로서 HTML을 확장하며, 이 확장이 기존 HTML 개념과 최대한 자연스럽고 일관성 있게 느껴지도록 설계되었습니다. 앵커 태그가 가져올 URL을 지정하기 위해 `href` 속성을 사용하는 것처럼, 폼은 제출할 URL을 지정하기 위해 `action` 속성을 사용하고, htmx는 HTTP 요청을 발행할 URL을 지정하기 위해 HTML _속성_을 사용합니다.

=== HTTP 요청 트리거하기 <_triggering_http_requests>

#index[hx-get][about]
#index[hx-post][about]
#index[hx-put][about]
#index[hx-patch][about]
#index[hx-delete][about]
htmx의 첫 번째 기능인 웹 페이지의 모든 요소가 HTTP 요청을 발행할 수 있는 기능을 살펴보겠습니다. 이는 htmx가 제공하는 핵심 기능으로, 다섯 가지 속성으로 구성되어 다섯 가지 개발자 대면 유형의 HTTP 요청을 발행하는 데 사용할 수 있습니다:
- `hx-get` - HTTP `GET` 요청을 발행합니다.
- `hx-post` - HTTP `POST` 요청을 발행합니다.
- `hx-put` - HTTP `PUT` 요청을 발행합니다.
- `hx-patch` - HTTP `PATCH` 요청을 발행합니다.
- `hx-delete` - HTTP `DELETE` 요청을 발행합니다.

이 속성 각각은 요소에 배치될 때, htmx 라이브러리에 "사용자가 이 요소를 클릭(또는 기타 상호 작용시), 지정된 유형의 HTTP 요청을 발행하라"고 지시합니다.

이러한 속성의 값은 앵커 태그의 `href` 및 폼의 `action` 값과 유사합니다: 주어진 HTTP 요청 유형을 발행하고자 하는 URL을 지정합니다. 일반적으로 이는 서버 상대 경로를 통해 이루어집니다.

#index[hx-get][example]
예를 들어, 버튼을 통해 `/contacts`에 `GET` 요청을 발행하고자 한다면, 다음 HTML을 작성합니다:

#figure(caption: [단순한 htmx 기반 버튼],
```html
<button hx-get="/contacts"> <1>
  Get The Contacts
</button>
```)
1. `/contacts`에 HTTP `GET` 요청을 발행하는 단순한 버튼입니다.

htmx 라이브러리는 이 버튼의 `hx-get` 속성을 보고, 사용자가 클릭할 때 `/contacts` 경로로 HTTP `GET` AJAX 요청을 발행하는 JavaScript 로직을 연결합니다.

이해하기 쉽고 HTML의 나머지 부분과 일관성이 있습니다.

==== 모든 것이 그냥 HTML입니다 <_its_all_just_html>

#index[htmx][HTML 기반]
위 버튼을 통해 발행된 요청으로, htmx에 대해 이해해야 할 가장 중요한 점에 도달하는데: 이 AJAX 요청에 대한 응답이 _HTML_이기를 기대합니다. htmx는 HTML의 확장입니다. 앵커 태그와 같은 기본 하이퍼미디어 컨트롤은 일반적으로 생성하는 HTTP 요청에 대한 HTML 응답을 받습니다. 유사하게, htmx는 _그_가 수행하는 요청에 대해 서버가 HTML로 응답할 것을 기대합니다.

이는 AJAX 요청에 대한 응답으로 JSON을 사용하는 것에 익숙한 웹 개발자들에게 놀라울 수 있으며, JSON은 그러한 요청에 대해 가장 일반적인 응답 형식입니다. 하지만 AJAX 요청은 HTTP 요청일 뿐이며, JSON 사용이 무조건 요구된다는 규칙은 없습니다. AJAX는 비동기 JavaScript 및 XML의 약자이므로, JSON는 원래 이 API에 대해 구상된 형식인 XML에서 이미 한 걸음 떨어져 있습니다.

htmx는 단순히 다른 방향으로 나아가며 HTML을 기대합니다.

==== Htmx와 "순수한" HTML 응답 비교 <_htmx_vs_plain_html_responses>
"일반적인" 앵커 또는 폼 기반 HTTP 요청과 htmx 기반 요청에 대한 HTTP 응답 간에는 중요한 차이점이 있습니다: htmx가 트리거한 요청의 경우 응답이 _부분적인_ HTML 조각이 될 수 있습니다.

#index[htmx][transclusion]
#index[htmx][부분 업데이트]
htmx 기반 상호작용에서는 일반적으로 전체 문서를 대체하지 않습니다. 대신,우리는 기존 문서 내에 콘텐츠를 포함하기 위해 "전송"을 사용합니다. 이 때문에 서버에서 브라우저로 전체 HTML 문서를 전달할 필요가 없거나 바람직하지 않은 경우가 많습니다.

이 사실은 대역폭 및 리소스 로딩 시간을 절약하는 데 활용될 수 있습니다. 서버에서 클라이언트로 전송되는 전체 콘텐츠 양이 줄어들고, 스타일 시트, 스크립트 태그 등과 함께 `head` 태그를 재처리할 필요가 없습니다.

"Get Contacts" 버튼이 클릭될 때, _부분적인_ HTML 응답은 다음과 같을 수 있습니다:

#figure(caption: [htmx 요청에 대한 부분 HTML 응답],
```html
<ul>
  <li><a href="mailto:joe@example.com">Joe</a></li>
  <li><a href="mailto:sarah@example.com">Sarah</a></li>
  <li><a href="mailto:fred@example.com">Fred</a></li>
</ul>
```)

이것은 클릭할 수 있는 요소가 포함된 연락처의 단순한 비순차 목록입니다. 여기에서는 'html' 시작 태그, 'head' 태그 등이 없습니다: 이는 _원시_ HTML 목록으로, 그 주위에 장식이 없습니다. 실제 애플리케이션에서의 응답은 이 단순한 목록보다 더 정교한 HTML을 포함할 수 있지만, 더 복잡하더라도 전체 HTML 페이지일 필요는 없습니다. 해당 리소스에 대한 HTML 표현의 "내부" 콘텐츠일 수 있습니다.

이제 이 단순한 목록 응답이 htmx에 어떻게 적합한지 보여주고 있습니다. htmx는 반환된 콘텐츠를 가져와 DOM의 일부 요소를 대체합니다. (이 콘텐츠가 DOM의 정확히 어디에 배치될지도 곧 살펴보겠습니다.) 이러한 방식으로 HTML 콘텐츠를 교체하는 것은 빠르고 효율적이며, 상당한 양의 클라이언트 측 JavaScript를 실행할 필요 없이 브라우저 내장 HTML 파서를 활용합니다.

이 작은 HTML 응답은 htmx가 하이퍼미디어 패러다임 내에서 설정된 방식을 보여줍니다: "일반적인" 웹 애플리케이션의 "일반적인" 하이퍼미디어 컨트롤처럼, 우리는 비상태적이고 균일한 방식으로 클라이언트에 하이퍼미디어가 전송되는 것을 봅니다.

이 버튼은 하이퍼미디어를 사용하여 웹 애플리케이션을 빌딩하는 약간 더 정교한 메커니즘을 제공합니다.

=== 다른 요소를 타겟팅하기 <_targeting_other_elements>
이제 htmx가 요청을 발행하고 HTML을 응답으로 받았으며, 이 콘텐츠를 기존 페이지에 교체할 예정이므로, 새로운 콘텐츠를 어디에 두어야 할지 질문이 생깁니다.

결국, 기본 htmx 동작은 반환된 콘텐츠를 요청을 트리거한 요소 내에 단순히 배치하는 것입니다. 그러나 이는 버튼의 경우 좋지 않은 일입니다: 최종적으로 연락처 목록이 버튼 요소 내에 어색하게 포함될 것입니다. 이는 매우 어색하게 보일 것이며, 분명히 우리가 원하는 것은 아닙니다.

#index[hx-target][about]
다행히 htmx는 `hx-target`이라는 다른 속성을 제공하여 새로운 콘텐츠가 DOM 내의 정확히 _어디에_ 배치될지를 지정할 수 있습니다. `hx-target` 속성의 값은 새로운 하이퍼미디어 콘텐츠를 넣을 요소를 지정할 수 있는 CSS _선택자_입니다.

버튼을 감싸는 `id`가 `main`인 `div` 태그를 추가해보겠습니다. 그런 다음 우리는 응답으로 이 `div`를 타겟팅할 것입니다:

#index[hx-target][example]
#figure(caption: [단순한 htmx 기반 버튼],
```html
<div id="main"> <1>

  <button hx-get="/contacts" hx-target="#main"> <2>
    Get The Contacts
  </button>

</div>
```)
1. 버튼을 감싸는 `div` 요소.
2. 응답의 대상을 지정하는 `hx-target` 속성입니다.

우리는 버튼에 `hx-target="#main"`을 추가했습니다. 여기서 `#main`은 "ID가 'main'인 요소"를 지칭하는 CSS 선택자입니다.

CSS 선택자를 사용함으로써, htmx는 친숙하고 표준 HTML 개념 위에 구축됩니다. 이는 htmx 작업에 대한 추가 개념적 부담을 최소화합니다.

이 새로운 구성을 통해, 사용자가 이 버튼을 클릭하고 응답이 수신 및 처리된 후 클라이언트의 HTML은 어떻게 보일까요?

대략 다음과 같은 모습이 될 것입니다:

#figure(caption: [htmx 요청 완료 후 우리의 HTML],
```html
<div id="main">
  <ul>
    <li><a href="mailto:joe@example.com">Joe</a></li>
    <li><a href="mailto:sarah@example.com">Sarah</a></li>
    <li><a href="mailto:fred@example.com">Fred</a></li>
  </ul>
</div>
```)

응답 HTML이 `div`에 교체되어 요청을 트리거한 버튼을 대체했습니다. 전송! 그리고 이는 AJAX를 통해 "배경에서" 일어나며, 번거로운 페이지 새로 고침 없이 이루어집니다.

=== 스타일 교체하기 <_swap_styles>
이제 서버 응답에서 콘텐츠를 `div` 내부로, 즉 자식 요소로 로드하고 싶지 않을 수 있습니다. 어쩌면 어떤 이유로든 전체 `div`를 응답으로 대체하고 싶을 수 있습니다. 이를 처리하기 위해 htmx는 콘텐츠가 DOM에 어떻게 교체되어야 하는지를 지정할 수 있는 또 다른 속성인 `hx-swap`을 제공합니다.

#index[htmx][swap model]
#index[hx-swap][about]
#index[hx-swap][innerHTML]
#index[hx-swap][outerHTML]
#index[hx-swap][beforebegin]
#index[hx-swap][afterbegin]
#index[hx-swap][beforeend]
#index[hx-swap][afterend]
#index[hx-swap][delete]
#index[hx-swap][none]
`hx-swap` 속성은 다음 값을 지원합니다:
- `innerHTML` - 기본값으로, 대상 요소의 내부 HTML을 대체합니다.
- `outerHTML` - 응답으로 전체 대상 요소를 교체합니다.
- `beforebegin` - 응답을 대상 요소 앞에 삽입합니다.
- `afterbegin` - 응답을 대상 요소의 첫 번째 자식 앞에 삽입합니다.
- `beforeend` - 응답을 대상 요소의 마지막 자식 뒤에 삽입합니다.
- `afterend` - 응답을 대상 요소 뒤에 삽입합니다.
- `delete` - 응답과 관계없이 대상 요소를 DOM에서 삭제합니다.
- `none` - 교체를 수행하지 않습니다.

첫 번째 두 값인 `innerHTML`과 `outerHTML`은 각각 요소 내의 콘텐츠를 교체하거나 전체 요소를 대체할 수 있는 표준 DOM 속성에서 가져온 것입니다.

다음 네 값은 `Element.insertAdjacentHTML()` DOM API에서 가져온 것으로, 주어진 요소 주위에 요소나 요소들을 배치하는 다양한 방식을 허용합니다.

마지막 두 값인 `delete`와 `none`은 htmx에 특화된 것입니다. 첫 번째 옵션은 DOM에서 대상 요소를 제거하는 반면, 두 번째 옵션은 아무런 작업도 수행하지 않습니다(응답 헤더만 작업하는 방식일 수 있으며, 이는 이 책에서 나중에 다루게 될 고급 기술이 될 것입니다).

다시 말해, htmx는 사용을 위한 개념적 부담을 최소화하기 위해 협력적 웹 표준에 최대한 가까이 다가갑니다.

그러므로, 그러한 경우를 고려해보겠습니다. 즉, 위의 주 요소의 `innerHTML` 콘텐츠를 교체하는 대신, HTML 응답으로 전체 `div`를 교체하고자 하는 상황입니다.

이를 위해 버튼에 `hx-swap` 속성을 추가하면 됩니다:

#figure(caption: [전체 div 교체하기])[ ```html
<div id="main">

  <button hx-get="/contacts" hx-target="#main" hx-swap="outerHTML"> <1>
    Get The Contacts
  </button>

</div>
``` ]
1. 새로운 콘텐츠를 교체하는 방법을 지정하는 `hx-swap` 속성입니다.

이제 응답을 받을 때, _전체_ div가 하이퍼미디어 콘텐츠로 교체될 것입니다:

#figure(caption: [htmx 요청 완료 후 우리의 HTML],
```html
<ul>
  <li><a href="mailto:joe@example.com">Joe</a></li>
  <li><a href="mailto:sarah@example.com">Sarah</a></li>
  <li><a href="mailto:fred@example.com">Fred</a></li>
</ul>
```)

이 변경으로 인해, 대상 div가 DOM에서 완전히 제거되고, 응답으로 반환된 목록이 이를 대체했습니다.

이 책 후반부에서는 주헌 수동 스크롤링 등을 구현할 때 `hx-swap`에 대한 추가 용도를 보게 될 것입니다.

`hx-get`, `hx-post`, `hx-put`, `hx-patch` 및 `hx-delete` 속성을 사용하여 우리는 우리가 앞서 식별한 하이퍼미디어로서 HTML의 네 가지 개선 기회 중 두 가지 문제를 해결했습니다:
- 기회 1: 이제 _모든_ 요소(이번 경우는 버튼)를 사용하여 HTTP 요청을 발행할 수 있습니다.
- 기회 3: 우리는 원하는 _모든 종류_의 HTTP 요청, 특히 `PUT`, `PATCH` 및 `DELETE`를 발행할 수 있습니다.

그리고 `hx-target` 및 `hx-swap`을 통해 우리는 세 번째 단점을 해결했습니다: 전체 페이지가 교체되어야 한다는 요구사항.
- 기회 4: 이제 우리는 트랜슬루전 방식으로 페이지 내의 원하는 요소를 교체할 수 있으며, 원하는 방식으로 그렇게 할 수 있습니다.

따라서, 비교적 간단한 추가 속성을 7개만으로도 하이퍼미디어로서 HTML의 대부분의 단점을 해결했습니다.

다음은 무엇일까요? 우리가 언급했던 모든 기회 중 하나, 즉 오직 `click` 이벤트(앵커의 경우)나 `submit` 이벤트(폼의 경우)만 HTTP 요청을 트리거할 수 있다는 점에 대해 살펴보겠습니다.
제한 사항을 해결하는 방법을 살펴보겠습니다.

=== 이벤트 사용하기 <_using_events>
지금까지 우리는 htmx로 요청을 발행하는 버튼을 사용하고 있었습니다. 버튼을 클릭하면 요청이 발행될 것이라는 점을 직관적으로 이해했을 것입니다. 버튼은 클릭될 때 요청을 발행합니다.

그리고, 그렇습니다. 기본적으로 `hx-get` 또는 htmx의 다른 요청 트리거 주석이 버튼에 놓여지면 버튼이 클릭될 때 요청이 발행됩니다.

#index[hx-trigger][about]
그러나 htmx는 요청을 트리거하는 이벤트 개념을 일반화하여, 맞습니다, 다른 속성인 `hx-trigger`를 사용합니다. 
`hx-trigger` 속성을 사용하면 요청을 트리거하는 이벤트를 하나 이상 지정할 수 있습니다.

종종 `hx-trigger`를 사용할 필요는 없지만 기본 트리거 이벤트가 원하는 이벤트가 될 것입니다. 기본 트리거 이벤트는 요소 유형에 따라 달라지며, 상대적으로 직관적입니다:
- `input`, `textarea` 및 `select` 요소의 요청은 `change` 이벤트에 의해 트리거됩니다.
- `form` 요소의 요청은 `submit` 이벤트에 의해 트리거됩니다.
- 모든 다른 요소의 요청은 `click` 이벤트에 의해 트리거됩니다.

`hx-trigger`가 작동하는 방식을 보여주는 상황을 고려해봅시다: 마우스가 버튼에 들어갔을 때 요청을 트리거하고자 합니다. 이는 확실히 좋은 UX 패턴은 아니지만, 예시로 사용하기 위해 이 방법을 사용해보겠습니다.

버튼에 마우스가 진입할 때 응답하도록 버튼에 다음 속성을 추가할 수 있습니다:

#figure(caption: [마우스 엔트리에 트리거가 있는 버튼],
```html
<div id="main">

  <button hx-get="/contacts" hx-target="#main" hx-swap="outerHTML"
    hx-trigger="mouseenter"> <1>
    Get The Contacts
  </button>

</div>
```)
1. ... `mouseenter` 이벤트에서 요청을 발행합니다.

이제 이 `hx-trigger` 속성이 설정되면, 사용자가 버튼에 마우스를 올렸을 때마다 요청이 트리거됩니다. 어리석어 보일 수 있지만, 작동합니다.

조금 더 현실적이고 유용할 수 있는 것을 시도해 보겠습니다: 연락처를 불러오기 위한 키보드 단축키를 추가해 봅시다, `Ctrl-L`(로드를 위해). 이를 위해 `hx-trigger` 속성이 지원하는 추가 구문인 이벤트 필터와 추가 인수를 활용해야 합니다.

#index[hx-trigger][이벤트 필터]
이벤트 필터는 주어진 이벤트가 요청을 트리거해야 할지 여부를 결정하는 메커니즘입니다. 이는 이벤트 뒤에 대괄호를 추가하여 적용됩니다: `someEvent[someFilter]`. 필터는 주어진 이벤트가 발생할 때 평가되는 JavaScript 표현식입니다. 결과가 JavaScript 의미에서 진리라면 요청이 트리거되며, 그렇지 않다면 요청은 트리거되지 않습니다.

#index[event][keyup]
키보드 단축키의 경우, 우리는 클릭 이벤트 외에도 `keyup` 이벤트를 감지하고자 합니다:

#figure(caption: [시작, keyup에서 트리거],
```html
<div id="main">

  <button hx-get="/contacts" hx-target="#main" hx-swap="outerHTML"
    hx-trigger="click, keyup"> <1>
    Get The Contacts
  </button>

</div>
```)
1. 두 이벤트를 가진 트리거입니다.

#index[hx-trigger][multiple events]
이 버튼에 대해 여러 개의 트리거 이벤트가 설정되었음을 확인하세요. "click" 이벤트에 응답하고 연락처를 불러오는 동시에 `Ctrl-L` 키보드 단축키를 처리하고자 합니다.

안타깝게도, `keyup` 추가 시 두 가지 문제가 있습니다: 현재 상태에서는 발생하는 _모든_ keyup 이벤트에 대해 요청을 트리거합니다. 더욱이, 오로지 이 버튼 내에서 발생한 keyup에 대해서만 트리거됩니다. 사용자는 버튼으로 포커스를 옮겨야 활성 상태가 되고, 그 다음에 입력하기 시작해야 합니다.

이 두 가지 문제를 해결합시다. 첫 번째 문제를 해결하기 위해 필터를 사용하여 Control 키와 "L" 키가 함께 눌려 있는지를 테스트합니다:

#index[event filter][example]
#figure(caption: [keyup 필터로 향상시키기],
```html
<div id="main">

  <button hx-get="/contacts" hx-target="#main" hx-swap="outerHTML"
    hx-trigger="click, keyup[ctrlKey && key == 'l']"> <1>
    Get The Contacts
  </button>

</div>
```)
1. `keyup`에는 필터가 있으므로 Control 키와 L 키가 눌려야 합니다.

이 경우 필터는 `ctrlKey && key == 'l'`입니다. 이는 "controlKey 속성이 true이고 key 속성이 l인 keyup 이벤트"로 해석될 수 있습니다. 속성 `ctrlKey`와 `key`는 글로벌 네임스페이스가 아닌 해당 이벤트에 맞춰 해결되므로, 해당 이벤트의 속성에 쉽게 필터를 적용할 수 있습니다. 그러나 필터로 사용할 수 있는 다른 표현식을 사용할 수 있습니다: 예를 들어 전역 JavaScript 함수를 호출하는 것도 완벽하게 허용됩니다.

오케이, 이 필터는 요청을 트리거할 keyup 이벤트를 `Ctrl-L` 프레스로 제한하지만, 여전히 문제가 있습니다. 현재 상태에서는 _버튼 내에서만_ 발생한 keyup 이벤트에 대해서만 요청이 트리거됩니다.

#index[event bubbling]
JavaScript 이벤트 버블링 모델에 익숙하지 않다면: 이벤트들은 일반적으로 부모 요소로 "버블"됩니다. 따라서 `keyup`과 같은 이벤트는 먼저 포커스를 가진 요소에서 발생한 다음, 그 부모(포함 요소)에서 발생하며, 상위 수준인 `document` 객체에 도달할 때까지 이와 같은 식으로 진행됩니다.

#index[hx-trigger][from:]
#index[keyboard shortcut]
요소가 포커스를 가지고 있지 않은 경우에도 글로벌 키보드 단축키를 지원하기 위해, 우리는 이벤트 버블링과 `hx-trigger` 속성이 지원하는 기능을 활용합니다: _다른 요소_에서 이벤트를 듣는 능력입니다. 이를 수행하는 구문은 특정 요소에 대해 주어진 이벤트를 청취하는 CSS 선택자를 사용할 수 있게 해주는 이벤트 이름 뒤에 `from:` 수식어를 추가한 것입니다.

#index[events][listener]
이 경우, 우리는 페이지의 모든 표시 요소의 부모 요소인 `body` 요소에 대해 듣고자 합니다.

업데이트된 `hx-trigger` 속성이 이렇게 보일 것입니다:

#figure(caption: [더 나아가, body에서 keyup 듣기],
```html
<div id="main">

  <button hx-get="/contacts" hx-target="#main" hx-swap="outerHTML"
    hx-trigger="click, keyup[ctrlKey && key == 'l'] from:body"> <1>
    Get The Contacts
  </button>

</div>
```)
1. `body` 태그에서 'keyup' 이벤트를 듣습니다.

이제 클릭할 때뿐만 아니라 페이지의 본문에서 누군가가 `Ctrl-L`을 눌렀을 때에도 요청이 트리거될 것입니다.

그리고 이제 우리의 하이퍼미디어 주도 애플리케이션을 위한 멋진 키보드 단축키가 생겼습니다.

#index[hx-trigger][about]
`hx-trigger` 속성은 훨씬 더 많은 수식어를 지원하며, 이로 인해 다른 htmx 속성보다 더욱 복잡해집니다. 이는 일반적으로 이벤트가 복잡하고, 정확히 맞추기 위해 많은 세부정보가 필요하기 때문입니다. 그러나 기본 트리거는 종종 충분하며, htmx를 사용할 때 복잡한 `hx-trigger` 기능이 필요하지 않은 경우가 많습니다.

우리가 방금 추가한 키보드 단축키와 같은 더욱 정교한 트리거 사양을 가지고 있음에도 불구하고, htmx의 전반적인 느낌은 _선언적_입니다.
  
즉, 명령형이 아닙니다. 이는 htmx 기반 애플리케이션이 상당한 양의 JavaScript를 추가하는 방식과는 다르게 "일반적인" 웹 1.0 애플리케이션처럼 느껴지게 합니다.

=== Htmx: HTML 확장 <_htmx_html_extended>
하여튼 확인해 보세요! `hx-trigger`를 사용하여 우리는 이번 장의 시작 부분에서 설명한 HTML 개선 기회를 해결했습니다:
- 기회 2: 우리는 _모든_ 이벤트를 사용하여 HTTP 요청을 트리거할 수 있습니다.

그렇다면 우리가 총 8개의 속성을 보유하게 되었는데, 이 모두는 일반 HTML과 동일한 개념 모델에 속하며, 하이퍼미디어로서 HTML을 확장함으로써 사용자 상호작용 가능성의 완전히 새로운 세계를 열어줍니다.

#index[HTML][opportunities]
다음은 이러한 기회를 요약하고 htmx 속성과 해당 기회를 매핑한 표입니다:

/ 어떤 요소든 HTTP 요청을 발행할 수 있어야 합니다: #[
  `hx-get`, `hx-post`, `hx-put`, `hx-patch`, `hx-delete`
  ]

/ 어떤 이벤트든 HTTP 요청을 트리거할 수 있어야 합니다: #[
  `hx-trigger`
  ]

/ 모든 HTTP 작업이 사용 가능해야 합니다: #[
  `hx-put`, `hx-patch`, `hx-delete`
  ]

/ 페이지의 어떤 위치든 교체 가능해야 합니다 (전송): #[
  `hx-target`, `hx-swap`
  ]

=== 요청 매개변수 전달하기 <_passing_request_parameters>

지금까지 우리는 버튼이 간단한 `GET` 요청을 만드는 상황을 살펴보았습니다. 이는 개념적으로 앵커 태그가 수행할 수 있는 것과 매우 가깝습니다. 하지만 HTML 기반 애플리케이션에는 또 다른 네이티브 하이퍼미디어 컨트롤인 #indexed[폼]이 있습니다.  
폼은 요청 시 URL 외에 추가 정보를 서버에 전달하는 데 사용됩니다.

이 정보는 다양한 입력 태그를 통해 폼 내의 입력 및 입력 유사 요소를 통해 캡처됩니다.

htmx는 이러한 추가 정보를 HTML 자체를 반영하는 방식으로 포함할 수 있게 해줍니다.

==== 폼 포함하기 <_enclosing_forms>
htmx에서 요청과 함께 입력 값을 전달하는 가장 간단한 방법은 요청을 발행하는 요소를 폼 태그 안에 포함하는 것입니다.

원래의 #indexed[search] 폼을 가져와 htmx를 사용하여 변환해 보겠습니다:

#figure(caption: [htmx 기반 검색 버튼],
```html
<form action="/contacts" method="get" class="tool-bar"> <1>
  <label for="search">Search Term</label>
  <input id="search" type="search" name="q" 
    value="{{ request.args.get('q') or '' }}"
    placeholder="Search Contacts"/>
  <button hx-post="/contacts" hx-target="#main"> <2>
    Search
  </button>
</form>
```)

1. htmx 기반 요소가 조상 폼 태그 안에 있을 경우, 해당 폼 내의 모든 입력 값은 비-`GET` 요청에 대해 제출됩니다.
2. 우리는 `submit` 유형의 `input`에서 `button`으로 전환하고 `hx-post` 속성을 추가했습니다.

#index[htmx][폼 값]
이제 사용자가 이 버튼을 클릭하면, `search` 아이디를 가진 입력의 값이 요청에 포함됩니다. 이는 버튼과 입력을 모두 포함하는 폼 태그가 존재하기 때문에 가능합니다: htmx에 의해 트리거된 요청이 이루어질 때 htmx는 DOM 계층에서 포함된 폼을 찾아보고, 찾은 경우 그 폼 내의 모든 값을 포함합니다. (이렇게 하는 것을 때때로 "폼 직렬화"라고 합니다.)

버튼이 `GET` 요청 대신 `POST` 요청으로 전환했다고 여러분은 눈치챘을지도 모릅니다. 이는 기본적으로 htmx가 `GET` 요청에 대해 가장 가까운 포함된 폼을 포함하지 않지만, 모든 다른 유형의 요청에는 포함하기 때문입니다.

이것은 다소 이상하게 느껴질 수 있지만, 이는 기록 항목을 다룰 때 폼에서 사용된 URL을 혼잡하게 만드는 것을 피하기 위한 것입니다. 이 부분은 곧 논의할 것입니다.
대신에, `GET` 요청으로 폼의 값을 포함하고 싶다면 `hx-include` 속성을 사용할 수 있습니다. 이 속성에 대해서는 다음에 논의하겠습니다.

또한 `hx-post` 속성을 버튼에 추가하는 대신 폼에 추가할 수도 있지만, 이는 `action` 속성과 `hx-post` 속성에서 검색 URL의 다소 어색한 중복을 생성하게 됩니다. 이 부분은 다음 장에서 논의할 `hx-boost` 속성을 사용하여 피할 수 있습니다.

==== 입력 포함하기 <_including_inputs>

#index[폼 태그][in tables]
입력을 요청에 포함하는 가장 일반적인 방법은 요청에 포함하고 싶은 모든 입력을 폼 내에 두는 것이지만, 항상 가능하거나 바람직한 것은 아닙니다: 폼 태그는 레이아웃에 영향을 미칠 수 있으며, 어떤 HTML 문서의 특정 위치에 배치할 수 없습니다. 대표적인 예가 테이블 행(`tr`) 요소입니다: `form` 태그는 테이블 행의 부모 또는 자식으로 유효하지 않으므로 데이터 행 내에 서식을 두거나 주위에 폼을 배치할 수 없습니다.

#index[hx-include][about]
#index[hx-include][example]
이 문제를 해결하기 위해 htmx는 요청에 입력 값을 포함하는 메커니즘인 `hx-include` 속성을 제공합니다. `hx-include` 속성은 요청에 포함할 입력 값을 CSS 선택자를 통해 선택할 수 있도록 해줍니다.

위의 예제를 다시 차려보면 입력을 쇼셜 없이 포함하도록 변형된 것입니다:

#figure(caption: [htmx 기반 버튼의 `hx-include`],
```html
<div id="main">

  <label for="search">Search Contacts:</label>
  <input id="search" name="q"  type="search" 
    value="{{ request.args.get('q') or '' }}"
    placeholder="Search Contacts"/>
  <button hx-post="/contacts" hx-target="#main" hx-include="#search"> <1>
    Search
  </button>

</div>
```)
1. `hx-include`는 요청에 직접 값을 포함하는 데 사용할 수 있습니다.

`hx-include` 속성은 CSS 선택자 값을 가져오며, 요청과 함께 보내고자 하는 값을 정확히 지정할 수 있습니다. 이는 요청을 발행하는 요소와 원하는 모든 입력을 함께 두는 것이 어려운 경우에 유용합니다.

또한, 기본적으로 htmx의 행동을 극복하고 실제로 `GET` 요청과 함께 값을 제출하고자 할 때 유용합니다.

===== 상대 CSS 선택자 <_relative_css_selectors>

#index[상대 CSS 선택자][about]
`hx-include` 속성과, 사실상 CSS 선택자를 취하는 대부분의 속성은 _상대_ CSS 선택자를 지원합니다. 이는 선언된 요소를 기준으로 CSS 선택자를 지정할 수 있게 해줍니다. 여기 몇 가지 예가 있습니다:

 / `closest`: #index[상대 CSS 선택자][closest] 주어진 선택자와 일치하는 가장 가까운 부모 요소를 찾습니다. 예: `closest form`.

/ `next`: #index[상대 CSS 선택자][next] 다음 요소(앞쪽 스캔)를 찾으며 주어진 선택자와 일치합니다. 예: `next input`.

/ `previous`: #index[상대 CSS 선택자][previous] 이전 요소(뒤쪽 스캔)를 찾으며 주어진 선택자와 일치합니다. 예: `previous input`.

/ `find`: #index[상대 CSS 선택자][find] 이 요소 내에 있는 다음 요소를 찾으며 주어진 선택자와 일치합니다. 예: `find input`.

/ `this`: #index[상대 CSS 선택자][this] 현재 요소를 의미합니다.

상대 CSS 선택자를 사용하면 요소에 ids를 생성할 필요 없이 그들의 지역적인 구조적 레이아웃을 활용할 수 있습니다.

==== 인라인 값 <_inline_values>

#index[hx-vals][about]
htmx 기반 요청에 값을 포함하는 마지막 방법은 요청에 "정적" 값을 포함할 수 있는 `hx-vals` 속성을 사용하는 것입니다. 이는 요청에 포함하고자 하는 추가 정보가 있을 때 유용합니다. 이런 정보를 예를 들어, 숨겨진 입력 엔진(HTML에 추가로 숨겨진 정보를 포함하는 표준적인 메커니즘)을 두고 싶지 않을 경우 유용합니다.

#index[hx-vals][예제]
#index[hx-vals][JSON]
#index[query strings]
`hx-vals`의 예는 다음과 같습니다:

#figure(caption: [htmx 기반 버튼의 `hx-vals`],
```html
<button hx-get="/contacts" hx-vals='{"state":"MT"}'> <1>
  Get The Contacts In Montana
</button>
```)
1. `hx-vals`, 요청에 포함될 JSON 값입니다.

`state`라는 매개변수에 `MT`라는 값이 `GET` 요청에 포함되며, 최종적으로 보이는 경로는 `/contacts?state=MT`와 같아집니다. `hx-vals` 속성을 사용하면서 속성 값 주위를 단일 따옴표로 바꿨습니다. 이는 JSON이 엄격하게 이중 인용부호를 요구하기 때문에, 이 속성 값을 벗어나지 않도록 하기 위함입니다.

#index[hx-vals][js: prefix]
`hx-vals`는 `js:` 접두어를 붙여 요청 시 평가되는 값을 전달할 수 있습니다. 이는 동적으로 유지 관리되는 변수를 포함하거나 타사 JavaScript 라이브러리 값을 포함할 수 있어 유용합니다.

예를 들어, `state` 변수가 JavaScript를 통해 동적으로 유지되며 현재 선택된 상태를 반환하는 `getCurrentState()`라는 JavaScript 함수가 있을 경우, 다음과 같이 동적으로 htmx 요청에 포함될 수 있습니다:

#figure(caption: [동적 값],
```html
<button hx-get="/contacts"
  hx-vals='js:{"state":getCurrentState()}'> <1>
  Get The Contacts In The Selected State
</button>
```)
1. `js:` 접두어가 붙어 있으므로, 이 표현식은 제출 시간에 평가됩니다.

요청의 매개변수로 사용하는 이 세 가지 메커니즘 (폼 태그 사용, `hx-include` 속성 사용, `hx-vals` 속성 사용)은 사용자가 원하는 대로 하이퍼미디어 요청에 값을 포함할 수 있으며, 이는 매우 익숙하고 HTML의 정신을 유지합니다. 동시에 원하는 것을 달성할 수 있도록 유연함을 제공합니다.

=== 히스토리 지원 <_history_support>
htmx에 대한 개요를 마무리하는 마지막 기능은 브라우저 히스토리 지원입니다. 일반 HTML 링크 및 폼을 사용할 때, 브라우저는 사용자가 방문한 모든 페이지를 추적합니다. 이를 통해 뒤로 버튼을 사용하여 이전 페이지로 다시 이동할 수 있으며, 이러한 작업을 수행한 후에는 앞으로 버튼을 사용하여 원래 페이지로 돌아갈 수 있습니다.

#index[브라우저 히스토리]
이 히스토리의 개념은 초기 웹의 주요 기능 중 하나였습니다. 불행히도, 단일 페이지 애플리케이션 패러다임으로 옮기면 히스토리가 까다로워지는 것으로 보입니다. AJAX 요청은 그것만으로는 웹 페이지를 브라우저의 히스토리에 등록하지 않음으로, 좋은 점이 있습니다. AJAX 요청은 웹 페이지의 상태와 아무런 관계가 없을 수 있으므로(아마도 브라우저의 일부 활동을 기록하기 위함일 것입니다), 해당 상호작용에 대해 새로운 히스토리 항목을 생성하는 것이 적절하지 않습니다.

하지만 단일 페이지 애플리케이션에서는 많은 AJAX 기반 상호작용이 있을 것이며, 이때는 적절하게 히스토리 항목을 생성할 수 있어야 합니다. 브라우저 히스토리를 처리하는 JavaScript API가 존재하지만, 이 API는 매우 성가신 방식이어서 종종 JavaScript 개발자들이 무시하는 경향이 있습니다.

단일 페이지 애플리케이션을 사용 중 실수로 뒤로 버튼을 클릭해 전체 애플리케이션 상태를 잃고 처음부터 다시 시작해야 했던 경험이 있다면, 이 문제가 실제로 어떻게 작용하는지 관찰했을 것입니다.

htmx에서는 단일 페이지 애플리케이션 프레임워크와 마찬가지로, 종종 히스토리 API와 함께 명시적으로 작업해야 할 필요가 있습니다. 다행히 htmx는 웹의 네이티브 모델에 최대한 근접하고 선언적이기 때문에 htmx 기반 애플리케이션에서 웹 히스토리를 올바르게 처리하는 것이 일반적으로 훨씬 더 쉬운 일입니다.

우리가 지금까지 살펴본 연락처를 불러오는 버튼을 생각해 봅시다:

#figure(caption: [우리의 믿음직한 버튼],
```html
<button hx-get="/contacts" hx-target="#main">
  Get The Contacts
</button>
```)

현재 상태로는 이 버튼이 클릭될 때 `/contacts`에서 콘텐츠를 검색해 `main` ID가 있는 요소에 로드되지만, _새로운_ 히스토리 항목은 생성되지 않습니다.

#index[hx-push-url]
#index[뒤로 버튼]
이 요청이 발생할 때 히스토리 항목을 생성하고 싶다면 버튼에 새로운 속성인 `hx-push-url` 속성을 추가하면 됩니다:

#figure(caption: [우리의 믿음직한 버튼, 이제 히스토리와 함께!],
```html
<button hx-get="/contacts" hx-target="#main" hx-push-url="true"> <1>
  Get The Contacts
</button>
```)
1. `hx-push-url`은 버튼이 클릭될 때 히스토리에 항목을 생성합니다.

이제 버튼이 클릭되면 `/contacts` 경로가 브라우저의 네비게이션 바에 배치되고, 이에 대한 히스토리 항목이 생성됩니다. 더 나아가 사용자가 뒤로 버튼을 클릭하면 페이지에 대한 원래 콘텐츠가 복원되며, 원래 URL도 함께 복원됩니다.

#index[htmx][브라우저 히스토리]
이제 `hx-push-url`이라는 속성의 이름이 다소 모호할 수 있지만, JavaScript API인 `history.pushState()`를 기반으로 하며="히스토리 항목은 스택으로 모델링하므로, 새 항목이 스택의 정점에 "푸시되는 것입니다.

이렇게 간단한 선언적 메커니즘을 통해 htmx는 HTML의 "일반적인" 동작을 모방하여 뒤로 버튼과 통합할 수 있습니다.

이제 우리가 히스토리를 "정확하게" 처리하기 위해 한 가지 추가 작업이 필요합니다: `/contacts` 경로가 브라우저의 주소 표시줄에 성공적으로 "푸시"되었고, 뒤로 버튼도 작동합니다. 하지만 누군가 `/contacts` 페이지에 있는 동안 브라우저를 새로 고침하면 어떻게 될까요?

이 경우 htmx 기반의 "부분" 응답과 비-htmx의 "전체 페이지" 응답을 모두 처리해야 합니다. 이는 HTTP 헤더를 사용하여 처리할 수 있으며, 이는 이 책 후반부에서 자세히 다룰 주제입니다.

=== 결론 <_conclusion>
이것이 htmx에 대한 우리의 급격한 소개였습니다. 우리는 라이브러리에서 약 열 개의 속성만을 보았지만, 이러한 속성이 얼마나 강력해질 수 있는지의 힌트를 볼 수 있습니다. htmx는 순수한 HTML보다 훨씬 더 정교한 웹 애플리케이션을 가능하게 하며, 대부분의 JavaScript 기반 접근 방식에 비해 최소한의 추가 개념적 부담을 지닙니다.

htmx는 HTML을 하이퍼미디어로 점진적으로 개선하는 것을 목표로 하며, 이는 기본 마크업 언어와 개념적으로 일관성을 가집니다. 모든 기술적 선택이 그러하듯, 여기에도 트레이드오프가 있으며: htmx는 HTML에 너무 가까이 머무르기 때문에 많은 개발자들이 "기본적으로" 있어야 한다고 느끼는 인프라를 제공하지 않습니다.

웹의 네이티브 모델에 더 가까이 다가가면서 htmx는 단순성과 기능 간의 균형을 이루려고 하며, 기존 웹 플랫폼 위에서 더 정교한 프론트엔드 확장을 위해 다른 라이브러리에 위임합니다. 좋은 소식은, htmx가 다른 라이브러리와 잘 호환되므로 이러한 필요가 발생할 경우 이를 처리할 수 있는 또 다른 라이브러리를 가져오기 쉬운 경우가 많다는 것입니다.

#html-note[HTML 예산 책정][
  콘텐츠와 마크업 간의 긴밀한 관계는 좋은 HTML이 노동 집약적이라는 것을 의미합니다. 대부분의 사이트는 작성자와 개발자 간의 분리가 있으며, 작성자는 HTML에 익숙하지 않고, 개발자는 주어진 콘텐츠를 처리할 수 있는 일반적인 시스템을 개발해야 합니다. 이 분리는 일반적으로 CMS 형태로 이루어지며, 그 결과로 고급 HTML에 필요한 마크업은 콘텐츠에 잘 맞게 맞추는 것이 어려운 경우가 많습니다.

  더욱이, 국제화된 사이트의 경우 서로 다른 언어로 작성된 콘텐츠가 동일한 요소에 삽입되는 경우, 언어 간의 스타일 규칙 차이로 인해 마크업 품질이 저하될 수 있습니다. 이는 많은 조직이 감당할 수 있는 비용이 아닙니다.

  따라서 모든 사이트가 완벽하게 준수되는 HTML을 포함할 수 있을 것으로 기대하지 않습니다. 가장 중요한 것은 _잘못된_ HTML을 피하는 것입니다 --- 보다 일반적인 요소를 사용하는 것이 정확히 틀리기보다는 나을 수 있습니다.

  그러나 리소스가 있는 경우, HTML에 더 많은 주의를 기울이면 더 세련된 사이트를 생성할 수 있습니다.
]