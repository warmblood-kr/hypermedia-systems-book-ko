#import "lib/definitions.typ": *

== 하이퍼뷰를 이용한 연락처 앱 구축하기

이 책의 이전 장에서는 하이퍼미디어 아키텍처를 이용해 앱을 구축하는 이점에 대해 설명했습니다. 이러한 이점은 강력한 연락처 웹 애플리케이션을 구축함으로써 입증되었습니다. 11장에서는 하이퍼미디어 개념이 웹 이외의 플랫폼에도 적용될 수 있고 적용되어야 한다고 주장했습니다. 우리는 모바일 앱 구축을 위해 특별히 설계된 하이퍼미디어 형식 및 클라이언트의 예로 하이퍼뷰를 소개했습니다. 하지만 여러분은 여전히 궁금해할 수 있습니다. 하이퍼뷰를 사용하여 완전한 기능을 갖춘 프로덕션 준비가 된 모바일 앱을 만드는 것은 어떤 느낌일까요? 새로운 언어와 프레임워크를 모두 배워야 할까요? 이 장에서는 연락처 웹 앱을 네이티브 모바일 앱으로 포팅하여 하이퍼뷰를 실제로 보여주겠습니다. 여러분은 하이퍼뷰로 개발할 때 많은 웹 개발 기술(그리고 실제로 코드의 많은 부분)이 완전히 동일하다는 것을 보게 될 것입니다. 어떻게 가능한가요?

#[
#set enum(numbering: "1.", start: 1)
+ 우리의 연락처 웹 앱은 HATEOAS(하이퍼미디어를 애플리케이션 상태의 엔진으로 사용하는 것)의 원칙에 따라 구축되었습니다. 앱의 모든 기능(연락처를 검색하고, 편집하고, 생성하는 것)은 백엔드에서 구현됩니다(`Contacts` Python 클래스). 하이퍼뷰로 구축된 모바일 앱도 HATEOAS를 활용하며 앱의 모든 논리에 대해 백엔드에 의존합니다. 이는 `Contacts` Python 클래스가 웹 앱을 구동하는 방식과 동일하게 모바일 앱을 구동할 수 있음을 의미하며, 변경이 필요하지 않습니다.

+ 웹 앱의 클라이언트-서버 통신은 HTTP를 사용하여 발생합니다. 우리의 웹 앱을 위한 HTTP 서버는 Flask 프레임워크를 사용하여 작성되었습니다. 하이퍼뷰도 클라이언트-서버 통신을 위해 HTTP를 사용합니다. 따라서 우리는 모바일 앱에서도 웹 앱의 Flask 경로 및 뷰를 재사용할 수 있습니다.

+ 웹 앱은 하이퍼미디어 형식으로 HTML을 사용하고, 하이퍼뷰는 HXML을 사용합니다. HTML과 HXML은 서로 다른 형식이지만 기본 구문은 유사합니다(속성이 있는 중첩 태그). 이는 우리가 HTML과 HXML 모두를 위해 동일한 템플릿 라이브러리(Jinja)를 사용할 수 있음을 의미합니다. 또한 htmx의 많은 개념이 HXML에 내장되어 있습니다. 우리는 htmx를 사용하여 구현된 웹 앱 기능(검색, 무한 로딩)을 HXML로 직접 포팅할 수 있습니다.
]

본질적으로, 우리는 웹 앱의 백엔드에서 거의 모든 것을 재사용할 수 있지만, HTML 템플릿을 HXML 템플릿으로 대체해야 합니다. 이 장의 대부분의 섹션은 우리가 웹 연락처 앱을 로컬에서 실행하고 포트 5000에서 수신 대기하고 있다고 가정할 것입니다. 준비되었습니까? 모바일 앱의 UI를 위한 새로운 HXML 템플릿을 만들어봅시다.

=== 모바일 앱 만들기 <_creating_a_mobile_app>
HXML로 시작하려면 한 가지 귀찮은 요구 사항이 있습니다: 하이퍼뷰 클라이언트. 웹 애플리케이션을 개발할 때는 클라이언트(웹 브라우저)가 보편적으로 사용 가능하기 때문에 서버에 대해서만 걱정하면 됩니다. 모든 모바일 장치에 설치된 하이퍼뷰 클라이언트는 없습니다. 대신, 우리는 우리 서버와만 통신하도록 맞춤화된 하이퍼뷰 클라이언트를 만들 것입니다. 이 클라이언트는 Android 또는 iOS 모바일 앱으로 패키징할 수 있으며, 해당 앱 스토어를 통해 배포할 수 있습니다.

운 좋게도, 하이퍼뷰 클라이언트를 구현하기 위해 처음부터 시작할 필요는 없습니다. 하이퍼뷰 코드 저장소에는 Expo를 사용하여 구축된 데모 백엔드와 데모 클라이언트가 포함되어 있습니다. 이 데모 클라이언트를 사용할 것이지만 연락처 앱 백엔드를 시작점으로 지정할 것입니다.

#figure[```bash
git clone git@github.com:Instawork/hyperview.git
cd hyperview/demo
yarn <1>
yarn start <2>
```]
1. 데모 앱의 종속성을 설치합니다.
2. Expo 서버를 시작하여 iOS 시뮬레이터에서 모바일 앱을 실행합니다.

`yarn start`를 실행한 후, Android 에뮬레이터 또는 iOS 시뮬레이터를 사용하여 모바일 앱을 열라는 프롬프트가 표시됩니다. 설치한 개발 SDK에 따라 옵션을 선택하세요. (이 장의 스크린샷은 iOS 시뮬레이터에서 촬영될 것입니다.) 운이 좋다면 시뮬레이터에 설치된 Expo 모바일 앱을 볼 수 있을 것입니다. 모바일 앱은 자동으로 실행되고 "네트워크 요청 실패"라는 메시지가 표시된 화면이 나타납니다. 이는 기본적으로 이 앱이 http:\/\/0.0.0.0:8085/index.xml에 요청을 하도록 구성되어 있지만, 우리의 백엔드는 포트 5000에서 수신 대기하고 있기 때문입니다. 이 문제를 해결하기 위해 `demo/src/constants.js` 파일에서 간단한 구성 변경을 할 수 있습니다:

#figure[```js
//export const ENTRY_POINT_URL = 'http://0.0.0.0:8085/index.xml'; <1>
export const ENTRY_POINT_URL = 'http://0.0.0.0:5000/'; <2>
```]
1. 데모 앱의 기본 진입점 URL
2. URL을 우리의 연락처 앱으로 설정

우리는 아직 준비가 안 되어 있습니다. 하이퍼뷰 클라이언트가 올바른 엔드포인트를 가리키게 되었으므로, "ParseError"라는 다른 오류가 표시됩니다. 이는 백엔드가 HTML 콘텐츠로 요청에 응답하고 있지만 하이퍼뷰 클라이언트는 XML 응답(HXML)을 기대하기 때문입니다. 따라서 Flask 백엔드로의 주의를 돌릴 시간입니다. Flask 뷰를 검토하고 HTML 템플릿을 HXML 템플릿으로 교체하겠습니다. 구체적으로, 모바일 앱에서 다음 기능을 지원하도록 하겠습니다:

- 검색 가능한 연락처 목록
- 연락처 세부 정보 보기
- 연락처 편집
- 연락처 삭제
- 새로운 연락처 추가

#sidebar[제로 클라이언트-구성 하이퍼미디어 애플리케이션][
  #index[Hyperview][entry-point URL]
  하이퍼뷰 클라이언트를 사용하는 많은 모바일 앱에 대해, 이 진입점 URL을 구성하는 것이 전체 기능 앱을 제공하기 위해 작성해야 하는 유일한 디바이스 코드입니다. 진입점 URL을 웹 브라우저에 입력하여 웹 앱을 열기 위한 주소로 생각해보세요. 하이퍼뷰에서는 주소 표시줄이 없고, 브라우저는 오직 하나의 URL만 열도록 하드코딩되어 있습니다. 이 URL은 사용자가 앱을 실행할 때 첫 번째 화면을 로드합니다. 사용자가 수행할 수 있는 다른 모든 작업은 그 첫 번째 화면의 HXML에 선언됩니다. 이 최소한의 구성은 하이퍼미디어 중심 아키텍처의 이점 중 하나입니다.

  물론, 모바일 앱에서 더 많은 기능을 지원하기 위해 더 많은 디바이스 코드를 작성하고 싶을 수 있습니다. 우리는 이 장의 "클라이언트 확장"이라는 섹션에서 이를 구현하는 방법을 시연할 것입니다.
]

=== 검색 가능한 연락처 목록 <_a_searchable_list_of_contacts>
우리는 하이퍼뷰 앱을 연락처 목록이라는 진입점 화면으로 구축하기 시작하겠습니다. 이 화면의 초기 버전을 위해, 웹 앱의 다음 기능을 지원하겠습니다:
- 스크롤 가능한 연락처 목록 표시
- 목록 위의 "타이핑 시 검색" 필드
- 사용자가 스크롤할 때 더 많은 연락처를 로드하기 위한 "무한 스크롤"

또한, 사용자가 모바일 앱의 목록 UI에서 이 기능을 기대하기 때문에 목록에서 "당기기 새로 고침" 상호작용을 추가할 것입니다.

모든 연락처 웹 앱의 페이지가 공통 기본 템플릿인 `layout.html`을 확장했다는 것을 기억하실 겁니다. 모바일 앱의 화면에도 비슷한 기본 템플릿이 필요합니다. 이 기본 템플릿은 우리의 UI 스타일 규칙과 모든 화면에 공통된 기본 구조를 포함할 것입니다. 이를 `layout.xml`이라고 부릅시다.

#figure(caption: [기본 템플릿 `hv/layout.xml`])[ ```xml
<doc xmlns="https://hyperview.org/hyperview">
  <screen>
    <styles><!-- 생략된 부분 --></styles>
    <body style="body" safe-area="true">
      <header style="header">
        {% block header %} <1>
          <text style="header-title">Contact.app</text>
        {% endblock %}
      </header>

      <view style="main">
        {% block content %}{% endblock %} <2>
      </view>
    </body>
  </screen>
</doc>
``` ]
1. 기본 템플릿의 헤더 섹션, 기본 제목 포함.
2. 다른 템플릿에 의해 제공될 템플릿의 콘텐츠 섹션.

우리는 지난 장에서 다룬 HXML 태그와 속성을 사용하고 있습니다. 이 템플릿은 `<doc>`, `<screen>`, `<body>`, `<header>`, `<view>` 태그를 사용하여 기본 화면 레이아웃을 설정합니다. HXML 구문이 Jinja 템플릿 라이브러리와 잘 호환된다는 점에 유의하세요. 여기서는 Jinja의 블록을 사용하여 화면의 고유한 콘텐츠를 보유할 두 섹션(`header` 및 `content`)을 정의합니다. 기본 템플릿이 완료되었으므로 연락처 목록 화면을 위한 템플릿을 생성할 수 있습니다.

#figure(
  caption: [`hv/index.xml`의 시작 부분],
)[ ```xml
{% extends 'hv/layout.xml' %} <1>

{% block content %} <2>
  <form> <3>
    <text-field name="q" value="" placeholder="검색..."
      style="search-field" />
    <list id="contacts-list"> <4>
      {% include 'hv/rows.xml' %}
    </list>
  </form>
{% endblock %}
``` ]
1. 기본 레이아웃 템플릿을 확장합니다.
2. 레이아웃 템플릿의 `content` 블록을 재정의합니다.
3. HTTP `GET`을 `/contacts`에 발행할 검색 양식을 생성합니다.
4. 연락처 목록, Jinja `include` 태그를 사용하여.

이 템플릿은 기본 `layout.xml`을 확장하고, `<form>`으로 `content` 블록을 재정의합니다. 처음에는 `<text-field>` 및 `<list>` 요소를 둘러싸고 있는 폼이 있는 것이 다소 이상하게 보일 수 있습니다. 그러나 하이퍼뷰에서는 폼 데이터가 자식 요소에서 시작되는 요청에 포함됩니다. 이 목록에 대화형(당기기 새로 고침)을 추가하면 폼 데이터가 필요할 것입니다. 연락처 목록에 대한 행을 렌더링하기 위해 Jinja include 태그를 사용하여 연락처의 HXML을 표시해야 한다는 점에 유의하세요(`hv/rows.xml`). HTML 템플릿에서와 마찬가지로, HXML을 더 작은 조각으로 나누기 위해 `include`를 사용할 수 있습니다. 또한 검색, 무한 스크롤, 당기기 새로 고침과 같은 상호작용에 대해 서버가 단지 `rows.xml` 템플릿으로 응답할 수 있도록 해줍니다.

#figure(caption: [`hv/rows.xml`])[ ```xml
<items xmlns="https://hyperview.org/hyperview"> <1>
  {% for contact in contacts %} <2>
    <item key="{{ contact.id }}" style="contact-item"> <3>
      <text style="contact-item-label">
        {% if contact.first %}
          {{ contact.first }} {{ contact.last }}
        {% elif contact.phone %}
          {{ contact.phone }}
        {% elif contact.email %}
          {{ contact.email }}
        {% endif %}
      </text>
    </item>
  {% endfor %}
</items>
``` ]
1. 공통 조상에 `<item>` 요소 세트를 그룹화하는 HXML 요소.
2. 템플릿에 전달된 연락처를 반복합니다.
3. 각 연락처에 대해 이름, 전화번호 또는 이메일을 보여주는 `<item>`을 렌더링합니다.

웹 앱에서 목록의 각 행은 연락처의 이름, 전화번호 및 이메일 주소를 표시했습니다. 하지만 모바일 앱에서는 사용할 수 있는 공간이 적습니다. 모든 정보를 한 줄에 넣는 것은 어려울 것입니다. 대신, 행은 연락처의 이름과 성만 표시하고, 이름이 설정되지 않은 경우 이메일 또는 전화로 대체됩니다. 행을 렌더링하기 위해, 우리는 다시 Jinja 템플릿 구문을 사용하여 템플릿에 전달된 데이터로 동적 텍스트를 렌더링할 수 있습니다.

이제 기본 레이아웃, 연락처 화면 및 연락처 행을 위한 템플릿을 가지게 되었습니다. 그러나 여전히 Flask 뷰를 이러한 템플릿을 사용하도록 업데이트해야 합니다. 현재 웹 앱을 위해 작성된 `contacts()` 뷰를 살펴보겠습니다:

#figure(
  caption: [`app.py`],
)[ ```py
@app.route("/contacts")
def contacts():
    search = request.args.get("q")
    page = int(request.args.get("page", 1))
    if search:
        contacts_set = Contact.search(search)
        if request.headers.get('HX-Trigger') == 'search':
            return render_template("rows.html",
              contacts=contacts_set, page=page)
    else:
        contacts_set = Contact.all(page)
    return render_template("index.html",
      contacts=contacts_set, page=page)
``` ]

이 뷰는 `q`와 `page`라는 두 쿼리 매개변수를 기반으로 연락처 세트를 가져오는 것을 지원합니다. 또한 `HX-Trigger` 헤더에 따라 전체 페이지(`index.html`) 또는 연락처 행만 렌더링할지 결정합니다. 이는 경미한 문제를 제기합니다. `HX-Trigger` 헤더는 htmx 라이브러리에 의해 설정됩니다. 하이퍼뷰에는 이에 상응하는 기능이 없습니다. 또한 하이퍼뷰에는 연락처 행만으로 응답해야 하는 여러 시나리오가 있습니다:
- 검색
- 당기기 새로 고침
- 다음 페이지의 연락처 로딩

`HX-Trigger`와 같은 헤더에 의존할 수 없기 때문에, 클라이언트가 전체 화면 또는 응답에서 행만 필요하는지를 감지할 수 있는 다른 방법이 필요합니다. 새로운 쿼리 매개변수 `rows_only`를 도입하여 이를 해결할 수 있습니다. 이 매개변수가 `true`로 설정되면 뷰는 `rows.xml` 템플릿을 렌더링하여 요청에 응답합니다. 그렇지 않으면 `index.xml` 템플릿으로 응답할 것입니다:

#figure(
  caption: [`app.py`],
)[ ```py
@app.route("/contacts")
def contacts():
    search = request.args.get("q")
    page = int(request.args.get("page", 1))
    rows_only = request.args.get("rows_only") == "true" <1>
    if search:
        contacts_set = Contact.search(search)
    else:
        contacts_set = Contact.all(page)

    template_name = "hv/rows.xml" if rows_only else "hv/index.xml" <1>
    return render_template(template_name,
      contacts=contacts_set, page=page)
``` ]
1. 새로운 `rows_only` 쿼리 매개변수를 체크합니다.
2. `rows_only`에 근거하여 적절한 HXML 템플릿을 렌더링합니다.

우리가 만들어야 할 또 하나의 변경 사항이 있습니다. Flask는 대부분의 뷰가 HTML로 응답할 것이라고 가정합니다. 따라서 Flask는 `Content-Type` 응답 헤더의 기본값을 `text/html`으로 설정합니다. 하지만 하이퍼뷰 클라이언트는 HXML 콘텐츠를 수신받기를 기대하며, 이는 `Content-Type` 응답 헤더가 `application/vnd.hyperview+xml`이어야 함을 나타냅니다. 클라이언트는 다른 콘텐츠 타입의 응답을 거부합니다. 이를 해결하기 위해, Flask 뷰에서 `Content-Type` 응답 헤더를 명시적으로 설정해야 합니다. 새로운 도우미 함수 `render_to_response()`를 도입하여 이를 수행할 것입니다:

#figure(
  caption: [`app.py`],
)[ ```py
def render_to_response(template_name, *args, **kwargs):
    content = render_template(template_name, *args, **kwargs) <1>
    response = make_response(content) <2>
    response.headers['Content-Type'] =
      'application/vnd.hyperview+xml' <3>
    return response
``` ]
1. 제공된 인수와 키워드 인수를 가지고 주어진 템플릿을 렌더링합니다.
2. 렌더링된 템플릿으로 명시적 응답 객체를 생성합니다.
3. 응답의 `Content-Type` 헤더를 XML로 설정합니다.

보시다시피, 이 도우미 함수는 내부적으로 `render_template()`를 사용합니다. `render_template()`는 문자열을 반환합니다. 이 도우미 함수는 해당 문자열을 사용하여 명시적 `Response` 객체를 생성합니다. 응답 객체는 `headers` 속성을 가지고 있어 응답 헤더를 설정하고 변경할 수 있습니다. 구체적으로, `render_to_response()`는 하이퍼뷰 클라이언트가 콘텐츠를 인식하도록 `Content-Type`을 `application/vnd.hyperview+xml`로 설정합니다. 이 도우미는 우리의 뷰에서 `render_template`의 대체로 사용할 수 있습니다. 따라서 `contacts()` 함수의 마지막 줄만 업데이트하면 됩니다.

#figure(
  caption: [`contacts() 함수`],
)[ ```py
return render_to_response(template_name,
  contacts=contacts_set, page=page) <1>
``` ]
1. HXML 템플릿을 XML 응답으로 렌더링합니다.

`contacts()` 뷰에 이러한 변경을 적용함으로써, 우리는 마침내 우리의 노력의 결실을 볼 수 있습니다. 백엔드를 재시작하고 모바일 앱에서 화면을 새로 고치면 연락처 화면을 볼 수 있습니다!

#figure([#image("images/screenshot_hyperview_list.png")], caption: [
  연락처 화면
])

==== 연락처 검색

#index[Hyperview][search]
지금까지 우리는 연락처 목록이 표시된 화면을 가진 모바일 앱을 구축했습니다. 그러나 우리의 UI는 상호작용을 지원하지 않습니다. 검색 필드에 쿼리를 입력해도 연락처 목록이 필터링되지 않습니다. 타이핑 시 검색 상호작용을 구현하기 위해 검색 필드에 행동을 추가해보겠습니다. 이를 위해 `<text-field>`를 확장하여 `<behavior>` 요소를 추가해야 합니다.

#figure(
  caption: [Snippet of `hv/index.xml`],
)[ ```xml
<text-field name="q" value="" placeholder="검색..."
  style="search-field">
  <behavior
    trigger="change" <1>
    action="replace-inner" <2>
    target="contacts-list" <3>
    href="/contacts?rows_only=true" <4>
    verb="get" <5>
  />
</text-field>
``` ]
1. 이 행동은 텍스트 필드의 값이 변경될 때 트리거됩니다.
2. 행동이 트리거되면, 이 액션은 타겟 요소의 내용을 교체합니다.
3. 액션의 타겟은 ID가 `contacts-list`인 요소입니다.
4. 교체 콘텐츠는 이 URL 경로에서 가져옵니다.
5. 교체 콘텐츠는 `GET` HTTP 메소드로 가져옵니다.

첫 번째로 주목할 점은 텍스트 필드의 태그를 셀프 클로징 태그(`<text-field />`)에서 여는 태그와 닫는 태그(`<text-field>…​</text-field>`)로 변경했다는 것입니다. 이는 우리가 자식 `<behavior>` 요소를 추가하여 상호작용을 정의할 수 있도록 합니다.

`trigger="change"` 속성은 텍스트 필드의 값 변경 시 행동을 트리거하도록 하이퍼뷰에 알립니다. 사용자가 글자를 추가하거나 삭제하여 텍스트 필드의 내용을 편집할 때마다 행동이 트리거됩니다.

`<behavior>` 요소의 나머지 속성은 행동을 정의합니다. `action="replace-inner"`는 액션이 요소의 HXML 콘텐츠를 새 콘텐츠로 교체하여 화면의 내용을 업데이트함을 의미합니다. `replace-inner`가 제대로 작동하려면 두 가지를 알아야 합니다: 화면에서 현재 요소의 대상과 교체에 사용할 콘텐츠. `target="contacts-list"`는 현재 요소의 ID를 가리킵니다. 참고로, 우리는 `index.xml`의 `<list>` 요소에도 `id="contacts-list"`를 설정했습니다. 따라서 사용자가 텍스트 필드에 검색 쿼리를 입력하면, 하이퍼뷰는 `<list>`의 콘텐츠(여러 개의 `<item>` 요소)를 새 콘텐츠로 교체합니다(검색 쿼리와 일치하는 `<item>` 요소). 여기에서 도메인은 화면을 가져오기 위해 사용된 도메인으로부터 추론됩니다. `href`에 우리 `rows_only` 쿼리 매개변수가 포함된 점에 유의하세요. 우리는 응답에 행만 포함되도록 하길 원하며 전체 화면은 원하지 않습니다.

#figure([#image("images/screenshot_hyperview_search.png")], caption: [
  연락처 검색
])

모바일 앱에 타이핑 시 검색 기능을 추가하는 데 필요한 모든 것이 여기에 있습니다! 사용자가 검색 쿼리를 입력할 때, 클라이언트는 백엔드에 요청을 보내고 검색 결과로 목록을 대체합니다. 그러면 백엔드가 사용할 쿼리를 아는 방법에 대해 궁금할 수 있습니다. 행동의 `href` 속성에 백엔드에서 기대하는 `q` 매개변수가 포함되어 있지 않습니다. 그러나 기억하세요, `index.xml`에서 우리는 `<text-field>`와 `<list>` 요소를 `<form>` 요소로 감싸주었습니다. `<form>` 요소는 자식 요소로부터 초래된 HTTP 요청에 직렬화된 입력 그룹을 정의합니다. 이 경우, `<form>` 요소는 검색 동작과 텍스트 필드를 둘러싸고 있습니다. 따라서 `<text-field>`의 값이 our HTTP 요청에 포함됩니다. `GET` 요청을 하고 있기 때문에, 텍스트 필드의 이름과 값은 쿼리 매개변수로 직렬화됩니다. `href`에 있는 기존 쿼리 매개변수는 보존됩니다. 이는 우리의 실제 HTTP 요청이 `GET /contacts?rows_only=true&q=Car`처럼 보인다는 것을 의미합니다. 백엔드는 이미 `q` 매개변수를 검색을 위해 지원하므로, 응답에는 문자열 "Car"와 일치하는 행이 포함될 것입니다.

==== 무한 스크롤

#index[Hyperview][infinite scroll]
사용자가 수백 또는 수천 개의 연락처를 가지고 있다면, 이를 한 번에 모두 로드하는 것은 앱 성능이 저하될 수 있습니다. 그렇기 때문에 긴 목록이 있는 대부분의 모바일 앱은 "무한 스크롤"로 알려진 상호작용을 구현합니다. 앱은 목록에 100개의 고정 항목을 로드한다고 가정해봅시다. 사용자가 목록의 맨 밑으로 스크롤하면, 더 많은 콘텐츠가 로드되고 있다는 것을 나타내는 스피너가 보입니다. 콘텐츠가 준비되면 스피너가 다음 100개의 항목으로 대체됩니다. 이러한 항목은 목록에 추가되며, 기존 항목을 교체하지 않습니다. 따라서 목록에는 이제 200개의 항목이 포함됩니다. 사용자가 다시 목록의 맨 밑으로 스크롤하면 또 다른 스피너가 보이고, 앱은 다음 콘텐츠 세트를 로드할 것입니다. 무한 스크롤은 앱 성능을 두 가지 방법으로 향상시킵니다:
- 100개의 항목에 대한 초기 요청이 신속하게 처리되며, 예상 가능한 대기 시간을 가집니다.
- 후속 요청도 빠르고 예측 가능할 수 있습니다.
- 사용자가 목록의 맨 밑으로 스크롤하지 않으면, 앱은 후속 요청을 수행할 필요가 없습니다.

우리의 Flask 백엔드는 `/contacts` 엔드포인트에서 `page` 쿼리 매개변수를 통해 페이지 매김을 이미 지원하고 있습니다. HXML 템플릿을 수정하여 이 매개변수를 활용하기만 하면 됩니다. 이를 위해 `rows.xml`을 편집하여 Jinja for-loop 아래에 새 `<item>`을 추가하겠습니다:

#figure(caption: [Snippet of `hv/rows.xml`])[ ```xml
<items xmlns="https://hyperview.org/hyperview">
  {% for contact in contacts %}
    <item key="{{ contact.id }}" style="contact-item">
      <!-- 생략된 부분 -->
    </item>
  {% endfor %}
  {% if contacts|length > 0 %}
    <item key="load-more" id="load-more" style="load-more-item"> <1>
      <behavior
        trigger="visible" <2>
        action="replace" <3>
        target="load-more" <4>
        href="/contacts?rows_only=true&page={{ page + 1 }}" <5>
        verb="get"
      />
      <spinner /> <6>
    </item>
  {% endif %}
</items>
``` ]
1. 스피너를 표시하기 위해 목록에 추가 `<item>` 포함합니다.
2. 요소가 뷰포트에 보일 때 작성자의 행동이 트리거됩니다.
3. 트리거되면 이 행동이 화면의 요소를 교체합니다.
4. 화면에서 교체할 항목은 바로 그 항목(아이디 `load-more`)입니다.
5. 다음 페이지의 콘텐츠로 대체합니다.
6. 스피너 요소입니다.

현재 템플릿에 전달된 연락처 목록이 비어 있다면, 백엔드에서 가져올 추가 연락처가 없다고 가정할 수 있습니다. 따라서 Jinja 조건문을 사용하여 연락처 목록이 비어 있지 않을 때만 이 새로운 `<item>`을 포함합니다. 이 새로운 `<item>` 요소에는 ID와 행동이 있습니다. 이 행동은 무한 스크롤 상호작용을 정의합니다.

지금까지 우리는 `change` 및 `refresh`의 `trigger` 값을 보았습니다. 그러나 무한 스크롤을 구현하기 위해서는 사용자가 목록의 맨 밑으로 스크롤할 때 행동을 트리거할 수 있는 방법이 필요합니다. `visible` 트리거는 이 목적에 정확하게 사용될 수 있습니다. 이 행동이 있는 요소가 장치 뷰포트에 보일 때 이 행동이 트리거될 것입니다. 이 경우 새로운 `<item>` 요소는 목록의 마지막 항목이므로, 사용자가 해당 항목이 뷰포트에 들어갈 만큼 충분히 아래로 스크롤하면 행동이 트리거됩니다. 항목이 보이면 즉시 HTTP GET 요청을 하고 로딩하는 `<item>` 요소를 응답 콘텐츠로 대체할 것입니다.

우리의 `href`에는 `rows_only=true` 쿼리 매개변수가 포함되어야 하므로, 응답에는 연락처 항목에 대한 HXML만 포함되고 전체 화면은 포함되지 않습니다. 또한 우리는 `page`쿼리 매개변수를 전달하여 현재 페이지 번호를 증가시키고 다음 페이지를 로드합니다.

만약 항목이 여러 페이지일 경우 무엇이 발생할까요? 초기 화면은 처음 100개의 항목과 맨 아래에 "로드-더" 항목으로 포함됩니다. 사용자가 화면의 맨 밑으로 스크롤하면 하이퍼뷰는 두 번째 페이지의 항목(`&page=2`)을 요청하고, "로드-더" 항목은 새로운 항목으로 대체됩니다. 그러나 이 두 번째 페이지의 항목에도 새로운 "로드-더" 항목이 포함됩니다. 따라서 사용자가 두 번째 페이지의 모든 항목을 스크롤한 후, 하이퍼뷰는 다시 더 많은 항목(`&page=3`)을 요청합니다. 마찬가지로 "로드-더" 항목은 새로운 항목으로 대체될 것입니다. 이 프로세스는 화면에 모든 항목이 로드될 때까지 계속됩니다. 그 시점에서 반환할 연락처가 없으며, 응답에는 다른 "로드-더" 항목이 포함되지 않고 페이지 매김이 종료됩니다.

==== 당기기 새로 고침

#index[Hyperview][pull-to-refresh]
당기기 새로 고침은 모바일 앱에서 흔한 상호작용으로, 특히 동적인 콘텐츠가 있는 화면에서 그렇습니다. 이러한 방식으로 작동합니다: 스크롤 뷰의 맨 위에서 사용자는 아래로 스와이프 제스처로 스크롤링 콘텐츠를 끌어내립니다. 이는 콘텐츠 아래에 스피너를 표시합니다. 충분히 아래로 콘텐츠를 당기면 새로 고침이 트리거됩니다. 콘텐츠가 새로 고쳐지는 동안 스피너는 화면에 보입니다. 이는 사용자가 여전히 작업이 진행 중임을 나타내는 것입니다. 콘텐츠가 새로 고쳐지면, 콘텐츠는 기본 위치로 되돌아가 스피너를 숨기고 작업이 완료되었음을 사용자에게 알립니다.

#figure([#image("images/screenshot_hyperview_refresh_cropped.png")], caption: [
  당기기 새로 고침
])

이 패턴은 매우 흔하고 유용하기 때문에 하이퍼뷰의 `refresh` 액션을 통해 내장되어 있습니다. 우리의 연락처 목록에 당기기 새로 고침을 추가하여 이를 실행해 봅시다.

#figure(caption: [Snippet of `hv/index.xml`])[ ```xml
<list id="contacts-list"
  trigger="refresh" <1>
  action="replace-inner" <2>
  target="contacts-list" <3>
  href="/contacts?rows_only=true" <4>
  verb="get" <5>
>
  {% include 'hv/rows.xml' %}
</list>
``` ]
1. 이 행동은 사용자가 "당기기 새로 고침" 제스처를 수행할 때 트리거됩니다.
2. 행동이 트리거되면, 이 액션은 타겟 요소 내부의 콘텐츠를 교체합니다.
3. 액션의 타겟은 `<list>` 요소 자체입니다.
4. 교체 콘텐츠는 이 URL 경로에서 가져옵니다.
5. 교체 콘텐츠는 `GET` HTTP 메소드로 가져옵니다.

위의 코드 조각에서 비정상적인 점을 주목하세요: `<list>`에 `<behavior>` 요소를 추가하는 대신, 행동 속성을 `<list>` 요소에 직접 추가했습니다. 이는 단일 행동을 요소에 지정할 때 유용한 약식 표기법입니다. 이는 동일한 속성을 가진 `<behavior>` 요소를 `<list>`에 추가하는 것과 동일합니다.

그렇다면 왜 여기서 약식 구문을 사용했을까요? `replace-inner` 액션 때문입니다. 이 액션은 타겟의 모든 자식 요소를 새로운 콘텐츠로 교체합니다. 이는 `<behavior>` 요소도 포함합니다! 만약 우리의 `<list>`가 `<behavior>`를 포함하고 있었다면, 사용자가 검색 또는 당기기 새로 고침을 수행하면, 우리는 `rows.xml`의 내용을 사용하여 `<list>`의 내용을 대체할 것입니다. `<behavior>`는 더 이상 `<list>`에 정의되지 않을 것이고, 이후 당기기 새로 고침을 시도했을 때는 작동하지 않을 것입니다. `<list>`의 속성으로 행동을 정의함으로써, 목록의 항목을 교체할 때도 행동이 유지됩니다. 일반적으로, 우리는 HXML에서 명시적 `<behavior>` 요소를 사용하는 것을 선호합니다. 이는 여러 행동을 정의하고, 리팩토링하는 동안 행동을 이동하기 쉽게 만들어줍니다. 그러나 이런 상황에서 약식 구문을 사용하는 것은 좋습니다.

==== 연락처 세부 정보 보기 <_viewing_the_details_of_a_contact>
이제 우리의 연락처 목록 화면이 잘 구축되었으므로, 앱에 다른 화면을 추가하기 시작할 수 있습니다. 자연스러운 다음 단계는 사용자가 연락처 목록에서 항목을 탭할 때 나타나는 세부 정보 화면을 만드는 것입니다. 연락처 `<item>` 요소를 렌더링하는 템플릿을 업데이트하고 세부 정보 화면을 보여줄 행동을 추가합시다.

#figure(
  caption: [`hv/rows.xml`],
)[ ```xml
<items xmlns="https://hyperview.org/hyperview">
  {% for contact in contacts %}
    <item key="{{ contact.id }}" style="contact-item">
      <behavior trigger="press" action="push"
        href="/contacts/{{ contact.id }}" /> <1>
      <text style="contact-item-label">
        <!-- 생략된 부분 -->
      </text>
    </item>
  {% endfor %}
</items>
``` ]
1. 클릭 시 연락처 세부 정보 화면을 스택에 PUSH하는 행동.

우리의 Flask 백엔드에는 이미 `/contacts/<contact_id>`에서 연락처 세부 정보를 제공하는 경로가 있습니다. 템플릿에서는 Jinja 변수를 사용하여 For 루프에서 현재 연락처의 URL 경로를 동적으로 생성합니다. 또한 세부 정보를 보여주기 위해 "push" 액션을 사용하여 스택에 새 화면을 추가합니다. 앱을 다시 로드하면 목록의 모든 연락처를 탭할 수 있으며 하이퍼뷰는 새 화면을 엽니다. 그러나 새로운 화면에는 오류 메시지가 표시됩니다. 그 이유는 백엔드가 여전히 응답에서 HTML을 반환하고 있고 하이퍼뷰 클라이언트는 HXML을 기대하기 때문입니다. 백엔드를 업데이트 하여 HXML 및 적절한 헤더로 응답하도록 하겠습니다.

#figure(caption: [`app.py`])[ ```py
@app.route("/contacts/<contact_id>")
def contacts_view(contact_id=0):
    contact = Contact.find(contact_id)
    return render_to_response("hv/show.xml", contact=contact) <1>
``` ]
1. 새 템플릿 파일에서 XML 응답을 생성합니다.

`contacts()` 뷰와 마찬가지로, `contacts_view()`는 응답의 `Content-Type` 헤더를 설정하기 위해 `render_to_response()`를 사용합니다. 또한 새로운 HXML 템플릿에서 응답을 생성하고 있으며, 지금 바로 만들 수 있습니다:

#figure(
  caption: [`hv/show.xml`],
)[ ```xml
{% extends 'hv/layout.xml' %} <1>

{% block header %} <2>
  <text style="header-button">
    <behavior trigger="press" action="back" /> <3>
    뒤로
  </text>
{% endblock %}

{% block content %} <4>
<view style="details">
  <text style="contact-name">
    {{ contact.first }} {{ contact.last }}
  </text>

  <view style="contact-section">
    <text style="contact-section-label">전화번호</text>
    <text style="contact-section-info">{{contact.phone}}</text>
  </view>

  <view style="contact-section">
    <text style="contact-section-label">이메일</text>
    <text style="contact-section-info">{{contact.email}}</text>
  </view>
</view>
{% endblock %}
``` ]
1. 기본 레이아웃 템플릿을 확장합니다.
2. "뒤로" 버튼을 포함하기 위해 레이아웃 템플릿의 `header` 블록을 재정의합니다.
3. 클릭 시 이전 화면으로 이동하는 행동.
4. 선택된 연락처의 전체 세부 정보를 보여주기 위해 `content` 블록을 재정의합니다.

연락처 세부 정보 화면은 `index.xml`에서와 마찬가지로 기본 `layout.xml` 템플릿을 확장합니다. 이번에는 `header` 블록과 `content` 블록 모두에서 콘텐츠를 재정의하고 있습니다. 헤더 블록을 재정의하면 행동을 가진 "뒤로" 버튼을 추가할 수 있습니다. 클릭 시 하이퍼뷰 클라이언트는 내비게이션 스택을 풀어주고 사용자를 연락처 목록으로 되돌려 보냅니다.

이 행동을 트리거하는 것 외에도 뒤로 가는 방법은 여러 가지가 있습니다. 하이퍼뷰 클라이언트는 다양한 플랫폼에서 내비게이션 규칙을 존중합니다. iOS에서는 사용자가 장치의 왼쪽 가장자리에서 오른쪽으로 스와이프하여 이전 화면으로도 이동할 수 있습니다. Android에서는 사용자가 하드웨어 뒤로 버튼을 클릭하여도 이전 화면으로 이동할 수 있습니다. 이러한 상호작용을 얻기 위해 HXML에 추가로 명시할 필요는 없습니다.

#figure([#image("images/screenshot_hyperview_detail_cropped.png")], caption: [
  연락처 세부 정보 화면
])

몇 가지 간단한 변경만으로 우리는 단일 화면 앱에서 다중 화면 앱으로 발전했습니다. 이 새로운 화면을 지원하기 위해 실제 모바일 앱 코드를 변경할 필요가 없었다는 점에 유의하십시오. 이는큰 의미가 있습니다. 전통적인 모바일 앱 개발에서는 화면을 추가하는 것이 상당한 작업이 될 수 있습니다. 개발자는 새 화면을 만들고 내비게이션 구조의 적절한 위치에 삽입하고 기존 화면에서 새 화면을 열기 위해 코드를 작성해야 합니다. 하이퍼뷰에서는 `action="push"`가 있는 행동을 추가하는 것만으로 간단하게 해결할 수 있습니다.

=== 연락처 편집하기 <_editing_a_contact>
지금까지, 우리의 앱은연락처 목록을 탐색하고 특정 연락처의 세부 정보를 볼 수 있도록 해주었습니다. 연락처의 이름, 전화번호 또는 이메일을 업데이트할 수 있다면 좋지 않을까요? 다음 개선 사항으로 연락처를 편집할 수 있는 UI를 추가해 봅시다.

우선, 편집 UI를 어떻게 표시할 것인지 결정해야 합니다. 연락처 세부 정보 화면을 스택에 푸시하는 새 편집 화면을 추가할 수 있지만, 이는 사용자 경험 관점에서 가장 좋은 디자인은 아닙니다. 새 화면을 푸시하는 것은 목록에서 단일 아이템으로 드릴 다운하는 데이터 작업일 때 의미가 있습니다. 그러나 편집은 "드릴 다운" 상호작용이 아니라, 보기와 편집 모드 간의 전환입니다. 따라서 새로운 화면을 푸시하는 대신, 현재 화면을 편집 UI로 대체합시다. 이는 헤더에서 버튼 및 행동을 추가해야 함을 의미합니다. 연락처 세부 정보 화면의 헤더에 버튼을 추가할 수 있습니다.

#figure(
  caption: [Snippet of `hv/show.xml`],
)[ ```xml
{% block header %}
  <text style="header-button">
    <behavior trigger="press" action="back" />
    뒤로
  </text>

  <text style="header-button"> <1>
    <behavior trigger="press" action="reload"
      href="/contacts/{{contact.id}}/edit" /> <2>
    Edit
  </text>
{% endblock %}
``` ]
1. 새로운 "편집" 버튼.
2. 클릭 시 현재 화면을 편집 화면으로 새로 고침하는 행동.

한 번 더, 우리는 편집 UI를 위해 기존 Flask 경로(`/contacts/<contact_id>/edit`)를 재사용하고 있으며, Jinja 템플릿에 전달된 데이터의 사용으로 연락처 ID를 채워넣고 있습니다. 또한 `contacts_edit_get()` 뷰를 업데이트하여 HXML 템플릿(`hv/edit.xml`)을 기반으로 XML 응답을 반환해야 합니다. 우리는 코드 샘플을 생략할 것이며, 필요한 변경 사항은 이전 섹션에서 `contacts_view()`에 적용한 것과 동일합니다. 대신, 편집 화면을 위한 템플릿에 집중해 봅시다.

#figure(caption: [`hv/edit.xml`])[ ```xml
{% extends 'hv/layout.xml' %}

{% block header %}
  <text style="header-button">
    <behavior trigger="press" action="back" href="#" />
    뒤로
  </text>
{% endblock %}

{% block content %}
<form> <1>
  <view id="form-fields"> <2>
    {% include 'hv/form_fields.xml' %} <3>
  </view>

  <view style="button"> <4>
    <behavior
      trigger="press"
      action="replace-inner"
      target="form-fields"
      href="/contacts/{{contact.id}}/edit"
      verb="post"
    />
    <text style="button-label">저장</text>
  </view>
</form>
{% endblock %}
``` ]
1. 입력 필드 및 버튼을 감싸는 폼.
2. ID를 가진 컨테이너로 입력 필드가 포함됩니다.
3. 입력 필드를 렌더링하기 위한 템플릿 포함.
4. 폼 데이터를 제출하고 입력 필드 컨테이너를 업데이트하는 버튼.

편집 화면은 백엔드에게 데이터를 보내야 하므로 전체 콘텐츠 섹션을 `<form>` 요소로 감쌉니다. 이를 통해 폼 필드 데이터를 HTTP 요청에 포함할 수 있습니다. `<form>` 요소 내에서, 우리의 UI는 두 개의 섹션(폼 필드 및 저장 버튼)으로 나뉩니다. 실제 폼 필드는 별도의 템플릿(`form_fields.xml`)에 정의되어 있으며, Jinja 포함 태그를 사용하여 편집 화면에 추가됩니다.

#figure(
  caption: [`hv/form_fields.xml`],
)[ ```xml
<view style="edit-group">
  <view style="edit-field">
    <text-field name="first_name" placeholder="이름"
      value="{{ contact.first }}" /> <1>
    <text style="edit-field-error">{{ contact.errors.first }}</text> <2>
  </view>

  <view style="edit-field"> <3>
    <text-field name="last_name" placeholder="성"
      value="{{ contact.last }}" />
    <text style="edit-field-error">{{ contact.errors.last }}</text>
  </view>

  <!-- 연락처의 email 및 phone에 대한 동일한 마크업 -->
</view>
``` ]
1. 연락처의 이름에 대한 현재 값을 보유하는 텍스트 입력.
2. 연락처 모델의 오류를 표시할 수 있는텍스트 요소.
3. 연락처 성에 대한 다른 텍스트 필드.

우리는 연락처의 전화번호 및 이메일 주소에 대한 코드를 생략했습니다. 왜냐하면 이들도 이름 및 성의 첫 번째 텍스트 필드와 동일한 패턴을 따르기 때문입니다. 각 연락처 필드는 자신의 `<text-field>` 및 아래에 오류를 표시하기 위해 같은 `<text>` 요소를 가집니다. `<text-field>`에는 두 가지 중요한 속성이 있습니다:
- `name`은 텍스트 필드의 값을 HTTP 요청의 폼 데이터로 직렬화할 때 사용할 이름을 정의합니다. 이전 장의 웹 앱과 동일한 이름(`first_name`, `last_name`, `phone`, `email`)을 사용하고 있습니다. 그렇게 하면 백엔드에서 폼 데이터를 구문 분석하는 변경을 할 필요가 없습니다.
- `value`는 텍스트 필드에 사전 입력된 데이터를 정의합니다. 기존 연락처를 편집하고 있기 때문에 현재 이름, 전화번호 또는 이메일로 텍스트 필드를 사전 입력하는 것이 합리적입니다.

왜 우리는 폼 필드를 별도의 템플릿(`form_fields.xml`)에서 정의하기로 선택했는지 궁금할 수 있습니다. 이 결정의 배경을 이해하기 위해서는 먼저 "저장" 버튼에 대해 논의할 필요가 있습니다. 버튼이 눌리면 하이퍼뷰 클라이언트는 폼 필드 입력으로 직렬화된 데이터를 포함하여 `contacts/<contact_id>/edit`에 HTTP `POST` 요청을 하게 됩니다. HXML 응답은 폼 필드 컨테이너(ID `form-fields`)의 콘텐츠를 교체합니다. 하지만 이 응답은 무엇이어야 할까요? 이는 폼 데이터의 유효성에 따라 다릅니다:

1. 데이터가 유효하지 않으면(예: 중복 이메일 주소), 우리의 UI는 편집 모드에 남아 해당 필드의 오류 메시지를 표시합니다. 이는 사용자가 오류를 수정하고 다시 저장해볼 수 있도록 합니다.

2. 데이터가 유효하다면, 우리의 백엔드는 편집 내용을 유지하고 UI는 표시 모드(연락처 세부 정보 UI)로 돌아갑니다.

따라서 우리의 백엔드는 유효한 편집과 유효하지 않은 편집을 구분할 수 있어야 합니다. 이러한 두 시나리오를 지원하기 위해, Flask 앱의 기존 `contacts_edit_post()` 뷰에 몇 가지 변경을 해보겠습니다.

#figure(
  caption: [`app.py`],
)[ ```py
@app.route("/contacts/<contact_id>/edit", methods=["POST"])
def contacts_edit_post(contact_id=0):
    c = Contact.find(contact_id)
    c.update(
      request.form['first_name'],
      request.form['last_name'], 
      request.form['phone'], 
      request.form['email']) <1>
    if c.save(): <2>
        flash("연락처 업데이트 성공!")
        return render_to_response("hv/form_fields.xml",
          contact=c, saved=True) <3>
    else:
        return render_to_response("hv/form_fields.xml", contact=c) <4>
``` ]
1. 요청의 폼 데이터에서 연락처 객체를 업데이트합니다.
2. 업데이트를 지속하려고 시도합니다. 이는 유효하지 않은 데이터의 경우 `False`를 반환합니다.
3. 성공적이면 폼 필드 템플릿을 렌더링하고, 템플릿에 `saved` 플래그를 전달합니다.
4. 실패 시 폼 필드 템플릿을 렌더링합니다. 오류 메시지는 연락처 객체에 존재할 것입니다.

이 뷰는 이미 연락처 모델의 `save()` 성공 여부에 따른 조건 논리를 포함하고 있습니다. `save()`가 실패하면 `form_fields.xml` 템플릿을 렌더링합니다. `contact.errors`는 유효하지 않은 필드에 대한 오류 메시지를 포함하며, 이는 `<text style="edit-field-error">` 요소로 렌더링됩니다. `save()`가 성공하면 `form_fields.xml` 템플릿을 다시 렌더링합니다. 그러나 이번에는 템플릿이 `saved` 플래그를 받을 것입니다. 우리는 이 플래그를 채택하여, 원하는 UI를 구현하도록 템플릿을 업데이트할 수 있습니다: UI를 표시 모드로 전환합니다.

#figure(
  caption: [`hv/form_fields.xml`],
)[ ```xml
<view style="edit-group">
  {% if saved %} <1>
    <behavior
      trigger="load" <2>
      action="reload" <3>
      href="/contacts/{{contact.id}}" <4>
    />
  {% endif %}

  <view style="edit-field">
    <text-field name="first_name" placeholder="이름"
      value="{{ contact.first }}" />
    <text style="edit-field-error">{{ contact.errors.first }}</text>
  </view>

  <!-- 다른 필드에 대해 동일한 마크업 -->
</view>
``` ]
1. 연락처 업데이트 성공 후에만 이 행동을 포함할 것.
2. 행동을 즉시 트리거.
3. 현재 화면을 새로 고칩니다.
4. 연락처 세부 정보 화면으로 재로드합니다.

Jinja 템플릿 조건문은 우리의 행동이 성공적으로 저장될 때만 렌더링되도록 합니다. 초기 화면을 열거나 사용자가 유효하지 않은 데이터를 제출할 때는 렌더링되지 않습니다. 성공 시 템플릿은 행동을 포함하며, 이는 `trigger="load"` 덕분에 즉시 트리거됩니다. 이 액션은 현재 화면을 연락처 세부 정보 화면으로 재로드합니다(`/contacts/<contact_id>` 경로에서).

결과는? 사용자가 "저장" 버튼을 누르면 우리의 백엔드는 새 연락처 데이터를 지속하고 화면은 세부 정보 화면으로 전환됩니다. 앱은 연락처 세부 정보를 받기 위해 새로운 HTTP 요청을 하므로 새롭게 저장된 편집 내용을 보여줄 것입니다.

#sidebar[왜 리다이렉트하지 않을까요?][
웹 앱 버전의 이 코드가 다르게 작동했던 것을 기억할 수 있습니다. 성공적인 저장 후, 뷰는 `redirect("/contacts/" + str(contact_id))`를 반환했습니다. 이 HTTP 리다이렉트는 웹 브라우저에게 연락처 세부 정보 페이지로 이동하라는 요청입니다.

이 접근 방식은 하이퍼뷰에서는 지원되지 않습니다. 왜냐고요? 웹 앱의 내비게이션 스택은 단순합니다: 선형 페이지의 순서로, 항상 하나의 활성 페이지만 존재합니다. 모바일 앱의 내비게이션은 훨씬 더 복잡합니다. 모바일 앱은 중첩된 내비게이션 스택, 모달 및 탭의 구조를 사용합니다. 이 구조에서는 모든 화면이 활성 상태가 되며 사용자의 행동에 즉시 표시될 수 있습니다. 여기에서 하이퍼뷰 클라이언트는 HTTP 리다이렉트를 어떻게 해석해야 할까요? 현재 화면을 새로 고려야 할까요? 새로운 화면을 푸시해야 할까요? 아니면 동일한 URL로 스택에서 화면으로 이동해야 할까요?

최적이 아닌 선택을 하지 않기 위해, 하이퍼뷰는 다른 접근 방식을 채택합니다. 서버 제어 리다이렉트는 불가능하지만, 백엔드는 HXML에 내비게이션 행동을 렌더링할 수 있습니다. 이는 위의 코드에서 편집 UI에서 세부 정보 UI로 전환하는 방법입니다. 이를 클라이언트 측 리다이렉트 또는 클라이언트 측 내비게이션이라고 생각해보세요.
]
우리는 연락처 앱에 작업하는 편집 UI를 갖게 되었습니다. 사용자는 연락처 세부 정보 화면에서 버튼을 눌러 편집 모드로 진입할 수 있습니다. 편집 모드에서는 연락처의 데이터를 업데이트하고 백엔드에 저장할 수 있습니다. 사용자가 백엔드에서 편집을 유효하지 않게 거부하면, 앱은 편집 모드에 유지되고 유효성 검사 오류를 표시합니다. 백엔드가 유효성을 수용하고 편집을 지속할 경우, 앱은 세부 정보 모드로 다시 전환되어 업데이트된 연락처 데이터를 보여줍니다.

편집 UI에 한 가지 더 개선 사항을 추가해 보겠습니다. 사용자가 편집 모드에서 연락처를 저장할 필요 없이 전환할 수 있다면 좋을 것 같습니다. 이는 일반적으로 "취소" 동작을 제공하여 이루어집니다. 우리는 이것을 "저장" 버튼 아래에 새로운 버튼으로 추가할 수 있습니다.

#figure(
  caption: [Snippet of `hv/edit.xml`],
)[ ```xml
<view style="button">
  <behavior trigger="press" action="replace-inner"target="form-fields"
    href="/contacts/{{contact.id}}/edit" verb="post" />
  <text style="button-label">저장</text>
</view>
<view style="button"> <1>
  <behavior
    trigger="press"
    action="reload" <2>
    href="/contacts/{{contact.id}}" <3>
  />
  <text style="button-label">취소</text>
</view>
``` ]
1. 편집 화면의 새 취소 버튼.
2. 클릭 시 전체 화면을 새로 고침합니다.
3. 화면은 연락처 세부 정보 화면으로 새로 고쳐질 것입니다.

이는 우연히도 성공적으로 연락처를 편집한 후 편집 UI에서 세부 정보 UI로 전환하는 데 사용한 방법과 동일합니다. 그러나 "취소"를 누르면 UI가 업데이트되는 것이 "저장"을 누를 때보다 빠릅니다. 저장 시 앱은 먼저 데이터를 저장하기 위해 `POST` 요청을 하며, 그 후 세부 정보 화면에 대한 `GET` 요청을 하게 됩니다. 취소를 눌러도 `POST`를 건너 뛰고 즉시 `GET` 요청을 보내기 때문에 더 빠릅니다.

#figure([#image("images/screenshot_hyperview_edit.png")], caption: [
  연락처 편집 화면
])

==== 연락처 목록 업데이트하기 <_updating_the_contacts_list>
현재 이 장의 성공적으로 편집 UI를 구현했다고 주장할 수 있는 시점에 이르렀습니다. 그러나 문제가 하나 있습니다. 사실, 여기서 멈춘다면 사용자들은 앱이 버그가 있다고 생각할 수도 있습니다! 그 이유는 여러 화면에서 앱 상태를 동기화하는 문제입니다. 일련의 상호작용을 살펴보겠습니다:

1. 앱을 실행하여 연락처 목록으로 이동합니다.
2. 연락처 "Joe Blow"를 눌러 그의 연락처 세부 정보를 로드합니다.
3. 편집 버튼을 눌러 편집 모드로 전환하고 연락처의 이름을 "Joseph"로 변경합니다.
4. 저장 버튼을 눌러 보기 모드로 돌아갑니다. 연락처의 이름이 이제 "Joseph Blow"입니다.
5. 뒤로 버튼을 눌러 연락처 목록으로 돌아갑니다.

문제를 발견하셨나요? 우리의 연락처 목록은 앱을 실행했을 때와 동일한 이름 목록을 여전히 보여주고 있습니다. "Joseph"로 바꾼 연락처는 여전히 목록에서 "Joe"로 표시됩니다. 이는 하이퍼미디어 애플리케이션의 일반적인 문제입니다. 클라이언트는 UI의 다른 부분에서 공유 데이터 개념이 없습니다. 앱의 한 부분에서 업데이트가 발생하더라도 다른 부분은 자동으로 업데이트되지 않습니다.

운이 좋게도, 하이퍼뷰에는 이를 해결하는 방법이 있습니다: 이벤트입니다. 이벤트는 행동 시스템에 내장되어 있으며 UI의 다양한 부분 간에 경량 통신을 가능하게 합니다.

#sidebar[이벤트 행동][
#index[Hyperview][events]
이벤트는 하이퍼뷰의 클라이언트 측 기능입니다. 
#link("/client-side-scripting/#_hyperscript")[클라이언트 측 스크립팅]에서는 HTML, \_hyperscript 및 DOM으로 작업하면서 이벤트를 논의했습니다. DOM 요소는 사용자 상호작용의 결과로 이벤트를 발송합니다. 스크립트는 이러한 이벤트를 수신하고 임의의 JavaScript 코드를 실행하여 응답할 수 있습니다.

하이퍼뷰에서의 이벤트는 훨씬 더 간단하지만 스크립팅과는 필요하지 않으며 HXML에서 선언적으로 정의할 수 있습니다. 이는 행동 시스템을 통해 수행됩니다. 이벤트는 새 행동 속성, 액션 유형 및 트리거 유형을 추가해야 합니다:

- `event-name`: 이 `<behavior>`의 속성은 발송되거나 수신될 이벤트의 이름을 정의합니다.

- `action="dispatch-event"`: 트리거되면 이 행동은 `event-name` 속성에 정의된 이름의 이벤트를 발송합니다. 이 이벤트는 하이퍼뷰 앱 전체에 전역적으로 발송됩니다.

- `trigger="on-event"`: 이 행동은 앱의 다른 행동이 `event-name` 속성과 일치하는 이벤트를 발송할 때 트리거됩니다.

`<behavior>` 요소가 `action="dispatch-event"` 또는 `trigger="on-event"`를 사용하는 경우 이벤트 이름도 정의해야 합니다. 여러 행동이 동일한 이름의 이벤트를 발송할 수 있다는 점에 유의하세요. 마찬가지로 여러 행동이 동일한 이벤트 이름에서 트리거될 수 있습니다.

이 간단한 행동을 살펴봅시다:

`<behavior trigger="press" action="toggle" target="container" />`.

이 행동이 포함된 요소를 누르면 "container" ID를 가진 요소의 가시성이 토글됩니다. 그러나 우리가 토글하려는 요소가 다른 화면에 있다면? "토글" 행동과 타겟 ID 조회는 현재 화면에서만 작동하므로 이 해결책은 작동하지 않을 것입니다. 해결책은 두 개의 행동을 만들되 각 행동은 각 화면에 있으며, 이벤트를 통해 통신하는 것입니다:

- 화면 A:
  `<behavior trigger="press" action="dispatch-event" event-name="button-pressed" />`

- 화면 B:
  `<behavior trigger="on-event" event-name="button-pressed" action="toggle" target="container" />`

화면 A에서 첫 번째 행동이 있는 요소를 누르면 "button-pressed"라는 이름의 이벤트를 발송하게 됩니다. 두 번째 행동은 화면 B에서 이 이름의 이벤트가 트리거되면 "container" ID를 가진 요소의 가시성이 토글됩니다.

이벤트는 많은 용도가 있지만 가장 일반적인 용도는 백엔드 상태 변경을 다른 화면에 알리는 것입니다. 이러한 변경 사항은 UI를 새로 고치는 것을 요구할 수 있습니다.
]

우리는 이제 하이퍼뷰의 이벤트 시스템에 대해 충분히 알고 있습니다. 사용자가 연락처에 대한 변경 사항을 저장할 때, 세부 정보 화면에서 이벤트를 발송해야 합니다. 연락처 화면은 이 이벤트를 수신하고, 자신을 새로 고쳐 편집된 내용을 반영해야 합니다. 이미 `form_fields.xml` 템플릿은 백엔드가 연락처를 성공적으로 저장할 때 `saved` 플래그를 얻으므로 이벤트를 발송하기 좋은 장소입니다:

#figure(caption: [Snippet from `hv/form_fields.xml`])[ ```xml
{% if saved %}
  <behavior
    trigger="load" <1>
    action="dispatch-event" <2>
    event-name="contact-updated" <2>
  />
  <behavior <4>
    trigger="load"
    action="reload"
    href="/contacts/{{contact.id}}"
  />
{% endif %}
``` ]
1. 행동을 즉시 트리거 합니다.
2. 행동은 이벤트를 발송합니다.
3. 이벤트 이름은 "contact-updated"입니다.
4. 세부 UI를 보여주기 위한 기존 행동입니다.

이제 연락처 목록이 `contact-updated` 이벤트를 수신하고 자체적으로 새로 고쳐야 합니다:

#figure(caption: [Snippet from `hv/index.xml`])[ ```xml
<form>
  <behavior
    trigger="on-event" <1>
    event-name="contact-updated" <2>
    action="replace-inner" <3>
    target="contacts-list"
    href="/contacts?rows_only=true"
    verb="get"
  />
  <!-- 텍스트 필드 생략 -->
  <list id="contacts-list">
    {% include 'hv/rows.xml' %}
  </list>
</form>
``` ]
1. 이벤트 발송시 행동을 트리거 합니다.
2. 발송된 이벤트의 이름이 "contact-updated"일 때 행동을 트리거 합니다.
3. 트리거될 때, `<list>` 요소의 내용을 백엔드로부터의 행으로 교체합니다.

사용자가 연락처를 편집할 때마다 연락처 목록 화면은 수정 사항을 반영하여 업데이트됩니다. 이 두 `<behavior>` 요소의 추가로 버그가 수정되었습니다: 연락처 목록 화면은 목록에서 "Joseph Blow"를 올바르게 표시할 것입니다. 우리는 의도적으로 새로운 행동을 `<form>` 요소 내에 추가했습니다. 이는 트리거된 요청이 모든 검색 쿼리를 보존하도록 보장합니다.

무슨 의미인지 보여주기 위해, 제기했던 버그가 발생하는 단계 세트를 다시 살펴봅시다. 사용자가 "Joe"를 검색 필드에 입력하여 연락처를 검색했다고 가정합시다. 나중에 사용자가 연락처를 "Joseph Blow"로 업데이트하면 우리의 템플릿은 "contact-updated" 이벤트를 발송하고, 연락처 목록 화면에서 `replace-inner` 행동을 트리거합니다. `<form>` 요소 덕분에 "Joe"라는 검색 쿼리가 요청과 함께 직렬화됩니다:
`GET /contacts?rows_only=true&q=Joe`. "Joseph"라는 이름은 "Joe"라는 쿼리와 일치하지 않기 때문에 편집한 연락처는 목록에 나타나지 않습니다(사용자가 쿼리를 지울 때까지). 우리의 앱 상태는 백엔드와 모든 활성 화면 간에 일관성을 유지합니다.

이벤트는 행동에 대한 추상화 수준을 도입합니다. 지금까지 우리는 연락처를 편집하면 연락처 목록이 새로 고쳐질 것이라는 점을 보았습니다. 그러나 연락처 목록은 연락처 삭제 또는 새 연락처 추가와 같은 다른 작업 후에도 새로 고쳐야 합니다. 삭제 또는 생성을 위한 HXML 응답이 `contact-updated` 이벤트를 발송하는 행동을 포함하고 있기만 하면, 연락처 목록 화면에서 원하는 새로 고침 동작을 얻을 것입니다.

화면은 `contact-updated` 이벤트가 발송된 이유를 알 필요가 없습니다. 단지 이벤트가 발생했을 때 무엇을 해야 할지만 알고 있습니다.

=== 연락처 삭제하기 <_deleting_a_contact>
연락처 삭제와 관련하여, 이것은 구현할 다음 좋은 기능입니다. 사용자가 편집 UI에서 연락처를 삭제할 수 있도록 하겠습니다. 따라서 새로운 버튼을 `edit.xml`에 추가하겠습니다.

#figure(
  caption: [Snippet of `hv/edit.xml`],
)[ ```xml
<view style="button">
  <behavior trigger="press" action="replace-inner" target="form-fields"
    href="/contacts/{{contact.id}}/edit" verb="post" />
  <text style="button-label">저장</text>
</view>
<view style="button">
  <behavior trigger="press" action="reload"
    href="/contacts/{{contact.id}}" />
  <text style="button-label">취소</text>
</view>
<view style="button"> <1>
  <behavior
    trigger="press"
    action="append" <2>
    target="form-fields"
    href="/contacts/{{contact.id}}/delete" <3>
    verb="post"
  />
  <text style="button-label button-label-delete">연락처 삭제</text>
</view>
``` ]
1. 편집 화면의 "연락처 삭제" 버튼 추가.
2. 눌렀을 때 화면의 컨테이너에 HXML을 추가합니다.
3. HXML은 `POST /contacts/<contact_id>/delete` 요청을 통해 가져옵니다.

삭제 버튼의 HXML은 저장 버튼과 상당히 유사하지만 몇 가지 미묘한 차이가 있습니다. 기억하세요, 저장 버튼을 클릭하면 두 가지 예상되는 결과 중 하나가 발생합니다. 즉, 유효하지 않고 폼의 유효성 검사 오류를 표시하거나, 성공하고 연락처 세부 정보 화면으로 전환합니다. 첫 번째 결과를 지원하려면(유효하지 않고 오류를 표시해야 함) 저장 행동은 폼 필드 컨테이너(`<view id="form-fields">`)의 내용을 `form_fields.xml`의 새 버전으로 대체합니다. 따라서 `replace-inner` 액션을 사용하는 것은 의미가 있습니다.

삭제에는 유효성 검사 단계가 필요하지 않으므로 예상되는 결과는 오직 하나뿐입니다: 연락처를 성공적으로 삭제합니다. 삭제가 성공하면 연락처가 더 이상 존재하지 않습니다. 존재하지 않는 연락처의 편집 UI 또는 세부 정보를 표시하는 것은 의미가 없습니다. 대신, 우리의 앱은 이전 화면(연락처 목록)으로 돌아가야 합니다. 응답에는 즉시 트리거되는 행동만 포함됩니다. UI를 변경할 필요는 없습니다. 그러므로 `append` 액션을 사용하게 된다면, 현재 UI를 보존하면서 하이퍼뷰는 행동을 실행합니다.

#figure(
  caption: [Snippet of `hv/deleted.xml`],
)[ ```xml
<view>
  <behavior trigger="load" action="dispatch-event"
    event-name="contact-updated" /> <1>
  <behavior trigger="load" action="back" /> <2>
</view>
``` ]
1. 로드 시, 연락처 목록 화면을 업데이트하기 위해 `contact-updated` 이벤트를 발송합니다.
2. 연락처 목록 화면으로 돌아갑니다.

다시 말해, 행동이 돌아가는 것 외에도 이 템플릿은 `contact-updated` 이벤트를 발송하는 행동도 포함하고 있습니다. 이전 장 섹션에서 우리는 이 이벤트가 발송될 때 목록을 새로 고칠 행동을 `index.xml`에 추가했습니다. 삭제 후 이벤트를 발송함으로써, 삭제된 연락처는 목록에서 제거됩니다.

다시 한번, Flask 백엔드의 변경은 생략하겠습니다. 우리는 `contacts_delete()` 뷰를 업데이트하여 `hv/deleted.xml` 템플릿으로 응답해야 합니다. 또한 하이퍼뷰 클라이언트가 `GET`과 `POST`만 이해하므로, `DELETE`뿐만 아니라 `POST`를 지원하도록 경로를 업데이트해야 합니다.

우리는 이제 완전히 기능하는 삭제 기능을 갖추었습니다! 그러나 가장 사용자 친화적이지는 않습니다: 우연한 탭 한 번으로 연락처가 영구적으로 삭제됩니다. 연락처 삭제와 같은 파괴적인 작업에 대해서는 항상 사용자에게 확인 요청을 하는 것이 좋습니다.

우리는 삭제 행동에 대해 이전 장의 설명한 `alert` 시스템 행동을 사용하여 확인을 추가할 수 있습니다. 기억하시겠지만, `alert` 행동은 버튼으로 다른 행동을 트리거할 수 있는 시스템 다이얼로그 박스를 표시합니다. 삭제 `<behavior>`를 `action="alert"`를 사용하는 행동으로 감싸기만 하면 됩니다.

#figure(caption: [삭제 버튼 `hv/edit.xml`]) [ ```xml
<view style="button">
  <behavior <1>
    xmlns:alert="https://hyperview.org/hyperview-alert"
    trigger="press"
    action="alert"
    alert:title="삭제 확인"
    alert:message="정말로 {{ contact.first }}를 삭제하시겠습니까?"
  >
    <alert:option alert:label="확인"> <2>
      <behavior <3>
        trigger="press"
        action="append"
        target="form-fields"
        href="/contacts/{{contact.id}}/delete"
        verb="post"
      />
    </alert:option>
    <alert:option alert:label="취소" /> <4>
  </behavior>
  <text style="button-label button-label-delete">연락처 삭제</text>
</view>
``` ]
1. "삭제" 를 누를 때 주어진 제목과 메시지를 데이터로 사용하여 시스템 다이얼로그를 표시하는 행동을 트리거합니다.
2. 시스템 다이얼로그에서 첫 번째 눌 수 있는 옵션.
3. 첫 번째 옵션을 눌러 삭제가 가능합니다.
4. 두 번째 눌 수 있는 옵션은 행동이 없으므로 단지 다이얼로그를 닫는 역할만 합니다.

이전과 달리, 삭제 버튼을 누르면 즉각적인 효과를 가져오지 않습니다. 대신, 사용자에게 다이얼로그 박스가 표시되고 확인 또는 취소 여부를 요청받게 됩니다. 우리의 핵심 삭제 행동은 변경되지 않았으며, 다른 행동에서 연쇄됩니다.

#figure([#image("images/screenshot_hyperview_delete_cropped.png")], caption: [
  연락처 삭제 확인
])

=== 새로운 연락처 추가하기 <_adding_a_new_contact>
새 연락처 추가는 우리 모바일 앱에서 지원하고자 하는 마지막 기능입니다. 운 좋게도, 이 기능은 가장 쉽기도 합니다. 이미 구현한 기능의 개념(심지어 일부 템플릿)을 재사용할 수 있습니다. 특히, 새로운 연락처를 추가하는 것은 기존 연락처를 편집하는 것과 매우 유사합니다. 두 기능 모두:
- 연락처에 대한 정보를 수집하는 폼을 보여줘야 합니다.
- 입력된 정보를 저장하는 방법이 있어야 합니다.
- 폼에서 유효성 검사 오류를 표시해야 합니다.
- 유효성 검사 오류가 없으면 연락처를 지속해야 합니다.

기능이 너무 유사하기 때문에, 코드 샘플을 보여주지 않고 변경 사항을 요약하겠습니다.

1. `index.xml` 업데이트.

  - 새로운 "추가" 버튼을 추가하기 위해 `header` 블록을 재정의합니다.

  - 버튼에 행동 포함. 버튼을 눌렀을 때 모달로 새로운 화면을 푸시하고 `/contacts/new`에서 화면 콘텐츠를 요청합니다.

2. `hv/new.xml` 템플릿 생성.

  - 모달을 닫는 버튼을 포함하기 위해 헤더 블록을 재정의하고 `action="close"`를 사용합니다.

  - 빈 입력 필드를 렌더링하기 위해 `hv/form_fields.xml` 템플릿을 포함합니다.

  - 입력 필드 아래에 "연락처 추가" 버튼을 추가합니다.

  - 버튼에 행동을 포함합니다. 버튼을 누르면 `/contacts/new`에 `POST` 요청을 하고, 폼 필드를 업데이트하기 위한 `action="replace-inner"`을 사용합니다.

3. Flask 뷰 업데이트.

  - `contacts_new_get()`을 `render_to_response()`와 함께 `hv/new.xml` 템플릿을 사용하도록 변경합니다.

  - `contacts_new()`를 `render_to_response()`와 함께 `hv/form_fields.xml` 템플릿을 사용하도록 변경합니다. 새 연락처를 성공적으로 지속한 후에는 템플릿을 렌더링할 때 `saved=True`를 전달합니다.

연락처 추가와 편집을 위한 `form_fields.xml`를 재사용함으로써 우리는 일부 코드를 재사용하고 두 기능이 일관된 UI를 가지도록 할 수 있습니다. 또한 "새 연락처 추가" 화면은 `form_fields.xml`의 일부인 "saved" 논리의 이점을 받게 될 것입니다. 새로운 연락처를 성공적으로 추가한 후, 화면은 `contact-updated` 이벤트를 발송하게 되고, 이것은 연락처 목록을 새로 고쳐 추가된 연락처를 표시합니다. 화면은 연락처 세부 정보를 표시하기 위해 다시 로드됩니다.

#figure([#image("images/screenshot_hyperview_add.png")], caption: [
  새 연락처 추가 모달
])

=== 앱 배포

#index[Hyperview][deployment]
연락처 생성 UI의 완성과 함께, 우리는 완전히 구현된 모바일 앱을 가지고 있습니다. 연락처 목록을 검색하고, 연락처 세부 정보를 보고, 편집하고 삭제하며 새 연락처를 추가할 수 있습니다. 하지만 지금까지 우리는 데스크톱 컴퓨터의 시뮬레이터를 이용해 앱을 개발했습니다. 이를 실제 모바일 장치에서 보는 방법은? 그리고 사용자에게 전달하기 위해선 무엇을 해야 할까요?

물리적인 장치에서 앱이 실행되는 것을 보려면, Expo 플랫폼의 앱 미리보기 기능을 활용해 봅시다.

#[
#set enum(numbering: "1.", start: 1)
+ Android 또는 iOS 디바이스에 Expo Go 앱을 다운로드합니다.

+ Flask 앱을 재시작하고 네트워크에서 접근할 수 있는 인터페이스에 바인딩합니다. 이는 `flask run --host 192.168.7.229`와 같을 수 있으며, 여기서 호스트는 컴퓨터의 IP 주소입니다.

+ Hyperview 클라이언트 코드에서 `ENTRY_POINT_URL`을(를) Flask 서버가 바인딩된 IP 및 포트로 업데이트합니다.

+ 하이퍼뷰 데모 앱에서 `yarn start`를 실행하면 콘솔에 QR 코드가 인쇄되고, Android 및 iOS에서 스캔하는 방법에 대한 지침이 표시될 것입니다.
]

QR 코드를 스캔하면 전체 앱이 장치에서 실행됩니다. 앱과 상호작용하는 동안, Flask 서버에 HTTP 요청이 발생하는 것을 볼 수 있습니다. 개발 중 물리적 장치를 사용할 수도 있습니다. HXML에서 변경 사항을 만들 때마다, 화면을 새로 고쳐 UI 업데이트를 확인할 수 있습니다.

우리는 이제 물리적 장치에서 앱이 실행되고 있지만, 여전히 프로덕션 준비가 되지 않았습니다. 사용자에게 앱을 배포하기 위해 몇 가지 일을 해야 합니다:

#[
#set enum(numbering: "1.", start: 1)
+ 프로덕션으로 백엔드를 배포합니다. Flask 개발 서버 대신 Gunicorn과 같은 프로덕션 등급 웹 서버를 사용해야 합니다. 또한, 대부분 AWS 또는 Heroku와 같은 클라우드 제공업체를 사용하여 인터넷에 도달할 수 있는 머신에서 앱을 실행해야 합니다.

+ 독립형 바이너리 앱을 생성합니다. Expo 프로젝트의 지침을 따라 iOS 및 Android 플랫폼에 대한 `.ipa` 또는 `.apk` 파일을 생성할 수 있습니다. Hyperview 클라이언트에서 `ENTRY_POINT_URL`을 프로덕션 백엔드로 가리키도록 업데이트하는 것을 잊지 마세요.

+ 이진 파일을 iOS App Store 또는 Google Play Store에 제출하고, 앱 승인을 기다립니다.
]

앱이 승인되면 축하합니다! 우리의 모바일 앱은 Android 및 iOS 사용자에게 다운로드할 수 있습니다. 최상의 점은: 앱이 하이퍼미디어 아키텍처를 사용하기 때문에, 백엔드를 업데이트하기만 하면 앱에 기능을 추가할 수 있습니다. UI 및 상호작용은 서버 측 템플릿에서 생성된 HXML에 의해 완전히 명시됩니다. 화면의 새 섹션을 추가하고 싶으신가요? 기존 HXML 템플릿을 업데이트하기만 하면 됩니다. 앱에 새 유형의 화면을 추가하고 싶으신가요? 새로운 경로, 뷰 및 HXML 템플릿을 생성하십시오. 그런 다음 기존 화면에 새로운 화면을 열 수 있는 행동을 추가하기만 하면 됩니다. 이러한 변경 사항을 사용자에게 배포하려면, 백엔드를 재배포하면 됩니다. 우리 앱은 HXML을 해석하는 방법을 알며, 이는 새로운 기능을 처리하는 방법을 이해하는 데 충분합니다.

=== 하나의 백엔드, 여러가의 하이퍼미디어 포맷 <_one_backend_multiple_hypermedia_formats>

모바일 앱을 하이퍼미디어 아키텍처를 사용하여 만들기 위해, 우리는 웹 기반 연락처 앱에서 시작하여 몇 가지 변경을 했습니다. 주로 HTML 템플릿을 HXML 템플릿으로 바꾸는 것이었습니다. 하지만 모바일 앱에 서비스를 제공하기 위해 백엔드를 포팅하는 과정에서, 웹 애플리케이션의 기능이 사라졌습니다. 실제로 웹 브라우저에서 `http://0.0.0.0:5000`를 방문하려고 하면 텍스트와 XML 마크업이 뒤섞인 것을 보게 될 것입니다. 이는 웹 브라우저가 일반 XML을 렌더링하는 방법을 모르기 때문이며, HXML의 태그와 속성을 해석하여 앱을 렌더링하는 법도 모릅니다. 아쉬운 것은 웹 애플리케이션과 모바일 앱의 Flask 코드가 거의 동일하다는 점입니다. 데이터베이스와 모델 로직은 공유되고, 대부분의 뷰도 변경되지 않았습니다.

이 시점에서 여러분은 분명히 궁금할 것입니다: 동일한 백엔드를 사용하여 웹 애플리케이션과 모바일 앱을 모두 제공할 수 있을까요? 답은 예! 실제로 이것은 여러 플랫폼에서 하이퍼미디어 아키텍처를 사용하는 장점 중 하나입니다. 우리는 어떤 클라이언트 측 로직을 다른 플랫폼으로 포팅할 필요가 없으며, 적절한 하이퍼미디어 형식으로 요청에 응답하기만 하면 됩니다. 이를 위해 HTTP에 내장된 콘텐츠 협상을 활용할 것입니다.

==== 콘텐츠 협상이란 무엇인가? <_what_is_content_negotiation>
독일어 사용자와 일본어 사용자가 각각 자신의 웹 브라우저에서 `https://google.com`을 방문한다고 상상해 보세요. 그들은 각각 독일어와 일본어로 지역화된 구글 홈페이지를 볼 것입니다. 구글은 사용자의 선호 언어에 따라 홈페이지의 다른 버전을 반환하는 방법이 무엇일까요? 그 답은 REST 아키텍처에 있으며, 리소스와 표현의 개념을 분리하는 방식에 있습니다.

REST 아키텍처에서 구글 홈페이지는 고유한 URL로 표현되는 단일 "리소스"로 간주됩니다. 그러나 그 단일 리소스는 여러 개의 "표현"을 가질 수 있습니다. 표현은 리소스의 콘텐츠가 클라이언트에게 어떻게 전달되는지의 변형입니다. 독일어와 일본어 버전의 구글 홈페이지는 동일한 리소스의 두 가지 표현입니다. 리소스를 반환할 최적의 표현을 결정하기 위해, HTTP 클라이언트와 서버는 "콘텐츠 협상"이라 불리는 과정을 진행합니다. 여기서 그렇게 작동하는 방식은 다음과 같습니다:
- 클라이언트는 `Accept-*` 요청 헤더를 통해 선호하는 표현을 지정합니다.
- 서버는 가능한 한 최선의 표현에 맞추려 하며, 선택한 표현을 `Content-*`를 사용하여 다시 알립니다.

구글 홈페이지 예시에서 독일어 사용자는 독일어로 지역화된 콘텐츠를 선호하도록 설정된 브라우저를 사용합니다. 웹 브라우저에서 생성된 모든 HTTP 요청은 헤더 `Accept-Language: de-DE`를 포함합니다. 서버는 요청 헤더를 보고 가능한 경우 독일어로 지역화된 응답을 반환합니다. HTTP 응답에는 응답 콘텐츠의 언어를 알리기 위해 `Content-Language: de-DE` 헤더가 포함됩니다.

언어는 리소스 표현을 위한 하나의 요소일 뿐입니다. 우리에게 더 중요한 것은 리소스가 HTML 또는 HXML과 같은 다양한 콘텐츠 유형으로 표현될 수 있다는 것입니다. 콘텐츠 유형에 대한 콘텐츠 협상은 `Accept` 요청 헤더와 `Content-Type` 응답 헤더를 사용하여 수행됩니다. 웹 브라우저는 `Accept` 헤더에서 `text/html`을 선호하는 콘텐츠 유형으로 설정합니다. Hyperview 클라이언트는 `application/vnd.hyperview+xml`을 선호하는 콘텐츠 유형으로 설정합니다. 이렇게 하면 우리의 백엔드는 웹 브라우저와 Hyperview 클라이언트로부터 오는 요청을 구분하고 각각에 적합한 콘텐츠를 제공할 수 있습니다.

콘텐츠 협상에는 두 가지 주요 접근 방식이 있습니다: 세분화된 접근 방식과 글로벌 접근 방식입니다.

==== 접근 방식 1: 템플릿 전환 <_approach_1_template_switching>
우리가 웹에서 모바일로 연락처 앱을 포팅할 때, 모든 Flask 뷰를 유지했지만 몇 가지 사소한 변경을 했습니다. 구체적으로, 새로운 함수 `render_to_response()`를 도입하고, 각각의 뷰의 반환 문에서 호출했습니다. 기억을 되새기기 위해 그 함수는 다음과 같습니다:

#figure(caption: [`app.py`])[ ```py
def render_to_response(template_name, *args, **kwargs):
    content = render_template(template_name, *args, **kwargs)
    response = make_response(content)
    response.headers['Content-Type'] = 'application/vnd.hyperview+xml'
    return response
``` ]

`render_to_response()`는 주어진 컨텍스트로 템플릿을 렌더링하고, 적절한 하이퍼뷰 `Content-Type` 헤더와 함께 Flask 응답 객체로 변환합니다. 명백히, 이 구현은 우리의 Hyperview 모바일 앱에 서비스를 제공하는 데 매우 특정적입니다. 하지만 요청의 `Accept` 헤더에 따라 콘텐츠 협상을 수행하도록 함수를 수정할 수 있습니다:

#figure(
  caption: [`app.py`],
)[ ```py
HTML_MIME = 'text/html'
HXML_MIME = 'application/vnd.hyperview+xml'

def render_to_response(
    html_template_name, hxml_template_name, *args, **kwargs <1>
):
    response_type = request.accept_mimetypes.best_match(
      [HTML_MIME, HXML_MIME], default=HTML_MIME) <2>
    template_name =
      hxml_template_name
      if response_type == HXML_MIME
      else html_template_name <3>
    content = render_template(template_name, *args, **kwargs)
    response = make_response(content)
    response.headers['Content-Type'] = response_type <4>
    return response
``` ]
1. 함수 시그니처는 HTML과 HXML을 위한 두 개의 템플릿을 받습니다.
2. 클라이언트가 HTML 또는 HXML을 원하는지 결정합니다.
3. 클라이언트에 대한 최적의 일치를 기반으로 템플릿을 선택합니다.
4. 클라이언트에 대한 최적의 일치에 따라 `Content-Type` 헤더를 설정합니다.

Flask의 요청 객체는 콘텐츠 협상을 돕기 위해 `accept_mimetypes` 속성을 노출합니다. 우리는 두 가지 콘텐츠 MIME 유형을 `request.accept_mimetypes.best_match()`에 전달하고, 클라이언트에 맞는 MIME 유형을 반환받습니다. 최적의 매칭 MIME 유형에 기반하여 HTML 템플릿 또는 HXML 템플릿 둘 중 하나를 렌더링하도록 선택합니다. 또한 `Content-Type` 헤더를 적절한 MIME 유형으로 설정해야 합니다. 우리의 Flask 뷰에서 유일한 차이점은 HTML과 HXML 템플릿을 모두 제공해야 한다는 것입니다:

#figure(
  caption: [`app.py`],
)[ ```py
@app.route("/contacts/<contact_id>")
def contacts_view(contact_id=0):
    contact = Contact.find(contact_id)
    return render_to_response("show.html", "hv/show.xml",
      contact=contact)
``` ]
- 클라이언트를 기준으로 HTML 템플릿과 HXML 템플릿 간의 템플릿 전환 수행

모든 Flask 뷰를 업데이트하여 두 템플릿을 지원하게 되면, 우리의 백엔드는 웹 브라우저와 모바일 앱 모두를 지원하게 됩니다! 이 기술은 모바일 앱의 화면이 웹 애플리케이션의 페이지에 직접 매핑되기 때문에 연락처 앱에 잘 작동합니다. 각 앱은 연락처를 나열하고 세부 정보를 보여주고 편집하며 새로운 연락처를 생성하기 위한 전용 페이지(또는 화면)를 가지고 있습니다. 이로 인해 Flask 뷰를 주요 변경 없이 그대로 유지할 수 있었습니다.

하지만 만약 우리가 모바일 앱의 사용자 인터페이스를 다시 구상하고 싶다면 어떨까요? 아마도 우리는 모바일 앱이 단일 화면을 사용하고, 정보 보기 및 편집을 지원하기 위해 행이 인라인으로 확장되도록 하고 싶을 것입니다. 플랫폼 간 UI가 분기되는 상황에서는 템플릿 전환이 번거롭거나 불가능해질 수 있습니다. 한 가지 백엔드에서 두 가지 하이퍼미디어 형식을 제공하기 위해서는 다른 접근 방식이 필요합니다.

==== 접근 방식 2: 리디렉션 분기 <_approach_2_the_redirect_fork>
기억하시겠지만, 연락처 웹 앱에는 루트 경로 `/`에서 라우팅되는 `index` 뷰가 있습니다:

#figure(caption: [`app.py`])[ ```py
@app.route("/")
def index():
    return redirect("/contacts") <1>
``` ]
1. "/"에서 "/contacts"로 요청 리디렉션

웹 애플리케이션의 루트 경로에 대한 요청이 들어오면, Flask는 그들을 `/contacts` 경로로 리디렉션합니다. 이 리디렉션은 우리의 Hyperview 모바일 앱에서도 작동합니다. Hyperview 클라이언트의 `ENTRY_POINT_URL`은 `http://0.0.0.0:5000/`를 가리키며, 서버는 이를 `http://0.0.0.0:5000/contacts`로 리디렉션합니다. 하지만 웹 애플리케이션과 모바일 앱에서 동일한 경로로 리디렉션할 필요가 있다는 규칙은 없습니다. 리디렉션 경로를 결정하기 위해 `Accept` 헤더를 사용하면 어떨까요?

#figure(
  caption: [`app.py`],
)[ ```py
HTML_MIME = 'text/html'
HXML_MIME = 'application/vnd.hyperview+xml'

@app.route("/")
def index():
    response_type = request.accept_mimetypes.best_match(
      [HTML_MIME, HXML_MIME], default=HTML_MIME) <1>
    if response_type == HXML_MIME:
      return redirect("/mobile/contacts") <2>
    else:
      return redirect("/web/contacts") <3>
``` ]
1. 클라이언트가 HTML 또는 HXML을 원하는지 결정합니다.
2. 클라이언트가 HXML을 원한다면, `/mobile/contacts`로 리디렉션합니다.
3. 클라이언트가 HTML을 원한다면, `/web/contacts`로 리디렉션합니다.

진입점은 갈림길입니다: 클라이언트가 HTML을 원할 경우 하나의 경로로 리디렉션하고, HXML을 원할 경우 다른 경로로 리디렉션합니다. 이러한 리디렉션은 서로 다른 Flask 뷰에 의해 처리됩니다:

#figure(caption: [`app.py`])[ ```py
@app.route("/mobile/contacts")
def mobile_contacts():
  # HXML 응답 렌더링

@app.route("/web/contacts")
def web_contacts():
  # HTML 응답 렌더링
``` ]

`mobile_contacts()` 뷰는 연락처 목록을 포함하는 HXML 템플릿을 렌더링합니다. 연락처 항목을 탭하면 `mobile_contacts_view` 뷰에서 처리되는 `/mobile/contacts/1`로 요청된 화면이 열립니다. 초기 분기가 끝난 후, 모바일 앱의 모든 후속 요청은 `/mobile/`로 접두사가 붙은 경로로 이동하며, 모바일 전용 Flask 뷰에 의해 처리됩니다. 마찬가지로 웹 앱의 모든후속 요청은 `/web/`로 접두사가 붙은 경로로 이동하며, 웹 전용 Flask 뷰에 의해 처리됩니다. (실제로는 웹 뷰와 모바일 뷰를 코드베이스의 서로 다른 부분으로 분리하는 것이 좋습니다: `web_app.py`와 `mobile_app.py`. 브라우저의 주소 표시줄에 더 우아한 URL을 표시하고 싶다면 웹 경로에 `/web/` 접두사를 붙이지 않기로 선택할 수도 있습니다.)

여러분은 리디렉션 분기가 많은 코드 중복을 초래한다고 생각할 수 있습니다. 결국 우리는 웹 애플리케이션과 모바일 앱 각각에 대해 두 배의 수의 뷰를 작성해야 합니다. 이것은 사실이므로, 리디렉션 분기는 두 플랫폼이 불연속적인 뷰 로직 세트를 요구할 때만 선호됩니다. 만약 두 플랫폼에서 앱이 유사하다면, 템플릿 전환이 많은 시간을 절약하고 앱을 일관되게 유지할 수 있습니다. 리디렉션 분기를 사용하더라도, 우리의 모델에서 대부분의 로직은 두 세트의 뷰에서 공유될 수 있습니다.

실제로, 처음에는 템플릿 전환을 사용하다가 플랫폼 특정 기능 때문에 분기를 구현해야 한다는 것을 깨닫는 경우가 있을 수 있습니다. 사실 우리는 이미 연락처 앱에서 그렇게 하고 있습니다. 웹에서 모바일로 앱을 포팅할 때, 아카이브 기능과 같은 특정 기능을 가져오지 않았습니다. 동적 아카이브 UI는 모바일 장치에서 의미가 없는 강력한 기능입니다. 우리의 HXML 템플릿들이 아카이브 기능에 대한 어떤 진입점도 노출하지 않기 때문에, 이를 "웹 전용"으로 간주하고 Hyperview에서 이를 지원하는 것에 대해 걱정할 필요가 없습니다.

=== 하이퍼뷰의 Contacts.app <_contact_app_in_hyperview>
우리는 이 장에서 많은 내용을 다뤘습니다. 잠시 숨을 고르고 우리가 얼마나 발전했는지 다시 점검해 보세요: 우리는 Contacts.app 웹 애플리케이션의 핵심 기능을 모바일로 포팅했습니다. 그리고 우리는 우리의 Flask 백엔드를 많이 재사용하고 Jinja 템플릿을 그대로 유지하면서 이를 구현했습니다. 우리는 또한 애플리케이션의 다양한 측면을 연결하기 위해 이벤트의 유용성을 다시 한 번 보았습니다.

아직 끝나지 않았습니다. 다음 장에서는 모바일 Contact.app을 완성하기 위해 사용자 정의 동작과 UI 요소를 구현할 것입니다.

=== 하이퍼미디어 노트: API 엔드포인트 <_hypermedia_notes_api_endpoints>
JSON API와 달리, 하이퍼미디어 API는 하이퍼미디어 기반 애플리케이션의 UI 요구 사항에 맞게 특화된 엔드포인트를 제공해야 합니다.

하이퍼미디어 API는 범용 클라이언트가 소비하도록 설계되지 않았기 때문에, 일반화된 형태를 유지해야 한다는 압박에서 벗어나 특정 애플리케이션에 필요한 콘텐츠를 생성할 수 있습니다. 귀하의 엔드포인트는 특정 애플리케이션의 UI/UX 요구 사항을 지원하도록 최적화되어야 하며, 도메인 모델을 위한 범용 데이터 접근 모델이 아닙니다.

관련 팁은 하이퍼미디어 기반 API가 있을 때 JSON API 기반 SPA 또는 모바일 클라이언트를 작성할 때 강력히 권장되지 않는 방식으로 API를 적극적으로 리팩토링할 수 있다는 것입니다. 하이퍼미디어 기반 애플리케이션은 응용 상태의 엔진으로 하이퍼미디어를 사용하기 때문에, 애플리케이션 개발자와 사용 사례에 따라 이들을 변경할 수 있으며 실제로 그렇게 하는 것이 권장됩니다.

하이퍼미디어 접근 방식의 큰 강점은 API의 형태를 시간 경과에 따라 새로운 요구에 맞게 완전히 개편할 수 있으며, API의 버전 관리나 문서화가 필요 없다는 점입니다. 이를 적극적으로 활용하세요!
