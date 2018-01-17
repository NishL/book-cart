#encoding: utf-8
I18n.default_locale = :en

LANGUAGES = [
  ['English', 'en'],
  ['Espa&ntilde;ol'.html_safe, 'es']
]

# This code does two things:
# 1) It uses the I18n module to set the defualt_locale.
# 2) It defines a list of associations between display names and locale names.
#    We don't have a keyboard that can input a tilde above the 'n' in Espanol,
#    So we call html_safe on the string so that Rails knows the string is safe
#    to be interpreted as containing HTML, otherwise only the markup would be
#    displayed.
