$ ->
  $(".square").on "click", (e) ->
    $.post '/squares', { x_value: $(e.target).context.dataset["x"], y_value: $(e.target).context.dataset["y"], board: $(e.target).context.dataset["board"] }