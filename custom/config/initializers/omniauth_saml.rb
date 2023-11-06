OmniAuth.config.allowed_request_methods = %i[get post]

if Rails.application.secrets.saml_metadata_url.present?
  idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
  idp_metadata = idp_metadata_parser.parse_remote_to_hash(Rails.application.secrets.saml_metadata_url)
  idp_metadata[:issuer] = Rails.application.secrets.saml_issuer

  if Rails.application.secrets.saml_nameid_format.present?
    idp_metadata[:name_identifier_format] = Rails.application.secrets.saml_nameid_format
  end

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :saml, idp_metadata
  end

  Devise.setup do |config|
    options = {
      idp_cert_fingerprint: idp_metadata[:idp_cert_fingerprint],
      idp_sso_target_url: idp_metadata[:idp_sso_service_url]
    }
    if Rails.application.secrets.saml_nameid_format.present?
      options[:name_identifier_format] = Rails.application.secrets.saml_nameid_format
    end
    config.omniauth :saml, options
  end

  OneLogin::RubySaml::Attributes.single_value_compatibility = false
end
