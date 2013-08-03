# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#@hide_panel = () ->
#  unless $(".tabbable").position().left < 0
#    $(".tabbable").animate({"left": "-=310px"}, "slow")

@hide_panel = () ->
  if $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "+=315px"}, "slow").removeClass("showed")

#@show_panel = () ->
#  unless $(".tabbable").position().left > 0
#    $(".tabbable").animate({"left": "+=310px"}, "slow")

@show_panel = () ->
  unless $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "-=315px"}, "slow").addClass("showed")

@build_from = (coord) ->
  $('#coord_from').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

@build_to = (coord) ->
  $('#coord_to').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

build = (from = null, to = null) ->
  if from && to
#    modal.open({content:$("<p>Howdy</p>")})

    $.get('get_direction_info?from='+from+'&to='+to, (data) ->
        modal.open({content: data}))



$ ->
#  $('.gmnoprint[controlheight="356"]').css("left", "50px");
  $(".jquery-ui-date").datepicker()
  $(".tabbable li").click(show_panel)
#  $('.map_section').click ->
#    $('img[style*="left: -18px; top: -44px"]:first').trigger('click')

#  $('a').click(function(e){
#  e.stopImmediatePropagation();
#  alert('hi');
#});


$ ->
  $(".form-search").submit ->
    valuesToSubmit = $(this).serialize()
    $.ajax(
      url: $(this).attr("action")
      data: valuesToSubmit
      dataType: "script"
    )
    false

#@movie_contrils = () ->
#  if $('.gmnoprint[controlheight="356"]').children().length == 4
#    $('.gmnoprint[controlheight="356"]').css("left", "10px").css("top","110px")
#  else
#    setTimeout (->
#      @movie_contrils()
#      $('title').text($('title').text()+"+")
#    ), 100
#
#
#$(window).load ->
#  @movie_contrils()
#  setTimeout (->

#  ), 5000
