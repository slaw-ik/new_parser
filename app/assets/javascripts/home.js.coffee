# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


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
  $(".jquery-ui-date").datepicker()

