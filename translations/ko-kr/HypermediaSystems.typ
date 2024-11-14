
#import "lib/definitions-ko-kr.typ": *
#import "lib/style-ko-kr.typ": *

#show: hypermedia-systems-book(
  [Hypermedia Systems], authors: ("카슨 그로스", "아담 스테핀스키", "데니즈 악심색"),
  frontmatter: {
    page(include "-1-copy-ack.typ", header: none, numbering: none)
    page({
      include "-2-dedication.typ"
    }, header: none, numbering: none)
    page(counter(page).update(0),
      header: none, numbering: none)
    include "-3-foreword.typ"
  },
)

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

= Conclusion

#include "ch14-conclusion.typ"
