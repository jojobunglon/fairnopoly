class Article < ActiveRecord::Base
  extend Enumerize

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :title, :use => :slugged
  validates_presence_of :slug



  # Relations


  validates_presence_of :transaction , :unless => :template?
  belongs_to :transaction, :dependent => :destroy
  accepts_nested_attributes_for :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, :through => :library_elements

  belongs_to :seller, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?

  belongs_to :article_template

   #article module concerns
  include Categories, Commendation, FeesAndDonations, Images, Initial, Attributes, Search, Sanitize
  include Template

  # without parameter or 'true' returns all articles with a user_id, else only
  # the articles with the specified user_id
  scope :with_user_id, lambda{|user_id = true|
    if user_id == true
      where(Article.arel_table[:user_id].not_eq(nil))
    else
      where(:user_id => user_id)
    end
  }



  # We have to do this in the article class because we want to 
  # override the dynamic Rails method to get rid of the RecordNotFound 
  # http://stackoverflow.com/questions/9864501/recordnotfound-with-accepts-nested-attributes-for-and-belongs-to
  def seller_attributes=(seller_attrs)
    if seller_attrs.has_key?(:id)
      self.seller = User.find(seller_attrs.delete(:id))
      rejected = seller_attrs.reject { |k,v| valid_seller_attributes.include?(k) }
      if rejected != nil && !rejected.empty? # Docs say reject! will return nil for no change but returns empty array
        raise SecurityError
      end
      self.seller.attributes = seller_attrs
    end
  end

   # The allowed attributes for updating user/seller in article form
  def valid_seller_attributes
    ["bank_code", "bank_account_number", "bank_account_owner" ,"paypal_account", "bank_name" ]
  end
  
  amoeba do
      enable
      include_field :fair_trust_questionnaire
      include_field :social_producer_questionnaire
      include_field :categories
      include_field :images
      
    end
  

end