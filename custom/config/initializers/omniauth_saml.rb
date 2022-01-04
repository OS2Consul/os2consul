idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
idp_metadata = idp_metadata_parser.parse_remote_to_hash(Rails.application.secrets.saml_metadata_url)
idp_metadata[:issuer] = Rails.application.secrets.saml_issuer

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml, idp_metadata
end

Devise.setup do |config|
  config.omniauth :saml,
    idp_cert_fingerprint: idp_metadata[:idp_cert_fingerprint],
    idp_sso_target_url: idp_metadata[:idp_sso_target_url]
end
