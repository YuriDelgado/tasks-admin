module ActivitiesHelper
  def static_stars(stars, max: 5)
    content_tag :div, class: "flex flex-row-reverse justify-end" do
      (1..max).to_a.reverse.map do |i|
        css = i <= stars.to_i ? "text-yellow-400" : "text-gray-300"

        content_tag :div, "★",
          class: "#{css} cursor-default transition-colors text-sm"
        end.join.html_safe
      end
  end
end
