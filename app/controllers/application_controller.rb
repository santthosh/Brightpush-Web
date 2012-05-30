class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_affiliate_cookie
  before_filter :set_mailer_url_options
  before_filter :collect_billing_info
  before_filter :initialize_bucket_name

  helper_method :current_account, :admin?

  protected

    # This is used throughout the app to scope queries, like
    # current_account.users, etc.
    def current_account(raise_on_not_found = true)
      if !request.subdomain.present? || request.subdomain.casecmp("www") == 0
        @current_account = Account.first
        return @current_account
      end

      @current_account ||= Account.find_by_full_domain(request.host) || (Rails.env.development? ? Account.first : nil)
      raise ActiveRecord::RecordNotFound if !@current_account && raise_on_not_found
      @current_account
    end

    # Whether a user is the admin for the account loaded by the
    # current subdomain
    def admin?
      user_signed_in? && current_user.admin?
    end

    def set_affiliate_cookie
      if !params[:ref].blank? && affiliate = SubscriptionAffiliate.find_by_token(params[:ref])
        cookies[:affiliate] = { :value => params[:ref], :expires => 1.month.from_now }
      end
    end

    def set_mailer_url_options
      ActionMailer::Base.default_url_options[:host] = current_account(false).try(:full_domain)
    end

    # Redirect to the billing page if the user needs to enter
    # payment info before being able to use the app
    def collect_billing_info
      return if self.class.to_s.match(/^Devise/) # Don't prevent logins, etc.
      return unless account = current_account # Nothing to do if there is no account
      return if !(sub = account.subscription) || sub.state.nil?
      return if sub.state == 'active' && sub.current? && !sub.needs_payment_info?
      return if sub.state == 'trial' && (!Saas::Config.require_payment_info_for_trials || !sub.needs_payment_info?)
      redirect_to billing_account_path
    end
    # Checking for authentication
    def authorized?
      redirect_to new_user_session_url unless (user_signed_in? && self.action_name == 'index') || admin?
    end
    
    def initialize_bucket_name
      if request.host == 'brightpush.in'
        $domain_name = "brightpush_application_icons"
        $application_icons = "brightpush_application_icons"
        $development_certificate_pkcs12 = "brightpush_development_ios_certificate_pkcs12"
        $production_certificate_pkcs12 = "brightpush_production_ios_certificate_pkcs12"
        $certificate_pem = "brightpush_ios_certificates_pem"
        $c2dm_token = "brightpush_c2dm_token_txt"
      elsif request.host == 'brightpushalpha.in'
        $domain_name = "in.brighpushalpha.notifications"
        $application_icons = "alpha_brightpush_application_icons"
        $development_certificate_pkcs12 = "alpha_brightpush_development_ios_certificate_pkcs12"
        $production_certificate_pkcs12 = "alpha_brightpush_production_ios_certificate_pkcs12"
        $certificate_pem = "alpha_brightpush_ios_certificates_pem"
        $c2dm_token = "alpha_brightpush_c2dm_token_txt"
      elsif request.host == 'brightpushbeta.in'
        $domain_name = "in.brighpushbeta.notifications"
        $application_icons = "beta_brightpush_application_icons"
        $development_certificate_pkcs12 = "beta_brightpush_development_ios_certificate_pkcs12"
        $production_certificate_pkcs12 = "beta_brightpush_production_ios_certificate_pkcs12"
        $certificate_pem = "beta_brightpush_ios_certificates_pem"
        $c2dm_token = "beta_brightpush_c2dm_token_txt"
      else
        $domain_name = "in.localhost.notifications"
        $application_icons = "local_brightpush_application_icons"
        $development_certificate_pkcs12 = "local_brightpush_development_ios_certificate_pkcs12"
        $production_certificate_pkcs12 = "local_brightpush_production_ios_certificate_pkcs12"
        $certificate_pem = "local_brightpush_ios_certificates_pem"
        $c2dm_token = "local_brightpush_c2dm_token_txt"
      end  
	end
end