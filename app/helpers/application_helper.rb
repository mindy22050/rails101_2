module ApplicationHelper
  def notice_message
    alert_types = { notice: :success, alert: :danger }
    close_botten_options = {class:"close", "data-dismiss" =>"alert" ,"aria-hidden" => true}
    close_botten = content_tag(:bottom, 'x',close_botten_options)

    alerts = flash.map do |type, message|
      alert_content =close_botten + message

      alert_type = alert_types[type.to_sym] ||type
      alert_class = "alert alert-#{alert_type} alert-dismissable"

      content_tag(:div, alert_content,class: alert_class)
    end

    alerts.join("\n").html_safe
  end
end
