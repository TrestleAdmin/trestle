Trestle.i18n.store({
  "ko": {
    "admin": {
      "breadcrumbs": {
        "home": "Home"
      },
      "buttons": {
        "delete": "%{model_name} 삭제",
        "edit": "%{model_name} 수정",
        "new": "%{model_name} 생성",
        "ok": "확인",
        "save": "%{model_name} 저장",
        "show": "%{model_name} 보기"
      },
      "datepicker": {
        "formats": {
          "date": "Y/m/d",
          "datetime": "Y/m/d h:i K",
          "time": "h:i K"
        }
      },
      "flash": {
        "create": {
          "failure": {
            "message": "하기된 에러를 확인하십시오.",
            "title": "경고!"
          },
          "success": {
            "message": "%{lowercase_model_name} 성공적으로 생성되었습니다.",
            "title": "성공!"
          }
        },
        "destroy": {
          "failure": {
            "message": "%{lowercase_model_name} 삭제할 수 없습니다.",
            "title": "경고!"
          },
          "success": {
            "message": "%{lowercase_model_name} 성공적으로 삭제되었습니다.",
            "title": "성공!"
          }
        },
        "update": {
          "failure": {
            "message": "하기된 에러를 확인하십시오.",
            "title": "경고!"
          },
          "success": {
            "message": "%{lowercase_model_name} 성공적으로 수정되었습니다.",
            "title": "성공!"
          }
        }
      },
      "form": {
        "select": {
          "prompt": "- %{attribute_name} 선택 -"
        }
      },
      "format": {
        "blank": "없음"
      },
      "table": {
        "headers": {
          "id": "ID"
        }
      },
      "titles": {
        "edit": "%{model_name} 수정",
        "index": "%{pluralized_model_name} 목록",
        "new": "%{model_name} 생성"
      }
    },
    "trestle": {
      "confirmation": {
        "cancel": "취소",
        "delete": "삭제",
        "title": "정말 하시겠습니까?"
      },
      "dialog": {
        "error": "완료될 수 없는 요청입니다."
      },
      "footer": "Powered by Trestle",
      "helpers": {
        "page_entries_info": {
          "more_pages": {
            "display_entries": "<b>%{total}</b> 중 <strong>%{first}&nbsp;-&nbsp;%{last}</strong> %{entry_name} 표시중"
          },
          "one_page": {
            "display_entries": {
              "one": "<strong>1</strong> %{entry_name} 표시중",
              "other": "<strong>모든 %{count}</strong> %{entry_name} 표시중",
              "zero": "%{entry_name}을(를) 찾을 수 없습니다."
            }
          }
        }
      },
      "onboarding": {
        "no_admins": "사용하시려면 <code>app/admin</code>에 admin을 생성하십시오.",
        "no_form": "form block을 정의하시거나 <code>_form.html</code> partial를 생성하십시오.",
        "no_template": "이 템플릿을 사용자화 하시려면, <code>%{path}</code>를 생성하십시오.",
        "welcome": "Trestle에 오신 것을 환영합니다."
      },
      "title": "Trestle Admin",
      "ui": {
        "toggle_navigation": "네비게이션 토글",
        "toggle_sidebar": "사이드바 토글"
      },
      "version": "버전"
    }
  }
});