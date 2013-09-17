class User
  include Mongoid::Document

  require 'open-uri'
  require 'net/http'

  ## Relations
  has_many :orders

  ## Data Fields
  field :fb_name,        :type => String
  field :fb_email,       :type => String
  field :fb_token,       :type => String
  field :fb_userid,      :type => String
  field :coordinates,    :type => Array

  ## Validations
  validates :fb_name,    :presence => true
  validates :fb_token,   :presence => true
  validates :fb_userid,  :presence => true,  :uniqueness => true

  before_create :save_created_info


  def token_valid?
    return User.token_valid?(self.fb_token)
  end

  def self.token_valid? (token)
    @uri  = URI.parse("https://graph.facebook.com/me/?fields=id,name&access_token=" + token)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @res = @http.get(@uri.request_uri)

    if @res.body.to_s.split('error').count == 1
      return true
    else
      return false
    end
  end

  def save_created_info
    self.remember_created_at = Time.current
  end

  ########################################################
  #### DEVISE MODULES ####################################
  ########################################################
  devise :rememberable, :trackable, :token_authenticatable

  ## Token authenticatable
  field :authentication_token, :type => String

  ## Rememberable
  field :remember_created_at,  :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Database authenticatable
  # field :email,              :type => String, :default => ""
  # field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
end
