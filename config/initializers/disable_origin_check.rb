# Disabling this for the current janky way of forwarding requests
# through the CDN in production to origin.
#
Rails.application.config.action_controller.forgery_protection_origin_check = false
