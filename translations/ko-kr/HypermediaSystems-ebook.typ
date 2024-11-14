
#import "lib/definitions-ko-kr.typ": *

#set document(
  title: [하이퍼미디어 시스템],
)

#show figure.where(kind: "image"): box

#page[
  #set align(start + horizon)
  #set par(leading: 10pt, justify: false)
  #show heading: set text(size: 3em, font: display-font)
  #skew(
    -0.174, // -10deg
    upper(
      text(style: "oblique", heading(level: 1, outlined: false, [하이퍼미디어 시스템])),
    ),
  )
  #box(height: 1em)
  #set text(font: secondary-font)
  #grid(gutter: 1em, columns: 3 * (auto,),
    [카슨 그로스],
    [아담 스테핀스키],
    [데니즈 악심색],
  )
]

#include "-1-copy-ack.typ"

#pagebreak()

= 감사의 말

#include "-2-dedication.typ"

#pagebreak()

#counter(page).update(0)

#include "-3-foreword.typ"

= 하이퍼미디어 개념

#include "ch00-introduction.typ"
#include "ch01-hypermedia-a-reintroduction.typ"
#include "ch02-components-of-a-hypermedia-system.typ"
#include "ch03-a-web-1-0-application.typ"

= 하이퍼미디어 기반 웹 애플리케이션과 Htmx

#include "ch04-extending-html-as-hypermedia.typ"
#include "ch05-htmx-patterns.typ"
#include "ch06-more-htmx-patterns.typ"
#include "ch07-a-dynamic-archive-ui.typ"
#include "ch08-tricks-of-the-htmx-masters.typ"
#include "ch09-client-side-scripting.typ"
#include "ch10-json-data-apis.typ"

= 모바일로 하이퍼미디어 제공하기

#include "ch11-hyperview-a-mobile-hypermedia.typ"
#include "ch12-building-a-contacts-app-with-hyperview.typ"
#include "ch13-extending-the-hyperview-client.typ"

= 결론

#include "ch14-conclusion.typ"
