$(document).ready ->


# ------  Footer Bottom
  mathHEiCont = () ->
    hh = $('header').height() # высота header
    fh = $('footer').height() # высота footer
    wh = $(window).height() # высота window
      # считаем оптимальную высоту для блока с контентом
    сh = wh - hh - fh - 30
      # применяем посчитанную высоту
    $('.content').css 'min-height', сh

  mathHEiCont()

  $( window ).resize ->
    mathHEiCont()
