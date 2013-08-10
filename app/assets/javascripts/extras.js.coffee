thisApp.directive('invertsIconColorWhenHovered', () ->
    {
        restrict: "A"
        link: (scope, element, attributes) ->
            element.bind("mouseover", () ->
                element.parent().removeClass("btn-link")
            )
            element.bind("mouseout", () ->
                element.parent().addClass("btn-link")
            )
    }
)
