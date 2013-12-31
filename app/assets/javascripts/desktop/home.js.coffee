# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@hide_panel = () ->
  if $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "+=315px"}, "slow").removeClass("showed")

@show_panel = () ->
  active_tab = $(this).hasClass('active')

  unless $(".tabbable").hasClass('showed')
    $(".tabbable").animate({"left": "-=315px"}, "slow").addClass("showed")
  else
    hide_panel() if active_tab

@build_from = (coord) ->
  $('#coord_from').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

@build_to = (coord) ->
  $('#coord_to').val(coord)
  build($('#coord_from').val(), $('#coord_to').val())

build = (from = null, to = null) ->
  if from && to
#    modal.open({content:$("<p>Howdy</p>")})

    $.get('get_direction_info?from=' + from + '&to=' + to, (data) ->
      modal.open({content: data}))


$ ->
  $(".tabbable li").click ->
   show_panel()

$ ->
  $('#header-search-form i').click ->
    $('#header-search-form .input-medium').val('')

$ ->
  $(".form-search").submit ->
    valuesToSubmit = $(this).serialize()
    $.ajax(
      url: $(this).attr("action")
      data: valuesToSubmit
      dataType: "script"
    )
    false