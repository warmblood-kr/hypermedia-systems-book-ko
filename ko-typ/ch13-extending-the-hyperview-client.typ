#import "lib/definitions.typ": *

== 하이퍼뷰 클라이언트 확장하기

지난 장에서는 연락처 앱의 완전한 기능을 갖춘 네이티브 모바일 버전을 만들었습니다. 진입점 URL을 사용자화하는 것 외에는 모바일 장치에서 실행되는 코드에 손을 대지 않았습니다. Flask와 HXML 템플릿을 사용하여 모바일 앱의 UI와 로직을 백엔드 코드에서 완전히 정의했습니다. 이는 표준 하이퍼뷰 클라이언트가 모바일 앱의 모든 기본 기능을 지원하기 때문에 가능합니다.

하지만 표준 하이퍼뷰 클라이언트는 모든 것을 기본적으로 지원할 수는 없습니다. 앱 개발자로서 우리는 앱이 고유한 터치를 가지고 사용자 인터페이스나 플랫폼 기능과의 깊은 통합을 갖기를 원합니다. 이러한 요구를 지원하기 위해 하이퍼뷰 클라이언트는 사용자 정의 동작 및 UI 요소로 확장할 수 있도록 설계되었습니다. 이 섹션에서는 두 가지 예제를 사용하여 모바일 앱을 향상시키겠습니다.

시작하기에 앞서 사용할 기술 스택을 간단히 살펴보겠습니다. 하이퍼뷰 클라이언트는 모바일 앱을 만들기 위한 인기 있는 크로스 플랫폼 프레임워크인 React Native로 작성되었습니다. 이는 React와 동일한 구성 요소 기반 API를 사용합니다. 따라서 JavaScript와 React에 익숙한 개발자들은 React Native를 빠르게 익힐 수 있습니다. React Native는 오픈 소스 라이브러리의 건강한 생태계를 가지고 있습니다. 우리는 이러한 라이브러리를 활용하여 하이퍼뷰 클라이언트의 사용자 정의 확장을 만들 것입니다.

=== 전화 및 이메일 추가

#index[Hyperview][전화 통화]
우리의 연락처 앱에서 가장 뚜렷하게 부족한 기능인 전화 통화부터 시작하겠습니다. 모바일 장치는 전화 통화를 할 수 있습니다. 우리의 앱에 있는 연락처에는 전화 번호가 있습니다. 우리 앱이 그 전화 번호로 전화를 걸 수 있어야 하지 않을까요? 또한, 이와 동시에 우리의 앱은 연락처에 이메일을 보낼 수 있어야 합니다.

웹에서는 전화 번호에 대해 `tel:` URI 스킴을 사용하고, 이메일에 대해서는 `mailto:` URI 스킴을 지원합니다:

#figure(caption: [`tel` 및 `mailto` 스킴이 포함된 HTML])[ ```html
<a href="tel:555-555-5555">전화 걸기</a> <1>
<a href="mailto:joe@example.com">이메일 보내기</a> <2>
``` ]
+ 클릭 시 지정된 전화 번호로 전화를 걸라는 프롬프트 표시
+ 클릭 시 지정된 주소가 `to:` 필드에 채워진 이메일 클라이언트 열기.

하이퍼뷰 클라이언트는 `tel:` 및 `mailto:` URI 스킴을 지원하지 않습니다. 하지만 사용자 정의 동작으로 이러한 기능을 클라이언트에 추가할 수 있습니다. 동작은 HXML에서 정의된 상호작용을 의미합니다. 동작은 트리거("press", "refresh")와 액션("update", "share")이 있습니다. "action"의 값은 하이퍼뷰 라이브러리에 포함된 집합으로 제한되지 않습니다. 따라서 두 가지 새로운 동작, "open-phone" 및 "open-email"을 정의하겠습니다.

#figure(
  caption: [전화 및 이메일 동작],
)[ ```xml
<view
  xmlns:comms="https://hypermedia.systems/hyperview/communications"> <1>
  <text>
    <behavior action="open-phone"
      comms:phone-number="555-555-5555" /> <2>
    전화 걸기
  </text>
  <text>
    <behavior action="open-email"
      comms:email-address="joe@example.com" /> <3>
    이메일 보내기
  </text>
</view>
``` ]
+ 우리의 새로운 속성을 사용하는 XML 네임스페이스에 대한 별칭 정의.
+ 클릭 시 지정된 전화 번호로 전화를 걸라는 프롬프트 표시.
+ 클릭 시 지정된 주소가 `to:` 필드에 채워진 이메일 클라이언트 열기.

실제 전화번호와 이메일 주소를 별도의 속성을 사용하여 정의한 것을 주목하세요. HTML에서는 스킴과 데이터가 `href` 속성에 밀집되어 있습니다. HXML의 `<behavior>` 요소는 데이터를 표현할 수 있는 더 많은 옵션을 제공합니다. 우리는 속성을 사용하기로 선택했지만, 전화번호나 이메일을 자식 요소로 표현할 수도 있었습니다. 또한 향후 다른 클라이언트 확장과 충돌할 수 있는 가능성을 피하기 위해 네임스페이스를 사용하고 있습니다.

지금까지 잘 진행되고 있지만 하이퍼뷰 클라이언트는 `open-phone` 및 `open-email`을 해석하고 `phone-number` 및 `email-address` 속성을 참조하는 방법을 어떻게 알까요? 이제는 JavaScript를 작성해야 할 때입니다.

우선, 데모 앱에 3rd-party 라이브러리(`react-native-communications`)를 추가하겠습니다. 이 라이브러리는 전화 및 이메일과 관련된 OS 수준의 기능과 상호작용하는 간단한 API를 제공합니다.

```bash
cd hyperview/demo
yarn add react-native-communications <1>
yarn start <2>
```
+ `react-native-communications`에 대한 종속성 추가
+ 모바일 앱 재시작

다음으로, `open-phone` 동작과 관련된 코드를 구현하는 새 파일 `phone.js`를 생성하겠습니다:

#figure(
  caption: [demo/src/phone.js],
)[ ```js
import { phonecall } from 'react-native-communications'; <1>

const namespace = "https://hypermedia.systems/hyperview/communications";

export default {
  action: "open-phone", <2>
  callback: (behaviorElement) => { <3>
    const number = behaviorElement
      .getAttributeNS(namespace, "phone-number"); <4>
    if (number != null) {
      phonecall(number, false); <5>
    }
  },
};
``` ]
+ 필요로 하는 함수를 3rd-party 라이브러리에서 가져오기.
+ 동작의 이름.
+ 동작이 트리거될 때 실행되는 콜백.
+ `<behavior>` 요소에서 전화 번호 가져오기.
+ 3rd-party 라이브러리의 함수에 전화 번호 전달하기.

사용자 정의 동작은 두 개의 키로 정의된 JavaScript 객체로 만들어집니다: `action`과 `callback`. 이는 하이퍼뷰 클라이언트가 HXML의 사용자 정의 동작과 사용자 정의 코드와 연관짓는 방법입니다. 콜백 값은 단일 매개변수 `behaviorElement`를 받는 함수입니다. 이 매개변수는 동작을 트리거한 `<behavior>` 요소의 XML DOM 표현입니다. 그렇기 때문에 `getAttribute`와 같은 메소드를 호출하거나 `childNodes`와 같은 속성에 접근할 수 있습니다. 이 경우, `getAttributeNS`를 사용하여 `<behavior>` 요소의 `phone-number` 속성에서 전화 번호를 읽습니다. 전화 번호가 요소에 정의되어 있으면 `react-native-communications` 라이브러리에서 제공하는 `phonecall()` 함수를 호출할 수 있습니다.

사용자 정의 동작을 사용할 수 있기 전에 할 일이 하나 더 있습니다: 하이퍼뷰 클라이언트에 동작을 등록하는 것입니다. 하이퍼뷰 클라이언트는 `Hyperview`라는 React Native 구성 요소로 표현됩니다. 이 구성 요소는 사용자 정의 동작 객체의 배열인 `behaviors`라는 prop을 받습니다. 데모 앱의 `Hyperview` 구성 요소에 "open-phone" 구현을 전달하겠습니다.

#figure(caption: [demo/src/HyperviewScreen.js])[ ```js
import React, { PureComponent } from 'react';
import Hyperview from 'hyperview';
import OpenPhone from './phone'; <1>

export default class HyperviewScreen extends PureComponent {
  // ... 생략

  behaviors = [OpenPhone]; <2>

  render() {
    return (
      <Hyperview
        behaviors={this.behaviors} <3>
        entrypointUrl={this.entrypointUrl}
        // 추가 props...
      />
    );
  }
}
``` ]
+ open-phone 동작을 가져오기.
+ 사용자 정의 동작 배열 작성하기.
+ 사용자 정의 동작을 이야든 props로 `Hyperview` 구성 요소에 전달하기.

내부적으로 `Hyperview` 구성 요소는 HXML을 가져와 모바일 UI 요소로 변환하는 역할을 합니다. 또한 사용자의 상호작용에 따라 동작을 트리거하는 것을 처리합니다.

"open-phone" 동작을 Hyperview에 전달함으로써 이제는 `<behavior>` 요소의 `action` 속성에 대한 값을 사용할 수 있습니다. 사실지금 `show.xml` 템플릿을 업데이트하여 이를 수행하겠습니다:

#figure(
  caption: [hv/show.xml의 스니펫],
)[ ```xml
{% block content %}
<view style="details">
  <text style="contact-name">
    {{ contact.first }} {{ contact.last }}
  </text>

  <view style="contact-section">
    <behavior <1>
      xmlns:comms="https://hypermedia.systems/hyperview/communications"
      trigger="press"
      action="open-phone" <2>
      comms:phone-number="{{contact.phone}}" <3>
    />
    <text style="contact-section-label">전화</text>
    <text style="contact-section-info">{{contact.phone}}</text>
  </view>

  <view style="contact-section">
    <behavior <4>
      xmlns:comms="https://hypermedia.systems/hyperview/communications"
      trigger="press"
      action="open-email"
      comms:email-address="{{contact.email}}"
    />
    <text style="contact-section-label">이메일</text>
    <text style="contact-section-info">{{contact.email}}</text>
  </view>
</view>
{% endblock %}
``` ]
+ "press"에서 트리거되는 전화번호 섹션에 동작 추가하기.
+ 새 "open-phone" 동작을 트리거하기.
+ "open-phone" 동작에서 기대하는 속성 설정하기.
+ 같은 아이디어 구화, 다른 동작("open-email")로.

#index[Hyperview][이메일]
두 번째 사용자 정의 동작인 "open-email"의 구현은 생략하겠습니다. 짐작하겠지만, 이 동작은 시스템 수준의 이메일 작성기를 열어 사용자에게 연락처에 이메일을 보낼 수 있도록 할 것입니다. "open-email"의 구현은 "open-phone"와 거의 동일합니다. `react-native-communications` 라이브러리는 `email()`이라는 함수를 노출하므로, 이를 래핑하고 인자를 같은 방식으로 전달하면 됩니다.

이제 사용자 정의 동작으로 클라이언트를 확장하는 완전한 예제를 얻었습니다. 우리는 우리의 동작에 대해 새로운 이름("open-phone" 및 "open-email")을 선택하고 이 이름들을 함수와 연결했습니다. 이 함수들은 `<behavior>` 요소를 받아서 임의의 React Native 코드를 실행할 수 있습니다. 우리는 기존의 3rd-party 라이브러리를 래핑하고 `<behavior>` 요소에 설정된 속성을 읽어 라이브러리에 데이터를 전달했습니다. 우리의 데모 앱을 재시작한 후, 클라이언트는 HXML 템플릿에서 동작을 참조하여 즉시 활용할 수 있는 새로운 기능을 갖게 되었습니다.

=== 메시지 추가

#index[Hyperview][메시지]
이전 섹션에 추가된 전화 및 이메일 동작은 "시스템 동작"의 예입니다. 시스템 동작은 장치의 OS에서 제공하는 UI 또는 기능을 트리거합니다. 하지만 사용자 정의 동작은 OS 수준 API와의 상호작용에만 국한되지 않습니다. 동작을 구현하는 콜백은 임의의 코드를 실행할 수 있으며, 여기에는 우리 자신의 UI 요소를 렌더링하는 코드가 포함됩니다. 다음 사용자 정의 동작의 예는 바로 이러한 작업을 수행하여 사용자 정의 확인 메시지 UI 요소를 렌더링합니다.

우리가 기억하는 연락처 웹 앱은 연락처를 삭제하거나 생성하는 성공적인 작업 후에 메시지를 표시합니다. 이러한 메시지는 Flask 백엔드에서 `flash()` 함수를 사용하여 생성되며, 이는 뷰에서 호출됩니다. 그런 다음 기본 `layout.html` 템플릿이 최종 웹 페이지로 메시지를 렌더링합니다.

#figure(caption: [templates/layout.html의 스니펫], ```
{% for message in get_flashed_messages() %}
  <div class="flash">{{ message }}</div>
{% endfor %}
```)

우리의 Flask 앱은 여전히 `flash()` 호출을 포함하고 있지만, 하이퍼뷰 앱은 사용자에게 표시할 플래시된 메시지에 접근하지 않습니다. 이제 해당 지원을 추가하겠습니다.

우리는 웹 앱과 유사한 기법을 사용하여 메시지를 보여줄 수 있습니다: 메시지를 반복하며 `layout.xml`에서 몇 개의 `<text>` 요소를 렌더링하는 것입니다. 그러나 이 접근 방식에는 주요 단점이 있습니다: 렌더링된 메시지는 특정 화면에 묶여 있었습니다. 만약 해당 화면이 탐색 작업에 의해 숨겨지면, 메시지도 숨겨집니다. 우리가 원하는 것은 메시지 UI가 탐색 스택의 모든 화면 "위에" 표시되는 것입니다. 이렇게 하면 스택 변경하더라도 메시지가 계속 보이고(몇 초 후 사라짐), 메시지 UI를 화면이 아래에서 바뀌어도 유지할 수 있습니다. `<screen>` 요소 외부에 UI를 표시하기 위해, 우리는 하이퍼뷰 클라이언트를 새로운 사용자 정의 동작인 `show-message`로 확장해야 합니다. 또 다른 기회를 사용하여 오픈 소스 라이브러리인 `react-native-root-toast`를 사용하겠습니다. 이 라이브러리를 데모 앱에 추가하겠습니다.

```bash
cd hyperview/demo
yarn add react-native-root-toast <1>
yarn start <2>
```]
+ `react-native-root-toast`에 대한 종속성 추가
+ 모바일 앱 재시작

이제 사용자 정의 동작으로 메시지 UI를 구현하는 코드를 작성할 수 있습니다.

#figure(
  caption: [demo/src/message.js],
)[ ```js
import Toast from 'react-native-root-toast'; <1>

const namespace = "https://hypermedia.systems/hyperview/message";

export default {
  action: "show-message", <2>
  callback: (behaviorElement) => { <3>
    const text = behaviorElement.getAttributeNS(namespace, "text");
    if (text != null) {
      Toast.show(text, { <4>
        position: Toast.positions.TOP, duration: 2000
      });
    }
  },
};
``` ]
+ `Toast` API 가져오기.
+ 동작의 이름.
+ 동작이 트리거될 때 실행되는 콜백.
+ 메시지를 토스트 라이브러리에 전달하기.

이 코드는 `open-phone`의 구현과 매우 유사합니다. 두 콜백은 유사한 패턴을 따릅니다: `<behavior>` 요소에서 네임스페이딩된 속성을 읽고 그 값을 3rd-party 라이브러리에 전달합니다. 단순화를 위해 전달할 메시지를 화면의 맨 위에 보여주도록 하드코딩된 옵션을 사용하고, 2초 후에 사라지도록 설정했습니다. 하지만 `react-native-root-toast`는 위치, 애니메이션의 타이밍, 색상 등 많은 옵션을 제공합니다. 이러한 옵션을 사용하여 `behaviorElement`에서 추가 속성을 지정하여 동작을 더 구성 가능하게 만들 수 있습니다. 우리의 목적에 따라 기본적인 구현으로 진행하겠습니다.

이제 `<Hyperview>` 구성 요소에 메시지 동작을 등록해야 합니다. 하이퍼뷰 클라이언트에 동작을 등록하는 과정은 사용자 정의 동작을 등록하는 것과 유사합니다. 사용자 정의 구성 요소를 `Hyperview` 구성 요소에 `behaviors` props로 추가합니다.

#figure(caption: [demo/src/HyperviewScreen.js])[ ```js
import React, { PureComponent } from 'react';
import Hyperview from 'hyperview';
import OpenEmail from './email';
import OpenPhone from './phone';
import ShowMessage from './message'; <1>

export default class HyperviewScreen extends PureComponent {
  // ... 생략

  behaviors = [OpenEmail, OpenPhone, ShowMessage]; <2>

  // ... 생략
}
``` ]
+ `show-message` 동작 가져오기.
+ `Hyperview` 구성 요소에 동작을 `behaviors`라는 prop으로 전달하기.

이제 HXML에서 `show-message` 동작을 트리거할 준비가 되었습니다. 메시지를 표시할 때 세 가지 사용자 작업이 있습니다:

+ 새로운 연락처 생성
+ 기존 연락처 업데이트
+ 연락처 삭제

처음 두 동작은 같은 HXML 템플릿인 `form_fields.xml`을 사용하여 우리 앱에 구현되어 있습니다. 성공적으로 연락처를 생성하거나 업데이트할 때, 이 템플릿은 화면을 다시 로드하고 "load"에서 트리거되는 동작을 사용하여 이벤트를 트리거합니다. 삭제 동작도 "load"에서 트리거되는 동작을 사용하는 `deleted.xml` 템플릿을 사용합니다. 따라서 `form_fields.xml`과 `deleted.xml` 모두 로드 시 메시지를 표시하도록 수정해야 합니다. 실제 동작은 두 템플릿에서 동일할 것이므로 HXML을 재사용하는 공유 템플릿을 만듭시다.

#figure(caption: [hv/templates/messages.xml])[ ```xml
{% for message in get_flashed_messages() %}
  <behavior <1>
    xmlns:message="https://hypermedia.systems/hyperview/message"
    trigger="load" <2>
    action="show-message" <3>
    message:text="{{ message }}" <4>
  />
{% endfor %}
``` ]
+ 각각의 메시지를 표시하는 동작 정의.
+ 요소가 로드되면 즉시 이 동작을 트리거하십시오.
+ 새 "show-message" 동작 트리거하기.
+ "show-message" 동작은 플래시된 메시지를 UI에 표시합니다.

웹 앱의 `layout.html`처럼 플래시된 메시지를 모두 반복하면서 각 메시지에 대한 마크업을 렌더링합니다. 그러나 웹 앱에서는 메시지가 웹 페이지에 직접 렌더링되었습니다. 하이퍼뷰 앱에서는 각 메시지가 사용자 정의 UI를 트리거하는 동작을 사용하는 방식으로 표시됩니다. 이제 `form_fields.xml`에 이 템플릿을 포함할 필요가 있습니다.

#figure(
  caption: [hv/templates/form_fields.xml의 스니펫],
)[ ```xml
<view xmlns="https://hyperview.org/hyperview" style="edit-group">
  {% if saved %}
    {% include "hv/messages.xml" %} <1>
    <behavior trigger="load" once="true" action="dispatch-event"
      event-name="contact-updated" />
    <behavior trigger="load" once="true" action="reload"
      href="/contacts/{{contact.id}}" />
  {% endif %}
  <!-- 생략 -->
</view>
``` ]
+ 화면이 로드될 때마다 메시지를 표시합니다.

우리는 `deleted.xml`에서도 같은 작업을 할 수 있습니다:

#figure(
  caption: [hv/templates/deleted.xml의 스니펫],
)[ ```xml
<view xmlns="https://hyperview.org/hyperview">
  {% include "hv/messages.xml" %} <1>
  <behavior trigger="load" action="dispatch-event"
    event-name="contact-updated" />
  <behavior trigger="load" action="back" />
</view>
``` ]
+ 화면이 로드될 때마다 메시지를 표시합니다.

`form_fields.xml` 및 `deleted.xml` 모두에서 여러 동작이 "load"에서 트리거됩니다. `deleted.xml`에서는 이전 화면으로 즉시 탐색합니다. `form_fields.xml`에서는 현재 화면을 즉시 다시 로드하여 연락처 세부정보를 표시합니다. 메시지 UI 요소를 화면에 직접 렌더링하면 사용자가 화면이 사라지거나 다시 로드되기 전에 메시지를 거의 보지 못할 것입니다. 사용자 정의 동작을 사용하면 메시지 UI는 화면이 그 아래에서 변경되는 동안에도 여전히 표시됩니다.

#figure([#image("images/screenshot_hyperview_toast.png")], caption: [
  뒤로 탐색할 때 표시된 메시지
])

=== 연락처에 스와이프 제스처 추가 <_swipe_gesture_on_contacts>
통신 기능과 메시지 UI를 추가하기 위해 우리는 사용자 정의 동작으로 클라이언트를 확장했습니다. 그러나 하이퍼뷰 클라이언트는 화면에 렌더링되는 사용자 정의 UI 구성 요소로도 확장될 수 있습니다. 사용자 정의 구성 요소는 React Native 구성 요소로 구현됩니다. 즉, React Native에서 가능한 모든 것이 하이퍼뷰에서도 가능합니다! 사용자 정의 구성 요소는 하이퍼미디어 아키텍처로 풍부한 모바일 앱을 구축할 수 있는 무한한 가능성을 열어 줍니다.

가능성을 설명하기 위해, 우리는 우리의 모바일 앱에서 하이퍼뷰 클라이언트를 확장하여 "스와이프 가능한 행" 구성 요소를 추가할 것입니다. 작동 방식은 어떻게 될까요? "스와이프 가능한 행" 구성 요소는 수평 스와이핑 제스처를 지원합니다. 사용자가 이 구성 요소를 오른쪽에서 왼쪽으로 스와이프하면, 구성 요소가 이동하고 일련의 동작 버튼이 나타납니다. 각 동작 버튼은 눌렸을 때 표준 하이퍼뷰 동작을 트리거할 수 있습니다. 우리는 이 사용자 정의 구성 요소를 연락처 목록 화면에서 사용할 것입니다. 각 연락처 항목은 "스와이프 가능한 행"이 될 것이며, 동작은 연락처에 대한 편집 및 삭제 동작에 신속하게 접근할 수 있게 해 줄 것입니다.

#figure([#image("images/screenshot_hyperview_swipe.png")], caption: [
  스와이프 가능한 연락처 항목
])

==== 구성 요소 설계 <_designing_the_component>
스와이프 제스처를 처음부터 구현하는 대신, 우리는 다시 오픈 소스 3rd-party 라이브러리인 `react-native-swipeable`을 사용할 것입니다.

```bash
cd hyperview/demo
yarn add react-native-swipeable <1>
yarn start <2>
```]
+ `react-native-swipeable`에 대한 종속성 추가.
+ 모바일 앱 재시작.

이 라이브러리는 `Swipeable`이라는 React Native 구성 요소를 제공합니다. 이는 스와이프할 수 있는 주요 콘텐츠(스와이프 가능한 부분)로 임의의 React Native 구성 요소를 렌더링할 수 있습니다. 또한 행동 버튼으로 렌더링할 React Native 구성 요소의 배열을 prop으로 받습니다.

사용자 정의 구성 요소를 설계할 때는 코드 작성 전에 구성 요소의 HXML을 정의하는 것을 좋아합니다. 이렇게 하면 마크업이 표현력이 있지만 간결하도록 하고, 기본 라이브러리와 함께 작동하도록 할 수 있습니다.

스와이프 가능한 행을 위해 우리는 전체 구성 요소, 주요 콘텐츠 및 여러 버튼 중 하나를 표시하는 방법이 필요합니다.

```xml
<swipe:row
  xmlns:swipe="https://hypermedia.systems/hyperview/swipeable"> <1>
  <swipe:main> <2>
    <!-- 여기 표시된 주요 콘텐츠 -->
  </swipe:main>

  <swipe:button> <3>
    <!-- 스와이프할 때 나타나는 첫 번째 버튼 -->
  </swipe:button>

  <swipe:button> <4>
    <!-- 스와이프할 때 나타나는 두 번째 버튼 -->
  </swipe:button>
</swipe:row>
```]
+ 전체 스와이프 가능한 행을 캡처하는 상위 요소, 사용자 정의 네임스페이스 포함.
+ 스와이프 가능한 행의 주요 콘텐츠로, 임의의 HXML을 포함할 수 있습니다.
+ 스와이프할 때 나타나는 첫 번째 버튼으로, 임의의 HXML을 포함할 수 있습니다.
+ 스와이프할 때 나타나는 두 번째 버튼으로, 임의의 HXML을 포함할 수 있습니다.

이 구조는 주요 콘텐츠와 버튼을 명확히 구분합니다. 또한 하나, 두 개 이상의 버튼을 지원하며, 버튼은 정의된 순서대로 나타나므로 순서를 쉽게 바꿀 수 있습니다.

이 디자인은 연락처 목록을 위한 스와이프 가능한 행을 구현하는 데 필요한 모든 것을 다룹니다. 또한 재사용 가능할 정도로 일반적입니다. 이전 마크업에는 연락처 이름, 연락처 편집 또는 삭제와 관련된 특정 내용이 포함되어 있지 않습니다. 나중에 앱에 또 다른 목록 화면을 추가하면 이 구성 요소를 사용하여 해당 목록의 항목들을 스와이프 가능하게 만들 수 있습니다.

==== 구성 요소 구현 <_implementing_the_component>
사용자 정의 구성 요소의 HXML 구조를 잘 알았으니 이를 구현하는 코드를 작성할 수 있습니다. 그 코드는 어떻게 보일까요? 하이퍼뷰 구성 요소는 React Native 구성 요소로 작성됩니다. 이러한 React Native 구성 요소는 고유한 XML 네임스페이스 및 태그 이름에 매핑됩니다. 하이퍼뷰 클라이언트가 HXML에서 이 네임스페이스와 태그 이름을 탐지하면, HXML 요소의 렌더링을 해당 React Native 구성 요소에 위임합니다. 위임의 일환으로 하이퍼뷰 클라이언트는 여러 props를 React Native 구성 요소에 전달합니다:
- `element`: React Native 구성 요소에 매핑된 XML DOM 요소.
- `stylesheets`: `<screen>`에 정의된 스타일.
- `onUpdate`: 구성 요소가 동작을 트리거할 때 호출할 함수.
- `option`: 하이퍼뷰 클라이언트에서 사용하는 여러 설정.

우리의 스와이프 가능한 행 구성 요소는 임의의 주요 콘텐츠 및 버튼을 렌더링할 슬롯이 있는 컨테이너입니다. 이는 해당 UI의 이러한 부분을 렌더링하기 위해 하이퍼뷰 클라이언트에 다시 위임할 필요가 있음을 의미합니다. 이는 하이퍼뷰 클라이언트가 공개하는 `Hyperview.renderChildren()`이라는 함수로 수행됩니다.

이제 하이퍼뷰의 사용자 정의 구성 요소가 어떻게 구현되는지 알았으니, 스와이프 가능한 행을 위한 코드를 작성해 보겠습니다.

#figure(
  caption: [demo/src/swipeable.js],
)[ ```js
import React, { PureComponent } from 'react';
import Hyperview from 'hyperview';
import Swipeable from 'react-native-swipeable';

const NAMESPACE_URI = 'https://hypermedia.systems/hyperview/swipeable';

export default class SwipeableRow extends PureComponent { <1>
  static namespaceURI = NAMESPACE_URI; <2>
  static localName = "row"; <3>

  getElements = (tagName) => {
    return Array.from(this.props.element
      .getElementsByTagNameNS(NAMESPACE_URI, tagName));
  };

  getButtons = () => { <4>
    return this.getElements("button").map((buttonElement) => {
      return Hyperview.renderChildren(buttonElement,
        this.props.stylesheets,
        this.props.onUpdate,
        this.props.options); <5>
    });
  };

  render() {
    const [main] = this.getElements("main");
    if (!main) {
      return null;
    }

    return (
      <Swipeable rightButtons={this.getButtons()}> <6>
        {Hyperview.renderChildren(main,
          this.props.stylesheets,
          this.props.onUpdate,
          this.props.options)} <7>
      </Swipeable>
    );
  }
}
``` ]
+ 클래스 기반 React Native 구성 요소.
+ 주어진 HXML 네임스페이스에 이 구성 요소 매핑하기.
+ 주어진 HXML 태그 이름에 이 구성 요소를 매핑하기.
+ `<button>` 요소마다 React Native 구성 요소의 배열을 반환하는 함수.
+ 각 버튼을 렌더링하기 위해 하이퍼뷰 클라이언트에 위임하기.
+ 버튼과 주요 콘텐츠를 3rd-party 라이브러리에 전달하기.
+ 주요 콘텐츠 렌더링을 위해 하이퍼뷰 클라이언트에 위임하기.

`SwipeableRow` 클래스는 React Native 구성 요소를 구현합니다. 클래스 상단에서는 정적 `namespaceURI` 속성과 `localName` 속성을 설정합니다. 이러한 속성은 HXML의 고유한 네임스페이스 및 태그 이름 쌍에 이 React Native 구성 요소를 매핑합니다. 이는 하이퍼뷰 클라이언트가 HXML에서 사용자 정의 요소를 발견할 때 `SwipeableRow`에 위임해야 함을 알 수 있는 방법입니다. 클래스 하단에서는 `render()` 메서드를 볼 수 있습니다. `render()`는 React Native에 의해 호출되어 렌더링된 구성 요소를 반환합니다. React Native는 구성(composition) 원칙을 기반으로 하므로, `render()`는 일반적으로 다른 React Native 구성 요소의 조합을 반환합니다. 이 경우 `Swipeable` 구성 요소(`react-native-swipeable` 라이브러리에서 제공)를 반환하며, 버튼과 주요 콘텐츠에 대한 React Native 구성 요소와 함께 구성됩니다. 버튼과 주요 콘텐츠의 React Native 구성 요소는 이와 유사한 프로세스를 사용하여 생성됩니다:

- 특정 자식 요소(`button` 또는 `main`)를 찾습니다.
- 이러한 요소를 `Hyperview.renderChildren()`을 사용해 React Native 구성 요소로 변환합니다.
- 구성 요소를 `Swipeable`의 자식 또는 props로 설정합니다.

#asciiart(
  read("images/diagram/hyperview-components.txt"), caption: [클라이언트와 사용자 정의 구성 요소 간의 렌더링 위임],
)

React나 React Native를 다루어 본 적이 없다면 이 코드는 따라가기가 어려울 수 있습니다. 괜찮습니다. 중요한 점은: 임의의 HXML을 React Native 구성 요소로 변환하기 위한 코드를 작성할 수 있다는 것입니다. HXML의 구조(속성과 요소 모두)는 UI의 여러 측면(이 경우 버튼과 주요 콘텐츠)을 나타내는 데 사용될 수 있습니다. 마지막으로, 코드는 자식 구성 요소의 렌더링을 하이퍼뷰 클라이언트로 되돌아가 위임할 수 있습니다.

결과: 이 스와이프 가능한 행구성 요소는 완전히 일반적입니다. 주요 콘텐츠 및 버튼의 실제 구조와 스타일링 및 상호작용은 HXML에서 정의할 수 있습니다. 일반 구성 요소를 생성하면 다양한 용도로 여러 화면에서 재사용할 수 있습니다. 향후 더 많은 사용자 정의 구성 요소나 새로운 동작을 추가한다면 스와이프 가능한 행 구현에 맞게 작동할 것입니다.

마지막으로 해야 할 일은 하이퍼뷰 클라이언트에 이 새 구성 요소를 등록하는 것입니다. 프로세스는 사용자 정의 동작을 등록하는 것과 유사합니다. 사용자 정의 구성 요소는 `Hyperview` 구성 요소에 `components`라는 별도의 prop으로 전달됩니다.

#figure(caption: [demo/src/HyperviewScreen.js])[ ```js
import React, { PureComponent } from 'react';
import Hyperview from 'hyperview';
import OpenEmail from './email';
import OpenPhone from './phone';
import ShowMessage from './message';
import SwipeableRow from './swipeable'; <1>

export default class HyperviewScreen extends PureComponent {
  // ... 생략

  behaviors = [OpenEmail, OpenPhone, ShowMessage];
  components = [SwipeableRow]; <2>

  render() {
    return (
      <Hyperview
        behaviors={this.behaviors}
        components={this.components} <3>
        entrypointUrl={this.entrypointUrl}
        // 추가 props...
      />
    );
  }
}
``` ]
+ `SwipeableRow` 구성 요소 가져오기.
+ 사용자 정의 구성 요소 배열 만들기.
+ `Hyperview` 구성 요소에 사용자 정의 구성 요소를 `components`라는 prop으로 전달하기.

이제 우리의 HXML 템플릿을 업데이트하여 새 스와이프 가능한 행 구성 요소를 사용할 준비가 되었습니다.

===== 구성 요소 사용하기 <_using_the_component>
현재 목록의 연락처 항목에 대한 HXML은 `<behavior>` 및 `<text>` 요소로 구성되어 있습니다:

#figure(
  caption: [hv/rows.xml의 스니펫],
)[ ```xml
<item key="{{ contact.id }}" style="contact-item">
  <behavior trigger="press" action="push"
    href="/contacts/{{ contact.id }}" />
  <text style="contact-item-label">
    <!-- 생략 -->
  </text>
</item>
``` ]

우리의 스와이프 가능한 행 구성 요소로 이 마크업은 "주요" UI가 됩니다. 따라서 `<row>` 및 `<main>`을 조상 요소로 추가하겠습니다.

#figure(
  caption: [스와이프 가능한 행 추가 hv/rows.xml],
)[ ```xml
<item key="{{ contact.id }}">
  <swipe:row <1>
    xmlns:swipe="https://hypermedia.systems/hyperview/swipeable">
    <swipe:main> <2>
      <view style="contact-item"> <3>
        <behavior trigger="press" action="push"
          href="/contacts/{{ contact.id }}" />
        <text style="contact-item-label">
          <!-- 생략 -->
        </text>
      </view>
    </swipe:main>
  </swipe:row>
</item>
``` ]
+ 조상 요소로 `<swipe:row>` 추가, `swipe`에 대한 네임스페이스 별칭 정의.
+ 주요 콘텐츠를 정의하기 위해 `<swipe:main>` 요소 추가.
+ 기존 `<behavior>` 및 `<text>` 요소를 `<view>`로 감싸기.

이전에는 `contact-item` 스타일이 `<item>` 요소에 설정되었습니다. 이는 `<item>` 요소가 목록 항목의 주요 콘텐츠를 담고 있을 때 의미가 있었습니다. 그러나 이제 주요 콘텐츠가 `<swipe:main>`의 자식이므로 스타일을 적용할 새 `<view>`를 도입해야 합니다.

백엔드 및 모바일 앱을 다시 로드하면 연락처 목록 화면에서는 변경 사항이 없습니다. 액션 버튼이 정의되지 않았으므로 스와이프할 때 보여줄 것이 없습니다. 이제 스와이프 가능한 행에 버튼 두 개를 추가하겠습니다.

#figure(
  caption: [스와이프 가능한 행 추가 hv/rows.xml],
)[ ```xml
<item key="{{ contact.id }}">
  <swipe:row
    xmlns:swipe="https://hypermedia.systems/hyperview/swipeable">
    <swipe:main>
      <!-- 생략 -->
    </swipe:main>

    <swipe:button> <1>
      <view style="swipe-button">
        <text style="button-label">편집</text>
      </view>
    </swipe:button>

    <swipe:button> <2>
      <view style="swipe-button">
        <text style="button-label-delete">삭제</text>
      </view>
    </swipe:button>
  </swipe:row>
</item>
``` ]
+ 편집 작업을 위한 `<swipe:button>` 추가.
+ 삭제 작업을 위한 `<swipe:button>` 추가.

이제 모바일 앱을 사용하면 스와이프 가능한 행이 작동하는 것을 볼 수 있습니다! 연락처 항목을 스와이프하면 "편집" 및 "삭제" 버튼이 나타납니다. 그러나 아직 아무 일도 하지 않습니다. 이러한 버튼에 동작을 추가해야 합니다. "편집" 버튼은 간단합니다: 이를 누르면 연락처 세부정보 화면이 편집 모드로 열려야 합니다.

#figure(
  caption: [hv/rows.xml의 스니펫],
)[ ```xml
<swipe:button>
  <view style="swipe-button">
    <behavior trigger="press" action="push"
      href="/contacts/{{ contact.id }}/edit" /> <1>
    <text style="button-label">편집</text>
  </view>
</swipe:button>
``` ]
+ 눌리면 편집 연락처 UI가 있는 새 화면을 열기.

"삭제" 버튼은 좀 더 복잡합니다. 삭제를 위한 화면이 없으므로 사용자가 이 버튼을 누르면 무엇이 일어나야 할까요? 아마도 우리는 편집 연락처 화면의 "삭제" 버튼과 동일한 상호작용을 사용할 수 있습니다. 해당 상호작용은 사용자에게 삭제를 확인해달라는 시스템 다이얼로그를 프롬프트합니다. 사용자가 확인하면 하이퍼뷰 클라이언트는 `/contacts/<contact_id>/delete`에 `POST` 요청을 하고 응답을 화면에 추가합니다. 응답은 즉시 연락처 목록을 다시 로드하고 메시지를 표시하기 위한 몇 가지 동작을 트리거합니다. 이 작업이 우리의 작업 버튼에도 작동합니다:

#figure(
  caption: [hv/rows.xml의 스니펫],
)[ ```xml
<swipe:button>
  <view style="swipe-button">
    <behavior <1>
      xmlns:alert="https://hyperview.org/hyperview-alert"
      trigger="press"
      action="alert"
      alert:title="삭제 확인"
      alert:message="{{ contact.first }}을(를) 삭제하시겠습니까?"
    >
      <alert:option alert:label="확인">
        <behavior <2>
          trigger="press"
          action="append"
          target="item-{{ contact.id }}"
          href="/contacts/{{ contact.id }}/delete"
          verb="post"
        />
      </alert:option>
      <alert:option alert:label="취소" />
    </behavior>
    <text style="button-label-delete">삭제</text>
  </view>
</swipe:button>
``` ]
+ 눌리면 사용자가 작업을 확인하도록 요청하는 시스템 다이얼로그 박스 열기.
+ 확인되면 삭제 엔드포인트에 POST 요청을 하고 응답을 래핑하는 `<item>`에 추가하기.

이제 "삭제"를 누르면 예상대로 확인 다이얼로그가 나타납니다. 확인을 누르면 백엔드 반응이 메시지를 확인하고 연락처 목록을 다시 로드하는 동작을 트리거합니다. 삭제된 연락처의 항목은 목록에서 사라집니다.

#figure([#image("images/screenshot_hyperview_swipe_delete.png")], caption: [
  스와이프 버튼으로부터 삭제
])

액션 버튼은 `push`에서 `alert`까지 모든 유형의 동작을 지원할 수 있습니다. 원한다면 액션 버튼이 우리의 사용자 정의 동작인 `open-phone` 및 `open-email`을 트리거할 수 있습니다. 사용자 정의 구성 요소와 동작은 하이퍼뷰 프레임워크와 함께 제공되는 표준 구성 요소 및 동작과 자유롭게 혼합될 수 있습니다. 이는 하이퍼뷰 클라이언트에 대한 확장을 일급 기능처럼 느끼게 해줍니다.

사실, 비밀을 알려주겠습니다. 하이퍼뷰 클라이언트 내에서 표준 구성 요소와 동작은 사용자 정의 구성 요소와 동작과 동일한 방식으로 구현됩니다! 렌더링 코드는 `<view>`를 `<swipe:row>`와 다르게 처리하지 않습니다. 동작 코드는 `alert`를 `open-phone`와 다르게 처리하지 않습니다. 이는 모두 이 섹션에서 설명된 동일한 기술을 사용하여 구현됩니다. 표준 구성 요소와 동작은 모든 모바일 앱에 보편적으로 필요한 것들일 뿐입니다. 하지만 그들은 출발점일 뿐입니다.

대부분의 모바일 앱은 훌륭한 사용자 경험을 제공하기 위해 하이퍼뷰 클라이언트에 대한 몇 가지 확장이 필요합니다. 확장은 클라이언트를 일반 "하이퍼뷰 클라이언트"에서 특정 앱을 위한 목적 전용 클라이언트로 발전시킵니다. 그리고 중요한 것은 이 발전이 하이퍼미디어의 서버 주도 아키텍처와 그 모든 이점을 보존한다는 것입니다.

=== 모바일 하이퍼미디어 주도 애플리케이션 <_mobile_hypermedia_driven_applications>
모바일 Contact.app 구축을 마무리합니다. 코드 세부사항에서 한 발 물러서서 더 넓은 패턴을 고려해 보세요:
- 앱의 핵심 로직은 서버에 있습니다.
- 서버에서 렌더링된 템플릿이 웹 및 모바일 앱을 구동합니다.
- 플랫폼 사용자 정의는 웹 상에서 스크립팅을 통해 이루어지며, 모바일에서는 클라이언트 사용자 정의가 이루어집니다.

하이퍼미디어 주도 애플리케이션 아키텍처는 상당한 코드 재사용 및 관리 가능한 기술 스택을 허용했습니다. 웹과 모바일 모두에서의 지속적인 앱 업데이트와 유지보수는 동시에 진행될 수 있습니다.

예, 모바일에서 하이퍼미디어 주도 애플리케이션의 이야기가 있습니다.

=== 하이퍼미디어 노트: 충분히 좋은 UX와 상호 작용의 섬들 <_hypermedia_notes_good_enough_ux_and_islands_of_interactivity>
하이퍼미디어 접근 방식으로 오는 많은 SPA 및 네이티브 모바일 개발자들이 직면한 문제는 그들이 현재의 애플리케이션을 살펴보고 그것을 하이퍼미디어를 사용하여 정확히 구현하는 것을 상상하는 것입니다. htmx와 하이퍼뷰가 하이퍼미디어 주도 접근 방식으로 제공하는 사용자 경험을 상당히 향상시키지만, 특정 사용자 경험을 실현하는 것이 쉽지 않은 경우도 여전히 존재합니다.

2장에서 보았듯이 로이 필딩은 "특정 애플리케이션의 요구에 특정화된 것이 아니라 표준화된 형식으로 정보가 전송된다"라는 점에서 웹의 RESTful 네트워크 아키텍처와 관련된 이러한 트레이드오프를 언급했습니다.

특정 UX에 대한 덜 효율적이고 인터랙티브한 솔루션을 수용하는 것은 애플리케이션을 구축할 때 상당한 복잡성을 절약할 수 있습니다.

완벽함이 좋음의 적이 되지 않도록 하십시오. 일부 경우에 약간 덜 세련된 사용자 경험을 수용하면 많은 장점을 얻을 수 있으며, htmx 및 하이퍼뷰와 같은 도구들은 적절히 사용될 때 이러한 타협을 훨씬 더 용이하게 만듭니다.
