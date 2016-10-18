if Rails.env.development?
  Rails.application.config.action_cable.allowed_request_origins =  ['http://127.0.0.1:3000', 'https://magpie.imb.medizin.tu-dresden.de']
end
