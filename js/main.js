(function() {
  $(document).ready(function() {
    var mathHEiCont;
    mathHEiCont = function() {
      var fh, hh, wh, сh;
      hh = $('header').height();
      fh = $('footer').height();
      wh = $(window).height();
      сh = wh - hh - fh - 30;
      return $('.content').css('min-height', сh);
    };
    mathHEiCont();
    return $(window).resize(function() {
      return mathHEiCont();
    });
  });

}).call(this);

(function() {
  $(document).ready(function() {});

}).call(this);
